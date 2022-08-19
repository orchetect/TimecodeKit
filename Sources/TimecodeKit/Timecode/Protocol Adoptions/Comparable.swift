//
//  Comparable.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Darwin

extension Timecode: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        trunc(lhs.realTimeValue * 9) == trunc(rhs.realTimeValue * 9)
    }
}

extension Timecode: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        trunc(lhs.realTimeValue * 9) < trunc(rhs.realTimeValue * 9)
    }
}
