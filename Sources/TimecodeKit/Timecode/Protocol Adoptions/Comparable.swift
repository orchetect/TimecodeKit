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
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.realTimeValue.rounded(decimalPlaces: 9)
            <
            rhs.realTimeValue.rounded(decimalPlaces: 9)
    }
}
