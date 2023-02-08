//
//  Comparable.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Darwin
import Foundation

extension Timecode: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.realTimeValue.rounded(decimalPlaces: 9)
            ==
            rhs.realTimeValue.rounded(decimalPlaces: 9)
    }
}

extension Timecode: Comparable {
    /// Baseline linear comparison.
    ///
    /// This performs a face-value comparison that does not take timelines into consideration.
    ///
    /// ie:
    ///
    /// - `00:00:00:00 < 23:00:00:00 // true`
    /// - `23:00:00:00 < 00:00:00:00 // false`
    /// - `23:00:00:00 < 23:00:00:00 // false`
    ///
    /// For comparison based on a timeline that does not start at 00:00:00:00, see ``compare(to:timelineStart:)``.
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.realTimeValue.rounded(decimalPlaces: 9)
            <
            rhs.realTimeValue.rounded(decimalPlaces: 9)
    }
}

extension Timecode {
    /// Compare two ``Timecode`` instances, optionally using a timeline that does not start at
    /// 00:00:00:00. Timeline length and wrap point is determined by the ``upperLimit`` property.
    /// The timeline is considered linear for 24 hours (or 100 days) from this start time.
    ///
    /// For example, given 24 hour limit:
    ///
    /// - 00:00:00:00 and 23:00:00:00, timeline start 00:00:00:00:
    ///   returns `orderedAscending`
    /// - 00:00:00:00 and 23:00:00:00, timeline start 22:00:00:00:
    ///   returns `orderedDescending` since the period from 22 hours to 24 hours is earlier than
    ///   0 hours though 22 hours. (the timeline runs 24 consecutive hours from 22:00:00:00 through
    ///   00:00:00:00 through 21:59:59:XX)
    ///
    /// Passing `timelineStart` of zero (00:00:00:00) is the same as using the `<` or `>` operator
    /// between two ``Timecode`` instances.
    public func compare(to other: Timecode, timelineStart: Timecode? = nil) -> ComparisonResult {
        // identical timecodes can early-return
        if self == other { return .orderedSame }
        
        guard let timelineStart = timelineStart, !timelineStart.isZero else {
            // standard operator compare will work if timeline start is nil or zero (both mean zero)
            if self < other { return .orderedAscending }
            else { return .orderedDescending }
        }
        
        // non-zero timeline start
        
        let timelineStartFrameCount = timelineStart.frameCount.decimalValue
        var lhsFrameCount = frameCount.decimalValue
        var rhsFrameCount = other.frameCount.decimalValue
        
        if lhsFrameCount >= timelineStartFrameCount {
            let lhsOneDay = Timecode(rawValues: TCC(d: 1),
                                     at: frameRate,
                                     limit: ._100days,
                                     base: subFramesBase)
                .frameCount.decimalValue
            lhsFrameCount -= lhsOneDay
        }
        if rhsFrameCount >= timelineStartFrameCount {
            let rhsOneDay = Timecode(rawValues: TCC(d: 1),
                                     at: other.frameRate,
                                     limit: ._100days,
                                     base: other.subFramesBase)
                .frameCount.decimalValue
            rhsFrameCount -= rhsOneDay
        }
        
        if lhsFrameCount < rhsFrameCount {
            return .orderedAscending
        } else {
            return .orderedDescending
        }
    }
}
