//
//  Timecode Operators.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

// MARK: - Math operators: Self, Self

extension Timecode {
    /// a.k.a. `lhs.adding(rhs, by: wrapping)`
    public static func + (lhs: Self, rhs: Self) -> Timecode {
        do {
            return try lhs.adding(rhs, by: .wrapping)
        } catch {
            assertionFailure(
                "Could not convert right-hand Timecode operand to left-hand Timecode frameRate."
            )
            return lhs
        }
    }
    
    /// a.k.a. `lhs.add(rhs, by: wrapping)`
    public static func += (lhs: inout Self, rhs: Self) {
        do {
            try lhs.add(rhs, by: .wrapping)
        } catch {
            assertionFailure(
                "Could not convert right-hand Timecode operand to left-hand Timecode frameRate."
            )
            return
        }
    }
    
    /// a.k.a. `lhs.subtracting(rhs, by: wrapping)`
    public static func - (lhs: Self, rhs: Self) -> Timecode {
        do {
            return try lhs.subtracting(rhs, by: .wrapping)
        } catch {
            assertionFailure(
                "Could not convert right-hand Timecode operand to left-hand Timecode frameRate."
            )
            return lhs
        }
    }
    
    /// a.k.a. `lhs.subtract(rhs, by: wrapping)`
    public static func -= (lhs: inout Self, rhs: Self) {
        do {
            try lhs.subtract(rhs, by: .wrapping)
        } catch {
            assertionFailure(
                "Could not convert right-hand Timecode operand to left-hand Timecode frameRate."
            )
            return
        }
    }
    
    /// a.k.a. `lhs.dividing(rhs)`
    public static func / (lhs: Self, rhs: Self) -> Double {
        do {
            return try lhs.dividing(rhs)
        } catch {
            assertionFailure(
                "Could not convert right-hand Timecode operand to left-hand Timecode frameRate."
            )
            return 1.0
        }
    }
}

// MARK: - Math Operators

extension Timecode {
    // MARK: - *
    
    /// a.k.a. `lhs.multiplying(rhs, by: wrapping)`
    public static func * (lhs: Self, rhs: Double) -> Self {
        lhs.multiplying(rhs, by: .wrapping)
    }
    
    /// a.k.a. `lhs.multiplying(rhs, by: wrapping)`
    public static func * <T: BinaryInteger>(lhs: Self, rhs: T) -> Self {
        lhs.multiplying(Double(rhs), by: .wrapping)
    }
    
    // MARK: - *=
    
    /// a.k.a. `lhs.multiply(rhs, by: wrapping)`
    public static func *= (lhs: inout Self, rhs: Double) {
        lhs.multiply(rhs, by: .wrapping)
    }
    
    /// a.k.a. `lhs.multiply(rhs, by: wrapping)`
    public static func *= <T: BinaryInteger>(lhs: inout Self, rhs: T) {
        lhs.multiply(Double(rhs), by: .wrapping)
    }
    
    // MARK: - /
    
    /// a.k.a. `lhs.dividing(rhs, by: wrapping)`
    public static func / (lhs: Self, rhs: Double) -> Self {
        lhs.dividing(rhs, by: .wrapping)
    }
    
    /// a.k.a. `lhs.dividing(rhs, by: wrapping)`
    public static func / <T: BinaryInteger>(lhs: Self, rhs: T) -> Self {
        lhs.dividing(Double(rhs), by: .wrapping)
    }
    
    // MARK: - /=
    
    /// a.k.a. `lhs.divide(rhs, by: wrapping)`
    public static func /= (lhs: inout Self, rhs: Double) {
        lhs.divide(rhs, by: .wrapping)
    }
    
    /// a.k.a. `lhs.divide(rhs, by: wrapping)`
    public static func /= <T: BinaryInteger>(lhs: inout Self, rhs: T) {
        lhs.divide(Double(rhs), by: .wrapping)
    }
}
