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
    
    func testInit_raw() {
        XCTAssertEqual(TimecodeFrameRate(raw: 23.976), ._23_976)
        XCTAssertEqual(TimecodeFrameRate(raw: 23.976023976), ._23_976)
        
        XCTAssertEqual(TimecodeFrameRate(raw: 24), ._24)
        
        // raw 24.98 fps won't match "24.98" because it's not close enough to correct rate
        XCTAssertNil(TimecodeFrameRate(raw: 24.98))
        XCTAssertEqual(TimecodeFrameRate(raw: 24.975), ._24_98)
        XCTAssertEqual(TimecodeFrameRate(raw: 24.975024975), ._24_98)
        
        XCTAssertEqual(TimecodeFrameRate(raw: 25), ._25)
        
        XCTAssertEqual(TimecodeFrameRate(raw: 29.97), ._29_97)
        XCTAssertEqual(TimecodeFrameRate(raw: 29.97, favorDropFrame: true), ._29_97_drop)
        XCTAssertEqual(TimecodeFrameRate(raw: 29.97002997), ._29_97)
        XCTAssertEqual(TimecodeFrameRate(raw: 29.97002997, favorDropFrame: true), ._29_97_drop)
        
        XCTAssertEqual(TimecodeFrameRate(raw: 30), ._30)
        // raw 30 fps is not correct for 30d; matches 30 instead
        XCTAssertEqual(TimecodeFrameRate(raw: 30, favorDropFrame: true), ._30)
        
        XCTAssertEqual(TimecodeFrameRate(raw: 47.952), ._47_952)
        XCTAssertEqual(TimecodeFrameRate(raw: 47.952047952), ._47_952)
        
        XCTAssertEqual(TimecodeFrameRate(raw: 50), ._50)
        
        XCTAssertEqual(TimecodeFrameRate(raw: 59.94), ._59_94)
        XCTAssertEqual(TimecodeFrameRate(raw: 59.94, favorDropFrame: true), ._59_94_drop)
        XCTAssertEqual(TimecodeFrameRate(raw: 59.9400599401), ._59_94)
        XCTAssertEqual(TimecodeFrameRate(raw: 59.9400599401, favorDropFrame: true), ._59_94_drop)
        
        XCTAssertEqual(TimecodeFrameRate(raw: 60), ._60)
        // raw 60 fps is not correct for 60d; matches 60 instead
        XCTAssertEqual(TimecodeFrameRate(raw: 60, favorDropFrame: true), ._60)
        
        XCTAssertEqual(TimecodeFrameRate(raw: 100), ._100)
        
        XCTAssertEqual(TimecodeFrameRate(raw: 119.88), ._119_88)
        XCTAssertEqual(TimecodeFrameRate(raw: 119.88, favorDropFrame: true), ._119_88_drop)
        XCTAssertEqual(TimecodeFrameRate(raw: 119.8801198801), ._119_88)
        XCTAssertEqual(TimecodeFrameRate(raw: 119.8801198801, favorDropFrame: true), ._119_88_drop)
        
        XCTAssertEqual(TimecodeFrameRate(raw: 120), ._120)
        // raw 120 fps is not correct for 120d; matches 120 instead
        XCTAssertEqual(TimecodeFrameRate(raw: 120, favorDropFrame: true), ._120)
    }
    
    func testInit_raw_invalid() {
        XCTAssertNil(TimecodeFrameRate(raw: 0.0))
        XCTAssertNil(TimecodeFrameRate(raw: 1.0))
        XCTAssertNil(TimecodeFrameRate(raw: 26.0))
        XCTAssertNil(TimecodeFrameRate(raw: 29.0))
        XCTAssertNil(TimecodeFrameRate(raw: 29.9))
        XCTAssertNil(TimecodeFrameRate(raw: 30.1))
        XCTAssertNil(TimecodeFrameRate(raw: 30.5))
        XCTAssertNil(TimecodeFrameRate(raw: 31.0))
        XCTAssertNil(TimecodeFrameRate(raw: 59.0))
        XCTAssertNil(TimecodeFrameRate(raw: 59.9))
        XCTAssertNil(TimecodeFrameRate(raw: 60.1))
        XCTAssertNil(TimecodeFrameRate(raw: 60.5))
        XCTAssertNil(TimecodeFrameRate(raw: 61.0))
        XCTAssertNil(TimecodeFrameRate(raw: 119.0))
        XCTAssertNil(TimecodeFrameRate(raw: 119.8))
        XCTAssertNil(TimecodeFrameRate(raw: 120.1))
        XCTAssertNil(TimecodeFrameRate(raw: 120.5))
        XCTAssertNil(TimecodeFrameRate(raw: 121.0))
    }
    
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
    
    func testInit_fraction_Typical() {
        // 24
        XCTAssertEqual(
            TimecodeFrameRate(rational: (24, 1), drop: false),
            ._24
        )
        
        // 24d is not a valid frame rate
        XCTAssertNil(TimecodeFrameRate(rational: (24, 1), drop: true))
        
        // 30
        XCTAssertEqual(
            TimecodeFrameRate(rational: (30, 1), drop: false),
            ._30
        )
        
        // 30d
        XCTAssertEqual(
            TimecodeFrameRate(rational: (30, 1), drop: true),
            ._30_drop
        )
        
        // edge cases
        
        // zero
        XCTAssertNil(TimecodeFrameRate(rational: (0, 0), drop: false))
        
        // nonsense
        XCTAssertNil(TimecodeFrameRate(rational: (12345, 1000), drop: false))
    }
}

#endif
