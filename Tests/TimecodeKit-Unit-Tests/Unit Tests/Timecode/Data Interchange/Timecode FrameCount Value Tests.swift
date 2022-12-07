//
//  Timecode FrameCount Value Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import TimecodeKit

class Timecode_UT_DI_FrameCount_Value_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testTimecode_init_FrameCountValue_Exactly() throws {
        let tc = try Timecode(
            .frames(670_907),
            at: ._30,
            limit: ._24hours
        )
        
        XCTAssertEqual(tc.days, 0)
        XCTAssertEqual(tc.hours, 6)
        XCTAssertEqual(tc.minutes, 12)
        XCTAssertEqual(tc.seconds, 43)
        XCTAssertEqual(tc.frames, 17)
        XCTAssertEqual(tc.subFrames, 0)
    }
    
    func testTimecode_init_FrameCountValue_Clamping() {
        let tc = Timecode(
            clamping: .frames(2073600 + 86400), // 25 hours @ 24fps
            at: ._24,
            limit: ._24hours
        )
        
        XCTAssertEqual(
            tc.components,
            TCC(h: 23, m: 59, s: 59, f: 23, sf: tc.subFramesBase.rawValue - 1)
        )
    }
    
    func testTimecode_init_FrameCountValue_Wrapping() {
        let tc = Timecode(
            wrapping: .frames(2073600 + 86400), // 25 hours @ 24fps
            at: ._24,
            limit: ._24hours
        )
        
        XCTAssertEqual(tc.days, 0)
        XCTAssertEqual(tc.hours, 1)
        XCTAssertEqual(tc.minutes, 0)
        XCTAssertEqual(tc.seconds, 0)
        XCTAssertEqual(tc.frames, 0)
        XCTAssertEqual(tc.subFrames, 0)
    }
    
    func testTimecode_init_FrameCountValue_RawValues() {
        let tc = Timecode(
            rawValues: .frames((2073600 * 2) + 86400), // 2 days + 1 hour @ 24fps
            at: ._24,
            limit: ._24hours
        )
        
        XCTAssertEqual(tc.days, 2)
        XCTAssertEqual(tc.hours, 1)
        XCTAssertEqual(tc.minutes, 0)
        XCTAssertEqual(tc.seconds, 0)
        XCTAssertEqual(tc.frames, 0)
        XCTAssertEqual(tc.subFrames, 0)
    }
}

#endif
