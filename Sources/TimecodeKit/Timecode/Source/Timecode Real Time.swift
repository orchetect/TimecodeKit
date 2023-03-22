//
//  Timecode Real Time.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - TimecodeSource

extension TimeInterval: TimecodeSource {
    public func set(timecode: inout Timecode) throws {
        try timecode.setTimecode(exactlyRealTime: self)
    }
    
    public func set(timecode: inout Timecode, by validation: Timecode.Validation) {
        switch validation {
        case .clamping, .clampingEach:
            timecode.setTimecode(clampingRealTime: self)
        case .wrapping:
            timecode.setTimecode(wrappingRealTime: self)
        case .allowingInvalidComponents:
            timecode.setTimecode(rawValuesRealTime: self)
        }
    }
}

extension TimecodeSource where Self == TimeInterval {
    public static func realTime(_ seconds: TimeInterval) -> Self {
        seconds
    }
}

// MARK: - Get

extension Timecode {
    /// (Lossy) Returns the current timecode converted to a duration in
    /// real-time (wall-clock time), based on the frame rate.
    public var realTimeValue: TimeInterval {
        frameCount.doubleValue * (1.0 / properties.frameRate.frameRateForRealTimeCalculation)
    }
}

// MARK: - Set

extension Timecode {
    /// Sets the timecode to the nearest frame at the current frame rate
    /// from real-time (wall-clock time).
    ///
    /// Throws an error if it underflows or overflows valid timecode range.
    /// (Validation is based on the frame rate and `upperLimit` property.)
    ///
    /// - Throws: ``ValidationError``
    internal mutating func setTimecode(exactlyRealTime: TimeInterval) throws {
        let convertedComponents = components(realTime: exactlyRealTime)
        try setTimecode(exactly: convertedComponents)
    }
    
    /// Sets the timecode to the nearest frame at the current frame rate
    /// from real-time (wall-clock time).
    ///
    /// Clamps to valid timecode.
    internal mutating func setTimecode(clampingRealTime: TimeInterval) {
        let convertedComponents = components(realTime: clampingRealTime)
        setTimecode(clamping: convertedComponents)
    }
    
    /// Sets the timecode to the nearest frame at the current frame rate
    /// from real-time (wall-clock time).
    ///
    /// Wraps timecode if necessary.
    internal mutating func setTimecode(wrappingRealTime: TimeInterval) {
        let convertedComponents = components(realTime: wrappingRealTime)
        setTimecode(wrapping: convertedComponents)
    }
    
    /// Sets the timecode to the nearest frame at the current frame rate
    /// from real-time (wall-clock time).
    ///
    /// Allows for invalid raw values (in this case, unbounded Days component).
    internal mutating func setTimecode(rawValuesRealTime: TimeInterval) {
        let convertedComponents = components(realTime: rawValuesRealTime)
        setTimecode(rawValues: convertedComponents)
    }
    
    // MARK: Helper Methods
    
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
