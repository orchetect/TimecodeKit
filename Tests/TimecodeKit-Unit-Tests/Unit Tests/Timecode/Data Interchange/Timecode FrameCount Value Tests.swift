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
}

#endif
