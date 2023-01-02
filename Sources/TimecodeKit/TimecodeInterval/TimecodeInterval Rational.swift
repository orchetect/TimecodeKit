//
//  TimecodeInterval Rational.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension TimecodeInterval {
    /// Initialize from a time duration represented as a rational fraction.
    /// A negative fraction will produce a negative time interval.
    ///
    /// - Note: The fraction is treated as an absolute value regardless of whether it is negative or
    /// positive. The sign simply determines whether the interval is ``Sign-swift.enum/positive`` or
    /// ``Sign-swift.enum/negative``.
    public init(
        _ rational: Fraction,
        at rate: TimecodeFrameRate,
        limit: Timecode.UpperLimit = ._24hours,
        base: Timecode.SubFramesBase = .default(),
        format: Timecode.StringFormat = .default()
    ) throws {
        let neg = rational.isNegative
        let absRational = rational.abs()
        
        let absTimecode = try Timecode(
            absRational,
            at: rate,
            limit: limit,
            base: base,
            format: format
        )
        
        self.init(absTimecode, neg ? .negative : .positive)
    }
    
    /// Returns the rational fraction for the timecode interval.
    public var rationalValue: Fraction {
        isNegative
            ? absoluteInterval.rationalValue.negated()
            : absoluteInterval.rationalValue
    }
}
