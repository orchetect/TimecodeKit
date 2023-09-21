//
//  TimecodeInterval Rational CMTime Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import CoreMedia
@testable import TimecodeKit
import XCTest

class TimecodeInterval_Rational_CMTime_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testTimecodeInterval_init_cmTime() throws {
        let ti = try TimecodeInterval(
            CMTime(value: 60, timescale: 30),
            at: ._24
        )
        
        XCTAssertEqual(ti.sign, .plus)
        
        XCTAssertEqual(
            ti.absoluteInterval,
            try Timecode(.components(s: 2), at: ._24)
        )
    }
    
    func testCMTime() throws {
        let ti = try TimecodeInterval(
            Timecode(.components(s: 2), at: ._24)
        )
        
        let cmTime = ti.cmTime
        
        XCTAssertEqual(cmTime.seconds.sign, .plus)
        XCTAssertEqual(cmTime.value, 2)
        XCTAssertEqual(cmTime.timescale, 1)
    }
    
    func testCMTime_timecodeInterval() throws {
        let ti = try CMTime(value: 60, timescale: 30).timecodeInterval(at: ._24)
        
        XCTAssertEqual(ti.sign, .plus)
        
        XCTAssertEqual(
            ti.absoluteInterval,
            try Timecode(.components(s: 2), at: ._24)
        )
    }
}

#endif
