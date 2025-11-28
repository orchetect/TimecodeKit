/// ----------------------------------------------
/// ----------------------------------------------
/// OTCore/Extensions/Swift/FloatingPoint.swift
///
/// Borrowed from OTCore 1.4.14 under MIT license.
/// https://github.com/orchetect/OTCore
/// Methods herein are unit tested at their source
/// so no unit tests are necessary.
/// ----------------------------------------------
/// ----------------------------------------------

#if canImport(Foundation)

import Foundation

// MARK: - Digit Places

extension Double {
    /// **OTCore:**
    /// Returns the number of digit places of the ``integral`` portion (left of the decimal).
    package var integralDigitPlaces: Int {
        Decimal(self).integralDigitPlaces
    }
    
    /// **OTCore:**
    /// Returns the number of digit places of the ``fraction`` portion (right of the decimal).
    package var fractionDigitPlaces: Int {
        Decimal(self).fractionDigitPlaces
    }
}

#endif
