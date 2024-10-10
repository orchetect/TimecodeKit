//
//  TimecodeInterval Rational Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import TimecodeKit
import XCTest

final class TimecodeInterval_Rational_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testRational() throws {
        let ti = try TimecodeInterval(
            Fraction(60, 30),
            at: .fps24
        )
        
        XCTAssertEqual(ti.sign, .plus)
        
        XCTAssertEqual(
            ti.absoluteInterval,
            try Timecode(.components(s: 2), at: .fps24)
        )
        
        XCTAssertEqual(
            ti.flattened(),
            try Timecode(.components(s: 2), at: .fps24)
        )
        
        XCTAssertEqual(ti.rationalValue, Fraction(2, 1))
    }
    
    func testRationalNegative() throws {
        let ti = try TimecodeInterval(
            Fraction(-60, 30),
            at: .fps24
        )
        
        XCTAssertEqual(ti.sign, .minus)
        
        XCTAssertEqual(
            ti.absoluteInterval,
            try Timecode(.components(s: 2), at: .fps24)
        )
        
        XCTAssertEqual(
            ti.flattened(), // wraps around clock by underflowing
            try Timecode(.components(h: 23, m: 59, s: 58, f: 00), at: .fps24)
        )
        
        XCTAssertEqual(ti.rationalValue, Fraction(-2, 1))
    }
    
    func testFraction_timecodeInterval() throws {
        let ti = try Fraction(60, 30).timecodeInterval(at: .fps24)
        
        XCTAssertEqual(ti.sign, .plus)
        
        XCTAssertEqual(
            ti.absoluteInterval,
            try Timecode(.components(s: 2), at: .fps24)
        )
    }
}
