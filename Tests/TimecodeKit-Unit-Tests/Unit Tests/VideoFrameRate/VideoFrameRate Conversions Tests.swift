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
    
//    func testInit_raw() {
//        XCTAssertEqual(VideoFrameRate(raw: 23.976), ._23_976)
//        XCTAssertEqual(VideoFrameRate(raw: 23.976023976), ._23_976)
//
//        XCTAssertEqual(VideoFrameRate(raw: 24), ._24)
//
//        // raw 24.98 fps won't match "24.98" because it's not close enough to correct rate
//        XCTAssertNil(VideoFrameRate(raw: 24.98))
//        XCTAssertEqual(VideoFrameRate(raw: 24.975), ._24_98)
//        XCTAssertEqual(VideoFrameRate(raw: 24.975024975), ._24_98)
//
//        XCTAssertEqual(VideoFrameRate(raw: 25), ._25)
//
//        XCTAssertEqual(VideoFrameRate(raw: 29.97), ._29_97)
//        XCTAssertEqual(VideoFrameRate(raw: 29.97, favorDropFrame: true), ._29_97_drop)
//        XCTAssertEqual(VideoFrameRate(raw: 29.97002997), ._29_97)
//        XCTAssertEqual(VideoFrameRate(raw: 29.97002997, favorDropFrame: true), ._29_97_drop)
//
//        XCTAssertEqual(VideoFrameRate(raw: 30), ._30)
//        // raw 30 fps is not correct for 30d; matches 30 instead
//        XCTAssertEqual(VideoFrameRate(raw: 30, favorDropFrame: true), ._30)
//
//        XCTAssertEqual(VideoFrameRate(raw: 47.952), ._47_952)
//        XCTAssertEqual(VideoFrameRate(raw: 47.952047952), ._47_952)
//
//        XCTAssertEqual(VideoFrameRate(raw: 50), ._50)
//
//        XCTAssertEqual(VideoFrameRate(raw: 59.94), ._59_94)
//        XCTAssertEqual(VideoFrameRate(raw: 59.94, favorDropFrame: true), ._59_94_drop)
//        XCTAssertEqual(VideoFrameRate(raw: 59.9400599401), ._59_94)
//        XCTAssertEqual(VideoFrameRate(raw: 59.9400599401, favorDropFrame: true), ._59_94_drop)
//
//        XCTAssertEqual(VideoFrameRate(raw: 60), ._60)
//        // raw 60 fps is not correct for 60d; matches 60 instead
//        XCTAssertEqual(VideoFrameRate(raw: 60, favorDropFrame: true), ._60)
//
//        XCTAssertEqual(VideoFrameRate(raw: 100), ._100)
//
//        XCTAssertEqual(VideoFrameRate(raw: 119.88), ._119_88)
//        XCTAssertEqual(VideoFrameRate(raw: 119.88, favorDropFrame: true), ._119_88_drop)
//        XCTAssertEqual(VideoFrameRate(raw: 119.8801198801), ._119_88)
//        XCTAssertEqual(VideoFrameRate(raw: 119.8801198801, favorDropFrame: true), ._119_88_drop)
//
//        XCTAssertEqual(VideoFrameRate(raw: 120), ._120)
//        // raw 120 fps is not correct for 120d; matches 120 instead
//        XCTAssertEqual(VideoFrameRate(raw: 120, favorDropFrame: true), ._120)
//    }
//
//    func testInit_raw_invalid() {
//        XCTAssertNil(VideoFrameRate(raw: 0.0))
//        XCTAssertNil(VideoFrameRate(raw: 1.0))
//        XCTAssertNil(VideoFrameRate(raw: 26.0))
//        XCTAssertNil(VideoFrameRate(raw: 29.0))
//        XCTAssertNil(VideoFrameRate(raw: 29.9))
//        XCTAssertNil(VideoFrameRate(raw: 30.1))
//        XCTAssertNil(VideoFrameRate(raw: 30.5))
//        XCTAssertNil(VideoFrameRate(raw: 31.0))
//        XCTAssertNil(VideoFrameRate(raw: 59.0))
//        XCTAssertNil(VideoFrameRate(raw: 59.9))
//        XCTAssertNil(VideoFrameRate(raw: 60.1))
//        XCTAssertNil(VideoFrameRate(raw: 60.5))
//        XCTAssertNil(VideoFrameRate(raw: 61.0))
//        XCTAssertNil(VideoFrameRate(raw: 119.0))
//        XCTAssertNil(VideoFrameRate(raw: 119.8))
//        XCTAssertNil(VideoFrameRate(raw: 120.1))
//        XCTAssertNil(VideoFrameRate(raw: 120.5))
//        XCTAssertNil(VideoFrameRate(raw: 121.0))
//    }
    
    func testInit_rationalFrameRate_allCases() {
        VideoFrameRate.allCases.forEach { fRate in
            let num = fRate.rationalFrameRate.numerator
            let den = fRate.rationalFrameRate.denominator
            
            XCTAssertEqual(
                VideoFrameRate(rational: (num, den), interlaced: fRate.isInterlaced),
                fRate
            )
        }
    }
    
    func testInit_rational_Typical() {
        // 24p
        XCTAssertEqual(
            VideoFrameRate(rational: (24, 1)),
            ._24p
        )
        
        // 25p
        XCTAssertEqual(
            VideoFrameRate(rational: (25, 1), interlaced: false),
            ._25p
        )
        
        // 25i
        XCTAssertEqual(
            VideoFrameRate(rational: (25, 1), interlaced: true),
            ._25i
        )
        
        // 30p
        XCTAssertEqual(
            VideoFrameRate(rational: (30, 1)),
            ._30p
        )
        
        // edge cases
        
        // zero
        XCTAssertNil(VideoFrameRate(rational: (0, 0)))
        
        // nonsense
        XCTAssertNil(VideoFrameRate(rational: (12345, 1000)))
    }
}

#endif
