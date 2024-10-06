//
//  TimecodeInterval Rational.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension TimecodeInterval {
    /// Initialize from a time duration represented as a rational fraction.
    /// A negative fraction will produce a negative time interval.
    ///
    /// - Note: The fraction is treated as an absolute value regardless of whether it is negative or
    /// positive. The sign simply determines whether the interval is negative or positive.
    ///
    /// - Throws: ``Timecode/ValidationError``
    public init(
        _ rational: Fraction,
        at frameRate: TimecodeFrameRate,
        base: Timecode.SubFramesBase = .default(),
        limit: Timecode.UpperLimit = .max24Hours
    ) throws {
        let neg = rational.isNegative
        let absRational = rational.abs()
        
        let absTimecode = try Timecode(.rational(absRational), at: frameRate, base: base, limit: limit)
        
        self.init(absTimecode, neg ? .minus : .plus)
    }
    
    /// Initialize from a time duration represented as a rational fraction.
    /// A negative fraction will produce a negative time interval.
    ///
    /// - Note: The fraction is treated as an absolute value regardless of whether it is negative or
    /// positive. The sign simply determines whether the interval is negative or positive.
    ///
    /// - Throws: ``Timecode/ValidationError``
    public init(
        _ rational: Fraction,
        using properties: Timecode.Properties
    ) throws {
        let neg = rational.isNegative
        let absRational = rational.abs()
        
        let absTimecode = try Timecode(.rational(absRational), using: properties)
        
        self.init(absTimecode, neg ? .minus : .plus)
    }
    
    /// Returns the rational fraction for the timecode interval.
    public var rationalValue: Fraction {
        isNegative
            ? absoluteInterval.rationalValue.negated()
            : absoluteInterval.rationalValue
    }
}

extension Fraction {
    /// Convenience function to initialize a `TimecodeInterval` instance from a time duration
    /// represented as a rational fraction.
    /// A negative fraction will produce a negative time interval.
    ///
    /// - Note: The fraction is treated as an absolute value regardless of whether it is negative or
    /// positive. The sign simply determines whether the interval is positive or negative.
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
    /// - Note: The fraction is treated as an absolute value regardless of whether it is negative or
    /// positive. The sign simply determines whether the interval is positive or negative.
    ///
    /// - Throws: ``Timecode/ValidationError``
    public func timecodeInterval(
        using properties: Timecode.Properties
    ) throws -> TimecodeInterval {
        try TimecodeInterval(self, using: properties)
    }
}
