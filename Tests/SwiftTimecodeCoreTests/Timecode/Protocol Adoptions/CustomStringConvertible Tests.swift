//
//  CustomStringConvertible Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftTimecodeCore
import XCTest

final class Timecode_CustomStringConvertible_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testCustomStringConvertibleA() throws {
        let tc = try Timecode(
            .components(d: 1, h: 2, m: 3, s: 4, f: 5, sf: 6),
            at: .fps24,
            limit: .max100Days
        )
        
        XCTAssertEqual(tc.description, "1 02:03:04:05.06")
        XCTAssertEqual(tc.debugDescription, "Timecode<1 02:03:04:05.06 @ 24 fps>")
    }
    
    func testCustomStringConvertibleB() throws {
        let tc = Timecode(
            .zero,
            at: .fps23_976,
            limit: .max100Days
        )
        
        XCTAssertEqual(tc.description, "00:00:00:00.00")
        XCTAssertEqual(tc.debugDescription, "Timecode<0 00:00:00:00.00 @ 23.976 fps>")
    }
    
    func testCustomStringConvertibleC() throws {
        let tc = Timecode(
            .zero,
            at: .fps23_976,
            limit: .max24Hours
        )
        
        XCTAssertEqual(tc.description, "00:00:00:00.00")
        XCTAssertEqual(tc.debugDescription, "Timecode<00:00:00:00.00 @ 23.976 fps>")
    }
}
