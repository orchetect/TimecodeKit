/// ----------------------------------------------
/// ----------------------------------------------
/// OTCore/Extensions/Foundation/Decimal.swift
///
/// Borrowed from OTCore 1.4.2 under MIT license.
/// https://github.com/orchetect/OTCore
/// Methods herein are unit tested at their source
/// so no unit tests are necessary.
/// ----------------------------------------------
/// ----------------------------------------------

#if canImport(Foundation)

import Foundation

// MARK: - FloatingPointPowerComputable

// MARK: - .power()

extension Decimal {
    /// Same as `pow()`
    /// (Functional convenience method)
    @_disfavoredOverload
    func power(_ exponent: Int) -> Decimal {
        pow(self, exponent)
    }
}

// MARK: - .truncated() / .rounded()

extension Decimal {
    /// Rounds to `decimalPlaces` number of decimal places using rounding `rule`.
    @_disfavoredOverload
    func rounded(
        _ rule: NSDecimalNumber.RoundingMode = .plain,
        decimalPlaces: Int
    ) -> Self {
        var initialDecimal = self
        var roundedDecimal = Decimal()
        let decimalPlaces = max(0, decimalPlaces)
        
        NSDecimalRound(&roundedDecimal, &initialDecimal, decimalPlaces, rule)
        
        return roundedDecimal
    }
    
    /// Replaces this value by rounding it to `decimalPlaces` number of decimal places using rounding `rule`.
    @_disfavoredOverload
    mutating func round(
        _ rule: NSDecimalNumber.RoundingMode = .plain,
        decimalPlaces: Int
    ) {
        self = rounded(rule, decimalPlaces: decimalPlaces)
    }
    
    /// Replaces this value by truncating it to `decimalPlaces` number of decimal places.
    @_disfavoredOverload
    mutating func truncate(decimalPlaces: Int) {
        self = truncated(decimalPlaces: decimalPlaces)
    }
    
    /// Truncates decimal places to `decimalPlaces` number of decimal places.
    @_disfavoredOverload
    func truncated(decimalPlaces: Int) -> Self {
        var initialDecimal = self
        var roundedDecimal = Decimal()
        let decimalPlaces = max(0, decimalPlaces)
        
        if self > 0 {
            NSDecimalRound(&roundedDecimal, &initialDecimal, decimalPlaces, .down)
        } else {
            NSDecimalRound(&roundedDecimal, &initialDecimal, decimalPlaces, .up)
        }
        
        return roundedDecimal
    }
}

extension Decimal {
    /// Similar to `Double.truncatingRemainder(dividingBy:)` from the standard Swift library.
    @_disfavoredOverload
    func truncatingRemainder(dividingBy rhs: Self) -> Self {
        let calculation = self / rhs
        let integral = calculation.truncated(decimalPlaces: 0)
        let fraction = self - (integral * rhs)
        return fraction
    }
    
    /// Similar to `Int.quotientAndRemainder(dividingBy:)` from the standard Swift library.
    @_disfavoredOverload
    func quotientAndRemainder(dividingBy rhs: Self) -> (quotient: Self, remainder: Self) {
        let calculation = self / rhs
        let integral = calculation.truncated(decimalPlaces: 0)
        let fraction = self - (integral * rhs)
        return (quotient: integral, remainder: fraction)
    }
    
    /// Returns both integral part and fractional part.
    ///
    /// - Note: This method is more computationally efficient than calling both `.integral` and .`fraction` properties separately unless you
    ///   only require one or the other.
    @_disfavoredOverload
    var integralAndFraction: (integral: Self, fraction: Self) {
        let integral = truncated(decimalPlaces: 0)
        let fraction = self - integral
        return (integral: integral, fraction: fraction)
    }
    
    /// Returns the integral part (digits before the decimal point)
    @_disfavoredOverload
    var integral: Self {
        integralAndFraction.integral
    }
    
    /// Returns the fractional part (digits after the decimal point)
    ///
    /// Note: this can result in a non-trivial loss of precision for the fractional part.
    @_disfavoredOverload
    var fraction: Self {
        integralAndFraction.fraction
    }
}

extension Decimal {
    /// **OTCore:**
    /// Returns the number of digit places of the ``integral`` portion (left of the decimal).
    var integralDigitPlaces: Int {
        // this works but may be brittle.
        // not sure if some locales will localize the number differently than expected.
        // on English systems the `significand` string interpolation produces
        // a string of digits with no thousands separators or other characters.
        
        if abs(self) <= 1 { return 0 }
        return "\(abs(significand))".count + exponent
    }
    
    /// **OTCore:**
    /// Returns the number of digit places of the ``fraction`` portion (right of the decimal).
    var fractionDigitPlaces: Int {
        max(-exponent, 0)
    }
}

#endif
