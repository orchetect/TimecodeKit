//
//  Comparable.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Darwin

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
    /// For comparison based on a timeline that does not start at 00:00:00:00, see ``isLessThan(_:timelineStart:)``.
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.realTimeValue.rounded(decimalPlaces: 9)
            <
            rhs.realTimeValue.rounded(decimalPlaces: 9)
    }
}
