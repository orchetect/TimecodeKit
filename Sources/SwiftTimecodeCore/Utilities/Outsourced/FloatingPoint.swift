/// ----------------------------------------------
/// ----------------------------------------------
/// OTCore/Extensions/Swift/FloatingPoint.swift
///
/// Borrowed from OTCore 1.4.2 under MIT license.
/// https://github.com/orchetect/OTCore
/// Methods herein are unit tested at their source
/// so no unit tests are necessary.
/// ----------------------------------------------
/// ----------------------------------------------

// MARK: - .truncated() / .rounded

extension FloatingPoint where Self: FloatingPointPowerComputable {
    /// Rounds to `decimalPlaces` number of decimal places using rounding `rule`.
    ///
    /// If `decimalPlaces` <= 0, trunc(self) is returned.
    @_disfavoredOverload
    package func rounded(
        _ rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero,
        decimalPlaces: Int
    ) -> Self {
        if decimalPlaces < 1 {
            return rounded(rule)
        }
        
        let offset = Self(10).power(Self(decimalPlaces))
        
        return (self * offset).rounded(rule) / offset
    }
    
    /// Replaces this value by rounding it to `decimalPlaces` number of decimal places using rounding `rule`.
    ///
    /// If `decimalPlaces` <= 0, `trunc(self)` is used.
    @_disfavoredOverload
    package mutating func round(
        _ rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero,
        decimalPlaces: Int
    ) {
        self = rounded(rule, decimalPlaces: decimalPlaces)
    }
}
