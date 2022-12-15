//
//  Fraction.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Numerical fraction containing a numerator and a denominator.
public struct Fraction {
    public let numerator: Int
    public let denominator: Int
    
    private let _isSimplestForm: Bool?
    public var isSimplestForm: Bool {
        if let _isSimplestForm = _isSimplestForm, _isSimplestForm { return _isSimplestForm }
        let reduced = reduced()
        return self == reduced
    }
    
    public init(_ numerator: Int, _ denominator: Int) {
        self.numerator = numerator
        self.denominator = denominator
        _isSimplestForm = nil
    }
    
    internal init(reducing numerator: Int, _ denominator: Int) {
        let reduced = Self.reduce(n: numerator, d: denominator)
        self.numerator = reduced.n
        self.denominator = reduced.d
        _isSimplestForm = true
    }
    
    public var doubleValue: Double {
        Double(numerator) / Double(denominator)
    }
    
    public var floatValue: Float {
        Float(doubleValue)
    }
}

extension Fraction: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.numerator == rhs.numerator
        && lhs.denominator == rhs.denominator
    }
}

extension Fraction: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(numerator)
        hasher.combine(denominator)
    }
}

extension Fraction: CustomStringConvertible {
    public var description: String {
        "\(numerator)/\(denominator)"
    }
}

extension Fraction {
    internal static func reduce(n: Int, d: Int) -> (n: Int, d: Int) {
        var v = n
        var u = d
        
        // Euclid's solution to finding the Greatest Common Denominator
        while (v != 0) {
            (v, u) = (u % v, v)
        }
        
        return (n / u, d / u)
    }
    
    public func reduced() -> Fraction {
        if _isSimplestForm == true { return self }
        return Fraction(reducing: numerator, denominator)
    }
}

// MARK: Double

extension Double {
    /// Internal:
    /// Converts a floating-point number to its simplest rational fraction.
    ///
    /// - Parameters:
    ///   - precision: Number of places after the decimal to preserve.
    /// - Returns: Numerator and denominator.
    internal func rational(
        precision: Int = 10
    ) -> Fraction {
        let pad = Int(truncating: pow(10, precision) as NSNumber)
        let n = Int(self * Double(pad))
        let d = pad
        
        return Fraction(n, d).reduced()
    }
}
