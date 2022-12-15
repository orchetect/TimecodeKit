//
//  TimecodeFrameRate String Extensions Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import TimecodeKit

class TimecodeFrameRate_StringExtensions_Tests: XCTestCase {
    func testString_toTimecodeFrameRate() {
        // do a spot-check to ensure this functions as expected
                
        XCTAssertEqual("23.976".toTimecodeFrameRate, ._23_976)
        XCTAssertEqual("29.97d".toTimecodeFrameRate, ._29_97_drop)
        
        XCTAssertNil("".toTimecodeFrameRate)
        XCTAssertNil(" ".toTimecodeFrameRate)
        XCTAssertNil("BogusString".toTimecodeFrameRate)
    }
}
#endif
