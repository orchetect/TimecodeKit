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
    
    func testInit_rationalRate_allCases() {
        TimecodeFrameRate.allCases.forEach { fRate in
            let num = fRate.rationalRate.numerator
            let den = fRate.rationalRate.denominator
            let drop = fRate.isDrop
            
            XCTAssertEqual(
                TimecodeFrameRate(rationalRate: (num, den), drop: drop),
                fRate
            )
        }
    }
    
    func testInit_rationalRate_Typical() {
        // 24
        XCTAssertEqual(
            TimecodeFrameRate(rationalRate: (24, 1), drop: false),
            ._24
        )
        XCTAssertEqual(
            TimecodeFrameRate(rationalRate: (240, 10), drop: false),
            ._24
        )
        
        // 24d is not a valid frame rate
        XCTAssertNil(TimecodeFrameRate(rationalRate: (24, 1), drop: true))
        
        // 30
        XCTAssertEqual(
            TimecodeFrameRate(rationalRate: (30, 1), drop: false),
            ._30
        )
        XCTAssertEqual(
            TimecodeFrameRate(rationalRate: (300, 10), drop: false),
            ._30
        )
        
        // 30d
        XCTAssertEqual(
            TimecodeFrameRate(rationalRate: (30, 1), drop: true),
            ._30_drop
        )
        
        // edge cases
        
        // check for division by zero etc.
        XCTAssertNil(TimecodeFrameRate(rationalRate: (0, 0), drop: false))
        XCTAssertNil(TimecodeFrameRate(rationalRate: (1, 0), drop: false))
        XCTAssertNil(TimecodeFrameRate(rationalRate: (0, 1), drop: false))
        
        // negative numbers
        XCTAssertNil(TimecodeFrameRate(rationalRate: (0, -1), drop: false))
        XCTAssertNil(TimecodeFrameRate(rationalRate: (-1, 0), drop: false))
        XCTAssertNil(TimecodeFrameRate(rationalRate: (-1, -1), drop: false))
        XCTAssertEqual(TimecodeFrameRate(rationalRate: (-30, -1), drop: false), ._30)
        XCTAssertNil(TimecodeFrameRate(rationalRate: (-30, 1), drop: false))
        XCTAssertNil(TimecodeFrameRate(rationalRate: (30, -1), drop: false))
        
        // nonsense
        XCTAssertNil(TimecodeFrameRate(rationalRate: (12345, 1000), drop: false))
    }
    
    func testInit_rationalFrameDuration_allCases() {
        TimecodeFrameRate.allCases.forEach { fRate in
            let num = fRate.rationalFrameDuration.numerator
            let den = fRate.rationalFrameDuration.denominator
            let drop = fRate.isDrop
            
            XCTAssertEqual(
                TimecodeFrameRate(rationalFrameDuration: (num, den), drop: drop),
                fRate
            )
        }
    }
    
    func testInit_rationalFrameDuration_Typical() {
        // 24
        XCTAssertEqual(
            TimecodeFrameRate(rationalFrameDuration: (1, 24), drop: false),
            ._24
        )
        XCTAssertEqual(
            TimecodeFrameRate(rationalFrameDuration: (10, 240), drop: false),
            ._24
        )
        
        // 24d is not a valid frame rate
        XCTAssertNil(TimecodeFrameRate(rationalFrameDuration: (1, 24), drop: true))
        
        // 30
        XCTAssertEqual(
            TimecodeFrameRate(rationalFrameDuration: (1, 30), drop: false),
            ._30
        )
        XCTAssertEqual(
            TimecodeFrameRate(rationalFrameDuration: (10, 300), drop: false),
            ._30
        )
        
        // 30d
        XCTAssertEqual(
            TimecodeFrameRate(rationalFrameDuration: (1, 30), drop: true),
            ._30_drop
        )
        
        // edge cases
        
        // check for division by zero etc.
        XCTAssertNil(TimecodeFrameRate(rationalFrameDuration: (0, 0), drop: false))
        XCTAssertNil(TimecodeFrameRate(rationalFrameDuration: (0, 1), drop: false))
        XCTAssertNil(TimecodeFrameRate(rationalFrameDuration: (1, 0), drop: false))
        
        // negative numbers
        XCTAssertNil(TimecodeFrameRate(rationalFrameDuration: (-1, 0), drop: false))
        XCTAssertNil(TimecodeFrameRate(rationalFrameDuration: (0, -1), drop: false))
        XCTAssertNil(TimecodeFrameRate(rationalFrameDuration: (-1, -1), drop: false))
        XCTAssertEqual(TimecodeFrameRate(rationalFrameDuration: (-1, -30), drop: false), ._30)
        XCTAssertNil(TimecodeFrameRate(rationalFrameDuration: (1, -30), drop: false))
        XCTAssertNil(TimecodeFrameRate(rationalFrameDuration: (-1, 30), drop: false))
        
        // nonsense
        XCTAssertNil(TimecodeFrameRate(rationalFrameDuration: (1000, 12345), drop: false))
    }
}

#endif
