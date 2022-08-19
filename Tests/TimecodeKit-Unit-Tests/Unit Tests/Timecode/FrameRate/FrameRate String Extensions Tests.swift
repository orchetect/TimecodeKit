//
//  FrameRate String Extensions Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import TimecodeKit

class Timecode_UT_FrameRate_StringExtensions_Tests: XCTestCase {
    func testString_toFrameRate() {
        // do a spot-check to ensure this functions as expected
                
        XCTAssertEqual("23.976".toFrameRate, ._23_976)
        XCTAssertEqual("29.97d".toFrameRate, ._29_97_drop)
        
        XCTAssertNil("".toFrameRate)
        XCTAssertNil(" ".toFrameRate)
        XCTAssertNil("BogusString".toFrameRate)
    }
}
#endif
