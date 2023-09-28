//
//  TimecodeFrameRate Conversions Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import CoreMedia
import TimecodeKit
import XCTest

class TimecodeFrameRate_Conversions_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testInit_rate_allCases() {
        TimecodeFrameRate.allCases.forEach { fRate in
            let num = fRate.rate.numerator
            let den = fRate.rate.denominator
            let drop = fRate.isDrop
            
            XCTAssertEqual(
                TimecodeFrameRate(rate: Fraction(num, den), drop: drop),
                fRate
            )
        }
    }
    
    func testInit_rate_Typical() {
        // 24
        XCTAssertEqual(
            TimecodeFrameRate(rate: Fraction(24, 1), drop: false),
            .fps24
        )
        XCTAssertEqual(
            TimecodeFrameRate(rate: Fraction(240, 10), drop: false),
            .fps24
        )
        
        // 24d is not a valid frame rate
        XCTAssertNil(TimecodeFrameRate(rate: Fraction(24, 1), drop: true))
        
        // 30
        XCTAssertEqual(
            TimecodeFrameRate(rate: Fraction(30, 1), drop: false),
            .fps30
        )
        XCTAssertEqual(
            TimecodeFrameRate(rate: Fraction(300, 10), drop: false),
            .fps30
        )
        
        // 30d
        XCTAssertEqual(
            TimecodeFrameRate(rate: Fraction(30, 1), drop: true),
            .fps30d
        )
        
        // edge cases
        
        // check for division by zero etc.
        XCTAssertNil(TimecodeFrameRate(rate: Fraction(0, 0), drop: false))
        XCTAssertNil(TimecodeFrameRate(rate: Fraction(1, 0), drop: false))
        XCTAssertNil(TimecodeFrameRate(rate: Fraction(0, 1), drop: false))
        
        // negative numbers
        XCTAssertNil(TimecodeFrameRate(rate: Fraction(0, -1), drop: false))
        XCTAssertNil(TimecodeFrameRate(rate: Fraction(-1, 0), drop: false))
        XCTAssertNil(TimecodeFrameRate(rate: Fraction(-1, -1), drop: false))
        XCTAssertEqual(TimecodeFrameRate(rate: Fraction(-30, -1), drop: false), .fps30)
        XCTAssertNil(TimecodeFrameRate(rate: Fraction(-30, 1), drop: false))
        XCTAssertNil(TimecodeFrameRate(rate: Fraction(30, -1), drop: false))
        
        // nonsense
        XCTAssertNil(TimecodeFrameRate(rate: Fraction(12345, 1000), drop: false))
    }
    
    func testInit_frameDuration_allCases() {
        TimecodeFrameRate.allCases.forEach { fRate in
            let num = fRate.frameDuration.numerator
            let den = fRate.frameDuration.denominator
            let drop = fRate.isDrop
            
            XCTAssertEqual(
                TimecodeFrameRate(frameDuration: Fraction(num, den), drop: drop),
                fRate
            )
        }
    }
    
    func testInit_frameDuration_Typical() {
        // 24
        XCTAssertEqual(
            TimecodeFrameRate(frameDuration: Fraction(1, 24), drop: false),
            .fps24
        )
        XCTAssertEqual(
            TimecodeFrameRate(frameDuration: Fraction(10, 240), drop: false),
            .fps24
        )
        
        // 24d is not a valid frame rate
        XCTAssertNil(TimecodeFrameRate(frameDuration: Fraction(1, 24), drop: true))
        
        // 30
        XCTAssertEqual(
            TimecodeFrameRate(frameDuration: Fraction(1, 30), drop: false),
            .fps30
        )
        XCTAssertEqual(
            TimecodeFrameRate(frameDuration: Fraction(10, 300), drop: false),
            .fps30
        )
        
        // 30d
        XCTAssertEqual(
            TimecodeFrameRate(frameDuration: Fraction(1, 30), drop: true),
            .fps30d
        )
        
        // edge cases
        
        // check for division by zero etc.
        XCTAssertNil(TimecodeFrameRate(frameDuration: Fraction(0, 0), drop: false))
        XCTAssertNil(TimecodeFrameRate(frameDuration: Fraction(0, 1), drop: false))
        XCTAssertNil(TimecodeFrameRate(frameDuration: Fraction(1, 0), drop: false))
        
        // negative numbers
        XCTAssertNil(TimecodeFrameRate(frameDuration: Fraction(-1, 0), drop: false))
        XCTAssertNil(TimecodeFrameRate(frameDuration: Fraction(0, -1), drop: false))
        XCTAssertNil(TimecodeFrameRate(frameDuration: Fraction(-1, -1), drop: false))
        XCTAssertEqual(TimecodeFrameRate(frameDuration: Fraction(-1, -30), drop: false), .fps30)
        XCTAssertNil(TimecodeFrameRate(frameDuration: Fraction(1, -30), drop: false))
        XCTAssertNil(TimecodeFrameRate(frameDuration: Fraction(-1, 30), drop: false))
        
        // nonsense
        XCTAssertNil(TimecodeFrameRate(frameDuration: Fraction(1000, 12345), drop: false))
    }
}

#if canImport(CoreMedia)
import CoreMedia

class TimecodeFrameRate_Conversions_CMTime_Tests: XCTestCase {
    func test_init_rate_CMTime() {
        XCTAssertEqual(
            TimecodeFrameRate(
                rate: CMTime(value: 30000, timescale: 1001),
                drop: false
            ),
            .fps29_97
        )
        XCTAssertEqual(
            TimecodeFrameRate(
                rate: CMTime(value: 30000, timescale: 1001),
                drop: true
            ),
            .fps29_97d
        )
    }
    
    func test_init_frameDuration_CMTime() {
        XCTAssertEqual(
            TimecodeFrameRate(
                frameDuration: CMTime(value: 1001, timescale: 30000),
                drop: false
            ),
            .fps29_97
        )
        XCTAssertEqual(
            TimecodeFrameRate(
                frameDuration: CMTime(value: 1001, timescale: 30000),
                drop: true
            ),
            .fps29_97d
        )
    }
    
    func testrateCMTime() throws {
        XCTAssertEqual(
            TimecodeFrameRate.fps29_97.rateCMTime,
            CMTime(value: 30000, timescale: 1001)
        )
    }
    
    func testframeDurationCMTime() throws {
        // spot-check
        XCTAssertEqual(
            TimecodeFrameRate.fps29_97.frameDurationCMTime,
            CMTime(value: 1001, timescale: 30000)
        )
        
        // ensure the CMTime instance returns correct 1 frame duration in seconds.
        // due to floating-point dithering, it tends to be accurate up to
        // 16 decimal places when stored in a Double (1 picosecond or less)
        
        try TimecodeFrameRate.allCases.forEach {
            let cmTimeSeconds = $0.frameDurationCMTime.seconds
            
            let oneFrameDuration = try Timecode(.components(f: 1), at: $0)
                .realTimeValue
            
            XCTAssertEqual(
                cmTimeSeconds,
                oneFrameDuration,
                accuracy: 0.0000_0000_0000_0001,
                "\($0) failed."
            )
        }
    }
}
#endif

#endif
