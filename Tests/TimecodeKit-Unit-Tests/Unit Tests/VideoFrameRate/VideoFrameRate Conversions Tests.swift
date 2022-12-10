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
