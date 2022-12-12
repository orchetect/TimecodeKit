//
//  Math.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension Double {
    /// Internal:
    /// Naïvely simplifies a floating-point number to its simplest rational fraction.
    ///
    /// - Parameters:
    ///   - precision: Number of places after the decimal to preserve.
    /// - Returns: Numerator and denominator.
    internal func rational(
        precision: Int = 10
    ) -> (numerator: Int, denominator: Int) {
        let pad = Int(truncating: pow(10, precision) as NSNumber)
        let n = Int(self * Double(pad))
        let d = pad
        
        return simplify(fraction: (numerator: n, denominator: d))
    }
}

/// Internal:
/// Reduces a fraction to its simplest form.
func simplify(
    fraction: (numerator: Int, denominator: Int)
) -> (numerator: Int, denominator: Int) {
    var n = fraction.numerator
    var d = fraction.denominator
    
    func simplify(_ n: inout Int, _ d: inout Int) {
        if n % 10 == 0, d % 10 == 0 {
            n = n / 10
            d = d / 10
            simplify(&n, &d)
            return
        }
        if n % 2 == 0, d % 2 == 0 {
            n = n / 2
            d = d / 2
            simplify(&n, &d)
            return
        }
    }
    
    simplify(&n, &d)
    return (n, d)
}
