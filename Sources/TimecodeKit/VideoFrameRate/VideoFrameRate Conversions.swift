//
//  VideoFrameRate Conversions.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension VideoFrameRate {
    /// Returns the corresponding ``Timecode``.``Timecode/FrameRate-swift.enum`` case.
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
    
    // TODO: add init from rational frame rate fraction
    
    /// Initialize from a frame rate expressed as a rational number (fraction).
    ///
    /// Since a fraction alone cannot encode whether a rate is drop or not, you must
    /// specify whether the rate is drop. (For example: both 29.97 drop and non-drop
    /// use the same numerator and denominators of 30000/1001, drop must be
    /// imperatively specified.)
    ///
    /// To get the rational numerator and denominator of a rate, query the
    /// ``rationalFrameRate`` property.
    public init?(rational: (numerator: Int, denominator: Int),
                 interlaced: Bool = false) {
        let foundMatches = Self.allCases.filter {
            let frac = $0.rationalFrameRate
            return frac.numerator == rational.numerator
            && frac.denominator == rational.denominator
        }
        guard !foundMatches.isEmpty else { return nil }
        
        guard let foundMatch = foundMatches.first(where: { $0.isInterlaced == interlaced })
        else { return nil }
        
        self = foundMatch
    }
}
