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
    
    func testInit_rationalRate_allCases() {
        VideoFrameRate.allCases.forEach { fRate in
            let num = fRate.rationalRate.numerator
            let den = fRate.rationalRate.denominator
            let interlaced = fRate.isInterlaced
            
            XCTAssertEqual(
                VideoFrameRate(rationalRate: (num, den), interlaced: interlaced),
                fRate
            )
        }
    }
    
    func testInit_rationalRate_Typical() {
        // 24p
        XCTAssertEqual(
            VideoFrameRate(rationalRate: (24, 1)),
            ._24p
        )
        XCTAssertEqual(
            VideoFrameRate(rationalRate: (240, 10)),
            ._24p
        )
        
        // 25p
        XCTAssertEqual(
            VideoFrameRate(rationalRate: (25, 1), interlaced: false),
            ._25p
        )
        XCTAssertEqual(
            VideoFrameRate(rationalRate: (250, 10), interlaced: false),
            ._25p
        )
        
        // 25i
        XCTAssertEqual(
            VideoFrameRate(rationalRate: (25, 1), interlaced: true),
            ._25i
        )
        XCTAssertEqual(
            VideoFrameRate(rationalRate: (250, 10), interlaced: true),
            ._25i
        )
        
        // 30p
        XCTAssertEqual(
            VideoFrameRate(rationalRate: (30, 1)),
            ._30p
        )
        XCTAssertEqual(
            VideoFrameRate(rationalRate: (300, 10)),
            ._30p
        )
        
        // edge cases
        
        // check for division by zero etc.
        XCTAssertNil(VideoFrameRate(rationalRate: (0, 0)))
        XCTAssertNil(VideoFrameRate(rationalRate: (1, 0)))
        XCTAssertNil(VideoFrameRate(rationalRate: (0, 1)))
        
        // negative numbers
        XCTAssertNil(VideoFrameRate(rationalRate: (0, -1)))
        XCTAssertNil(VideoFrameRate(rationalRate: (-1, 0)))
        XCTAssertNil(VideoFrameRate(rationalRate: (-1, -1)))
        XCTAssertEqual(VideoFrameRate(rationalRate: (-30, -1)), ._30p)
        XCTAssertNil(VideoFrameRate(rationalRate: (-30, 1)))
        XCTAssertNil(VideoFrameRate(rationalRate: (30, -1)))
        
        // nonsense
        XCTAssertNil(VideoFrameRate(rationalRate: (12345, 1000)))
    }
    
    func testInit_rationalFrameDuration_allCases() {
        VideoFrameRate.allCases.forEach { fRate in
            let num = fRate.rationalFrameDuration.numerator
            let den = fRate.rationalFrameDuration.denominator
            let interlaced = fRate.isInterlaced
            
            XCTAssertEqual(
                VideoFrameRate(rationalFrameDuration: (num, den), interlaced: interlaced),
                fRate
            )
        }
    }
    
    func testInit_rationalFrameDuration_Typical() {
        // 24p
        XCTAssertEqual(
            VideoFrameRate(rationalFrameDuration: (1, 24)),
            ._24p
        )
        XCTAssertEqual(
            VideoFrameRate(rationalFrameDuration: (10, 240)),
            ._24p
        )
        
        // 25p
        XCTAssertEqual(
            VideoFrameRate(rationalFrameDuration: (1, 25), interlaced: false),
            ._25p
        )
        XCTAssertEqual(
            VideoFrameRate(rationalFrameDuration: (10, 250), interlaced: false),
            ._25p
        )
        
        // 25i
        XCTAssertEqual(
            VideoFrameRate(rationalFrameDuration: (1, 25), interlaced: true),
            ._25i
        )
        XCTAssertEqual(
            VideoFrameRate(rationalFrameDuration: (10, 250), interlaced: true),
            ._25i
        )
        
        // 30p
        XCTAssertEqual(
            VideoFrameRate(rationalFrameDuration: (1, 30)),
            ._30p
        )
        XCTAssertEqual(
            VideoFrameRate(rationalFrameDuration: (10, 300)),
            ._30p
        )
        
        // edge cases
        
        // check for division by zero etc.
        XCTAssertNil(VideoFrameRate(rationalFrameDuration: (0, 0)))
        XCTAssertNil(VideoFrameRate(rationalFrameDuration: (0, 1)))
        XCTAssertNil(VideoFrameRate(rationalFrameDuration: (1, 0)))
        
        // negative numbers
        XCTAssertNil(VideoFrameRate(rationalFrameDuration: (-1, 0)))
        XCTAssertNil(VideoFrameRate(rationalFrameDuration: (0, -1)))
        XCTAssertNil(VideoFrameRate(rationalFrameDuration: (-1, -1)))
        XCTAssertEqual(VideoFrameRate(rationalFrameDuration: (-1, -30)), ._30p)
        XCTAssertNil(VideoFrameRate(rationalFrameDuration: (1, -30)))
        XCTAssertNil(VideoFrameRate(rationalFrameDuration: (-1, 30)))
        
        // nonsense
        XCTAssertNil(VideoFrameRate(rationalFrameDuration: (1000, 12345)))
    }
}

#if canImport(CoreMedia)
import CoreMedia

class VideoFrameRate_Conversions_CMTime_Tests: XCTestCase {
    func test_init_rationalRate_CMTime() {
        XCTAssertEqual(
            VideoFrameRate(
                rationalRate: CMTime(value: 30000, timescale: 1001),
                interlaced: false
            ),
            ._29_97p
        )
        XCTAssertEqual(
            VideoFrameRate(
                rationalRate: CMTime(value: 30000, timescale: 1001),
                interlaced: true
            ),
            ._29_97i
        )
    }
    
    func test_init_rationalFrameDuration_CMTime() {
        XCTAssertEqual(
            VideoFrameRate(
                rationalFrameDuration: CMTime(value: 1001, timescale: 30000),
                interlaced: false
            ),
            ._29_97p
        )
        XCTAssertEqual(
            VideoFrameRate(
                rationalFrameDuration: CMTime(value: 1001, timescale: 30000),
                interlaced: true
            ),
            ._29_97i
        )
    }
    
    func testRationalRateCMTime() throws {
        XCTAssertEqual(
            VideoFrameRate._29_97p.rationalRateCMTime,
            CMTime(value: 30000, timescale: 1001)
        )
    }
    
    func testRationalFrameDurationCMTime() throws {
        // spot-check
        XCTAssertEqual(VideoFrameRate._29_97p.rationalFrameDurationCMTime,
                       CMTime(value: 1001, timescale: 30000))
        
        // ensure the CMTime instance returns correct 1 frame duration in seconds.
        // due to floating-point dithering, it tends to be accurate up to
        // 16 decimal places when stored in a Double (1 picosecond or less)
        
        try VideoFrameRate.allCases.forEach {
            let cmTimeSeconds = $0.rationalFrameDurationCMTime.seconds
            
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
