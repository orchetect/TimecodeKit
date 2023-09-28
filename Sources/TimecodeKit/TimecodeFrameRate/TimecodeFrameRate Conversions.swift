//
//  TimecodeFrameRate Conversions.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension TimecodeFrameRate {
    /// Returns the corresponding ``VideoFrameRate`` case.
    /// Returns `nil` if there is no corresponding video rate.
    ///
    /// - Parameters:
    ///   - interlaced: Whether video frame rate is interlaced (`true`) or progressive (`false`).
    public func videoFrameRate(interlaced: Bool) -> VideoFrameRate? {
        switch self {
        case .fps23_976:  return interlaced ? nil        : .fps23_98p
        case .fps24:      return interlaced ? nil        : .fps24p
        case .fps24_98:   return interlaced ? nil        : .fps25p // TODO: needs testing
        case .fps25:      return interlaced ? .fps25i    : .fps25i
        case .fps29_97:   return interlaced ? .fps29_97i : .fps29_97p
        case .fps29_97d:  return interlaced ? .fps29_97i : .fps29_97p
        case .fps30:      return interlaced ? nil        : .fps30p     // 30i could exist?
        case .fps30d:     return interlaced ? nil        : .fps30p
        case .fps47_952:  return interlaced ? nil        : .fps47_95p
        case .fps48:      return interlaced ? nil        : .fps48p
        case .fps50:      return interlaced ? .fps50i    : .fps50p
        case .fps59_94:   return interlaced ? nil        : .fps59_94p  // TODO: 59.94i exists
        case .fps59_94d:  return interlaced ? nil        : .fps59_94p  // TODO: 59.94i exists
        case .fps60:      return interlaced ? .fps60i    : .fps60p
        case .fps60d:     return interlaced ? nil        : .fps60p
        case .fps95_904:  return interlaced ? nil        : .fps95_9p
        case .fps96:      return interlaced ? nil        : .fps96p
        case .fps100:     return interlaced ? nil        : .fps100p
        case .fps119_88:  return interlaced ? nil        : .fps119_88p // 119.88i could exist?
        case .fps119_88d: return interlaced ? nil        : .fps119_88p // 119.88i could exist?
        case .fps120:     return interlaced ? nil        : .fps120p    // 120i could exist?
        case .fps120d:    return interlaced ? nil        : .fps120p
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
