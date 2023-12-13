//
//  Fraction.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Numerical fraction containing a numerator and a denominator.
///
/// Used to convert to/from ``Timecode``, Core Media `CMTime`, or metadata encoding such as Final Cut Pro XML or AAF.
public struct Fraction {
    public let numerator: Int
    public let denominator: Int
    
    private let _isReduced: Bool?
    
    /// Returns `true` if the fraction is reduced to its simplest form and can not be reduced any
    /// further.
    public var isReduced: Bool {
        if let _isReduced = _isReduced, _isReduced { return _isReduced }
        let reduced = reduced()
        
        return isIdentical(to: reduced)
    }
    
    /// Returns `true` if one operand of the fraction is negative.
    public var isNegative: Bool {
        let n = numerator.signum() == -1
        let d = denominator.signum() == -1
        return (n && !d) || (!n && d)
    }
    
    /// Returns `true` if the evaluation of the fraction results in a whole integer with
    /// no fractional component (trailing decimal digits).
    public var isWholeInteger: Bool {
        doubleValue.fraction.isZero
    }
    
    // MARK: - Init
    
    /// Initialize with literal values.
    public init(_ numerator: Int, _ denominator: Int) {
        self.numerator = numerator
        self.denominator = denominator
        _isReduced = nil
    }
    
    /// Initialize by reducing and normalizing the fraction.
    public init(reducing numerator: Int, _ denominator: Int) {
        let reduced = reduce(n: numerator, d: denominator)
        self.numerator = reduced.n
        self.denominator = reduced.d
        _isReduced = true
    }
    
    /// Initialize by converting a floating-point number to a given precision (number of decimal
    /// places).
    ///
    /// Note that this conversion may be lossy.
    public init(
        double: Double,
        decimalPrecision: Int = 18
    ) {
        self = double.rational(precision: decimalPrecision)
    }
    
    // MARK: - Conversions
    
    /// Returns the evaluated fraction as a `Double`.
    public var doubleValue: Double {
        Double(numerator) / Double(denominator)
    }
    
    /// Returns the evaluated fraction as a `Float`.
    public var floatValue: Float {
        // converting Double to float produces greater precision than
        // performing the division using Float
        Float(doubleValue)
    }
    
    /// Returns the evaluated fraction as a `Decimal`.
    public var decimalValue: Decimal {
        Decimal(numerator) / Decimal(denominator)
    }
}

extension Fraction: Equatable {
    /// Performs a comparison against literal values.
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.isEqual(to: rhs)
    }
    
    /// Returns `true` if both fractions are mathematically equal (can reduce to the same values).
    public func isEqual(to other: Self) -> Bool {
        let lhsReduced = reduced().normalized()
        let rhsReduced = other.reduced().normalized()
        
        return lhsReduced.isIdentical(to: rhsReduced)
    }
    
    /// Returns `true` if both fractions contain identical numerators and identical denominators.
    public func isIdentical(to other: Self) -> Bool {
        numerator == other.numerator
            && denominator == other.denominator
    }
}

extension Fraction: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(numerator)
        hasher.combine(denominator)
    }
}

extension Fraction: Comparable {
    public static func < (lhs: Fraction, rhs: Fraction) -> Bool {
        lhs.doubleValue < rhs.doubleValue
    }
}

extension Fraction: CustomStringConvertible {
    public var description: String {
        "\(numerator)/\(denominator)"
    }
}

// MARK: - Static Constructors

extension Fraction {
    /// Returns a fraction with the time equivalent of zero.
    public static let zero = Fraction(0, 1)
}

// MARK: - Operations

extension Fraction {
    /// Returns the absolute fraction.
    /// (Returns unmodified if positive, negates if negative.)
    /// The fraction is also normalized.
    public func abs() -> Self {
        let norm = normalized()
        return isNegative ? norm.negated() : norm
    }
    
    /// Returns a new instance reduced to its simplest form.
    /// This also normalizes signs.
    public func reduced() -> Self {
        if _isReduced == true { return self }
        return Fraction(reducing: numerator, denominator)
    }
    
    /// Returns a new instance normalized.
    /// Fractions with two negative signs are normalized to two positive signs.
    /// Fractions with negative denominator are normalized to negative numerator and positive denominator.
    func normalized() -> Self {
        let result = normalize(n: numerator, d: denominator)
        return Fraction(result.n, result.d)
    }
    
    /// Negates the fraction.
    public mutating func negate() {
        var n = numerator
        n.negate()
        self = Self(n, denominator)
    }
    
    /// Returns a new instance negated.
    public func negated() -> Self {
        var n = self
        n.negate()
        return n
    }
}

// MARK: - Math

extension Fraction {
    public static func + (lhs: Self, rhs: Self) -> Self {
        if lhs.denominator == rhs.denominator {
            return Fraction(reducing: lhs.numerator + rhs.numerator, lhs.denominator)
        }
        
        let lcm = leastCommonMultiple(lhs: lhs.denominator, rhs: rhs.denominator)
        
        let num = (lhs.numerator * lcm.lhsMultiplier) + (rhs.numerator * lcm.rhsMultiplier)
        return Fraction(reducing: num, lcm.denominator)
    }
    
    public static func - (lhs: Self, rhs: Self) -> Self {
        if lhs.denominator == rhs.denominator {
            return Fraction(reducing: lhs.numerator - rhs.numerator, lhs.denominator)
        }
        
        let lcm = leastCommonMultiple(lhs: lhs.denominator, rhs: rhs.denominator)
        
        let num = (lhs.numerator * lcm.lhsMultiplier) - (rhs.numerator * lcm.rhsMultiplier)
        return Fraction(reducing: num, lcm.denominator)
    }
}

// MARK: - Double

extension Double {
    /// Internal:
    /// Converts a floating-point number to its simplest rational fraction.
    ///
    /// - Parameters:
    ///   - precision: Number of places after the decimal to preserve.
    /// - Returns: Numerator and denominator.
    func rational(
        precision: Int = 18
    ) -> Fraction {
        let isNegative = self < 0.0
        let absSelf = abs(self)
        
        // clamp exponent to avoid overflow crashes
        // Int.max = 9.22... x 10^18
        let maxExponent = precision.clamped(to: 0 ... max(19 - integralDigitPlaces, 0))
        let pad = Int(truncating: pow(10, maxExponent) as NSNumber)
        let nFloat = absSelf * Double(pad)
        
        let n = Int(truncating: nFloat as NSNumber)
        let d = pad
        
        return Fraction(reducing: isNegative ? -n : n, d)
    }
}

// MARK: - FCPXML Encoding

extension Fraction {
    /// Initializes from an encoded Final Cut Pro FCPXML time value string.
    ///
    /// Where the time value is an even number of seconds, it is encoded as a whole number without
    /// the fraction, ie: "0s" or "60s".
    ///
    /// Where a time value is not an even number of seconds, FCPXML uses the string format "N/Ds",
    /// ie: "34900/2500s".
    ///
    /// FCPXML uses a trailing "s" character in the string to denote 'seconds'.
    ///
    /// If the value is negative, a minus sign is prepended to the string, ie: "-60s" or
    /// "-34900/2500s".
    ///
    /// - Returns: ``Fraction`` instance if string is a valid FCPXML time encoding.
    ///   Returns `nil` if the string was not formatted as expected.
    public init?(fcpxmlString: String) {
        // test for whole seconds, without fraction
        let wholeSecsMatches = fcpxmlString
            .regexMatches(captureGroupsFromPattern: #"^([-]){0,1}([\d]+)s$"#)
        if wholeSecsMatches.count == 3 {
            let negativeSign = wholeSecsMatches[1] ?? ""
            if let secondsString = wholeSecsMatches[2],
               let seconds = Int(negativeSign + secondsString)
            {
                self.init(seconds, 1)
                return
            }
        }
        
        // test for fraction
        let fracMatches = fcpxmlString
            .regexMatches(captureGroupsFromPattern: #"^([-]){0,1}([\d]+)\/([\d]+)s$"#)
        if fracMatches.count == 4 {
            let negativeSign = fracMatches[1] ?? ""
            if let numeratorString = fracMatches[2],
               let numerator = Int(negativeSign + numeratorString),
               let denominatorString = fracMatches[3],
               let denominator = Int(denominatorString)
            {
                self.init(numerator, denominator)
                return
            }
        }
        return nil
    }
    
    /// Returns the string value using time value encoding for Final Cut Pro FCPXML files.
    /// Normalizes the fraction first if necessary.
    ///
    /// Where the time value is an even number of seconds, it is encoded as a whole number without
    /// the fraction, ie: "0s" or "60s".
    ///
    /// Where a time value is not an even number of seconds, FCPXML uses the string format "N/Ds",
    /// ie: "34900/2500s".
    ///
    /// FCPXML uses a trailing "s" character in the string to denote 'seconds'.
    ///
    /// If the value is negative, a minus sign is prepended to the string, ie: "-60s" or
    /// "-34900/2500s".
    public var fcpxmlStringValue: String {
        let reduced = _isReduced ?? false ? self : self.normalized()
        return isWholeInteger
            ? "\(Int(reduced.doubleValue))s"
            : "\(reduced.numerator)/\(reduced.denominator)s"
    }
}

// MARK: - Math Functions

/// Internal:
/// Normalize a fraction.
/// Fractions with two negative signs are normalized to two positive signs.
/// Fractions with negative denominator are normalized to negative numerator and positive denominator.
func normalize(n: Int, d: Int) -> (n: Int, d: Int) {
    var n = n
    var d = d
    if n >= 0 && d >= 0 { return (n: n, d: d) }
    if (n < 0 && d < 0) || (d < 0) {
        n *= -1
        d *= -1
    }
    return (n: n, d: d)
}

/// Internal:
/// Reduce a fraction to its simplest form.
/// This also normalizes signs.
func reduce(n: Int, d: Int) -> (n: Int, d: Int) {
    let (absN, signN) = n < 0 ? (-n, -1) : (n, 1)
    let (absD, signD) = d < 0 ? (-d, -1) : (d, 1)
    var v = n
    var u = d
    
    // Euclid's solution to finding the Greatest Common Denominator
    while (v != 0) {
        (v, u) = (u % v, v)
    }
    
    var outN = absN / u * signN
    var outD = absD / u * signD
    
    // final check to normalize if necessary
    if outN >= 0, outD < 0 {
        outN = -outN
        outD = -outD
    }
    
    return (outN, outD)
}

/// Internal:
/// Returns greatest common divisor of two numbers.
func greatestCommonDivisor(_ n1: Int, _ n2: Int) -> Int {
    var x = 0
    var y = max(n1, n2)
    var z = min(n1, n2)
    
    while z != 0 {
        x = y
        y = z
        z = x % y
    }
    
    return y
}

/// Internal:
/// Returns least common multiple of two numbers and their respective multipliers.
func leastCommonMultiple(
    lhs: Int, rhs: Int
) -> (denominator: Int, lhsMultiplier: Int, rhsMultiplier: Int) {
    let denominator = lhs * rhs / greatestCommonDivisor(lhs, rhs)
    let lhsMultiplier = denominator / lhs
    let rhsMultiplier = denominator / rhs
    
    return (
        denominator: denominator,
        lhsMultiplier: lhsMultiplier,
        rhsMultiplier: rhsMultiplier
    )
}
