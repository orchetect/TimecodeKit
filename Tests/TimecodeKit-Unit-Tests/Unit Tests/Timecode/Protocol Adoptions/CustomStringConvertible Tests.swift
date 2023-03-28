//
//  CustomStringConvertible Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import TimecodeKit

class Timecode_CustomStringConvertible_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testCustomStringConvertible() throws {
        let tc = try Timecode(
            .components(d: 1, h: 2, m: 3, s: 4, f: 5, sf: 6),
            using: ._24,
            limit: ._100days
        )
        
        XCTAssertNotEqual(tc.description, "")
        
        XCTAssertNotEqual(tc.debugDescription, "")
        
        XCTAssertNotEqual(tc.verboseDescription, "")
    }
}

#endif
