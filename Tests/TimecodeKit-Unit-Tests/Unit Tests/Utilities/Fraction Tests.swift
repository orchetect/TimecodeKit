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
    
    func testFractionInitReduced() {
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
    
    func testDoubleValue() {
        XCTAssertEqual(Fraction(4, 2).doubleValue, 2.0)
        XCTAssertEqual(Fraction(2, 1).doubleValue, 2.0)
        
        XCTAssertEqual(Fraction(2, 4).doubleValue, 0.5)
        XCTAssertEqual(Fraction(1, 2).doubleValue, 0.5)
    }
    
    func testEdgeCases() {
        // test that division by zero crashes don't occur etc.
        XCTAssertEqual(Fraction(1,0).doubleValue, .infinity)
        XCTAssertEqual(Fraction(0,0).doubleValue.isNaN, true)
        XCTAssertEqual(Fraction(0,1).doubleValue, 0.0)
    }
}

#endif
