//
//  VideoFrameRate Conversions Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import TimecodeKit

class VideoFrameRate_Conversions_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testInit_raw() {
        XCTAssertEqual(VideoFrameRate(fps: 23.976), ._23_98p)
        XCTAssertEqual(VideoFrameRate(fps: 23.976023976), ._23_98p)
        
        XCTAssertEqual(VideoFrameRate(fps: 24), ._24p)
        
        XCTAssertEqual(VideoFrameRate(fps: 25), ._25p)
        XCTAssertEqual(VideoFrameRate(fps: 25, interlaced: true), ._25i)
        
        XCTAssertEqual(VideoFrameRate(fps: 29.97), ._29_97p)
        XCTAssertEqual(VideoFrameRate(fps: 29.97, interlaced: true), ._29_97i)
        XCTAssertEqual(VideoFrameRate(fps: 29.97002997), ._29_97p)
        XCTAssertEqual(VideoFrameRate(fps: 29.97002997, interlaced: true), ._29_97i)
        
        XCTAssertEqual(VideoFrameRate(fps: 30), ._30p)
        
        XCTAssertEqual(VideoFrameRate(fps: 50), ._50p)
        XCTAssertEqual(VideoFrameRate(fps: 50, interlaced: true), ._50i)
        
        XCTAssertEqual(VideoFrameRate(fps: 59.94), ._59_94p)
        XCTAssertEqual(VideoFrameRate(fps: 59.9400599401), ._59_94p)
        
        XCTAssertEqual(VideoFrameRate(fps: 60), ._60p)
    }
    
    func testInit_raw_invalid() {
        XCTAssertNil(VideoFrameRate(fps: 0.0))
        XCTAssertNil(VideoFrameRate(fps: 1.0))
        XCTAssertNil(VideoFrameRate(fps: 26.0))
        XCTAssertNil(VideoFrameRate(fps: 29.0))
        XCTAssertNil(VideoFrameRate(fps: 29.9))
        XCTAssertNil(VideoFrameRate(fps: 30.1))
        XCTAssertNil(VideoFrameRate(fps: 30.5))
        XCTAssertNil(VideoFrameRate(fps: 31.0))
        XCTAssertNil(VideoFrameRate(fps: 59.0))
        XCTAssertNil(VideoFrameRate(fps: 59.9))
        XCTAssertNil(VideoFrameRate(fps: 60.1))
        XCTAssertNil(VideoFrameRate(fps: 60.5))
        XCTAssertNil(VideoFrameRate(fps: 61.0))
        XCTAssertNil(VideoFrameRate(fps: 119.0))
        XCTAssertNil(VideoFrameRate(fps: 119.8))
        XCTAssertNil(VideoFrameRate(fps: 120.1))
        XCTAssertNil(VideoFrameRate(fps: 120.5))
        XCTAssertNil(VideoFrameRate(fps: 121.0))
    }
    
    func testInit_rate_allCases() {
        VideoFrameRate.allCases.forEach { fRate in
            let num = fRate.rate.numerator
            let den = fRate.rate.denominator
            let interlaced = fRate.isInterlaced
            
            XCTAssertEqual(
                VideoFrameRate(rate: Fraction(num, den), interlaced: interlaced),
                fRate
            )
        }
    }
    
    func testInit_rate_Typical() {
        // 24p
        XCTAssertEqual(
            VideoFrameRate(rate: Fraction(24, 1)),
            ._24p
        )
        XCTAssertEqual(
            VideoFrameRate(rate: Fraction(240, 10)),
            ._24p
        )
        
        // 25p
        XCTAssertEqual(
            VideoFrameRate(rate: Fraction(25, 1), interlaced: false),
            ._25p
        )
        XCTAssertEqual(
            VideoFrameRate(rate: Fraction(250, 10), interlaced: false),
            ._25p
        )
        
        // 25i
        XCTAssertEqual(
            VideoFrameRate(rate: Fraction(25, 1), interlaced: true),
            ._25i
        )
        XCTAssertEqual(
            VideoFrameRate(rate: Fraction(250, 10), interlaced: true),
            ._25i
        )
        
        // 30p
        XCTAssertEqual(
            VideoFrameRate(rate: Fraction(30, 1)),
            ._30p
        )
        XCTAssertEqual(
            VideoFrameRate(rate: Fraction(300, 10)),
            ._30p
        )
        
        // edge cases
        
        // check for division by zero etc.
        XCTAssertNil(VideoFrameRate(rate: Fraction(0, 0)))
        XCTAssertNil(VideoFrameRate(rate: Fraction(1, 0)))
        XCTAssertNil(VideoFrameRate(rate: Fraction(0, 1)))
        
        // negative numbers
        XCTAssertNil(VideoFrameRate(rate: Fraction(0, -1)))
        XCTAssertNil(VideoFrameRate(rate: Fraction(-1, 0)))
        XCTAssertNil(VideoFrameRate(rate: Fraction(-1, -1)))
        XCTAssertEqual(VideoFrameRate(rate: Fraction(-30, -1)), ._30p)
        XCTAssertNil(VideoFrameRate(rate: Fraction(-30, 1)))
        XCTAssertNil(VideoFrameRate(rate: Fraction(30, -1)))
        
        // nonsense
        XCTAssertNil(VideoFrameRate(rate: Fraction(12345, 1000)))
    }
    
    func testInit_frameDuration_allCases() {
        VideoFrameRate.allCases.forEach { fRate in
            let num = fRate.frameDuration.numerator
            let den = fRate.frameDuration.denominator
            let interlaced = fRate.isInterlaced
            
            XCTAssertEqual(
                VideoFrameRate(frameDuration: Fraction(num, den), interlaced: interlaced),
                fRate
            )
        }
    }
    
    func testInit_frameDuration_Typical() {
        // 24p
        XCTAssertEqual(
            VideoFrameRate(frameDuration: Fraction(1, 24)),
            ._24p
        )
        XCTAssertEqual(
            VideoFrameRate(frameDuration: Fraction(10, 240)),
            ._24p
        )
        
        // 25p
        XCTAssertEqual(
            VideoFrameRate(frameDuration: Fraction(1, 25), interlaced: false),
            ._25p
        )
        XCTAssertEqual(
            VideoFrameRate(frameDuration: Fraction(10, 250), interlaced: false),
            ._25p
        )
        
        // 25i
        XCTAssertEqual(
            VideoFrameRate(frameDuration: Fraction(1, 25), interlaced: true),
            ._25i
        )
        XCTAssertEqual(
            VideoFrameRate(frameDuration: Fraction(10, 250), interlaced: true),
            ._25i
        )
        
        // 30p
        XCTAssertEqual(
            VideoFrameRate(frameDuration: Fraction(1, 30)),
            ._30p
        )
        XCTAssertEqual(
            VideoFrameRate(frameDuration: Fraction(10, 300)),
            ._30p
        )
        
        // edge cases
        
        // check for division by zero etc.
        XCTAssertNil(VideoFrameRate(frameDuration: Fraction(0, 0)))
        XCTAssertNil(VideoFrameRate(frameDuration: Fraction(0, 1)))
        XCTAssertNil(VideoFrameRate(frameDuration: Fraction(1, 0)))
        
        // negative numbers
        XCTAssertNil(VideoFrameRate(frameDuration: Fraction(-1, 0)))
        XCTAssertNil(VideoFrameRate(frameDuration: Fraction(0, -1)))
        XCTAssertNil(VideoFrameRate(frameDuration: Fraction(-1, -1)))
        XCTAssertEqual(VideoFrameRate(frameDuration: Fraction(-1, -30)), ._30p)
        XCTAssertNil(VideoFrameRate(frameDuration: Fraction(1, -30)))
        XCTAssertNil(VideoFrameRate(frameDuration: Fraction(-1, 30)))
        
        // nonsense
        XCTAssertNil(VideoFrameRate(frameDuration: Fraction(1000, 12345)))
    }
}

#if canImport(CoreMedia)
import CoreMedia

class VideoFrameRate_Conversions_CMTime_Tests: XCTestCase {
    func test_init_rate_CMTime() {
        XCTAssertEqual(
            VideoFrameRate(
                rate: CMTime(value: 30000, timescale: 1001),
                interlaced: false
            ),
            ._29_97p
        )
        XCTAssertEqual(
            VideoFrameRate(
                rate: CMTime(value: 30000, timescale: 1001),
                interlaced: true
            ),
            ._29_97i
        )
    }
    
    func test_init_frameDuration_CMTime() {
        XCTAssertEqual(
            VideoFrameRate(
                frameDuration: CMTime(value: 1001, timescale: 30000),
                interlaced: false
            ),
            ._29_97p
        )
        XCTAssertEqual(
            VideoFrameRate(
                frameDuration: CMTime(value: 1001, timescale: 30000),
                interlaced: true
            ),
            ._29_97i
        )
    }
    
    func testRateCMTime() throws {
        XCTAssertEqual(
            VideoFrameRate._29_97p.rateCMTime,
            CMTime(value: 30000, timescale: 1001)
        )
    }
    
    func testFrameDurationCMTime() throws {
        // spot-check
        XCTAssertEqual(VideoFrameRate._29_97p.frameDurationCMTime,
                       CMTime(value: 1001, timescale: 30000))
        
        // ensure the CMTime instance returns correct 1 frame duration in seconds.
        // due to floating-point dithering, it tends to be accurate up to
        // 16 decimal places when stored in a Double (1 picosecond or less)
        
        try VideoFrameRate.allCases.forEach {
            let cmTimeSeconds = $0.frameDurationCMTime.seconds
            
            let oneFrameDuration = try TCC(f: 1)
                .toTimecode(at: $0.timecodeFrameRate(drop: false)!)
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
