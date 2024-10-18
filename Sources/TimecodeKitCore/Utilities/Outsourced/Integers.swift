/// ----------------------------------------------
/// ----------------------------------------------
/// OTCore/Extensions/Swift/Integers.swift
///
/// Borrowed from OTCore 1.4.2 under MIT license.
/// https://github.com/orchetect/OTCore
/// Methods herein are unit tested at their source
/// so no unit tests are necessary.
/// ----------------------------------------------
/// ----------------------------------------------

// MARK: - Digits

extension BinaryInteger {
    /// Returns number of digits (places to the left of the decimal) in the number.
    ///
    /// ie:
    /// - for the integer 0, this would return 1
    /// - for the integer 5, this would return 1
    /// - for the integer 10, this would return 2
    /// - for the integer 250, this would return 3
    @_documentation(visibility: internal)
    @_disfavoredOverload
    package var numberOfDigits: Int {
        if self < 10 && self >= 0 || self > -10 && self < 0 {
            return 1
        } else {
            return 1 + (self / 10).numberOfDigits
        }
    }
}
