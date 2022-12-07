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
        realTimeValue exactly: TimeInterval,
        at rate: FrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        frameRate = rate
        upperLimit = limit
        subFramesBase = base
        stringFormat = format
        
        try setTimecode(realTimeValue: exactly)
    }
    
    /// Instance from total elapsed real time and frame rate, clamping to valid timecode if
    /// necessary.
    ///
    /// Clamping is based on the `upperLimit` and `subFramesBase` properties.
    ///
    /// - Note: This may be lossy.
    public init(
        clampingRealTimeValue source: TimeInterval,
        at rate: FrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        frameRate = rate
        upperLimit = limit
        subFramesBase = base
        stringFormat = format
        
        setTimecode(clampingRealTimeValue: source)
    }
    
    /// Instance from total elapsed real time and frame rate, wrapping timecode if necessary.
    ///
    /// Timecode will be wrapped around the timecode clock if out-of-bounds.
    ///
    /// - Note: This may be lossy.
    public init(
        wrappingRealTimeValue source: TimeInterval,
        at rate: FrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        frameRate = rate
        upperLimit = limit
        subFramesBase = base
        stringFormat = format
        
        setTimecode(wrappingRealTimeValue: source)
    }
    
    /// Instance from total elapsed real time and frame rate.
    ///
    /// Allows for invalid raw values (in this case, unbounded Days component).
    ///
    /// - Note: This may be lossy.
    public init(
        rawValuesRealTimeValue source: TimeInterval,
        at rate: FrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        frameRate = rate
        upperLimit = limit
        subFramesBase = base
        stringFormat = format
        
        setTimecode(rawValuesRealTimeValue: source)
    }
}

// MARK: - Get and Set

extension Timecode {
    /// (Lossy) Returns the current timecode converted to a duration in
    /// real-time (wall-clock time), based on the frame rate.
    ///
    /// Generally, ``realTimeValue`` -> ``setTimecode(exactlyRealTimeValue:)``
    /// will produce equivalent timecode.
    public var realTimeValue: TimeInterval {
        frameCount.doubleValue * (1.0 / frameRate.frameRateForRealTimeCalculation)
    }
    
    /// Sets the timecode to the nearest frame at the current frame rate
    /// from real-time (wall-clock time).
    ///
    /// Throws an error if it underflows or overflows valid timecode range.
    /// (Validation is based on the frame rate and `upperLimit` property.)
    ///
    /// - Throws: ``ValidationError``
    public mutating func setTimecode(realTimeValue: TimeInterval) throws {
        let convertedComponents = components(fromRealTimeValue: realTimeValue)
        try setTimecode(exactly: convertedComponents)
    }
    
    /// Sets the timecode to the nearest frame at the current frame rate
    /// from real-time (wall-clock time).
    ///
    /// Clamps to valid timecode.
    public mutating func setTimecode(clampingRealTimeValue: TimeInterval) {
        let convertedComponents = components(fromRealTimeValue: clampingRealTimeValue)
        setTimecode(clamping: convertedComponents)
    }
    
    /// Sets the timecode to the nearest frame at the current frame rate
    /// from real-time (wall-clock time).
    ///
    /// Wraps timecode if necessary.
    public mutating func setTimecode(wrappingRealTimeValue: TimeInterval) {
        let convertedComponents = components(fromRealTimeValue: wrappingRealTimeValue)
        setTimecode(wrapping: convertedComponents)
    }
    
    /// Sets the timecode to the nearest frame at the current frame rate
    /// from real-time (wall-clock time).
    ///
    /// Allows for invalid raw values (in this case, unbounded Days component).
    public mutating func setTimecode(rawValuesRealTimeValue: TimeInterval) {
        let convertedComponents = components(fromRealTimeValue: rawValuesRealTimeValue)
        setTimecode(rawValues: convertedComponents)
    }
    
    // MARK: Internal Methods
    
    /// Internal:
    /// Converts a real-time value (wall-clock time) to components using the instance's
    /// frame rate and subframes base.
    internal func components(fromRealTimeValue: TimeInterval) -> Components {
        let elapsedFrames = elapsedFrames(fromRealTimeValue: fromRealTimeValue)
        
        return Self.components(
            from: .init(.combined(frames: elapsedFrames), base: subFramesBase),
            at: frameRate
        )
    }
    
    /// Internal:
    /// Calculates elapsed frames at current frame rate from real-time (wall-clock time).
    internal func elapsedFrames(fromRealTimeValue: TimeInterval) -> Double {
        var calc = fromRealTimeValue / (1.0 / frameRate.frameRateForRealTimeCalculation)
        
        // over-estimate so real time is just past the equivalent timecode
        // since raw time values in practise can be a hair under the actual elapsed real time that would trigger the equivalent timecode (due to precision and rounding behaviors that may not be in our control, depending on where the passed real time value originated)
        
        calc += 0.000_010 // 10 microseconds
        
        return calc
    }
}

// a.k.a: extension Double
extension TimeInterval {
    /// Convenience method to create an `Timecode` struct using the default
    /// `(_ exactly:)` initializer.
    public func toTimecode(
        at rate: Timecode.FrameRate,
        limit: Timecode.UpperLimit = ._24hours,
        base: Timecode.SubFramesBase = .default(),
        format: Timecode.StringFormat = .default()
    ) throws -> Timecode {
        try Timecode(
            realTimeValue: self,
            at: rate,
            limit: limit,
            base: base,
            format: format
        )
    }
}
