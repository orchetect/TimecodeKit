//
//  TimecodeInterval Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import TimecodeKit

class TimecodeInterval_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testInitA() throws {
        // positive
        
        let intervalTC = try Timecode(TCC(m: 1), at: ._24)
        
        let interval = TimecodeInterval(intervalTC)
        
        XCTAssertEqual(interval.absoluteInterval, intervalTC)
        XCTAssertEqual(interval.intervalSign, .positive)
    }
    
    func testInitB() throws {
        // negative
        
        let intervalTC = try Timecode(TCC(m: 1), at: ._24)
        
        let interval = TimecodeInterval(intervalTC, .negative)
        
        XCTAssertEqual(interval.absoluteInterval, intervalTC)
        XCTAssertEqual(interval.intervalSign, .negative)
    }
    
    func testInitC() {
        // TCC can contain negative values;
        // this should not alter the sign however
        
        let intervalTC = Timecode(rawValues: TCC(m: -1), at: ._24)
        
        let interval = TimecodeInterval(intervalTC)
        
        XCTAssertEqual(interval.absoluteInterval, intervalTC)
        XCTAssertEqual(interval.intervalSign, .positive)
    }
    
    func testIsNegative() {
        XCTAssertEqual(
            TimecodeInterval(.init(at: ._24))
                .isNegative,
            false
        )
        
        XCTAssertEqual(
            TimecodeInterval(.init(at: ._24), .negative)
                .isNegative,
            true
        )
    }
    
    func testTimecodeA() throws {
        // positive
        
        let intervalTC = try Timecode(TCC(m: 1), at: ._24)
        
        let interval = TimecodeInterval(intervalTC)
        
        XCTAssertEqual(interval.flattened(), intervalTC)
    }
    
    func testTimecodeB() throws {
        // negative, wrapping
        
        let intervalTC = try Timecode(TCC(m: 1), at: ._24)
        
        let interval = TimecodeInterval(intervalTC, .negative)
        
        XCTAssertEqual(
            interval.flattened(),
            try Timecode(TCC(h: 23, m: 59, s: 00, f: 00), at: ._24)
        )
    }
    
    func testTimecodeC() throws {
        // positive, wrapping
        
        let intervalTC = Timecode(rawValues: TCC(h: 26), at: ._24)
        
        let interval = TimecodeInterval(intervalTC)
        
        XCTAssertEqual(
            interval.flattened(),
            try Timecode(TCC(h: 02, m: 00, s: 00, f: 00), at: ._24)
        )
    }
    
    func testTimecodeOffsettingA() throws {
        // positive
        
        let intervalTC = Timecode(rawValues: TCC(m: 1), at: ._24)
        
        let interval = TimecodeInterval(intervalTC)
        
        XCTAssertEqual(
            interval.timecode(offsetting: try Timecode(TCC(h: 1), at: ._24)),
            try Timecode(TCC(h: 01, m: 01, s: 00, f: 00), at: ._24)
        )
    }
    
    func testTimecodeOffsettingB() throws {
        // negative
        
        let intervalTC = Timecode(rawValues: TCC(m: 1), at: ._24)
        
        let interval = TimecodeInterval(intervalTC, .negative)
        
        XCTAssertEqual(
            interval.timecode(offsetting: try Timecode(TCC(h: 1), at: ._24)),
            try Timecode(TCC(h: 00, m: 59, s: 00, f: 00), at: ._24)
        )
    }
    
    func testRealTimeValueA() throws {
        // positive
        
        let intervalTC = try Timecode(TCC(h: 1), at: ._24)
        
        let interval = TimecodeInterval(intervalTC)
        
        XCTAssertEqual(interval.realTimeValue, intervalTC.realTimeValue)
    }
    
    func testRealTimeValueB() throws {
        // negative
        
        let intervalTC = try Timecode(TCC(h: 1), at: ._24)
        
        let interval = TimecodeInterval(intervalTC, .negative)
        
        XCTAssertEqual(interval.realTimeValue, -intervalTC.realTimeValue)
    }
    
    func testStaticConstructors_Positive() throws {
        let interval: TimecodeInterval = .positive(
            try Timecode(TCC(h: 1), at: ._24)
        )
        XCTAssertEqual(
            interval.absoluteInterval,
            try Timecode(TCC(h: 1), at: ._24)
        )
        XCTAssertFalse(interval.isNegative)
    }
    
    func testStaticConstructors_Negative() throws {
        let interval: TimecodeInterval = .negative(
            try Timecode(TCC(h: 1), at: ._24)
        )
        XCTAssertEqual(
            interval.absoluteInterval,
            try Timecode(TCC(h: 1), at: ._24)
        )
        XCTAssertTrue(interval.isNegative)
    }
}

#endif
