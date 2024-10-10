//
//  VideoFrameRate Conversions Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import TimecodeKit // do NOT import as @testable in this file
import XCTest

final class VideoFrameRate_Conversions_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testInit_raw_nonStrict() {
        XCTAssertEqual(VideoFrameRate(fps: 23, strict: false), nil)
        XCTAssertEqual(VideoFrameRate(fps: 23.9, strict: false), .fps23_98p)
        XCTAssertEqual(VideoFrameRate(fps: 23.98, strict: false), .fps23_98p)
        XCTAssertEqual(VideoFrameRate(fps: 23.976, strict: false), .fps23_98p)
        XCTAssertEqual(VideoFrameRate(fps: 23.976023976, strict: false), .fps23_98p)
        
        XCTAssertEqual(VideoFrameRate(fps: 24, strict: false), .fps24p)
        
        XCTAssertEqual(VideoFrameRate(fps: 25, strict: false), .fps25p)
        XCTAssertEqual(VideoFrameRate(fps: 25, interlaced: true, strict: false), .fps25i)
        XCTAssertEqual(VideoFrameRate(fps: 24.997648, interlaced: false, strict: false), .fps25p) // VFR-like
        
        XCTAssertEqual(VideoFrameRate(fps: 29, strict: false), nil)
        XCTAssertEqual(VideoFrameRate(fps: 29.9, strict: false), .fps29_97p)
        XCTAssertEqual(VideoFrameRate(fps: 29.97, strict: false), .fps29_97p)
        XCTAssertEqual(VideoFrameRate(fps: 29.97002997, strict: false), .fps29_97p)
        
        XCTAssertEqual(VideoFrameRate(fps: 29, interlaced: true, strict: false), nil)
        XCTAssertEqual(VideoFrameRate(fps: 29.9, interlaced: true, strict: false), .fps29_97i)
        XCTAssertEqual(VideoFrameRate(fps: 29.97, interlaced: true, strict: false), .fps29_97i)
        XCTAssertEqual(VideoFrameRate(fps: 29.97002997, interlaced: true, strict: false), .fps29_97i)
        
        XCTAssertEqual(VideoFrameRate(fps: 30, strict: false), .fps30p)
        
        XCTAssertEqual(VideoFrameRate(fps: 47, strict: false), nil)
        XCTAssertEqual(VideoFrameRate(fps: 47.9, strict: false), .fps47_95p)
        XCTAssertEqual(VideoFrameRate(fps: 47.95, strict: false), .fps47_95p)
        XCTAssertEqual(VideoFrameRate(fps: 47.952, strict: false), .fps47_95p)
        XCTAssertEqual(VideoFrameRate(fps: 47.952047952, strict: false), .fps47_95p)
        
        XCTAssertEqual(VideoFrameRate(fps: 48, strict: false), .fps48p)
        
        XCTAssertEqual(VideoFrameRate(fps: 50, strict: false), .fps50p)
        XCTAssertEqual(VideoFrameRate(fps: 50, interlaced: true, strict: false), .fps50i)
        
        XCTAssertEqual(VideoFrameRate(fps: 59, strict: false), nil)
        XCTAssertEqual(VideoFrameRate(fps: 59.9, strict: false), .fps59_94p)
        XCTAssertEqual(VideoFrameRate(fps: 59.94, strict: false), .fps59_94p)
        XCTAssertEqual(VideoFrameRate(fps: 59.9400599401, strict: false), .fps59_94p)
        
        XCTAssertEqual(VideoFrameRate(fps: 59, interlaced: true, strict: false), nil)
        XCTAssertEqual(VideoFrameRate(fps: 59.9, interlaced: true, strict: false), .fps59_94i)
        XCTAssertEqual(VideoFrameRate(fps: 59.94, interlaced: true, strict: false), .fps59_94i)
        XCTAssertEqual(VideoFrameRate(fps: 59.9400599401, interlaced: true, strict: false), .fps59_94i)
        
        XCTAssertEqual(VideoFrameRate(fps: 60, strict: false), .fps60p)
        
        XCTAssertEqual(VideoFrameRate(fps: 95, strict: false), nil)
        XCTAssertEqual(VideoFrameRate(fps: 95.9, strict: false), .fps95_9p)
        XCTAssertEqual(VideoFrameRate(fps: 95.904, strict: false), .fps95_9p)
        XCTAssertEqual(VideoFrameRate(fps: 95.9040959041, strict: false), .fps95_9p)
        
        XCTAssertEqual(VideoFrameRate(fps: 96, strict: false), .fps96p)
        
        XCTAssertEqual(VideoFrameRate(fps: 100, strict: false), .fps100p)
        
        XCTAssertEqual(VideoFrameRate(fps: 119, strict: false), nil)
        XCTAssertEqual(VideoFrameRate(fps: 119.8, strict: false), .fps119_88p)
        XCTAssertEqual(VideoFrameRate(fps: 119.88, strict: false), .fps119_88p)
        XCTAssertEqual(VideoFrameRate(fps: 119.8801198801, strict: false), .fps119_88p)
        
        XCTAssertEqual(VideoFrameRate(fps: 120, strict: false), .fps120p)
    }
    
    func testInit_raw_strict() {
        XCTAssertEqual(VideoFrameRate(fps: 23, strict: true), nil)
        XCTAssertEqual(VideoFrameRate(fps: 23.9, strict: true), nil)
        XCTAssertEqual(VideoFrameRate(fps: 23.98, strict: true), nil)
        XCTAssertEqual(VideoFrameRate(fps: 23.976, strict: true), .fps23_98p)
        XCTAssertEqual(VideoFrameRate(fps: 23.976023976, strict: true), .fps23_98p)
        
        XCTAssertEqual(VideoFrameRate(fps: 24, strict: true), .fps24p)
        
        XCTAssertEqual(VideoFrameRate(fps: 25, strict: true), .fps25p)
        XCTAssertEqual(VideoFrameRate(fps: 25, interlaced: true, strict: true), .fps25i)
        XCTAssertEqual(VideoFrameRate(fps: 24.997648, interlaced: false, strict: true), nil) // VFR-like
        
        XCTAssertEqual(VideoFrameRate(fps: 29, strict: true), nil)
        XCTAssertEqual(VideoFrameRate(fps: 29.9, strict: true), nil)
        XCTAssertEqual(VideoFrameRate(fps: 29.97, strict: true), .fps29_97p)
        XCTAssertEqual(VideoFrameRate(fps: 29.97002997, strict: true), .fps29_97p)
        
        XCTAssertEqual(VideoFrameRate(fps: 29, interlaced: true, strict: true), nil)
        XCTAssertEqual(VideoFrameRate(fps: 29.9, interlaced: true, strict: true), nil)
        XCTAssertEqual(VideoFrameRate(fps: 29.97, interlaced: true, strict: true), .fps29_97i)
        XCTAssertEqual(VideoFrameRate(fps: 29.97002997, interlaced: true, strict: true), .fps29_97i)
        
        XCTAssertEqual(VideoFrameRate(fps: 30, strict: true), .fps30p)
        
        XCTAssertEqual(VideoFrameRate(fps: 47, strict: true), nil)
        XCTAssertEqual(VideoFrameRate(fps: 47.9, strict: true), nil)
        XCTAssertEqual(VideoFrameRate(fps: 47.95, strict: true), nil)
        XCTAssertEqual(VideoFrameRate(fps: 47.952, strict: true), .fps47_95p)
        XCTAssertEqual(VideoFrameRate(fps: 47.952047952, strict: true), .fps47_95p)
        
        XCTAssertEqual(VideoFrameRate(fps: 48, strict: true), .fps48p)
        
        XCTAssertEqual(VideoFrameRate(fps: 50, strict: true), .fps50p)
        XCTAssertEqual(VideoFrameRate(fps: 50, interlaced: true, strict: true), .fps50i)
        
        XCTAssertEqual(VideoFrameRate(fps: 59, strict: true), nil)
        XCTAssertEqual(VideoFrameRate(fps: 59.9, strict: true), nil)
        XCTAssertEqual(VideoFrameRate(fps: 59.94, strict: true), .fps59_94p)
        XCTAssertEqual(VideoFrameRate(fps: 59.9400599401, strict: true), .fps59_94p)
        
        XCTAssertEqual(VideoFrameRate(fps: 59, interlaced: true, strict: true), nil)
        XCTAssertEqual(VideoFrameRate(fps: 59.9, interlaced: true, strict: true), nil)
        XCTAssertEqual(VideoFrameRate(fps: 59.94, interlaced: true, strict: true), .fps59_94i)
        XCTAssertEqual(VideoFrameRate(fps: 59.9400599401, interlaced: true, strict: true), .fps59_94i)
        
        XCTAssertEqual(VideoFrameRate(fps: 60, strict: true), .fps60p)
        
        XCTAssertEqual(VideoFrameRate(fps: 95, strict: true), nil)
        XCTAssertEqual(VideoFrameRate(fps: 95.9, strict: true), nil)
        XCTAssertEqual(VideoFrameRate(fps: 95.904, strict: true), .fps95_9p)
        XCTAssertEqual(VideoFrameRate(fps: 95.9040959041, strict: true), .fps95_9p)
        
        XCTAssertEqual(VideoFrameRate(fps: 96, strict: true), .fps96p)
        
        XCTAssertEqual(VideoFrameRate(fps: 100, strict: true), .fps100p)
        
        XCTAssertEqual(VideoFrameRate(fps: 119, strict: true), nil)
        XCTAssertEqual(VideoFrameRate(fps: 119.8, strict: true), nil)
        XCTAssertEqual(VideoFrameRate(fps: 119.88, strict: true), .fps119_88p)
        XCTAssertEqual(VideoFrameRate(fps: 119.8801198801, strict: true), .fps119_88p)
        
        XCTAssertEqual(VideoFrameRate(fps: 120, strict: true), .fps120p)
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
        for fRate in VideoFrameRate.allCases {
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
            .fps24p
        )
        XCTAssertEqual(
            VideoFrameRate(rate: Fraction(240, 10)),
            .fps24p
        )
        
        // 25p
        XCTAssertEqual(
            VideoFrameRate(rate: Fraction(25, 1), interlaced: false),
            .fps25p
        )
        XCTAssertEqual(
            VideoFrameRate(rate: Fraction(250, 10), interlaced: false),
            .fps25p
        )
        
        // 25i
        XCTAssertEqual(
            VideoFrameRate(rate: Fraction(25, 1), interlaced: true),
            .fps25i
        )
        XCTAssertEqual(
            VideoFrameRate(rate: Fraction(250, 10), interlaced: true),
            .fps25i
        )
        
        // 30p
        XCTAssertEqual(
            VideoFrameRate(rate: Fraction(30, 1)),
            .fps30p
        )
        XCTAssertEqual(
            VideoFrameRate(rate: Fraction(300, 10)),
            .fps30p
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
        XCTAssertEqual(VideoFrameRate(rate: Fraction(-30, -1)), .fps30p)
        XCTAssertNil(VideoFrameRate(rate: Fraction(-30, 1)))
        XCTAssertNil(VideoFrameRate(rate: Fraction(30, -1)))
        
        // nonsense
        XCTAssertNil(VideoFrameRate(rate: Fraction(12345, 1000)))
    }
    
    func testInit_frameDuration_allCases() {
        for fRate in VideoFrameRate.allCases {
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
            .fps24p
        )
        XCTAssertEqual(
            VideoFrameRate(frameDuration: Fraction(10, 240)),
            .fps24p
        )
        
        // 25p
        XCTAssertEqual(
            VideoFrameRate(frameDuration: Fraction(1, 25), interlaced: false),
            .fps25p
        )
        XCTAssertEqual(
            VideoFrameRate(frameDuration: Fraction(10, 250), interlaced: false),
            .fps25p
        )
        
        // 25i
        XCTAssertEqual(
            VideoFrameRate(frameDuration: Fraction(1, 25), interlaced: true),
            .fps25i
        )
        XCTAssertEqual(
            VideoFrameRate(frameDuration: Fraction(10, 250), interlaced: true),
            .fps25i
        )
        
        // 30p
        XCTAssertEqual(
            VideoFrameRate(frameDuration: Fraction(1, 30)),
            .fps30p
        )
        XCTAssertEqual(
            VideoFrameRate(frameDuration: Fraction(10, 300)),
            .fps30p
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
        XCTAssertEqual(VideoFrameRate(frameDuration: Fraction(-1, -30)), .fps30p)
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
            .fps29_97p
        )
        XCTAssertEqual(
            VideoFrameRate(
                rate: CMTime(value: 30000, timescale: 1001),
                interlaced: true
            ),
            .fps29_97i
        )
    }
    
    func test_init_frameDuration_CMTime() {
        XCTAssertEqual(
            VideoFrameRate(
                frameDuration: CMTime(value: 1001, timescale: 30000),
                interlaced: false
            ),
            .fps29_97p
        )
        XCTAssertEqual(
            VideoFrameRate(
                frameDuration: CMTime(value: 1001, timescale: 30000),
                interlaced: true
            ),
            .fps29_97i
        )
    }
    
    func testRateCMTime() throws {
        XCTAssertEqual(
            VideoFrameRate.fps29_97p.rateCMTime,
            CMTime(value: 30000, timescale: 1001)
        )
    }
    
    func testFrameDurationCMTime() throws {
        // spot-check
        XCTAssertEqual(
            VideoFrameRate.fps29_97p.frameDurationCMTime,
            CMTime(value: 1001, timescale: 30000)
        )
        
        // ensure the CMTime instance returns correct 1 frame duration in seconds.
        // due to floating-point dithering, it tends to be accurate up to
        // 16 decimal places when stored in a Double (1 picosecond or less)
        
        for item in VideoFrameRate.allCases {
            let cmTimeSeconds = item.frameDurationCMTime.seconds
            
            let oneFrameDuration = try Timecode(.components(f: 1), at: item.timecodeFrameRate(drop: false)!)
                .realTimeValue
            
            XCTAssertEqual(
                cmTimeSeconds,
                oneFrameDuration,
                accuracy: 0.0000_0000_0000_0001,
                "\(item) failed."
            )
        }
    }
}
#endif
