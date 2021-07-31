//
//  FrameRate Properties Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//

#if !os(watchOS)

import XCTest
@testable import TimecodeKit

class Timecode_UT_FrameRate_Properties_Tests: XCTestCase {
    
    func testProperties() {
        
        // spot-check that properties behave as expected
        
        let frameRate: Timecode.FrameRate = ._30
        
        XCTAssertEqual(frameRate.stringValue, "30")
        
        XCTAssertEqual(frameRate.stringValueVerbose, "30 fps")
        
        XCTAssertEqual(Timecode.FrameRate(stringValue: "30"), frameRate)
        
        XCTAssertEqual(frameRate.numberOfDigits, 2)
        
        XCTAssertEqual(frameRate.maxFrameNumberDisplayable, 29)
        
        XCTAssertEqual(frameRate.maxTotalFrames(in: ._24hours),
                       2592000)
        
        XCTAssertEqual(frameRate.maxTotalFrames(in: ._100days),
                       2592000 * 100)
        
        XCTAssertEqual(
            frameRate.maxTotalFramesExpressible(in: ._24hours),
            2592000 - 1)
        
        XCTAssertEqual(
            frameRate.maxTotalFramesExpressible(in: ._100days),
            (2592000 * 100) - 1)
        
        XCTAssertEqual(
            frameRate.maxTotalSubFrames(in: ._24hours,
                                        usingSubFramesDivisor: 80),
            2592000 * 80)
        
        XCTAssertEqual(
            frameRate.maxTotalSubFrames(in: ._100days,
                                        usingSubFramesDivisor: 80),
            2592000 * 100 * 80)
        
        XCTAssertEqual(
            frameRate.maxTotalSubFramesExpressible(in: ._24hours,
                                                   usingSubFramesDivisor: 80),
            (2592000 * 80) - 1)
        
        XCTAssertEqual(
            frameRate.maxTotalSubFramesExpressible(in: ._100days,
                                                   usingSubFramesDivisor: 80),
            (2592000 * 100 * 80) - 1)
        
        XCTAssertEqual(frameRate.maxFrames, 30)
        
        XCTAssertEqual(frameRate.frameRateForElapsedFramesCalculation, 30.0)
        
        XCTAssertEqual(frameRate.frameRateForRealTimeCalculation, 30.0)
        
        XCTAssertEqual(frameRate.framesDroppedPerMinute, 0.0)
        
    }
    
}
#endif
