//
//  CustomStringConvertible Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import TimecodeKit
import XCTest

final class Timecode_CustomStringConvertible_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testCustomStringConvertible() throws {
        let tc = try Timecode(
            .components(d: 1, h: 2, m: 3, s: 4, f: 5, sf: 6),
            at: .fps24,
            limit: .max100Days
        )
        
        XCTAssertNotEqual(tc.description, "")
        
        XCTAssertNotEqual(tc.debugDescription, "")
        
        XCTAssertNotEqual(tc.verboseDescription, "")
    }
}
