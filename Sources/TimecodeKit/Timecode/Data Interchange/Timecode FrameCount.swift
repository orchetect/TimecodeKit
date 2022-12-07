//
//  Timecode FrameCount.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - Init

extension Timecode {
    /// Instance exactly from total elapsed frames ("frame number") at a given frame rate.
    ///
    /// Validation is based on the `upperLimit` and `subFramesBase` properties.
    ///
    /// - Throws: ``ValidationError``
    public init(
        _ exactly: FrameCount.Value,
        at rate: FrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        frameRate = rate
        upperLimit = limit
        subFramesBase = base
        stringFormat = format
        
        try setTimecode(exactly: exactly)
    }
    
    /// Instance exactly from total elapsed frames ("frame number") at a given frame rate.
    ///
    /// Validation is based on the `upperLimit` and `subFramesBase` properties.
    ///
    /// - Throws: ``ValidationError``
    public init(
        _ exactly: FrameCount,
        at rate: FrameRate,
        limit: UpperLimit = ._24hours,
        format: StringFormat = .default()
    ) throws {
        frameRate = rate
        upperLimit = limit
        subFramesBase = exactly.subFramesBase
        stringFormat = format
        
        try setTimecode(exactly: exactly.value)
    }
}

// MARK: - Get and Set

extension Timecode {
    /// Returns the total number of whole frames elapsed from zero up to the timecode values.
    ///
    /// (Validation is based on the frame rate and `upperLimit` property.)
    public var frameCount: FrameCount {
        Self.frameCount(
            of: components,
            at: frameRate,
            base: subFramesBase
        )
    }
    
    /// Set timecode from total elapsed frames ("frame number").
    ///
    /// Subframes are represented by the fractional portion of the number.
    /// Timecode is updated as long as the value passed is in valid range.
    /// (Validation is based on the frame rate and `upperLimit` property.)
    ///
    /// - Throws: ``ValidationError``
    public mutating func setTimecode(exactly frameCountValue: FrameCount.Value) throws {
        let fc = FrameCount(frameCountValue, base: subFramesBase)
        
        guard fc.subFrameCount >= 0,
              fc <= maxFrameCountExpressible
        else { throw ValidationError.outOfBounds }
        
        let converted = Self.components(
            from: fc,
            at: frameRate
        )
        
        days = converted.d
        hours = converted.h
        minutes = converted.m
        seconds = converted.s
        frames = converted.f
        subFrames = converted.sf
    }
}

// MARK: - Static methods

extension Timecode {
    /// Calculates total frames from given values at the current frame rate.
    public static func frameCount(
        of values: Components,
        at frameRate: FrameRate,
        base: SubFramesBase = .default()
    ) -> FrameCount {
        let subFramesUnitInterval = Double(values.sf) / Double(base.rawValue)
        
        let frameCountValue: FrameCount.Value
        
        switch frameRate.isDrop {
        case true:
            let totalMinutes = (24 * 60 * values.d) + (60 * values.h) + values.m
            
            let base = (frameRate.maxFrames * 60 * 60 * 24 * values.d)
                + (frameRate.maxFrames * 60 * 60 * values.h)
                + (frameRate.maxFrames * 60 * values.m)
                + (frameRate.maxFrames * values.s)
                + (values.f)
            let dropOffset = Int(frameRate.framesDroppedPerMinute) *
                (totalMinutes - (totalMinutes / 10))
            let totalWholeFrames = base - dropOffset
            
            frameCountValue = .splitUnitInterval(
                frames: totalWholeFrames,
                subFramesUnitInterval: subFramesUnitInterval
            )
            
        case false:
            let dd = Double(values.d) * 24 * 60 * 60 * frameRate.frameRateForElapsedFramesCalculation
            let hh = Double(values.h) * 60 * 60 * frameRate.frameRateForElapsedFramesCalculation
            let mm = Double(values.m) * 60 * frameRate.frameRateForElapsedFramesCalculation
            let ss = Double(values.s) * frameRate.frameRateForElapsedFramesCalculation
            let totalWholeFrames = Int(round(dd + hh + mm + ss)) + values.f
            
            frameCountValue = .splitUnitInterval(
                frames: totalWholeFrames,
                subFramesUnitInterval: subFramesUnitInterval
            )
        }
        
        return .init(frameCountValue, base: base)
    }
    
    /// Calculates resulting values from total frames at the current frame rate.
    /// (You can add subframes afterward to the `sf` property if needed.)
    public static func components(
        from frameCount: FrameCount,
        at frameRate: FrameRate
    ) -> Components {
        // prep vars
        
        var dd = 00
        var hh = 00
        var mm = 00
        var ss = 00
        var ff = 00
        var sf = 00
        
        var inElapsedFrames = frameCount.decimalValue
        
        // drop frame
        
        if frameRate.isDrop {
            // modify input elapsed frame count in the case of a drop-frame frame rate
            // so it can be converted
            
            let framesDroppedPerMinute = Decimal(frameRate.framesDroppedPerMinute)
            
            let framesPer10Minutes = Decimal(frameRate.frameRateForElapsedFramesCalculation) *
                Decimal(600.0)
            
            let d = (inElapsedFrames / framesPer10Minutes).truncated(decimalPlaces: 0)
            
            let m = inElapsedFrames.truncatingRemainder(dividingBy: framesPer10Minutes)
            
            // don't allow negative numbers
            let f = max(Decimal(0), m - framesDroppedPerMinute)
            
            let part1 = (9 * framesDroppedPerMinute * d)
            let part2 = framesDroppedPerMinute *
                (f / ((framesPer10Minutes - framesDroppedPerMinute) / 10))
                .truncated(decimalPlaces: 0)
            
            inElapsedFrames = inElapsedFrames + part1 + part2
        }
        
        // final calculation
        
        let frMaxFrames = Decimal(frameRate.maxFrames)
        
        dd = Int(
            truncating: (inElapsedFrames / (frMaxFrames * 60 * 60 * 24))
                .truncated(decimalPlaces: 0)
                as NSDecimalNumber
        )
        
        hh = Int(
            truncating: (inElapsedFrames / (frMaxFrames * 60 * 60))
                .truncated(decimalPlaces: 0)
                .truncatingRemainder(dividingBy: 24)
                as NSDecimalNumber
        )
        
        mm = Int(
            truncating: (inElapsedFrames / (frMaxFrames * 60))
                .truncated(decimalPlaces: 0)
                .truncatingRemainder(dividingBy: 60)
                as NSDecimalNumber
        )
        
        ss = Int(
            truncating: (inElapsedFrames / frMaxFrames)
                .truncated(decimalPlaces: 0)
                .truncatingRemainder(dividingBy: 60)
                as NSDecimalNumber
        )
        
        ff = Int(
            truncating: inElapsedFrames
                .truncatingRemainder(dividingBy: frMaxFrames)
                as NSDecimalNumber
        )
        
        sf = Int(
            truncating: inElapsedFrames.fraction * Decimal(frameCount.subFramesBase.rawValue)
                as NSDecimalNumber
        )
        
        return Components(d: dd, h: hh, m: mm, s: ss, f: ff, sf: sf)
    }
}
