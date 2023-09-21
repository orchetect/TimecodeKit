//
//  Fraction CMTime.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

#if canImport(CoreMedia)

import CoreMedia
import Foundation

@available(macOS 10.7, iOS 4.0, tvOS 9.0, watchOS 6.0, *)
extension Fraction {
    public init(_ cmTime: CMTime) {
        guard !cmTime.isIndefinite,
              !cmTime.isNegativeInfinity,
              !cmTime.isPositiveInfinity
        else {
            self.init(0, 1)
            return
        }
        
        self.init(Int(cmTime.value), Int(cmTime.timescale))
    }
    
    /// Returns the fraction as a new `CMTime` instance.
    public func toCMTime() -> CMTime {
        CMTime(self)
    }
}

@available(macOS 10.7, iOS 4.0, tvOS 9.0, watchOS 6.0, *)
extension CMTime {
    public init(_ fraction: Fraction) {
        self.init(
            value: CMTimeValue(fraction.numerator),
            timescale: CMTimeScale(fraction.denominator)
        )
    }
    
    /// Returns the fraction as a new ``Fraction`` instance.
    public func toFraction() -> Fraction {
        Fraction(self)
    }
}

#endif
