//
//  TimecodeFrameRate Conversions.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension TimecodeFrameRate {
    // MARK: Rational
    
    /// Initialize from a frame rate (fps) expressed as a rational number (fraction).
    ///
    /// Since a fraction alone cannot encode whether a rate is drop or not, you must
    /// specify whether the rate is drop. (For example: both 29.97 drop and non-drop
    /// use the same numerator and denominators of 30000/1001, drop must be
    /// imperatively specified.)
    ///
    /// To get the rational numerator and denominator of a rate, query the
    /// ``rate`` property.
    public init?(
        rate: Fraction,
        drop: Bool = false
    ) {
        let foundMatches = Self.allCases.filter(rate: rate)
        guard !foundMatches.isEmpty else { return nil }
        
        guard let foundMatch = foundMatches.first(where: { $0.isDrop == drop })
        else { return nil }
        
        self = foundMatch
    }
    
    /// Initialize from a frame rate's frame duration expressed as a rational number (fraction).
    ///
    /// Since a fraction alone cannot encode whether a rate is drop or not, you must
    /// specify whether the rate is drop. (For example: both 29.97 drop and non-drop
    /// use the same numerator and denominators of 1001/30000, drop must be
    /// imperatively specified.)
    ///
    /// To get the rational numerator and denominator of a rate's frame duration, query the
    /// ``frameDuration`` property.
    public init?(
        frameDuration: Fraction,
        drop: Bool = false
    ) {
        let foundMatches = Self.allCases.filter(frameDuration: frameDuration)
        guard !foundMatches.isEmpty else { return nil }
        
        guard let foundMatch = foundMatches.first(where: { $0.isDrop == drop })
        else { return nil }
        
        self = foundMatch
    }
}

#if canImport(CoreMedia)
import CoreMedia

@available(macOS 10.7, iOS 4.0, tvOS 9.0, watchOS 6.0, *)
extension TimecodeFrameRate {
    /// Initialize from a frame rate (fps) expressed as a rational number (fraction).
    public init?(
        rate cmTime: CMTime,
        drop: Bool = false
    ) {
        self.init(
            rate: Fraction(Int(cmTime.value), Int(cmTime.timescale)),
            drop: drop
        )
    }
    
    /// Initialize from a frame rate's frame duration expressed as a rational number (fraction).
    public init?(
        frameDuration cmTime: CMTime,
        drop: Bool = false
    ) {
        self.init(
            frameDuration: Fraction(Int(cmTime.value), Int(cmTime.timescale)),
            drop: drop
        )
    }
    
    /// Returns the frame rate (fps) as a rational number (fraction)
    /// as a CoreMedia `CMTime` instance.
    public var rateCMTime: CMTime {
        CMTime(
            value: CMTimeValue(rate.numerator),
            timescale: CMTimeScale(rate.denominator)
        )
    }
    
    /// Returns the duration of 1 frame as a rational number (fraction)
    /// as a CoreMedia `CMTime` instance.
    public var frameDurationCMTime: CMTime {
        CMTime(
            value: CMTimeValue(frameDuration.numerator),
            timescale: CMTimeScale(frameDuration.denominator)
        )
    }
}
#endif

