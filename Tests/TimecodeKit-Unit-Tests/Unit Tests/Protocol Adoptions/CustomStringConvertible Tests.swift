//
//  CustomStringConvertible Tests.swift
//  TimecodeKitTests
//
//  Created by Steffan Andrews on 2020-06-16.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

import XCTest
@testable import TimecodeKit

class Timecode_UT_CustomStringConvertible_Tests: XCTestCase {
    
    override func setUp() { }
    override func tearDown() { }
    
    func testCustomStringConvertible() {
        
        let tc = Timecode(TCC(d: 1, h: 2, m: 3, s: 4, f: 5, sf: 6),
                          at: ._24,
                          limit: ._100days)!
        
        XCTAssertNotEqual(tc.description, "")
        
        XCTAssertNotEqual(tc.debugDescription, "")
        
        XCTAssertNotEqual(tc.verboseDescription, "")
        
    }
    
}

#endif
