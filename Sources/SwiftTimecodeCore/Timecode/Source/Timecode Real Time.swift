//
//  Timecode Real Time.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - TimecodeSource

extension TimeInterval: _TimecodeSource {
    package func set(timecode: inout Timecode) throws {
        try timecode._setTimecode(exactlyRealTime: self)
    }
    
    package func set(timecode: inout Timecode, by validation: Timecode.ValidationRule) {
        switch validation {
        case .clamping, .clampingComponents:
            timecode._setTimecode(clampingRealTime: self)
        case .wrapping:
            timecode._setTimecode(wrappingRealTime: self)
        case .allowingInvalid:
            timecode._setTimecode(rawValuesRealTime: self)
        }
    }
}

// MARK: - Static Constructors

extension TimecodeSourceValue {
    /// Real time (wall time) in seconds.
    public static func realTime(seconds: TimeInterval) -> Self {
        .init(value: seconds)
    }
}

// MARK: - Get

extension Timecode {
    /// (Lossy) Returns the current timecode converted to a duration in
    /// real-time (wall-clock time), based on the frame rate.
    public var realTimeValue: TimeInterval {
        frameCount.doubleValue * (1.0 / frameRate.frameRateForRealTimeCalculation)
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
    mutating func _setTimecode(exactlyRealTime: TimeInterval) throws {
        let convertedComponents = components(realTime: exactlyRealTime)
        try _setTimecode(exactly: convertedComponents)
    }
    
    /// Sets the timecode to the nearest frame at the current frame rate
    /// from real-time (wall-clock time).
    ///
    /// Clamps to valid timecode.
    mutating func _setTimecode(clampingRealTime: TimeInterval) {
        let convertedComponents = components(realTime: clampingRealTime)
        _setTimecode(clamping: convertedComponents)
    }
    
    /// Sets the timecode to the nearest frame at the current frame rate
    /// from real-time (wall-clock time).
    ///
    /// Wraps timecode if necessary.
    mutating func _setTimecode(wrappingRealTime: TimeInterval) {
        let convertedComponents = components(realTime: wrappingRealTime)
        _setTimecode(wrapping: convertedComponents)
    }
    
    /// Sets the timecode to the nearest frame at the current frame rate
    /// from real-time (wall-clock time).
    ///
    /// Allows for invalid raw values (in this case, unbounded Days component).
    mutating func _setTimecode(rawValuesRealTime: TimeInterval) {
        let convertedComponents = components(realTime: rawValuesRealTime)
        _setTimecode(rawValues: convertedComponents)
    }
    
    // MARK: Helper Methods
    
    /// Internal:
    /// Converts a real-time value (wall-clock time) to components using the instance's
    /// frame rate and subframes base.
    func components(realTime: TimeInterval) -> Components {
        let elapsedFrames = elapsedFrames(realTime: realTime)
        
        return Self.components(
            of: .init(.combined(frames: elapsedFrames), base: subFramesBase),
            at: frameRate
        )
    }
    
    /// Internal:
    /// Calculates elapsed frames at current frame rate from real-time (wall-clock time).
    func elapsedFrames(realTime: TimeInterval) -> Double {
        var calc = realTime / (1.0 / frameRate.frameRateForRealTimeCalculation)
        
        // over-estimate so real time is just past the equivalent timecode
        // since raw time values in practise can be a hair under the actual elapsed real time that would trigger the equivalent timecode
        // (due to precision and rounding behaviors that may not be in our control, depending on where the passed real time value
        // originated)
        
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
