//
//  TimecodeFrameRate Conversions.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension TimecodeFrameRate {
    // MARK: Raw fps
    
    /// Initialize from raw floating-point frame rate (fps) by attempting to heuristically match it against known SMPTE frame rates.
    ///
    /// A floating-point fps value can't always explicitly determine a BITC frame rate.
    /// Drop frame information cannot be conveyed.
    /// For example, 29.97002997 is ambiguous as it is valid for both
    /// 29.97 non-drop and 29.97 drop.
    /// For this purpose, the `favorDropFrame` parameter will return
    /// the drop rate variant if the raw rate matches more than one rate.
    ///
    /// `nil` is returned if rate does not match any of the supported rates.
    /// (Rate is non-standard or variable (VFR))
    ///
    /// - Warning: This method is provided as a convenience only and its use is discouraged in production; heuristically interpreting a video file's average frame rate is unreliable. TimecodeKit is designed to work with explicit SMPTE frame rates.
    @_disfavoredOverload
    public init?(
        raw fps: Float,
        favorDropFrame: Bool = false
    ) {
        self.init(
            raw: Double(fps),
            favorDropFrame: favorDropFrame
        )
    }
    
    /// Initialize from raw floating-point frame rate (fps) by attempting to heuristically match it against known SMPTE frame rates.
    ///
    /// A floating-point fps value can't always explicitly determine a BITC frame rate.
    /// Drop frame information cannot be conveyed.
    /// For example, 29.97002997 is ambiguous as it is valid for both
    /// 29.97 non-drop and 29.97 drop.
    /// For this purpose, the `favorDropFrame` parameter will return
    /// the drop rate variant if the raw rate matches more than one rate.
    ///
    /// `nil` is returned if rate does not match any of the supported rates.
    /// (Rate is non-standard or variable (VFR))
    ///
    /// - Warning: This method is provided as a convenience only and its use is discouraged in production; heuristically interpreting a video file's average frame rate is unreliable. TimecodeKit is designed to work with explicit SMPTE frame rates.
    public init?(
        raw fps: Double,
        favorDropFrame: Bool = false
    ) {
        if let videoRate = VideoFrameRate(raw: fps) {
            let r = videoRate.timecodeFrameRate(drop: favorDropFrame)
                ?? videoRate.timecodeFrameRate(drop: !favorDropFrame)
            if let r = r { self = r } else { return nil }
        } else {
            let findMatches = Self.allCases
                //.filter { ![._30_drop, ._60_drop, ._120_drop].contains($0) }
                .filter {
                    $0.frameRateForRealTimeCalculation.truncated(decimalPlaces: 3)
                    == fps.truncated(decimalPlaces: 3)
                }
            
            // in cases where it's not clear which frame rate it is,
            // there may be more than one match
            if favorDropFrame,
               findMatches.count > 1,
               let firstDrop = findMatches.first(where: { $0.isDrop })
            {
                self = firstDrop
                return
            }
            
            if let firstMatch = findMatches.first {
                self = firstMatch
                return
            }
            
            return nil
        }
    }
    
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
    public init?(rational: (numerator: Int, denominator: Int), drop: Bool = false) {
        let foundMatches = Self.allCases.filter {
            let frac = $0.rationalFrameRate
            return frac.numerator == rational.numerator
                && frac.denominator == rational.denominator
        }
        guard !foundMatches.isEmpty else { return nil }
        
        guard let foundMatch = foundMatches.first(where: { $0.isDrop == drop })
        else { return nil }
        
        self = foundMatch
    }
}
