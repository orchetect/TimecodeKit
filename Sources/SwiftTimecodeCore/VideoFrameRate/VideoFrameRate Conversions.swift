//
//  VideoFrameRate Conversions.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension VideoFrameRate {
    /// Returns the corresponding ``TimecodeFrameRate`` case.
    /// Returns `nil` if there is no corresponding timecode rate.
    ///
    /// - Parameters:
    ///   - drop: Whether timecode frame rate is drop or non-drop.
    public func timecodeFrameRate(drop: Bool) -> TimecodeFrameRate? {
        switch self {
        case .fps23_98p:  drop ? nil         : .fps23_976
        case .fps24p:     drop ? nil         : .fps24
        case .fps25p:     drop ? nil         : .fps25
        case .fps25i:     drop ? nil         : .fps25
        case .fps29_97p:  drop ? .fps29_97d  : .fps29_97
        case .fps29_97i:  drop ? .fps29_97d  : .fps29_97
        case .fps30p:     drop ? .fps30d     : .fps30
        case .fps47_95p:  drop ? nil         : .fps47_952
        case .fps48p:     drop ? nil         : .fps48
        case .fps50p:     drop ? nil         : .fps50
        case .fps50i:     drop ? nil         : .fps50
        case .fps59_94p:  drop ? .fps59_94d  : .fps59_94
        case .fps59_94i:  drop ? .fps59_94d  : .fps59_94
        case .fps60p:     drop ? .fps60d     : .fps60
        case .fps60i:     drop ? nil         : .fps60
        case .fps90p:     drop ? nil         : .fps90
        case .fps95_9p:   drop ? nil         : .fps95_904
        case .fps96p:     drop ? nil         : .fps96
        case .fps100p:    drop ? nil         : .fps100
        case .fps119_88p: drop ? .fps119_88d : .fps119_88
        case .fps120p:    drop ? nil         : .fps120
        }
    }
    
    // MARK: Raw fps
    
    /// Initialize from floating-point frame rate (fps).
    ///
    /// - Parameters:
    ///   - fps: Raw frames per second.
    ///   - interlaced: `true` for interlaced, `false` for progressive.
    ///   - strict: Enforces 3 decimal places of precision if `true` otherwise 1 decimal place.
    @_disfavoredOverload
    public init?(fps: Float, interlaced: Bool = false, strict: Bool = false) {
        self.init(fps: Double(fps), interlaced: interlaced)
    }
    
    /// Initialize from floating-point frame rate (fps).
    ///
    /// - Parameters:
    ///   - fps: Raw frames per second.
    ///   - interlaced: `true` for interlaced, `false` for progressive.
    ///   - strict: Enforces 3 decimal places of precision if `true` otherwise 1 decimal place.
    public init?(fps: Double, interlaced: Bool = false, strict: Bool = false) {
        let decimalPlaces = strict ? 3 : 1
        
        // first try truncating decimal places
        let fpsTruncated = fps.truncated(decimalPlaces: decimalPlaces)
        let truncMatches = Self.allCases.filter {
            $0.fps.truncated(decimalPlaces: decimalPlaces) == fpsTruncated
        }
        if let firstMatch = truncMatches.first(where: { $0.isInterlaced == interlaced }) {
            self = firstMatch
            return
        }
        
        // then try rounding decimal places to loosen up requirements
        let fpsRounded = fps.rounded(decimalPlaces: decimalPlaces)
        let roundMatches = Self.allCases.filter {
            $0.fps.rounded(decimalPlaces: decimalPlaces) == fpsRounded
        }
        if let firstMatch = roundMatches.first(where: { $0.isInterlaced == interlaced }) {
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
    /// - Note: Many AVFoundation and Core Media objects utilize `CMTime` as a way to represent
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
    /// - Note: Many AVFoundation and Core Media objects utilize `CMTime` as a way to represent
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
    
    // NOTE: `rateCMTime` and `frameDurationCMTime` properties are implemented on `FrameRateProtocol`
}
#endif
