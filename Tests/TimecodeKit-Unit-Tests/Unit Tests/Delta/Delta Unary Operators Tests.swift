//
//  Delta Unary Operators Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import TimecodeKit

class Timecode_UT_Delta_UnaryOperators_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testNegative() throws {
        let delta = try -Timecode(TCC(m: 1), at: ._24)
        
        XCTAssertEqual(delta.delta, try Timecode(TCC(m: 1), at: ._24))
        XCTAssertTrue(delta.isNegative)
    }
    
    func testPositive() throws {
        let delta = try +Timecode(TCC(m: 1), at: ._24)
        
        XCTAssertEqual(delta.delta, try Timecode(TCC(m: 1), at: ._24))
        XCTAssertFalse(delta.isNegative)
    }
}

#endif
