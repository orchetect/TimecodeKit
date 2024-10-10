//
//  Fraction Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

@testable import TimecodeKit
import XCTest

final class Fraction_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testAbs() {
        XCTAssertEqual(Fraction(2, 4).abs(), Fraction(2, 4))
        XCTAssertEqual(Fraction(-2, 4).abs(), Fraction(2, 4))
        XCTAssertEqual(Fraction(2, -4).abs(), Fraction(2, 4))
        XCTAssertEqual(Fraction(-2, -4).abs(), Fraction(2, 4))
    }
    
    func testIsNegative() {
        XCTAssertFalse(Fraction(2, 4).isNegative)
        XCTAssertTrue(Fraction(-2, 4).isNegative)
        XCTAssertTrue(Fraction(2, -4).isNegative)
        XCTAssertFalse(Fraction(-2, -4).isNegative)
    }
    
    func testIsWholeInteger() {
        XCTAssertTrue(Fraction(4, 2).isWholeInteger) // == 2.0
        XCTAssertTrue(Fraction(2, 1).isWholeInteger) // == 2.0
        
        XCTAssertFalse(Fraction(1, 2).isWholeInteger) // == 0.5
        XCTAssertFalse(Fraction(2, 4).isWholeInteger) // == 0.5
        
        XCTAssertTrue(Fraction(0, 1).isWholeInteger) // == 0.0
    }
    
    func testNegated() {
        XCTAssertEqual(Fraction(2, 4).negated(), Fraction(-2, 4))
        XCTAssertEqual(Fraction(-2, 4).negated(), Fraction(2, 4))
        XCTAssertEqual(Fraction(2, -4).negated(), Fraction(-2, -4))
        XCTAssertEqual(Fraction(-2, -4).negated(), Fraction(2, -4))
    }
    
    func testIsEqual() {
        XCTAssertTrue(Fraction(2, 4).isEqual(to: Fraction(2, 4)))
        XCTAssertTrue(Fraction(2, 4).isEqual(to: Fraction(1, 2)))
        XCTAssertTrue(Fraction(-1, -2).isEqual(to: Fraction(1, 2)))
    }
    
    func testComparable() {
        XCTAssertFalse(Fraction(2, 4) < Fraction(2, 4))
        XCTAssertFalse(Fraction(2, 4) > Fraction(2, 4))
        
        XCTAssertFalse(Fraction(1, 2) < Fraction(2, 4))
        XCTAssertFalse(Fraction(1, 2) > Fraction(2, 4))
        
        XCTAssertFalse(Fraction(2, 4) < Fraction(1, 2))
        XCTAssertFalse(Fraction(2, 4) > Fraction(1, 2))
        
        XCTAssertTrue(Fraction(1, 10) < Fraction(2, 10))
        XCTAssertTrue(Fraction(2, 10) > Fraction(1, 10))
    }
    
    func testMathAdd() {
        XCTAssertEqual(Fraction(1, 2) + Fraction(1, 4), Fraction(3, 4))
        XCTAssertEqual(Fraction(2, 4) + Fraction(1, 4), Fraction(3, 4))
        
        XCTAssertEqual(Fraction(-1, 2) + Fraction(1, 4), Fraction(-1, 4))
        XCTAssertEqual(Fraction(-1, 2) + Fraction(-1, 4), Fraction(-3, 4))
        
        XCTAssertEqual(Fraction(750, 1900) + Fraction(8000, 3800), Fraction(5, 2))
    }
    
    func testMathSubtract() {
        XCTAssertEqual(Fraction(3, 4) - Fraction(1, 2), Fraction(1, 4))
        XCTAssertEqual(Fraction(3, 4) - Fraction(2, 4), Fraction(1, 4))
        
        XCTAssertEqual(Fraction(-3, 4) - Fraction(2, 4), Fraction(-5, 4))
        XCTAssertEqual(Fraction(-3, 4) - Fraction(-2, 4), Fraction(-1, 4))
        
        XCTAssertEqual(Fraction(8000, 3800) - Fraction(100, 1900), Fraction(39, 19))
    }
    
    func testMathMultiply() {
        XCTAssertEqual(Fraction(1, 4) * Fraction(2, 8), Fraction(1, 16))
        XCTAssertEqual(Fraction(1, 4) * Fraction(8, 32), Fraction(1, 16))
        XCTAssertEqual(Fraction(3, 4) * Fraction(1, 2), Fraction(3, 8))
        
        XCTAssertEqual(Fraction(-3, 4) * Fraction(1, 2), Fraction(-3, 8))
        XCTAssertEqual(Fraction(-3, 4) * Fraction(-1, 2), Fraction(3, 8))
        
        XCTAssertEqual(Fraction(900, 1800) * Fraction(9500, 3800), Fraction(5, 4))
    }
    
    func testMathDivide() {
        XCTAssertEqual(Fraction(1, 16) / Fraction(2, 8), Fraction(1, 4))
        XCTAssertEqual(Fraction(8, 32) / Fraction(1, 4), Fraction(1, 1))
        
        XCTAssertEqual(Fraction(-1, 16) / Fraction(2, 8), Fraction(-1, 4))
        XCTAssertEqual(Fraction(-1, 16) / Fraction(-2, 8), Fraction(1, 4))
        XCTAssertEqual(Fraction(1, 16) / Fraction(-2, 8), Fraction(-1, 4))
        
        XCTAssertEqual(Fraction(5, 4) / Fraction(900, 1800), Fraction(9500, 3800))
    }
    
    func testFractionInitReducing() {
        let frac = Fraction(reducing: 4, 2)
        XCTAssertEqual(frac, Fraction(2, 1))
        XCTAssertEqual(frac.isReduced, true)
    }
    
    func testFractionReduced() {
        let frac = Fraction(4, 2)
        XCTAssertEqual(frac.numerator, 4)
        XCTAssertEqual(frac.denominator, 2)
        XCTAssertEqual(frac.isReduced, false)
        
        let reduced = frac.reduced()
        XCTAssertEqual(reduced, Fraction(2, 1))
        XCTAssertEqual(reduced.isReduced, true)
        
        XCTAssertEqual(Fraction(2, 1).isReduced, true)
    }
    
    func testFractionReduced_NegativeValues_A() {
        let frac = Fraction(-4, 2)
        XCTAssertEqual(frac.numerator, -4)
        XCTAssertEqual(frac.denominator, 2)
        XCTAssertEqual(frac.isReduced, false)
        
        let reduced = frac.reduced() // also normalizes signs
        XCTAssertEqual(reduced, Fraction(-2, 1))
        XCTAssertEqual(reduced.isReduced, true)
    }
    
    func testFractionReduced_NegativeValues_B() {
        let frac = Fraction(4, -2)
        XCTAssertEqual(frac.numerator, 4)
        XCTAssertEqual(frac.denominator, -2)
        XCTAssertEqual(frac.isReduced, false)
        
        let reduced = frac.reduced() // also normalizes signs
        XCTAssertEqual(reduced, Fraction(-2, 1))
        XCTAssertEqual(reduced.isReduced, true)
    }
    
    func testFractionReduced_NegativeValues_C() {
        let frac = Fraction(-4, -2)
        XCTAssertEqual(frac.numerator, -4)
        XCTAssertEqual(frac.denominator, -2)
        XCTAssertEqual(frac.isReduced, false)
        
        let reduced = frac.reduced() // also normalizes signs
        XCTAssertEqual(reduced, Fraction(2, 1))
        XCTAssertEqual(reduced.isReduced, true)
    }
    
    func testFractionReduced_NegativeValues_D() {
        let frac = Fraction(-1, 2)
        XCTAssertEqual(frac.numerator, -1)
        XCTAssertEqual(frac.denominator, 2)
        XCTAssertEqual(frac.isReduced, true)
        
        let reduced = frac.reduced() // also normalizes signs
        XCTAssertEqual(reduced, Fraction(-1, 2))
        XCTAssertEqual(reduced.isReduced, true)
    }
    
    func testInit_Double() {
        XCTAssertEqual(Fraction(double: 2.0), Fraction(2, 1))
        XCTAssertEqual(Fraction(double: 0.5), Fraction(1, 2))
        
        // high precision
        XCTAssertEqual(
            Fraction(double: 30000/1001, decimalPrecision: 18),
            Fraction(2926760739260739, 97656250000000)
        )
        XCTAssertEqual(
            Fraction(double: 30000/1001, decimalPrecision: 18).doubleValue,
            29.970029970029966
        )
        
        // edge case: algorithm can work with up to 18 places of precision
        XCTAssertEqual(Fraction(double: 9.999_999_999_999_999_99, decimalPrecision: 50).doubleValue,
                       9.999_999_999_999_999_999)
        XCTAssertEqual(Fraction(double: 9.999_999_999_999_999_99, decimalPrecision: 50).doubleValue,
                       10.0)
        
        // edge case: a really high precision number.
        // it will clamp number of decimal places internally.
        XCTAssertEqual(Fraction(double: 30000/1001, decimalPrecision: 50).doubleValue, 29.970029970029966)
        
        // edge case: a negative precision number.
        // it will clamp number of decimal places internally.
        XCTAssertEqual(Fraction(double: 30000/1001, decimalPrecision: -2).doubleValue, 29.0)
    }
    
    func testInit_Double_NegativeValues() {
        XCTAssertEqual(Fraction(double: -2.0), Fraction(-2, 1))
        XCTAssertEqual(Fraction(double: -0.5), Fraction(-1, 2))
        
        // high precision
        XCTAssertEqual(
            Fraction(double: -(30000/1001), decimalPrecision: 18),
            Fraction(-2926760739260739, 97656250000000)
        )
        XCTAssertEqual(
            Fraction(double: -(30000/1001), decimalPrecision: 18).doubleValue,
            -29.970029970029966
        )
        
        // edge case: a really high precision number.
        // it will clamp number of decimal places internally.
        XCTAssertEqual(Fraction(double: -30000/1001, decimalPrecision: 50).doubleValue, -29.970029970029966)
        
        // edge case: a negative precision number.
        // it will clamp number of decimal places internally.
        XCTAssertEqual(Fraction(double: -30000/1001, decimalPrecision: -2).doubleValue, -29.0)
    }
    
    func testDoubleValue() {
        XCTAssertEqual(Fraction(4, 2).doubleValue, 2.0)
        XCTAssertEqual(Fraction(2, 1).doubleValue, 2.0)
        
        XCTAssertEqual(Fraction(2, 4).doubleValue, 0.5)
        XCTAssertEqual(Fraction(1, 2).doubleValue, 0.5)
    }
    
    func testDoubleValue_NegativeValues() {
        XCTAssertEqual(Fraction(-4, 2).doubleValue, -2.0)
        XCTAssertEqual(Fraction(-2, 1).doubleValue, -2.0)
        
        XCTAssertEqual(Fraction(-2, 4).doubleValue, -0.5)
        XCTAssertEqual(Fraction(-1, 2).doubleValue, -0.5)
    }
    
    func testNegativeValues() {
        XCTAssertEqual(Fraction(-1, 5).doubleValue, -0.2)
        XCTAssertEqual(Fraction(1, -5).doubleValue, -0.2)
        XCTAssertEqual(Fraction(-1, -5).doubleValue, 0.2)
    }
    
    func testNormalized() {
        XCTAssertEqual(Fraction(-1, 5).normalized(), Fraction(-1, 5))
        XCTAssertEqual(Fraction(1, -5).normalized(), Fraction(-1, 5))
        XCTAssertEqual(Fraction(-1, -5).normalized(), Fraction(1, 5))
    }
    
    func testEdgeCases() {
        // test that division by zero crashes don't occur etc.
        
        XCTAssertEqual(Fraction(1, 0).doubleValue, .infinity)
        XCTAssertEqual(Fraction(0, 0).doubleValue.isNaN, true)
        XCTAssertEqual(Fraction(0, 1).doubleValue, 0.0)
        
        XCTAssertEqual(Fraction(-1, 0).doubleValue, -.infinity)
        XCTAssertEqual(Fraction(0, 0).doubleValue.isNaN, true)
        XCTAssertEqual(Fraction(0, -1).doubleValue, 0.0)
    }
    
    // MARK: FCPXML Encoding
    
    func testInit_fcpxmlString() {
        XCTAssertEqual(Fraction(fcpxmlString: "0s"), Fraction(0, 1))
        XCTAssertEqual(Fraction(fcpxmlString: "4s"), Fraction(4, 1))
        
        XCTAssertEqual(Fraction(fcpxmlString: "4/2s"), Fraction(2, 1))
        XCTAssertEqual(Fraction(fcpxmlString: "2/1s"), Fraction(2, 1))
    }
    
    func testInit_fcpxmlString_NegativeValues() {
        XCTAssertEqual(Fraction(fcpxmlString: "-0s"), Fraction(-0, 1))
        XCTAssertEqual(Fraction(fcpxmlString: "-4s"), Fraction(-4, 1))
        
        XCTAssertEqual(Fraction(fcpxmlString: "-4/2s"), Fraction(-2, 1))
        XCTAssertEqual(Fraction(fcpxmlString: "-2/1s"), Fraction(-2, 1))
        
        // we would like to ensure the fraction does not reduce for FCPXML.
        // it's not a requirement, but makes comparisons easier with the XML.
        XCTAssertEqual(Fraction(fcpxmlString: "4/2s")?.numerator, 4)
        XCTAssertEqual(Fraction(fcpxmlString: "4/2s")?.denominator, 2)
    }
    
    func testfcpxmlString() {
        XCTAssertEqual(Fraction(0, 1).fcpxmlStringValue, "0s")
        XCTAssertEqual(Fraction(4, 1).fcpxmlStringValue, "4s")
        
        XCTAssertEqual(Fraction(4, 2).fcpxmlStringValue, "2s")
        XCTAssertEqual(Fraction(2, 1).fcpxmlStringValue, "2s")
        
        // we would like to ensure the fraction does not reduce for FCPXML.
        // it's not a requirement, but makes comparisons easier with the XML.
        XCTAssertEqual(Fraction(2, 4).fcpxmlStringValue, "2/4s")
        XCTAssertEqual(Fraction(1, 2).fcpxmlStringValue, "1/2s")
    }
    
    func testfcpxmlString_NegativeValues() {
        XCTAssertEqual(Fraction(-0, 1).fcpxmlStringValue, "0s") // zero will remove negative sign
        XCTAssertEqual(Fraction(-4, 1).fcpxmlStringValue, "-4s")
        
        XCTAssertEqual(Fraction(-4, 2).fcpxmlStringValue, "-2s")
        XCTAssertEqual(Fraction(-2, 1).fcpxmlStringValue, "-2s")
        
        // we would like to ensure the fraction does not reduce for FCPXML.
        // it's not a requirement, but makes comparisons easier with the XML.
        XCTAssertEqual(Fraction(-2, 4).fcpxmlStringValue, "-2/4s")
        XCTAssertEqual(Fraction(-1, 2).fcpxmlStringValue, "-1/2s")
    }
}
