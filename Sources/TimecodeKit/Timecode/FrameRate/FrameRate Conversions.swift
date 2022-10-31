//
//  FrameRate Conversions.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension Timecode.FrameRate {
    /// Initialize from raw floating-point frame rate (fps) by attempting to heuristically match it against known SMPTE frame rates.
    ///
    /// A floating-point fps value can't always explicitly determine a BITC frame rate.
    /// Drop frame information cannot be conveyed.
    /// For example, 29.97002997 is ambiguous as it is valid for both
    /// 29.97 non-drop and 29.97 drop.
    /// For this purpose, the `favorDropFrame` parameter will return
    /// the drop-frame variant if the raw rate matches more than one rate.
    ///
    /// `nil` is returned if rate does not match any of the supported rates.
    /// (Rate is non-standard or variable (VFR))
    ///
    /// - Warning: This method is provided as a convenience only and its use is discouraged in production; heuristically interpreting a video file's average frame rate is unreliable. TimecodeKit is designed to work with explicit SMPTE frame rates.
    @_disfavoredOverload
    public init?(
        raw literalFramesPerSecond: Float,
        favorDropFrame: Bool = false
    ) {
        self.init(
            raw: Double(literalFramesPerSecond),
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
    /// the drop-frame variant if the raw rate matches more than one rate.
    ///
    /// `nil` is returned if rate does not match any of the supported rates.
    /// (Rate is non-standard or variable (VFR))
    ///
    /// - Warning: This method is provided as a convenience only and its use is discouraged in production; heuristically interpreting a video file's average frame rate is unreliable. TimecodeKit is designed to work with explicit SMPTE frame rates.
    public init?(
        raw literalFramesPerSecond: Double,
        favorDropFrame: Bool = false
    ) {
        // omit 30-drop and its multiples since they are not video rates
        // and should never be matched
        let findMatches = Self.allCases
            .filter { ![._30_drop, ._60_drop, ._120_drop].contains($0) }
            .filter {
            $0.frameRateForRealTimeCalculation.truncated(decimalPlaces: 3)
                == literalFramesPerSecond.truncated(decimalPlaces: 3)
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
