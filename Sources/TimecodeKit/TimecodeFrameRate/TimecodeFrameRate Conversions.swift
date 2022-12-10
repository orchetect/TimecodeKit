//
//  TimecodeFrameRate Conversions.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension TimecodeFrameRate {
    // MARK: Rational
    
    // TODO: add init from rational frame duration fraction
    
    /// Initialize from a frame rate expressed as a rational number (fraction).
    ///
    /// Since a fraction alone cannot encode whether a rate is drop or not, you must
    /// specify whether the rate is drop. (For example: both 29.97 drop and non-drop
    /// use the same numerator and denominators of 30000/1001, drop must be
    /// imperatively specified.)
    ///
    /// To get the rational numerator and denominator of a rate, query the
    /// ``rationalFrameRate`` property.
    public init?(
        rational: (numerator: Int, denominator: Int),
        drop: Bool = false
    ) {
        let foundMatches = Self.allCases.filter(rational: rational)
        guard !foundMatches.isEmpty else { return nil }
        
        guard let foundMatch = foundMatches.first(where: { $0.isDrop == drop })
        else { return nil }
        
        self = foundMatch
    }
}
