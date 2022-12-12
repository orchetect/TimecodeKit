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
    /// ``rationalRate`` property.
    public init?(
        rationalRate: (numerator: Int, denominator: Int),
        drop: Bool = false
    ) {
        let foundMatches = Self.allCases.filter(rationalRate: rationalRate)
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
    /// ``rationalFrameDuration`` property.
    public init?(
        rationalFrameDuration: (numerator: Int, denominator: Int),
        drop: Bool = false
    ) {
        let foundMatches = Self.allCases.filter(rationalFrameDuration: rationalFrameDuration)
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
        rationalRate cmTime: CMTime,
        drop: Bool = false
    ) {
        self.init(
            rationalRate: (Int(cmTime.value), Int(cmTime.timescale)),
            drop: drop
        )
    }
    
    /// Initialize from a frame rate's frame duration expressed as a rational number (fraction).
    public init?(
        rationalFrameDuration cmTime: CMTime,
        drop: Bool = false
    ) {
        self.init(
            rationalFrameDuration: (Int(cmTime.value), Int(cmTime.timescale)),
            drop: drop
        )
    }
    
    /// Returns the frame rate (fps) as a rational number (fraction)
    /// as a CoreMedia `CMTime` instance.
    public var rationalRateCMTime: CMTime {
        CMTime(
            value: CMTimeValue(rationalRate.numerator),
            timescale: CMTimeScale(rationalRate.denominator)
        )
    }
    
    /// Returns the duration of 1 frame as a rational number (fraction)
    /// as a CoreMedia `CMTime` instance.
    public var rationalFrameDurationCMTime: CMTime {
        CMTime(
            value: CMTimeValue(rationalFrameDuration.numerator),
            timescale: CMTimeScale(rationalFrameDuration.denominator)
        )
    }
}
#endif

