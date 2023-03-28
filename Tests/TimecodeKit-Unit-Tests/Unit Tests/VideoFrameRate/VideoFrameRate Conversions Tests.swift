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
    
    func testInit_raw_nonStrict() {
        XCTAssertEqual(VideoFrameRate(fps: 23, strict: false), nil)
        XCTAssertEqual(VideoFrameRate(fps: 23.9, strict: false), ._23_98p)
        XCTAssertEqual(VideoFrameRate(fps: 23.98, strict: false), ._23_98p)
        XCTAssertEqual(VideoFrameRate(fps: 23.976, strict: false), ._23_98p)
        XCTAssertEqual(VideoFrameRate(fps: 23.976023976, strict: false), ._23_98p)
        
        XCTAssertEqual(VideoFrameRate(fps: 24, strict: false), ._24p)
        
        XCTAssertEqual(VideoFrameRate(fps: 25, strict: false), ._25p)
        XCTAssertEqual(VideoFrameRate(fps: 25, interlaced: true, strict: false), ._25i)
        
        XCTAssertEqual(VideoFrameRate(fps: 29, strict: false), nil)
        XCTAssertEqual(VideoFrameRate(fps: 29.9, strict: false), ._29_97p)
        XCTAssertEqual(VideoFrameRate(fps: 29.97, strict: false), ._29_97p)
        XCTAssertEqual(VideoFrameRate(fps: 29.97002997, strict: false), ._29_97p)
        
        XCTAssertEqual(VideoFrameRate(fps: 29, interlaced: true, strict: false), nil)
        XCTAssertEqual(VideoFrameRate(fps: 29.9, interlaced: true, strict: false), ._29_97i)
        XCTAssertEqual(VideoFrameRate(fps: 29.97, interlaced: true, strict: false), ._29_97i)
        XCTAssertEqual(VideoFrameRate(fps: 29.97002997, interlaced: true, strict: false), ._29_97i)
        
        XCTAssertEqual(VideoFrameRate(fps: 30, strict: false), ._30p)
        
        XCTAssertEqual(VideoFrameRate(fps: 47, strict: false), nil)
        XCTAssertEqual(VideoFrameRate(fps: 47.9, strict: false), ._47_95p)
        XCTAssertEqual(VideoFrameRate(fps: 47.95, strict: false), ._47_95p)
        XCTAssertEqual(VideoFrameRate(fps: 47.952, strict: false), ._47_95p)
        XCTAssertEqual(VideoFrameRate(fps: 47.952047952, strict: false), ._47_95p)
        
        XCTAssertEqual(VideoFrameRate(fps: 48, strict: false), ._48p)
        
        XCTAssertEqual(VideoFrameRate(fps: 50, strict: false), ._50p)
        XCTAssertEqual(VideoFrameRate(fps: 50, interlaced: true, strict: false), ._50i)
        
        XCTAssertEqual(VideoFrameRate(fps: 59, strict: false), nil)
        XCTAssertEqual(VideoFrameRate(fps: 59.9, strict: false), ._59_94p)
        XCTAssertEqual(VideoFrameRate(fps: 59.94, strict: false), ._59_94p)
        XCTAssertEqual(VideoFrameRate(fps: 59.9400599401, strict: false), ._59_94p)
        
        XCTAssertEqual(VideoFrameRate(fps: 59, interlaced: true, strict: false), nil)
        XCTAssertEqual(VideoFrameRate(fps: 59.9, interlaced: true, strict: false), ._59_94i)
        XCTAssertEqual(VideoFrameRate(fps: 59.94, interlaced: true, strict: false), ._59_94i)
        XCTAssertEqual(VideoFrameRate(fps: 59.9400599401, interlaced: true, strict: false), ._59_94i)
        
        XCTAssertEqual(VideoFrameRate(fps: 60, strict: false), ._60p)
        
        XCTAssertEqual(VideoFrameRate(fps: 95, strict: false), nil)
        XCTAssertEqual(VideoFrameRate(fps: 95.9, strict: false), ._95_9p)
        XCTAssertEqual(VideoFrameRate(fps: 95.904, strict: false), ._95_9p)
        XCTAssertEqual(VideoFrameRate(fps: 95.9040959041, strict: false), ._95_9p)
        
        XCTAssertEqual(VideoFrameRate(fps: 96, strict: false), ._96p)
        
        XCTAssertEqual(VideoFrameRate(fps: 100, strict: false), ._100p)
        
        XCTAssertEqual(VideoFrameRate(fps: 119, strict: false), nil)
        XCTAssertEqual(VideoFrameRate(fps: 119.8, strict: false), ._119_88p)
        XCTAssertEqual(VideoFrameRate(fps: 119.88, strict: false), ._119_88p)
        XCTAssertEqual(VideoFrameRate(fps: 119.8801198801, strict: false), ._119_88p)
        
        XCTAssertEqual(VideoFrameRate(fps: 120, strict: false), ._120p)
    }
    
    func testInit_raw_strict() {
        XCTAssertEqual(VideoFrameRate(fps: 23, strict: true), nil)
        XCTAssertEqual(VideoFrameRate(fps: 23.9, strict: true), nil)
        XCTAssertEqual(VideoFrameRate(fps: 23.98, strict: true), nil)
        XCTAssertEqual(VideoFrameRate(fps: 23.976, strict: true), ._23_98p)
        XCTAssertEqual(VideoFrameRate(fps: 23.976023976, strict: true), ._23_98p)
        
        XCTAssertEqual(VideoFrameRate(fps: 24, strict: true), ._24p)
        
        XCTAssertEqual(VideoFrameRate(fps: 25, strict: true), ._25p)
        XCTAssertEqual(VideoFrameRate(fps: 25, interlaced: true, strict: true), ._25i)
        
        XCTAssertEqual(VideoFrameRate(fps: 29, strict: true), nil)
        XCTAssertEqual(VideoFrameRate(fps: 29.9, strict: true), nil)
        XCTAssertEqual(VideoFrameRate(fps: 29.97, strict: true), ._29_97p)
        XCTAssertEqual(VideoFrameRate(fps: 29.97002997, strict: true), ._29_97p)
        
        XCTAssertEqual(VideoFrameRate(fps: 29, interlaced: true, strict: true), nil)
        XCTAssertEqual(VideoFrameRate(fps: 29.9, interlaced: true, strict: true), nil)
        XCTAssertEqual(VideoFrameRate(fps: 29.97, interlaced: true, strict: true), ._29_97i)
        XCTAssertEqual(VideoFrameRate(fps: 29.97002997, interlaced: true, strict: true), ._29_97i)
        
        XCTAssertEqual(VideoFrameRate(fps: 30, strict: true), ._30p)
        
        XCTAssertEqual(VideoFrameRate(fps: 47, strict: true), nil)
        XCTAssertEqual(VideoFrameRate(fps: 47.9, strict: true), nil)
        XCTAssertEqual(VideoFrameRate(fps: 47.95, strict: true), nil)
        XCTAssertEqual(VideoFrameRate(fps: 47.952, strict: true), ._47_95p)
        XCTAssertEqual(VideoFrameRate(fps: 47.952047952, strict: true), ._47_95p)
        
        XCTAssertEqual(VideoFrameRate(fps: 48, strict: true), ._48p)
        
        XCTAssertEqual(VideoFrameRate(fps: 50, strict: true), ._50p)
        XCTAssertEqual(VideoFrameRate(fps: 50, interlaced: true, strict: true), ._50i)
        
        XCTAssertEqual(VideoFrameRate(fps: 59, strict: true), nil)
        XCTAssertEqual(VideoFrameRate(fps: 59.9, strict: true), nil)
        XCTAssertEqual(VideoFrameRate(fps: 59.94, strict: true), ._59_94p)
        XCTAssertEqual(VideoFrameRate(fps: 59.9400599401, strict: true), ._59_94p)
        
        XCTAssertEqual(VideoFrameRate(fps: 59, interlaced: true, strict: true), nil)
        XCTAssertEqual(VideoFrameRate(fps: 59.9, interlaced: true, strict: true), nil)
        XCTAssertEqual(VideoFrameRate(fps: 59.94, interlaced: true, strict: true), ._59_94i)
        XCTAssertEqual(VideoFrameRate(fps: 59.9400599401, interlaced: true, strict: true), ._59_94i)
        
        XCTAssertEqual(VideoFrameRate(fps: 60, strict: true), ._60p)
        
        XCTAssertEqual(VideoFrameRate(fps: 95, strict: true), nil)
        XCTAssertEqual(VideoFrameRate(fps: 95.9, strict: true), nil)
        XCTAssertEqual(VideoFrameRate(fps: 95.904, strict: true), ._95_9p)
        XCTAssertEqual(VideoFrameRate(fps: 95.9040959041, strict: true), ._95_9p)
        
        XCTAssertEqual(VideoFrameRate(fps: 96, strict: true), ._96p)
        
        XCTAssertEqual(VideoFrameRate(fps: 100, strict: true), ._100p)
        
        XCTAssertEqual(VideoFrameRate(fps: 119, strict: true), nil)
        XCTAssertEqual(VideoFrameRate(fps: 119.8, strict: true), nil)
        XCTAssertEqual(VideoFrameRate(fps: 119.88, strict: true), ._119_88p)
        XCTAssertEqual(VideoFrameRate(fps: 119.8801198801, strict: true), ._119_88p)
        
        XCTAssertEqual(VideoFrameRate(fps: 120, strict: true), ._120p)
    }
    
    func testInit_raw_invalid_nonStrict() {
        XCTAssertNil(VideoFrameRate(fps: 0.0, strict: false))
        XCTAssertNil(VideoFrameRate(fps: 1.0, strict: false))
        
        XCTAssertNil(VideoFrameRate(fps: 26.0, strict: false))
        
        XCTAssertNil(VideoFrameRate(fps: 29.0, strict: false))
        XCTAssertNotNil(VideoFrameRate(fps: 29.9, strict: false))
        
        XCTAssertNil(VideoFrameRate(fps: 30.1, strict: false))
        XCTAssertNil(VideoFrameRate(fps: 30.5, strict: false))
        XCTAssertNil(VideoFrameRate(fps: 31.0, strict: false))
        
        XCTAssertNil(VideoFrameRate(fps: 59.0, strict: false))
        XCTAssertNotNil(VideoFrameRate(fps: 59.9, strict: false))
        XCTAssertNil(VideoFrameRate(fps: 60.1, strict: false))
        XCTAssertNil(VideoFrameRate(fps: 60.5, strict: false))
        XCTAssertNil(VideoFrameRate(fps: 61.0, strict: false))
        
        XCTAssertNil(VideoFrameRate(fps: 95.8, strict: false))
        XCTAssertNil(VideoFrameRate(fps: 96.1, strict: false))
        XCTAssertNil(VideoFrameRate(fps: 97.0, strict: false))
        
        XCTAssertNil(VideoFrameRate(fps: 119.0, strict: false))
        XCTAssertNotNil(VideoFrameRate(fps: 119.8, strict: false))
        
        XCTAssertNil(VideoFrameRate(fps: 120.1, strict: false))
        XCTAssertNil(VideoFrameRate(fps: 120.5, strict: false))
        XCTAssertNil(VideoFrameRate(fps: 121.0, strict: false))
    }
    
    func testInit_raw_invalid_strict() {
        XCTAssertNil(VideoFrameRate(fps: 0.0, strict: true))
        XCTAssertNil(VideoFrameRate(fps: 1.0, strict: true))
        
        XCTAssertNil(VideoFrameRate(fps: 26.0, strict: true))
        
        XCTAssertNil(VideoFrameRate(fps: 29.0, strict: true))
        XCTAssertNil(VideoFrameRate(fps: 29.9, strict: true))
        
        XCTAssertNil(VideoFrameRate(fps: 30.1, strict: true))
        XCTAssertNil(VideoFrameRate(fps: 30.5, strict: true))
        XCTAssertNil(VideoFrameRate(fps: 31.0, strict: true))
        
        XCTAssertNil(VideoFrameRate(fps: 59.0, strict: true))
        XCTAssertNil(VideoFrameRate(fps: 59.9, strict: true))
        XCTAssertNil(VideoFrameRate(fps: 60.1, strict: true))
        XCTAssertNil(VideoFrameRate(fps: 60.5, strict: true))
        XCTAssertNil(VideoFrameRate(fps: 61.0, strict: true))
        
        XCTAssertNil(VideoFrameRate(fps: 95.8, strict: true))
        XCTAssertNil(VideoFrameRate(fps: 96.1, strict: true))
        XCTAssertNil(VideoFrameRate(fps: 97.0, strict: true))
        
        XCTAssertNil(VideoFrameRate(fps: 119.0, strict: true))
        XCTAssertNil(VideoFrameRate(fps: 119.8, strict: true))
        
        XCTAssertNil(VideoFrameRate(fps: 120.1, strict: true))
        XCTAssertNil(VideoFrameRate(fps: 120.5, strict: true))
        XCTAssertNil(VideoFrameRate(fps: 121.0, strict: true))
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
            
            let oneFrameDuration = try Timecode.Components(f: 1)
                .timecode(using: $0.timecodeFrameRate(drop: false)!)
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
