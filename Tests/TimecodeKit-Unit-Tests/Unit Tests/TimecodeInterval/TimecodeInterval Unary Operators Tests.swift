//
//  TimecodeInterval Unary Operators Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import TimecodeKit
import XCTest

class TimecodeInterval_UnaryOperators_Tests: XCTestCase {
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

#endif
