//
//  Delta Unary Operators.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension Timecode {
    /// Returns self as a negative `Delta`.
    public static prefix func - (operand: Self) -> Delta {
        Delta(operand, .negative)
    }
    
    /// Returns self as a positive `Delta`.
    public static prefix func + (operand: Self) -> Delta {
        Delta(operand, .positive)
    }
}
