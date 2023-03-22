//
//  Timecode Real Time.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - Init

extension Timecode {
    /// Instance from total elapsed real time and frame rate.
    ///
    /// - Note: This may be lossy.
    ///
    /// - Throws: ``ValidationError``
    public init(
        realTime exactly: TimeInterval,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default()
    ) throws {
        properties = Properties(rate: rate, base: base, limit: limit)
        
        try setTimecode(realTime: exactly)
    }
    
    /// Instance from total elapsed real time and frame rate, clamping to valid timecode if
    /// necessary.
    ///
    /// Clamping is based on the `upperLimit` and `subFramesBase` properties.
    ///
    /// - Note: This may be lossy.
    public init(
        clampingRealTime source: TimeInterval,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default()
    ) {
        properties = Properties(rate: rate, base: base, limit: limit)
        
        setTimecode(clampingRealTime: source)
    }
    
    /// Instance from total elapsed real time and frame rate, wrapping timecode if necessary.
    ///
    /// Timecode will be wrapped around the timecode clock if out-of-bounds.
    ///
    /// - Note: This may be lossy.
    public init(
        wrappingRealTime source: TimeInterval,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default()
    ) {
        properties = Properties(rate: rate, base: base, limit: limit)
        
        setTimecode(wrappingRealTime: source)
    }
    
    /// Instance from total elapsed real time and frame rate.
    ///
    /// Allows for invalid raw values (in this case, unbounded Days component).
    ///
    /// - Note: This may be lossy.
    public init(
        rawValuesRealTime source: TimeInterval,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default()
    ) {
        properties = Properties(rate: rate, base: base, limit: limit)
        
        setTimecode(rawValuesRealTime: source)
    }
}

// MARK: - Get and Set

extension Timecode {
    /// (Lossy) Returns the current timecode converted to a duration in
    /// real-time (wall-clock time), based on the frame rate.
    public var realTimeValue: TimeInterval {
        frameCount.doubleValue * (1.0 / properties.frameRate.frameRateForRealTimeCalculation)
    }
    
    /// Sets the timecode to the nearest frame at the current frame rate
    /// from real-time (wall-clock time).
    ///
    /// Throws an error if it underflows or overflows valid timecode range.
    /// (Validation is based on the frame rate and `upperLimit` property.)
    ///
    /// - Throws: ``ValidationError``
    public mutating func setTimecode(realTime: TimeInterval) throws {
        let convertedComponents = components(realTime: realTime)
        try setTimecode(exactly: convertedComponents)
    }
    
    /// Sets the timecode to the nearest frame at the current frame rate
    /// from real-time (wall-clock time).
    ///
    /// Clamps to valid timecode.
    public mutating func setTimecode(clampingRealTime: TimeInterval) {
        let convertedComponents = components(realTime: clampingRealTime)
        setTimecode(clamping: convertedComponents)
    }
    
    /// Sets the timecode to the nearest frame at the current frame rate
    /// from real-time (wall-clock time).
    ///
    /// Wraps timecode if necessary.
    public mutating func setTimecode(wrappingRealTime: TimeInterval) {
        let convertedComponents = components(realTime: wrappingRealTime)
        setTimecode(wrapping: convertedComponents)
    }
    
    /// Sets the timecode to the nearest frame at the current frame rate
    /// from real-time (wall-clock time).
    ///
    /// Allows for invalid raw values (in this case, unbounded Days component).
    public mutating func setTimecode(rawValuesRealTime: TimeInterval) {
        let convertedComponents = components(realTime: rawValuesRealTime)
        setTimecode(rawValues: convertedComponents)
    }
    
    // MARK: Internal Methods
    
    /// Internal:
    /// Converts a real-time value (wall-clock time) to components using the instance's
    /// frame rate and subframes base.
    internal func components(realTime: TimeInterval) -> Components {
        let elapsedFrames = elapsedFrames(realTime: realTime)
        
        return Self.components(
            of: .init(.combined(frames: elapsedFrames), base: properties.subFramesBase),
            at: properties.frameRate
        )
    }
    
    /// Internal:
    /// Calculates elapsed frames at current frame rate from real-time (wall-clock time).
    internal func elapsedFrames(realTime: TimeInterval) -> Double {
        var calc = realTime / (1.0 / properties.frameRate.frameRateForRealTimeCalculation)
        
        // over-estimate so real time is just past the equivalent timecode
        // since raw time values in practise can be a hair under the actual elapsed real time that would trigger the equivalent timecode (due to precision and rounding behaviors that may not be in our control, depending on where the passed real time value originated)
        
        let magicNumber = 0.000_010 // 10 microseconds
        
        switch calc.sign {
        case .plus:
            calc += magicNumber
        case .minus:
            calc -= magicNumber
        }
        
        return calc
    }
}

// a.k.a: extension Double
extension TimeInterval {
    /// Convenience method to create an `Timecode` struct using the default
    /// `(_ exactly:)` initializer.
    ///
    /// - Throws: ``ValidationError``
    public func toTimecode(
        at rate: TimecodeFrameRate,
        limit: Timecode.UpperLimit = ._24hours,
        base: Timecode.SubFramesBase = .default()
    ) throws -> Timecode {
        try Timecode(
            realTime: self,
            at: rate,
            limit: limit,
            base: base
        )
    }
}
