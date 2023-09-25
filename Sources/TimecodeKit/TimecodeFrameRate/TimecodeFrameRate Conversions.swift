//
//  TimecodeFrameRate Conversions.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension TimecodeFrameRate {
    /// Returns the corresponding ``VideoFrameRate`` case.
    ///
    /// - Parameters:
    ///   - interlaced: Whether video frame rate is interlaced (`true`) or progressive (`false`).
    public func videoFrameRate(interlaced: Bool) -> VideoFrameRate? {
        switch self {
        case ._23_976:      return interlaced ? nil      : ._23_98p
        case ._24:          return interlaced ? nil      : ._24p
        case ._24_98:       return interlaced ? nil      : ._25p // TODO: needs testing
        case ._25:          return interlaced ? ._25i    : ._25i
        case ._29_97:       return interlaced ? ._29_97i : ._29_97p
        case ._29_97_drop:  return interlaced ? ._29_97i : ._29_97p
        case ._30:          return interlaced ? nil      : ._30p     // 30i could exist?
        case ._30_drop:     return interlaced ? nil      : ._30p
        case ._47_952:      return interlaced ? nil      : ._47_95p
        case ._48:          return interlaced ? nil      : ._48p
        case ._50:          return interlaced ? ._50i    : ._50p
        case ._59_94:       return interlaced ? nil      : ._59_94p  // TODO: 59.94i exists
        case ._59_94_drop:  return interlaced ? nil      : ._59_94p  // TODO: 59.94i exists
        case ._60:          return interlaced ? ._60i    : ._60p
        case ._60_drop:     return interlaced ? nil      : ._60p
        case ._95_904:      return interlaced ? nil      : ._95_9p
        case ._96:          return interlaced ? nil      : ._96p
        case ._100:         return interlaced ? nil      : ._100p
        case ._119_88:      return interlaced ? nil      : ._119_88p // 119.88i could exist?
        case ._119_88_drop: return interlaced ? nil      : ._119_88p // 119.88i could exist?
        case ._120:         return interlaced ? nil      : ._120p    // 120i could exist?
        case ._120_drop:    return interlaced ? nil      : ._120p
        }
    }
}

extension TimecodeFrameRate {
    // MARK: Rational
    
    /// Initialize from a frame rate (fps) expressed as a rational number (fraction).
    ///
    /// - Note: Some file formats encode video frame rate and/or time locations (timecode) in
    /// rational number notation: a fraction of two whole number integers. (AAF encodes video rate
    /// this way, whereas FCPXML (Final Cut Pro) encodes both video rate and time locations as
    /// fractions.)
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
    /// - Note: Some file formats encode video frame rate and/or time locations (timecode) in
    /// rational number notation: a fraction of two whole number integers. (AAF encodes video rate
    /// this way, whereas FCPXML (Final Cut Pro) encodes both video rate and time locations as
    /// fractions.)
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
    ///
    /// - Note: Many AVFoundation and Core Media objects utilize `CMTime` as a way to represent
    /// times and durations.
    ///
    /// - Note: Some file formats encode video frame rate and/or time locations (timecode) in
    /// rational number notation: a fraction of two whole number integers. (AAF encodes video rate
    /// this way, whereas FCPXML (Final Cut Pro) encodes both video rate and time locations as
    /// fractions.)
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
    ///
    /// - Note: Many AVFoundation and Core Media objects utilize `CMTime` as a way to represent
    /// times and durations.
    ///
    /// - Note: Some file formats encode video frame rate and/or time locations (timecode) in
    /// rational number notation: a fraction of two whole number integers. (AAF encodes video rate
    /// this way, whereas FCPXML (Final Cut Pro) encodes both video rate and time locations as
    /// fractions.)
    public init?(
        frameDuration cmTime: CMTime,
        drop: Bool = false
    ) {
        self.init(
            frameDuration: Fraction(Int(cmTime.value), Int(cmTime.timescale)),
            drop: drop
        )
    }
    
    // NOTE: `rateCMTime` and `frameDurationCMTime` properties are implemented on `FrameRateProtocol`
}
#endif
