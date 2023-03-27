//
//  TimecodeInterval Rational CMTime.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if canImport(CoreMedia)

import Foundation
import CoreMedia

@available(macOS 10.7, iOS 4.0, tvOS 9.0, watchOS 6.0, *)
extension TimecodeInterval {
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
    
    /// Initialize from a time duration represented as a rational fraction.
    /// A negative fraction will produce a negative time interval.
    ///
    /// - Throws: ``Timecode/ValidationError``
    public init(
        _ cmTime: CMTime,
        at rate: TimecodeFrameRate
    ) throws {
        let fraction = Fraction(cmTime)
        try self.init(fraction, using: .init(rate: rate))
    }
    
    /// Returns the rational fraction for the timecode interval as `CMTime`.
    public var cmTime: CMTime {
        CMTime(rationalValue)
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
        using properties: Timecode.Properties
    ) throws -> TimecodeInterval {
        try TimecodeInterval(
            self,
            using: properties
        )
    }
    
    /// Convenience function to initialize a `TimecodeInterval` instance from a time duration
    /// represented as a rational fraction.
    /// A negative fraction will produce a negative time interval.
    ///
    /// - Throws: ``Timecode/ValidationError``
    public func timecodeInterval(
        using rate: TimecodeFrameRate
    ) throws -> TimecodeInterval {
        try TimecodeInterval(
            self,
            using: .init(rate: rate)
        )
    }
}

#endif
