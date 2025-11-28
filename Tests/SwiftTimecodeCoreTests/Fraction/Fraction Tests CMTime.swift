//
//  Fraction Tests CMTime.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(CoreMedia)

import CoreMedia
import SwiftTimecodeCore
import XCTest

final class Fraction_CMTime_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testFraction_init_CMTime() {
        XCTAssertEqual(
            Fraction(CMTime(value: 3600, timescale: 1)),
            Fraction(3600, 1)
        )
        
        XCTAssertEqual(
            Fraction(CMTime(value: -3600, timescale: 1)),
            Fraction(-3600, 1)
        )
    }
    
    func testFraction_init_CMTime_EdgeCases() {
        XCTAssertEqual(
            Fraction(CMTime.indefinite),
            Fraction(0, 1)
        )
        
        XCTAssertEqual(
            Fraction(CMTime.negativeInfinity),
            Fraction(0, 1)
        )
        
        XCTAssertEqual(
            Fraction(CMTime.positiveInfinity),
            Fraction(0, 1)
        )
    }
    
    func testFraction_cmTimeValue() {
        XCTAssertEqual(
            Fraction(3600, 1).cmTimeValue,
            CMTime(value: 3600, timescale: 1)
        )
        
        XCTAssertEqual(
            Fraction(-3600, 1).cmTimeValue,
            CMTime(value: -3600, timescale: 1)
        )
    }
    
    func testCMTime_init_Fraction() {
        XCTAssertEqual(
            CMTime(Fraction(3600, 1)),
            CMTime(value: 3600, timescale: 1)
        )
        
        XCTAssertEqual(
            CMTime(Fraction(-3600, 1)),
            CMTime(value: -3600, timescale: 1)
        )
    }
    
    func testCMTime_fractionValue() {
        XCTAssertEqual(
            CMTime(value: 3600, timescale: 1).fractionValue,
            Fraction(3600, 1)
        )
        
        XCTAssertEqual(
            CMTime(value: -3600, timescale: 1).fractionValue,
            Fraction(-3600, 1)
        )
    }
}

#endif
