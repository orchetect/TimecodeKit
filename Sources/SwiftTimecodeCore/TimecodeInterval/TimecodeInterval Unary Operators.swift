//
//  TimecodeInterval Unary Operators.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension Timecode {
    /// Returns self as a negative ``TimecodeInterval``.
    public static prefix func - (operand: Self) -> TimecodeInterval {
        TimecodeInterval(operand, .minus)
    }
    
    /// Returns self as a positive ``TimecodeInterval``.
    public static prefix func + (operand: Self) -> TimecodeInterval {
        TimecodeInterval(operand, .plus)
    }
}
