//
//  TimecodeFrameRate Properties Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

@testable import TimecodeKitCore
import XCTest

final class TimecodeFrameRate_Properties_Tests: XCTestCase {
    func testProperties() {
        // spot-check that properties behave as expected
        
        let frameRate: TimecodeFrameRate = .fps30
        
        XCTAssertEqual(frameRate.stringValue, "30")
        
        XCTAssertEqual(frameRate.stringValueVerbose, "30 fps")
        
        XCTAssertEqual(TimecodeFrameRate(stringValue: "30"), frameRate)
        
        XCTAssertEqual(frameRate.numberOfDigits, 2)
        
        XCTAssertEqual(frameRate.maxFrameNumberDisplayable, 29)
        
        XCTAssertEqual(
            frameRate.maxTotalFrames(in: .max24Hours),
            2_592_000
        )
        
        XCTAssertEqual(
            frameRate.maxTotalFrames(in: .max100Days),
            2_592_000 * 100
        )
        
        XCTAssertEqual(
            frameRate.maxTotalFramesExpressible(in: .max24Hours),
            2_592_000 - 1
        )
        
        XCTAssertEqual(
            frameRate.maxTotalFramesExpressible(in: .max100Days),
            (2_592_000 * 100) - 1
        )
        
        XCTAssertEqual(
            frameRate.maxTotalSubFrames(
                in: .max24Hours,
                base: .max80SubFrames
            ),
            2_592_000 * 80
        )
        
        // these integers result in overflow on armv7/i386 (32-bit arch)
        #if !(arch(arm) || arch(i386))
        XCTAssertEqual(
            frameRate.maxTotalSubFrames(
                in: .max100Days,
                base: .max80SubFrames
            ),
            2_592_000 * 100 * 80
        )
        
        XCTAssertEqual(
            frameRate.maxSubFrameCountExpressible(
                in: .max100Days,
                base: .max80SubFrames
            ),
            (2_592_000 * 100 * 80) - 1
        )
        #endif
        
        XCTAssertEqual(
            frameRate.maxSubFrameCountExpressible(
                in: .max24Hours,
                base: .max80SubFrames
            ),
            (2_592_000 * 80) - 1
        )
        
        XCTAssertEqual(frameRate.maxFrames, 30)
        
        XCTAssertEqual(frameRate.frameRateForElapsedFramesCalculation, 30.0)
        
        XCTAssertEqual(frameRate.frameRateForRealTimeCalculation, 30.0)
        
        XCTAssertEqual(frameRate.framesDroppedPerMinute, 0.0)
    }
    
    func testInitStringValue() {
        XCTAssertEqual(TimecodeFrameRate(stringValue: "23.976"), .fps23_976)
        XCTAssertEqual(TimecodeFrameRate(stringValue: "29.97d"), .fps29_97d)
        
        XCTAssertNil(TimecodeFrameRate(stringValue: ""))
        XCTAssertNil(TimecodeFrameRate(stringValue: " "))
        XCTAssertNil(TimecodeFrameRate(stringValue: "BogusString"))
    }
}
