//
//  TimecodeFrameRate String Extensions Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

@testable import TimecodeKit
import XCTest

class TimecodeFrameRate_StringExtensions_Tests: XCTestCase {
    func testString_toTimecodeFrameRate() {
        // do a spot-check to ensure this functions as expected
                
        XCTAssertEqual("23.976".timecodeFrameRate(), ._23_976)
        XCTAssertEqual("29.97d".timecodeFrameRate(), ._29_97_drop)
        
        XCTAssertNil("".timecodeFrameRate())
        XCTAssertNil(" ".timecodeFrameRate())
        XCTAssertNil("BogusString".timecodeFrameRate())
    }
}
#endif
