//
//  CustomStringConvertible Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

@testable import TimecodeKit
import XCTest

class Timecode_CustomStringConvertible_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testCustomStringConvertible() throws {
        let tc = try Timecode(
            .components(d: 1, h: 2, m: 3, s: 4, f: 5, sf: 6),
            at: ._24,
            limit: ._100Days
        )
        
        XCTAssertNotEqual(tc.description, "")
        
        XCTAssertNotEqual(tc.debugDescription, "")
        
        XCTAssertNotEqual(tc.verboseDescription, "")
    }
}

#endif
