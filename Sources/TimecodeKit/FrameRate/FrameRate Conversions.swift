//
//  FrameRate Conversions.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
@_implementationOnly import OTCore

extension Timecode.FrameRate {
    /// Initialize from raw floating-point frame rate (fps).
    ///
    /// A floating-point fps value can't always explicitly determine a BITC frame rate. Drop frame information cannot be conveyed. For example, 29.97002997 is ambiguous as it is valid for both 29.97 non-drop, 29.97 drop, and 30 drop. For this purpose, the `favorDropFrame` parameter will return the drop-frame variant if the raw rate matches more than one rate.
    ///
    /// `nil` is returned if rate does not match any of the supported rates. (Rate is non-standard or variable (VFR))
    @_disfavoredOverload
    public init?(
        raw: Float,
        favorDropFrame: Bool = false
    ) {
        self.init(
            raw: Double(raw),
            favorDropFrame: favorDropFrame
        )
    }
    
    /// Initialize from raw floating-point frame rate (fps).
    ///
    /// A floating-point fps value can't always explicitly determine a BITC frame rate. Drop frame information cannot be conveyed. For example, 29.97002997 is ambiguous as it is valid for both 29.97 non-drop, 29.97 drop, and 30 drop. For this purpose, the `favorDropFrame` parameter will return the drop-frame variant if the raw rate matches more than one rate.
    ///
    /// `nil` is returned if rate does not match any of the supported rates. (Rate is non-standard or variable (VFR))
    public init?(
        raw: Double,
        favorDropFrame: Bool = false
    ) {
        let findMatches = Self.allCases.filter {
            $0.frameRateForRealTimeCalculation.truncated(decimalPlaces: 3)
                == raw.truncated(decimalPlaces: 3)
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
