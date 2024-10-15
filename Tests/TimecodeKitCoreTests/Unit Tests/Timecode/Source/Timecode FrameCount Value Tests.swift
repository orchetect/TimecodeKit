//
//  Timecode FrameCount Value Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import TimecodeKitCore // do NOT import as @testable in this file
import XCTest

final class Timecode_FrameCount_Value_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testTimecode_init_FrameCountValue_Exactly() throws {
        let tc = try Timecode(
            .frames(670_907),
            at: .fps30,
            limit: .max24Hours
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
            .frames(2073600 + 86400), // 25 hours @ 24fps
            at: .fps24,
            limit: .max24Hours,
            by: .clamping
        )
        
        XCTAssertEqual(
            tc.components,
            Timecode.Components(h: 23, m: 59, s: 59, f: 23, sf: tc.subFramesBase.rawValue - 1)
        )
    }
    
    func testTimecode_init_FrameCountValue_Wrapping() {
        let tc = Timecode(
            .frames(2073600 + 86400), // 25 hours @ 24fps
            at: .fps24,
            limit: .max24Hours,
            by: .wrapping
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
            .frames((2073600 * 2) + 86400), // 2 days + 1 hour @ 24fps
            at: .fps24,
            limit: .max24Hours,
            by: .allowingInvalid
        )
        
        XCTAssertEqual(tc.days, 2)
        XCTAssertEqual(tc.hours, 1)
        XCTAssertEqual(tc.minutes, 0)
        XCTAssertEqual(tc.seconds, 0)
        XCTAssertEqual(tc.frames, 0)
        XCTAssertEqual(tc.subFrames, 0)
    }
}
