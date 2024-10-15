//
//  Timecode FrameCount.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - TimecodeSource

extension Timecode.FrameCount: _TimecodeSource {
    package func set(timecode: inout Timecode) throws {
        timecode.subFramesBase = subFramesBase
        try timecode._setTimecode(exactly: self)
    }
    
    package func set(timecode: inout Timecode, by validation: Timecode.ValidationRule) {
        switch validation {
        case .clamping, .clampingComponents:
            timecode._setTimecode(clamping: self)
        case .wrapping:
            timecode._setTimecode(wrapping: self)
        case .allowingInvalid:
            timecode._setTimecode(rawValues: self)
        }
    }
}

// MARK: - Static Constructors

extension TimecodeSourceValue {
    /// Timecode total elapsed frame count value (``Timecode/FrameCount``).
    public static func frames(_ source: Timecode.FrameCount) -> Self {
        .init(value: source)
    }
}

// MARK: - Get

extension Timecode {
    /// Returns the total number of frames elapsed.
    public var frameCount: FrameCount {
        Self.frameCount(
            of: components,
            at: frameRate,
            base: subFramesBase
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
    mutating func _setTimecode(exactly source: FrameCount) throws {
        components = try components(exactly: source)
    }
    
    /// Set timecode from total elapsed frames ("frame number").
    ///
    /// Clamps to valid timecode.
    ///
    /// Subframes are represented by the fractional portion of the number.
    mutating func _setTimecode(clamping source: FrameCount) {
        let convertedComponents = components(rawValues: source)
        _setTimecode(clamping: convertedComponents)
    }
    
    /// Set timecode from total elapsed frames ("frame number").
    ///
    /// Timecode will be wrapped around the timecode clock if out-of-bounds.
    ///
    /// Subframes are represented by the fractional portion of the number.
    mutating func _setTimecode(wrapping source: FrameCount) {
        let convertedComponents = components(rawValues: source)
        _setTimecode(wrapping: convertedComponents)
    }
    
    /// Set timecode from total elapsed frames ("frame number").
    ///
    /// Allows for invalid raw values (in this case, unbounded Days component).
    ///
    /// Subframes are represented by the fractional portion of the number.
    mutating func _setTimecode(rawValues source: FrameCount) {
        let convertedComponents = components(rawValues: source)
        _setTimecode(rawValues: convertedComponents)
    }
    
    // MARK: Helper Methods
    
    /// Internal:
    /// Returns frame count value converted to components using the instance's
    /// frame rate and subframes base.
    ///
    /// - Throws: ``ValidationError``
    func components(exactly source: FrameCount) throws -> Components {
        // early return if we don't need to scale subframes
        if source.subFramesBase == subFramesBase || source.subFrames == 0 {
            return try components(exactly: source.value)
        }
        
        // scale subframes between subframes bases
        var convertedComponents = components(rawValues: source)
        convertedComponents.subFrames = source.subFramesBase.convert(
            subFrames: convertedComponents.subFrames,
            to: subFramesBase
        )
        return convertedComponents
    }
    
    /// Internal:
    /// Returns frame count value converted to components using the instance's
    /// frame rate and subframes base.
    func components(rawValues source: FrameCount) -> Components {
        var convertedComponents = components(rawValues: source.value)
        
        // early return if we don't need to scale subframes
        if source.subFramesBase == subFramesBase || source.subFrames == 0 {
            return convertedComponents
        }
        
        // scale subframes between subframes bases
        convertedComponents.subFrames = source.subFramesBase.convert(
            subFrames: convertedComponents.subFrames,
            to: subFramesBase
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
        
        let rawFrames: Double
        
        switch frameRate.isDrop {
        case true:
            let dd = Double(values.days) * 24 * 60
            let hh = Double(values.hours) * 60
            let mm = Double(values.minutes)
            let totalMinutes = dd + hh + mm
            let totalSeconds = (totalMinutes * 60) + Double(values.seconds)
            
            let baseFrames = (totalSeconds * Double(frameRate.maxFrames)) + Double(values.frames)
            let dropOffset = frameRate.framesDroppedPerMinute * (totalMinutes - floor(totalMinutes / 10))
            
            rawFrames = baseFrames - dropOffset
            
        case false:
            let dd = Double(values.days) * 24 * 60 * 60
            let hh = Double(values.hours) * 60 * 60
            let mm = Double(values.minutes) * 60
            let ss = Double(values.seconds)
            
            rawFrames = round((dd + hh + mm + ss) * frameRate.frameRateForElapsedFramesCalculation) + Double(values.frames)
        }
        
        // failsafe to avoid underflow/overflow crashes
        guard rawFrames >= Double(Int.min), rawFrames <= Double(Int.max) else {
            return .init(.frames(0), base: base)
        }
        
        let totalWholeFrames = Int(rawFrames)
        
        let frameCountValue: FrameCount.Value = .splitUnitInterval(
            frames: totalWholeFrames,
            subFramesUnitInterval: subFramesUnitInterval
        )
        
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
        if days != 0 { days.negate(); return }
        if hours != 0 { hours.negate(); return }
        if minutes != 0 { minutes.negate(); return }
        if seconds != 0 { seconds.negate(); return }
        if frames != 0 { frames.negate(); return }
        if subFrames != 0 { subFrames.negate(); return }
    }
}
