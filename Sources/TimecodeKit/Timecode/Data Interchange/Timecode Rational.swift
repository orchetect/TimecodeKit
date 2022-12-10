//
//  Timecode Rational.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension Timecode {
    public init(
        rational: (numerator: Int, denominator: Int),
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        frameRate = rate
        upperLimit = limit
        subFramesBase = base
        stringFormat = format
        
        let rt = Double(rational.numerator) / Double(rational.denominator)
        try setTimecode(realTime: rt)
    }
    
    // TODO: add additional inits for clamping/wrapping/rawValues
    
    /// Returns the time location as a rational fraction.
    /// Evaluating the fraction produces the elapsed seconds.
    public var rationalValue: (numerator: Int, denominator: Int) {
        realTimeValue.rational()
    }
}

// MARK: Helpers

extension Double {
    /// Internal:
    /// Reduces a floating-point number to its simplest rational fraction.
    ///
    /// - Parameters:
    ///   - precision: Number of places after the decimal to preserve.
    /// - Returns: Numerator and denominator.
    internal func rational(
        precision: Int = 10
    ) -> (numerator: Int, denominator: Int) {
        let pad = Int(truncating: pow(10, precision) as NSNumber)
        var n = Int(self * Double(pad))
        var d = pad
        
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
}
