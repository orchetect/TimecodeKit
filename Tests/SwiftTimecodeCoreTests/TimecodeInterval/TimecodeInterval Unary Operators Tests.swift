//
//  TimecodeInterval Unary Operators Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftTimecodeCore
import XCTest

final class TimecodeInterval_UnaryOperators_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testNegative() throws {
        let interval = try -Timecode(.components(m: 1), at: .fps24)
        
        XCTAssertEqual(interval.absoluteInterval, try Timecode(.components(m: 1), at: .fps24))
        XCTAssertTrue(interval.isNegative)
    }
    
    func testPositive() throws {
        let interval = try +Timecode(.components(m: 1), at: .fps24)
        
        XCTAssertEqual(interval.absoluteInterval, try Timecode(.components(m: 1), at: .fps24))
        XCTAssertFalse(interval.isNegative)
    }
}
