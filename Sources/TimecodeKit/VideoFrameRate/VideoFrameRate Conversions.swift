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
        case ._23_98p: return drop ? nil          : ._23_976
        case ._24p:    return drop ? nil          : ._24
        case ._25p:    return drop ? nil          : ._25
        case ._25i:    return drop ? nil          : ._25
        case ._29_97p: return drop ? ._29_97_drop : ._29_97
        case ._29_97i: return drop ? ._29_97_drop : ._29_97
        case ._30p:    return drop ? ._30_drop    : ._30
        case ._50p:    return drop ? nil          : ._50
        case ._50i:    return drop ? nil          : ._50
        case ._59_94p: return drop ? ._59_94_drop : ._59_94
        case ._60p:    return drop ? ._60_drop    : ._60
        case ._60i:    return drop ? nil          : ._60
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
    /// ``rationalRate`` property.
    public init?(
        rationalRate: (numerator: Int, denominator: Int),
        interlaced: Bool = false
    ) {
        let foundMatches = Self.allCases.filter(rationalRate: rationalRate)
        guard !foundMatches.isEmpty else { return nil }
        
        guard let foundMatch = foundMatches.first(where: { $0.isInterlaced == interlaced })
        else { return nil }
        
        self = foundMatch
    }
    
    /// Initialize from a frame rate's frame duration expressed as a rational number (fraction).
    ///
    /// To get the rational numerator and denominator of a rate's frame duration, query the
    /// ``rationalFrameDuration`` property.
    public init?(
        rationalFrameDuration: (numerator: Int, denominator: Int),
        interlaced: Bool = false
    ) {
        let foundMatches = Self.allCases.filter(rationalFrameDuration: rationalFrameDuration)
        guard !foundMatches.isEmpty else { return nil }
        
        guard let foundMatch = foundMatches.first(where: { $0.isInterlaced == interlaced })
        else { return nil }
        
        self = foundMatch
    }
}
