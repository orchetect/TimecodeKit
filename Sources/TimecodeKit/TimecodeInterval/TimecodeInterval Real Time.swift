//
//  TimecodeInterval Real Time.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension TimecodeInterval {
    /// Initialize from a time duration in seconds.
    /// A negative value will produce a negative time interval.
    ///
    /// - Throws: ``Timecode/ValidationError``
    public init(
        realTime seconds: TimeInterval,
        at frameRate: TimecodeFrameRate,
        base: Timecode.SubFramesBase = .default(),
        limit: Timecode.UpperLimit = .max24Hours
    ) throws {
        let neg = seconds < .zero
        let absSeconds = abs(seconds)
        
        let absTimecode = try Timecode(.realTime(seconds: absSeconds), at: frameRate, base: base, limit: limit)
        
        self.init(absTimecode, neg ? .minus : .plus)
    }
    
    /// Initialize from a time duration in seconds.
    /// A negative value will produce a negative time interval.
    ///
    /// - Throws: ``Timecode/ValidationError``
    public init(
        realTime seconds: TimeInterval,
        using properties: Timecode.Properties
    ) throws {
        let neg = seconds < .zero
        let absSeconds = abs(seconds)
        
        let absTimecode = try Timecode(.realTime(seconds: absSeconds), using: properties)
        
        self.init(absTimecode, neg ? .minus : .plus)
    }
    
    /// Returns the interval time as real-time (wall-clock time) in seconds.
    /// Expressed as either a positive or negative number.
    public var realTimeValue: TimeInterval {
        switch sign {
        case .plus:
            absoluteInterval.realTimeValue
            
        case .minus:
            -(absoluteInterval.realTimeValue)
        }
    }
}

extension TimeInterval {
    /// Convenience function to initialize a `TimecodeInterval` instance from a time duration
    /// in seconds.
    /// A negative value will produce a negative time interval.
    ///
    /// - Throws: ``Timecode/ValidationError``
    public func timecodeInterval(
        at frameRate: TimecodeFrameRate,
        base: Timecode.SubFramesBase = .default(),
        limit: Timecode.UpperLimit = .max24Hours
    ) throws -> TimecodeInterval {
        try TimecodeInterval(realTime: self, at: frameRate, base: base, limit: limit)
    }
    
    /// Convenience function to initialize a `TimecodeInterval` instance from a time duration
    /// in seconds.
    /// A negative value will produce a negative time interval.
    ///
    public func timecodeInterval(
        using properties: Timecode.Properties
    ) throws -> TimecodeInterval {
        try TimecodeInterval(realTime: self, using: properties)
    }
}
