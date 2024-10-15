//
//  TimecodeInterval Rational CMTime.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(CoreMedia)

import CoreMedia
import Foundation

@available(macOS 10.7, iOS 4.0, tvOS 9.0, watchOS 6.0, *)
extension TimecodeInterval {
    /// Initialize from a time duration represented as a rational fraction.
    /// A negative fraction will produce a negative time interval.
    ///
    /// - Throws: ``Timecode/ValidationError``
    public init(
        _ cmTime: CMTime,
        at frameRate: TimecodeFrameRate,
        base: Timecode.SubFramesBase = .default(),
        limit: Timecode.UpperLimit = .max24Hours
    ) throws {
        let fraction = Fraction(cmTime)
        try self.init(fraction, at: frameRate, base: base, limit: limit)
    }
    
    /// Returns the rational fraction for the timecode interval as `CMTime`.
    public var cmTimeValue: CMTime {
        CMTime(rationalValue)
    }
    
    /// Initialize from a time duration represented as a rational fraction.
    /// A negative fraction will produce a negative time interval.
    ///
    /// - Throws: ``Timecode/ValidationError``
    public init(
        _ cmTime: CMTime,
        using properties: Timecode.Properties
    ) throws {
        let fraction = Fraction(cmTime)
        try self.init(fraction, using: properties)
    }
}

@available(macOS 10.7, iOS 4.0, tvOS 9.0, watchOS 6.0, *)
extension CMTime {
    /// Convenience function to initialize a `TimecodeInterval` instance from a time duration
    /// represented as a rational fraction.
    /// A negative fraction will produce a negative time interval.
    ///
    /// - Throws: ``Timecode/ValidationError``
    public func timecodeInterval(
        at frameRate: TimecodeFrameRate,
        base: Timecode.SubFramesBase = .default(),
        limit: Timecode.UpperLimit = .max24Hours
    ) throws -> TimecodeInterval {
        try TimecodeInterval(self, at: frameRate, base: base, limit: limit)
    }
    
    /// Convenience function to initialize a `TimecodeInterval` instance from a time duration
    /// represented as a rational fraction.
    /// A negative fraction will produce a negative time interval.
    ///
    /// - Throws: ``Timecode/ValidationError``
    public func timecodeInterval(
        using properties: Timecode.Properties
    ) throws -> TimecodeInterval {
        try TimecodeInterval(self, using: properties)
    }
}

#endif
