//
//  VideoFrameRate Conversions.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension VideoFrameRate {
    /// Returns the corresponding ``TimecodeFrameRate`` case.
    ///
    /// - Parameters:
    ///   - drop: Whether timecode frame rate is drop or non-drop.
    public func timecodeFrameRate(drop: Bool) -> TimecodeFrameRate? {
        switch self {
        case ._23_98p:  return drop ? nil           : ._23_976
        case ._24p:     return drop ? nil           : ._24
        case ._25p:     return drop ? nil           : ._25
        case ._25i:     return drop ? nil           : ._25
        case ._29_97p:  return drop ? ._29_97_drop  : ._29_97
        case ._29_97i:  return drop ? ._29_97_drop  : ._29_97
        case ._30p:     return drop ? ._30_drop     : ._30
        case ._47_592p: return drop ? nil           : ._47_952
        case ._48p:     return drop ? nil           : ._48
        case ._50p:     return drop ? nil           : ._50
        case ._50i:     return drop ? nil           : ._50
        case ._59_94p:  return drop ? ._59_94_drop  : ._59_94
        case ._60p:     return drop ? ._60_drop     : ._60
        case ._60i:     return drop ? nil           : ._60
        case ._100p:    return drop ? nil           : ._100
        case ._119_88p: return drop ? ._119_88_drop : ._119_88
        case ._120p:    return drop ? nil           : ._120
        }
    }
    
    // MARK: Raw fps
    
    /// Initialize from floating-point frame rate (fps).
    @_disfavoredOverload
    public init?(fps: Float, interlaced: Bool = false) {
        self.init(fps: Double(fps), interlaced: interlaced)
    }
    
    /// Initialize from floating-point frame rate (fps).
    public init?(fps: Double, interlaced: Bool = false) {
        let findMatches = Self.allCases.filter {
            $0.fps.truncated(decimalPlaces: 3)
            == fps.truncated(decimalPlaces: 3)
        }
        
        if let firstMatch = findMatches.first(where: { $0.isInterlaced == interlaced }) {
            self = firstMatch
            return
        }
        
        return nil
    }
    
    // MARK: Rational
    
    /// Initialize from a frame rate expressed as a rational number (fraction).
    ///
    /// To get the rational numerator and denominator of a rate, query the
    /// ``rate`` property.
    ///
    /// - Note: Some file formats encode video frame rate and/or time locations (timecode) in
    /// rational number notation: a fraction of two whole number integers. (AAF encodes video rate
    /// this way, whereas FCPXML (Final Cut Pro) encodes both video rate and time locations as
    /// fractions.)
    public init?(
        rate: Fraction,
        interlaced: Bool = false
    ) {
        let foundMatches = Self.allCases.filter(rate: rate)
        guard !foundMatches.isEmpty else { return nil }
        
        guard let foundMatch = foundMatches.first(where: { $0.isInterlaced == interlaced })
        else { return nil }
        
        self = foundMatch
    }
    
    /// Initialize from a frame rate's frame duration expressed as a rational number (fraction).
    ///
    /// To get the rational numerator and denominator of a rate's frame duration, query the
    /// ``frameDuration`` property.
    ///
    /// - Note: Some file formats encode video frame rate and/or time locations (timecode) in
    /// rational number notation: a fraction of two whole number integers. (AAF encodes video rate
    /// this way, whereas FCPXML (Final Cut Pro) encodes both video rate and time locations as
    /// fractions.)
    public init?(
        frameDuration: Fraction,
        interlaced: Bool = false
    ) {
        let foundMatches = Self.allCases.filter(frameDuration: frameDuration)
        guard !foundMatches.isEmpty else { return nil }
        
        guard let foundMatch = foundMatches.first(where: { $0.isInterlaced == interlaced })
        else { return nil }
        
        self = foundMatch
    }
}

#if canImport(CoreMedia)
import CoreMedia

@available(macOS 10.7, iOS 4.0, tvOS 9.0, watchOS 6.0, *)
extension VideoFrameRate {
    /// Initialize from a frame rate (fps) expressed as a rational number (fraction).
    ///
    /// - Note: Many AVFoundation and Core Media objects utilize `CMTime` as a way to communicate
    /// times and durations.
    ///
    /// - Note: Some file formats encode video frame rate and/or time locations (timecode) in
    /// rational number notation: a fraction of two whole number integers. (AAF encodes video rate
    /// this way, whereas FCPXML (Final Cut Pro) encodes both video rate and time locations as
    /// fractions.)
    public init?(
        rate cmTime: CMTime,
        interlaced: Bool = false
    ) {
        self.init(
            rate: Fraction(Int(cmTime.value), Int(cmTime.timescale)),
            interlaced: interlaced
        )
    }
    
    /// Initialize from a frame rate's frame duration expressed as a rational number (fraction).
    ///
    /// - Note: Many AVFoundation and Core Media objects utilize `CMTime` as a way to communicate
    /// times and durations.
    ///
    /// - Note: Some file formats encode video frame rate and/or time locations (timecode) in
    /// rational number notation: a fraction of two whole number integers. (AAF encodes video rate
    /// this way, whereas FCPXML (Final Cut Pro) encodes both video rate and time locations as
    /// fractions.)
    public init?(
        frameDuration cmTime: CMTime,
        interlaced: Bool = false
    ) {
        self.init(
            frameDuration: Fraction(Int(cmTime.value), Int(cmTime.timescale)),
            interlaced: interlaced
        )
    }
    
    /// Returns the frame rate (fps) as a rational number (fraction)
    /// as a CoreMedia `CMTime` instance.
    ///
    /// - Note: Many AVFoundation and Core Media objects utilize `CMTime` as a way to communicate
    /// times and durations.
    ///
    /// - Note: Some file formats encode video frame rate and/or time locations (timecode) in
    /// rational number notation: a fraction of two whole number integers. (AAF encodes video rate
    /// this way, whereas FCPXML (Final Cut Pro) encodes both video rate and time locations as
    /// fractions.)
    public var rateCMTime: CMTime {
        CMTime(
            value: CMTimeValue(rate.numerator),
            timescale: CMTimeScale(rate.denominator)
        )
    }
    
    /// Returns the duration of 1 frame as a rational number (fraction)
    /// as a CoreMedia `CMTime` instance.
    ///
    /// - Note: Many AVFoundation and Core Media objects utilize `CMTime` as a way to communicate
    /// times and durations.
    ///
    /// - Note: Some file formats encode video frame rate and/or time locations (timecode) in
    /// rational number notation: a fraction of two whole number integers. (AAF encodes video rate
    /// this way, whereas FCPXML (Final Cut Pro) encodes both video rate and time locations as
    /// fractions.)
    public var frameDurationCMTime: CMTime {
        CMTime(
            value: CMTimeValue(frameDuration.numerator),
            timescale: CMTimeScale(frameDuration.denominator)
        )
    }
}
#endif
