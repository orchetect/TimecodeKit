//
//  Timecode Operators Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import TimecodeKit

class Timecode_Operators_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testAdd_and_Subtract_Operators() throws {
        var tc = Timecode(.zero, at: ._30)
        
        // + and - operators
        
        tc = try Timecode.Components(h: 00, m: 00, s: 00, f: 00).timecode(at: ._30)
        
        tc = try tc + Timecode.Components(h: 00, m: 00, s: 00, f: 05).timecode(at: ._30)
        XCTAssertEqual(tc.components, Timecode.Components(h: 00, m: 00, s: 00, f: 05))
        
        tc = try tc - Timecode.Components(h: 00, m: 00, s: 00, f: 04).timecode(at: ._30)
        XCTAssertEqual(tc.components, Timecode.Components(h: 00, m: 00, s: 00, f: 01))
        
        // (underflow: wraps)
        tc = try tc - Timecode.Components(h: 00, m: 00, s: 00, f: 04).timecode(at: ._30)
        XCTAssertEqual(tc.components, Timecode.Components(h: 23, m: 59, s: 59, f: 27))
        
        // (overflow: wraps)
        tc = try tc + Timecode.Components(h: 00, m: 00, s: 00, f: 05).timecode(at: ._30)
        XCTAssertEqual(tc.components, Timecode.Components(h: 00, m: 00, s: 00, f: 02))
        
        // += and -= operators
        
        tc = try Timecode.Components(h: 00, m: 00, s: 00, f: 00).timecode(at: ._30)
        
        tc += try Timecode.Components(h: 00, m: 00, s: 00, f: 05).timecode(at: ._30)
        XCTAssertEqual(tc.components, Timecode.Components(h: 00, m: 00, s: 00, f: 05))
        
        tc -= try Timecode.Components(h: 00, m: 00, s: 00, f: 04).timecode(at: ._30)
        XCTAssertEqual(tc.components, Timecode.Components(h: 00, m: 00, s: 00, f: 01))
        
        // (underflow: wraps)
        tc -= try Timecode.Components(h: 00, m: 00, s: 00, f: 04).timecode(at: ._30)
        XCTAssertEqual(tc.components, Timecode.Components(h: 23, m: 59, s: 59, f: 27))
        
        // (overflow: wraps)
        tc += try Timecode.Components(h: 00, m: 00, s: 00, f: 05).timecode(at: ._30)
        XCTAssertEqual(tc.components, Timecode.Components(h: 00, m: 00, s: 00, f: 02))
    }
    
    func testMultiply_and_Divide_Double_Operators() throws {
        var tc = Timecode(.zero, at: ._30)
        
        // * and / operators
        
        tc = try Timecode.Components(h: 01, m: 00, s: 00, f: 00).timecode(at: ._30)
        
        tc = tc * 5
        XCTAssertEqual(tc.components, Timecode.Components(h: 05, m: 00, s: 00, f: 00))
        
        tc = tc / 5
        XCTAssertEqual(tc.components, Timecode.Components(h: 01, m: 00, s: 00, f: 00))
        
        // (overflow: wraps)
        tc = tc * 30 // == aka 30:00:00:00, 6 hours over 24:00:00:00
        XCTAssertEqual(tc.components, Timecode.Components(h: 06, m: 00, s: 00, f: 00))
        
        // (underflow: wraps)
        tc = tc * -2.5 // == aka -15:00:00:00, 15 hours under 24:00:00:00
        XCTAssertEqual(tc.components, Timecode.Components(h: 09, m: 00, s: 00, f: 00))
        
        // (underflow: wraps)
        tc = tc / -2 // == aka -4:30:00:00, 4 hours 30 min under 24:00:00:00
        XCTAssertEqual(tc.components, Timecode.Components(h: 19, m: 30, s: 00, f: 00))
        
        // *= and /= operators
        
        tc = try Timecode.Components(h: 01, m: 00, s: 00, f: 00).timecode(at: ._30)
        
        tc *= 5
        XCTAssertEqual(tc.components, Timecode.Components(h: 05, m: 00, s: 00, f: 00))
        
        tc /= 5
        XCTAssertEqual(tc.components, Timecode.Components(h: 01, m: 00, s: 00, f: 00))
        
        // (overflow: wraps)
        tc *= 30 // == aka 30:00:00:00, 6 hours over 24:00:00:00
        XCTAssertEqual(tc.components, Timecode.Components(h: 06, m: 00, s: 00, f: 00))
        
        // (underflow: wraps)
        tc *= -2.5 // == aka -15:00:00:00, 15 hours under 24:00:00:00
        XCTAssertEqual(tc.components, Timecode.Components(h: 09, m: 00, s: 00, f: 00))
        
        // (underflow: wraps)
        tc /= -2 // == aka -4:30:00:00, 4 hours 30 min under 24:00:00:00
        XCTAssertEqual(tc.components, Timecode.Components(h: 19, m: 30, s: 00, f: 00))
    }
    
    func testDivide_Timecode_Operator() throws {
        // / operator
        
        XCTAssertEqual(
            try Timecode.Components(h: 01, m: 00, s: 00, f: 00).timecode(at: ._30) /
            Timecode.Components(h: 01, m: 00, s: 00, f: 00).timecode(at: ._30),
            1.0
        )
        
        XCTAssertEqual(
            try Timecode.Components(h: 01, m: 00, s: 00, f: 00).timecode(at: ._30) /
            Timecode.Components(h: 00, m: 10, s: 00, f: 00).timecode(at: ._30),
            6.0
        )
        
        XCTAssertEqual(
            try Timecode.Components(h: 01, m: 00, s: 00, f: 00).timecode(at: ._30) /
            Timecode.Components(h: 00, m: 16, s: 00, f: 00).timecode(at: ._30),
            3.75
        )
    }
}

#endif
