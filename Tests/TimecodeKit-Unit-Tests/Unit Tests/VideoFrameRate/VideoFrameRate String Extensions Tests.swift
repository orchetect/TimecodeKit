//
//  VideoFrameRate String Extensions Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

@testable import TimecodeKit
import XCTest

class VideoFrameRate_StringExtensions_Tests: XCTestCase {
    func testString_videoFrameRate() {
        // do a spot-check to ensure this functions as expected
        
        XCTAssertEqual("24p".videoFrameRate, ._24p)
        XCTAssertEqual("23.98p".videoFrameRate, ._23_98p)
        XCTAssertEqual("29.97p".videoFrameRate, ._29_97p)
        
        XCTAssertNil("".videoFrameRate)
        XCTAssertNil(" ".videoFrameRate)
        XCTAssertNil("BogusString".videoFrameRate)
    }
}
#endif
