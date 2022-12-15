//
//  TimecodeInterval Unary Operators Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import TimecodeKit

class TimecodeInterval_UnaryOperators_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testNegative() throws {
        let interval = try -Timecode(TCC(m: 1), at: ._24)
        
        XCTAssertEqual(interval.absoluteInterval, try Timecode(TCC(m: 1), at: ._24))
        XCTAssertTrue(interval.isNegative)
    }
    
    func testPositive() throws {
        let interval = try +Timecode(TCC(m: 1), at: ._24)
        
        XCTAssertEqual(interval.absoluteInterval, try Timecode(TCC(m: 1), at: ._24))
        XCTAssertFalse(interval.isNegative)
    }
}

#endif
