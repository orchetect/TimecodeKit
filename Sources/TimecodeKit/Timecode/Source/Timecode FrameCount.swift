//
//  Timecode FrameCount.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - TimecodeSource

extension Timecode.FrameCount: TimecodeSource {
    public func set(timecode: inout Timecode) throws {
        timecode.properties.subFramesBase = self.subFramesBase
        try timecode.setTimecode(exactly: self)
    }
    
    public func set(timecode: inout Timecode, by validation: Timecode.Validation) {
        switch validation {
        case .clamping, .clampingEach:
            timecode.setTimecode(clamping: self)
        case .wrapping:
            timecode.setTimecode(wrapping: self)
        case .allowingInvalidComponents:
            timecode.setTimecode(rawValues: self)
        }
    }
}

extension TimecodeSource where Self == Timecode.FrameCount {
    // no static constructors
}

// MARK: - Get

extension Timecode {
    /// Returns the total number of frames elapsed.
    public var frameCount: FrameCount {
        Self.frameCount(
            of: components,
            at: properties.frameRate,
            base: properties.subFramesBase
        )
    }
}

// MARK: - Set

extension Timecode {
    /// Set timecode from total elapsed frames ("frame number").
    ///
    /// Subframes are represented by the fractional portion of the number.
    /// Timecode is updated as long as the value passed is in valid range.
    /// (Validation is based on the frame rate and `upperLimit` property.)
    ///
    /// - Throws: ``ValidationError``
    internal mutating func setTimecode(exactly source: FrameCount) throws {
        components = try components(exactly: source)
    }
    
    /// Set timecode from total elapsed frames ("frame number").
    ///
    /// Clamps to valid timecode.
    ///
    /// Subframes are represented by the fractional portion of the number.
    internal mutating func setTimecode(clamping source: FrameCount) {
        let convertedComponents = components(rawValues: source)
        setTimecode(clamping: convertedComponents)
    }
    
    /// Set timecode from total elapsed frames ("frame number").
    ///
    /// Timecode will be wrapped around the timecode clock if out-of-bounds.
    ///
    /// Subframes are represented by the fractional portion of the number.
    internal mutating func setTimecode(wrapping source: FrameCount) {
        let convertedComponents = components(rawValues: source)
        setTimecode(wrapping: convertedComponents)
    }
    
    /// Set timecode from total elapsed frames ("frame number").
    ///
    /// Allows for invalid raw values (in this case, unbounded Days component).
    ///
    /// Subframes are represented by the fractional portion of the number.
    internal mutating func setTimecode(rawValues source: FrameCount) {
        let convertedComponents = components(rawValues: source)
        setTimecode(rawValues: convertedComponents)
    }
    
    // MARK: Helper Methods
    
    /// Internal:
    /// Returns frame count value converted to components using the instance's
    /// frame rate and subframes base.
    ///
    /// - Throws: ``ValidationError``
    internal func components(exactly source: FrameCount) throws -> Components {
        // early return if we don't need to scale subframes
        if source.subFramesBase == properties.subFramesBase || source.subFrames == 0 {
            return try components(exactly: source.value)
        }
        
        // scale subframes between subframes bases
        var convertedComponents = components(rawValues: source)
        convertedComponents.subFrames = source.subFramesBase.convert(
            subFrames: convertedComponents.subFrames,
            to: properties.subFramesBase
        )
        return convertedComponents
    }
    
    /// Internal:
    /// Returns frame count value converted to components using the instance's
    /// frame rate and subframes base.
    internal func components(rawValues source: FrameCount) -> Components {
        var convertedComponents = components(rawValues: source.value)
        
        // early return if we don't need to scale subframes
        if source.subFramesBase == properties.subFramesBase || source.subFrames == 0 {
            return convertedComponents
        }
        
        // scale subframes between subframes bases
        convertedComponents.subFrames = source.subFramesBase.convert(
            subFrames: convertedComponents.subFrames,
            to: properties.subFramesBase
        )
        return convertedComponents
    }
}

// MARK: - Static methods

extension Timecode {
    /// Calculates total frames from given values at the current frame rate.
    public static func frameCount(
        of values: Components,
        at frameRate: TimecodeFrameRate,
        base: SubFramesBase = .default()
    ) -> FrameCount {
        let subFramesUnitInterval = Double(values.subFrames) / Double(base.rawValue)
        
        let frameCountValue: FrameCount.Value
        
        switch frameRate.isDrop {
        case true:
            let totalMinutes = (24 * 60 * values.days) + (60 * values.hours) + values.minutes
            
            let base = (frameRate.maxFrames * 60 * 60 * 24 * values.days)
                + (frameRate.maxFrames * 60 * 60 * values.hours)
                + (frameRate.maxFrames * 60 * values.minutes)
                + (frameRate.maxFrames * values.seconds)
                + (values.frames)
            let dropOffset = Int(frameRate.framesDroppedPerMinute) *
                (totalMinutes - (totalMinutes / 10))
            let totalWholeFrames = base - dropOffset
            
            frameCountValue = .splitUnitInterval(
                frames: totalWholeFrames,
                subFramesUnitInterval: subFramesUnitInterval
            )
            
        case false:
            let dd = Double(values.days) * 24 * 60 * 60 * frameRate.frameRateForElapsedFramesCalculation
            let hh = Double(values.hours) * 60 * 60 * frameRate.frameRateForElapsedFramesCalculation
            let mm = Double(values.minutes) * 60 * frameRate.frameRateForElapsedFramesCalculation
            let ss = Double(values.seconds) * frameRate.frameRateForElapsedFramesCalculation
            let totalWholeFrames = Int(round(dd + hh + mm + ss)) + values.frames
            
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
        of frameCount: FrameCount,
        at frameRate: TimecodeFrameRate
    ) -> Components {
        // prep vars
        
        var dd = 00
        var hh = 00
        var mm = 00
        var ss = 00
        var ff = 00
        var sf = 00
        
        var inElapsedFrames = frameCount.decimalValue
        let isNegative = inElapsedFrames.sign == .minus
        if isNegative { inElapsedFrames.negate() }
        
        // drop frame
        
        if frameRate.isDrop {
            // modify input elapsed frame count in the case of a drop rate
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
        
        var newComponents = Components(d: dd, h: hh, m: mm, s: ss, f: ff, sf: sf)
        
        // only apply negative sign to largest non-zero value
        if isNegative {
            newComponents.negate()
        }
        
        return newComponents
    }
}

extension Timecode.Components {
    /// Negates the largest non-zero component.
    fileprivate mutating func negate() {
        if days != 0 { days.negate() ; return }
        if hours != 0 { hours.negate() ; return }
        if minutes != 0 { minutes.negate() ; return }
        if seconds != 0 { seconds.negate() ; return }
        if frames != 0 { frames.negate() ; return }
        if subFrames != 0 { subFrames.negate() ; return }
    }
}