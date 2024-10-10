//
//  TimecodeInterval Real Time Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import TimecodeKit
import XCTest

final class TimecodeInterval_RealTime_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testRealTime() throws {
        let ti = try TimecodeInterval(
            realTime: 2.0,
            at: .fps24
        )
        
        XCTAssertEqual(ti.sign, .plus)
        
        XCTAssertEqual(
            ti.absoluteInterval,
            try Timecode(.components(s: 2), at: .fps24)
        )
        
        XCTAssertEqual(
            ti.flattened(),
            try Timecode(.components(s: 2), at: .fps24)
        )
        
        XCTAssertEqual(ti.rationalValue, Fraction(2, 1))
    }
    
    func testRealTimeNegative() throws {
        let ti = try TimecodeInterval(
            realTime: -2.0,
            at: .fps24
        )
        
        XCTAssertEqual(ti.sign, .minus)
        
        XCTAssertEqual(
            ti.absoluteInterval,
            try Timecode(.components(s: 2), at: .fps24)
        )
        
        XCTAssertEqual(
            ti.flattened(), // wraps around clock by underflowing
            try Timecode(.components(h: 23, m: 59, s: 58, f: 00), at: .fps24)
        )
        
        XCTAssertEqual(ti.rationalValue, Fraction(-2, 1))
    }
    
    func testTimeInterval_timecodeInterval() throws {
        let ti = try 2.0.timecodeInterval(at: .fps24)
        
        XCTAssertEqual(ti.sign, .plus)
        
        XCTAssertEqual(
            ti.absoluteInterval,
            try Timecode(.components(s: 2), at: .fps24)
        )
    }
}
