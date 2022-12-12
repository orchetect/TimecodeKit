//
//  TimecodeFrameRate Conversions Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import TimecodeKit
import CoreMedia

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
    
    func test_init_rationalRate_CMTime() {
        XCTAssertEqual(
            TimecodeFrameRate(
                rationalRate: CMTime(value: 30000, timescale: 1001),
                drop: false
            ),
            ._29_97
        )
        XCTAssertEqual(
            TimecodeFrameRate(
                rationalRate: CMTime(value: 30000, timescale: 1001),
                drop: true
            ),
            ._29_97_drop
        )
    }
    
    func test_init_rationalFrameDuration_CMTime() {
        XCTAssertEqual(
            TimecodeFrameRate(
                rationalFrameDuration: CMTime(value: 1001, timescale: 30000),
                drop: false
            ),
            ._29_97
        )
        XCTAssertEqual(
            TimecodeFrameRate(
                rationalFrameDuration: CMTime(value: 1001, timescale: 30000),
                drop: true
            ),
            ._29_97_drop
        )
    }
    
    func testRationalRateCMTime() throws {
        XCTAssertEqual(
            TimecodeFrameRate._29_97.rationalRateCMTime,
            CMTime(value: 30000, timescale: 1001)
        )
    }
    
    func testRationalFrameDurationCMTime() throws {
        // spot-check
        XCTAssertEqual(TimecodeFrameRate._29_97.rationalFrameDurationCMTime,
                       CMTime(value: 1001, timescale: 30000))
        
        // ensure the CMTime instance returns correct 1 frame duration in seconds.
        // due to floating-point dithering, it tends to be accurate up to
        // 16 decimal places when stored in a Double (1 picosecond or less)
        
        try TimecodeFrameRate.allCases.forEach {
            let cmTimeSeconds = $0.rationalFrameDurationCMTime.seconds
            
            let oneFrameDuration = try TCC(f: 1)
                .toTimecode(at: $0)
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
