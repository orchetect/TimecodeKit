/// ----------------------------------------------
/// ----------------------------------------------
/// OTCore/Extensions/Darwin/FloatingPoint and Darwin.swift
///
/// Borrowed from OTCore 1.4.2 under MIT license.
/// https://github.com/orchetect/OTCore
/// Methods herein are unit tested at their source
/// so no unit tests are necessary.
/// ----------------------------------------------
/// ----------------------------------------------

#if canImport(Darwin)

import Darwin

// MARK: - ceiling / floor

extension FloatingPoint {
    /// Same as `ceil()`
    /// (Functional convenience method)
    @_disfavoredOverload
    var ceiling: Self {
        Darwin.ceil(self)
    }
    
    /// Same as `floor()`
    /// (Functional convenience method)
    @_disfavoredOverload
    var floor: Self {
        Darwin.floor(self)
    }
}

// MARK: - FloatingPointPowerComputable

// MARK: - .power()

extension Double: FloatingPointPowerComputable {
    /// Same as `pow()`
    /// (Functional convenience method)
    @_disfavoredOverload
    func power(_ exponent: Double) -> Double {
        pow(self, exponent)
    }
}

extension Float: FloatingPointPowerComputable {
    /// Same as `powf()`
    /// (Functional convenience method)
    @_disfavoredOverload
    func power(_ exponent: Float) -> Float {
        powf(self, exponent)
    }
}

#if !(arch(arm64) || arch(arm) || os(watchOS)) // Float80 is now removed for ARM
extension Float80: FloatingPointPowerComputable {
    /// Same as `powl()`
    /// (Functional convenience method)
    @_disfavoredOverload
    func power(_ exponent: Float80) -> Float80 {
        powl(self, exponent)
    }
}
#endif

// MARK: - .truncated()

extension FloatingPoint where Self: FloatingPointPowerComputable {
    /// Replaces this value by truncating it to `decimalPlaces` number of decimal places.
    ///
    /// If `decimalPlaces` <= 0, then `trunc(self)` is returned.
    @_disfavoredOverload
    mutating func truncate(decimalPlaces: Int) {
        self = truncated(decimalPlaces: decimalPlaces)
    }
    
    /// Truncates decimal places to `decimalPlaces` number of decimal places.
    ///
    /// If `decimalPlaces` <= 0, then `trunc(self)` is returned.
    @_disfavoredOverload
    func truncated(decimalPlaces: Int) -> Self {
        if decimalPlaces < 1 {
            return trunc(self)
        }
        
        let offset = Self(10).power(Self(decimalPlaces))
        return trunc(self * offset) / offset
    }
}

extension FloatingPoint {
    /// Similar to `Int.quotientAndRemainder(dividingBy:)` from the standard Swift library.
    @_disfavoredOverload
    func quotientAndRemainder(dividingBy rhs: Self) -> (quotient: Self, remainder: Self) {
        let calculation = self / rhs
        let integral = trunc(calculation)
        let fraction = self - (integral * rhs)
        return (quotient: integral, remainder: fraction)
    }
    
    /// Returns both integral part and fractional part.
    ///
    /// - Note: This method is more computationally efficient than calling both `.integral` and .`fraction` properties separately unless you only require one or the other.
    ///
    /// This method can result in a non-trivial loss of precision for the fractional part.
    @_disfavoredOverload
    var integralAndFraction: (integral: Self, fraction: Self) {
        let integral = trunc(self)
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
    /// - Note: this method can result in a non-trivial loss of precision for the fractional part.
    @_disfavoredOverload
    var fraction: Self {
        integralAndFraction.fraction
    }
}

#endif
