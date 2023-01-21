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
        at rate: TimecodeFrameRate,
        limit: Timecode.UpperLimit = ._24hours,
        base: Timecode.SubFramesBase = .default(),
        format: Timecode.StringFormat = .default()
    ) throws {
        let fraction = Fraction(cmTime)
        try self.init(fraction, at: rate, limit: limit, base: base, format: format)
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
    public func toTimecodeInterval(
        at rate: TimecodeFrameRate,
        limit: Timecode.UpperLimit = ._24hours,
        base: Timecode.SubFramesBase = .default(),
        format: Timecode.StringFormat = .default()
    ) throws -> TimecodeInterval {
        try TimecodeInterval(
            self,
            at: rate,
            limit: limit,
            base: base,
            format: format
        )
    }
}

#endif
