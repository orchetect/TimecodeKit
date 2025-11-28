//
//  VideoFrameRate String Extensions Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

@testable import SwiftTimecodeCore
import XCTest

final class VideoFrameRate_StringExtensions_Tests: XCTestCase {
    func testString_videoFrameRate() {
        // do a spot-check to ensure this functions as expected
        
        XCTAssertEqual("24p".videoFrameRate, .fps24p)
        XCTAssertEqual("23.98p".videoFrameRate, .fps23_98p)
        XCTAssertEqual("29.97p".videoFrameRate, .fps29_97p)
        
        XCTAssertNil("".videoFrameRate)
        XCTAssertNil(" ".videoFrameRate)
        XCTAssertNil("BogusString".videoFrameRate)
    }
}
