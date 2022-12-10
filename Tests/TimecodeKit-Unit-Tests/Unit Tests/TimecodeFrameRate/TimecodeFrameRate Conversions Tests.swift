//
//  TimecodeFrameRate Conversions Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import TimecodeKit

class TimecodeFrameRate_Conversions_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testInit_rationalFrameRate_allCases() {
        TimecodeFrameRate.allCases.forEach { fRate in
            let num = fRate.rationalFrameRate.numerator
            let den = fRate.rationalFrameRate.denominator
            let drop = fRate.isDrop
            
            XCTAssertEqual(
                TimecodeFrameRate(rational: (num, den), drop: drop),
                fRate
            )
        }
    }
    
    func testInit_rational_Typical() {
        // 24
        XCTAssertEqual(
            TimecodeFrameRate(rational: (24, 1), drop: false),
            ._24
        )
        XCTAssertEqual(
            TimecodeFrameRate(rational: (240, 10), drop: false),
            ._24
        )
        
        // 24d is not a valid frame rate
        XCTAssertNil(TimecodeFrameRate(rational: (24, 1), drop: true))
        
        // 30
        XCTAssertEqual(
            TimecodeFrameRate(rational: (30, 1), drop: false),
            ._30
        )
        XCTAssertEqual(
            TimecodeFrameRate(rational: (300, 10), drop: false),
            ._30
        )
        
        // 30d
        XCTAssertEqual(
            TimecodeFrameRate(rational: (30, 1), drop: true),
            ._30_drop
        )
        
        // edge cases
        
        // check for division by zero etc.
        XCTAssertNil(TimecodeFrameRate(rational: (0, 0), drop: false))
        XCTAssertNil(TimecodeFrameRate(rational: (1, 0), drop: false))
        XCTAssertNil(TimecodeFrameRate(rational: (0, 1), drop: false))
        
        // negative numbers
        XCTAssertNil(TimecodeFrameRate(rational: (0, -1), drop: false))
        XCTAssertNil(TimecodeFrameRate(rational: (-1, 0), drop: false))
        XCTAssertNil(TimecodeFrameRate(rational: (-1, -1), drop: false))
        XCTAssertEqual(TimecodeFrameRate(rational: (-30, -1), drop: false), ._30)
        XCTAssertNil(TimecodeFrameRate(rational: (-30, 1), drop: false))
        XCTAssertNil(TimecodeFrameRate(rational: (30, -1), drop: false))
        
        // nonsense
        XCTAssertNil(TimecodeFrameRate(rational: (12345, 1000), drop: false))
    }
}

#endif
