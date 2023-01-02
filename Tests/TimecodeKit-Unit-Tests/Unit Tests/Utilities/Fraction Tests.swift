//
//  Fraction Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import TimecodeKit

class Fraction_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testIsNegative() {
        XCTAssertFalse(Fraction(2, 4).isNegative)
        XCTAssertTrue(Fraction(-2, 4).isNegative)
        XCTAssertTrue(Fraction(2, -4).isNegative)
        XCTAssertFalse(Fraction(-2, -4).isNegative)
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
    
    func testFractionInitReducing() {
        let frac = Fraction(reducing: 4, 2)
        XCTAssertEqual(frac, Fraction(2, 1))
        XCTAssertEqual(frac.isSimplestForm, true)
    }
    
    func testFractionReduced() {
        let frac = Fraction(4, 2)
        XCTAssertEqual(frac.numerator, 4)
        XCTAssertEqual(frac.denominator, 2)
        XCTAssertEqual(frac.isSimplestForm, false)
        
        let reduced = frac.reduced()
        XCTAssertEqual(reduced, Fraction(2, 1))
        XCTAssertEqual(reduced.isSimplestForm, true)
        
        XCTAssertEqual(Fraction(2, 1).isSimplestForm, true)
    }
    
    func testFractionReduced_NegativeValues_A() {
        let frac = Fraction(-4, 2)
        XCTAssertEqual(frac.numerator, -4)
        XCTAssertEqual(frac.denominator, 2)
        XCTAssertEqual(frac.isSimplestForm, false)
        
        let reduced = frac.reduced() // also normalizes signs
        XCTAssertEqual(reduced, Fraction(-2, 1))
        XCTAssertEqual(reduced.isSimplestForm, true)
    }
    
    func testFractionReduced_NegativeValues_B() {
        let frac = Fraction(4, -2)
        XCTAssertEqual(frac.numerator, 4)
        XCTAssertEqual(frac.denominator, -2)
        XCTAssertEqual(frac.isSimplestForm, false)
        
        let reduced = frac.reduced() // also normalizes signs
        XCTAssertEqual(reduced, Fraction(-2, 1))
        XCTAssertEqual(reduced.isSimplestForm, true)
    }
    
    func testFractionReduced_NegativeValues_C() {
        let frac = Fraction(-4, -2)
        XCTAssertEqual(frac.numerator, -4)
        XCTAssertEqual(frac.denominator, -2)
        XCTAssertEqual(frac.isSimplestForm, false)
        
        let reduced = frac.reduced() // also normalizes signs
        XCTAssertEqual(reduced, Fraction(2, 1))
        XCTAssertEqual(reduced.isSimplestForm, true)
    }
    
    func testDoubleValue() {
        XCTAssertEqual(Fraction(4, 2).doubleValue, 2.0)
        XCTAssertEqual(Fraction(2, 1).doubleValue, 2.0)
        
        XCTAssertEqual(Fraction(2, 4).doubleValue, 0.5)
        XCTAssertEqual(Fraction(1, 2).doubleValue, 0.5)
    }
    
    func testNegativeValues() {
        XCTAssertEqual(Fraction(-1,5).doubleValue, -0.2)
        XCTAssertEqual(Fraction(1,-5).doubleValue, -0.2)
        XCTAssertEqual(Fraction(-1,-5).doubleValue, 0.2)
    }
    
    func testNormalized() {
        XCTAssertEqual(Fraction(-1,5).normalized(), Fraction(-1,5))
        XCTAssertEqual(Fraction(1,-5).normalized(), Fraction(-1,5))
        XCTAssertEqual(Fraction(-1,-5).normalized(), Fraction(1,5))
    }
    
    func testEdgeCases() {
        // test that division by zero crashes don't occur etc.
        
        XCTAssertEqual(Fraction(1,0).doubleValue, .infinity)
        XCTAssertEqual(Fraction(0,0).doubleValue.isNaN, true)
        XCTAssertEqual(Fraction(0,1).doubleValue, 0.0)
        
        XCTAssertEqual(Fraction(-1,0).doubleValue, -.infinity)
        XCTAssertEqual(Fraction(0,0).doubleValue.isNaN, true)
        XCTAssertEqual(Fraction(0,-1).doubleValue, 0.0)
    }
}

#endif
