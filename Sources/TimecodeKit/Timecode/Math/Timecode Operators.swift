//
//  Timecode Operators.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// MARK: - Math operators: Self, Self

extension Timecode {
    /// a.k.a. `lhs.adding(rhs, by: wrapping)`
    public static func + (lhs: Self, rhs: Self) -> Timecode {
        if lhs.frameRate == rhs.frameRate {
            return lhs.adding(rhs.components, by: .wrapping)
        } else {
            guard let rhsConverted = try? rhs.converted(to: lhs.frameRate) else {
                assertionFailure(
                    "Could not convert right-hand Timecode operand to left-hand Timecode frameRate."
                )
                return lhs
            }
            
            return lhs.adding(rhsConverted.components, by: .wrapping)
        }
    }
    
    /// a.k.a. `lhs.add(rhs, by: wrapping)`
    public static func += (lhs: inout Self, rhs: Self) {
        if lhs.frameRate == rhs.frameRate {
            lhs.add(rhs.components, by: .wrapping)
        } else {
            guard let rhsConverted = try? rhs.converted(to: lhs.frameRate) else {
                assertionFailure(
                    "Could not convert right-hand Timecode operand to left-hand Timecode frameRate."
                )
                return
            }
            
            return lhs.add(rhsConverted.components, by: .wrapping)
        }
    }
    
    /// a.k.a. `lhs.subtracting(rhs, by: wrapping)`
    public static func - (lhs: Self, rhs: Self) -> Timecode {
        if lhs.frameRate == rhs.frameRate {
            return lhs.subtracting(rhs.components, by: .wrapping)
        } else {
            guard let rhsConverted = try? rhs.converted(to: lhs.frameRate) else {
                assertionFailure(
                    "Could not convert right-hand Timecode operand to left-hand Timecode frameRate."
                )
                return lhs
            }
            
            return lhs.subtracting(rhsConverted.components, by: .wrapping)
        }
    }
    
    /// a.k.a. `lhs.subtract(rhs, by: wrapping)`
    public static func -= (lhs: inout Self, rhs: Self) {
        if lhs.frameRate == rhs.frameRate {
            lhs.subtract(rhs.components, by: .wrapping)
        } else {
            guard let rhsConverted = try? rhs.converted(to: lhs.frameRate) else {
                assertionFailure(
                    "Could not convert right-hand Timecode operand to left-hand Timecode frameRate."
                )
                return
            }
            
            return lhs.subtract(rhsConverted.components, by: .wrapping)
        }
    }
}

// MARK: - Math operators: Self, BinaryInteger

extension Timecode {
    /// a.k.a. `lhs.multiplying(rhs, by: wrapping)`
    public static func * <T: BinaryInteger>(lhs: Self, rhs: T) -> Self {
        lhs.multiplying(Double(rhs), by: .wrapping)
    }
    
    /// a.k.a. `lhs.multiply(rhs, by: wrapping)`
    public static func *= <T: BinaryInteger>(lhs: inout Self, rhs: T) {
        lhs.multiply(Double(rhs), by: .wrapping)
    }
    
    /// a.k.a. `lhs.dividing(rhs, by: wrapping)`
    public static func / <T: BinaryInteger>(lhs: Self, rhs: T) -> Self {
        lhs.dividing(Double(rhs), by: .wrapping)
    }
    
    /// a.k.a. `lhs.divide(rhs, by: wrapping)`
    public static func /= <T: BinaryInteger>(lhs: inout Self, rhs: T) {
        lhs.divide(Double(rhs), by: .wrapping)
    }
}

// MARK: - Math operators: Self, Double

extension Timecode {
    /// a.k.a. `lhs.multiplying(rhs, by: wrapping)`
    public static func * (lhs: Self, rhs: Double) -> Self {
        lhs.multiplying(rhs, by: .wrapping)
    }
    
    /// a.k.a. `lhs.multiply(rhs, by: wrapping)`
    public static func *= (lhs: inout Self, rhs: Double) {
        lhs.multiply(rhs, by: .wrapping)
    }
    
    /// a.k.a. `lhs.dividing(rhs, by: wrapping)`
    public static func / (lhs: Self, rhs: Double) -> Self {
        lhs.dividing(rhs, by: .wrapping)
    }
    
    /// a.k.a. `lhs.divide(rhs, by: wrapping)`
    public static func /= (lhs: inout Self, rhs: Double) {
        lhs.divide(rhs, by: .wrapping)
    }
}
