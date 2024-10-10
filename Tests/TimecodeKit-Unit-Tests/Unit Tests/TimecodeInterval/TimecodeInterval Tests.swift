//
//  TimecodeInterval Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

@testable import TimecodeKit
import XCTest

final class TimecodeInterval_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testInitA() throws {
        // positive
        
        let intervalTC = try Timecode(.components(m: 1), at: .fps24)
        
        let interval = TimecodeInterval(intervalTC)
        
        XCTAssertEqual(interval.absoluteInterval, intervalTC)
        XCTAssertEqual(interval.sign, .plus)
    }
    
    func testInitB() throws {
        // negative
        
        let intervalTC = try Timecode(.components(m: 1), at: .fps24)
        
        let interval = TimecodeInterval(intervalTC, .minus)
        
        XCTAssertEqual(interval.absoluteInterval, intervalTC)
        XCTAssertEqual(interval.sign, .minus)
    }
    
    func testInitC() {
        // Timecode.Components can contain negative values;
        // this should not alter the sign however
        
        let intervalTC = Timecode(.components(m: -1), at: .fps24, by: .allowingInvalid)
        
        let interval = TimecodeInterval(intervalTC)
        
        XCTAssertEqual(interval.absoluteInterval, intervalTC)
        XCTAssertEqual(interval.sign, .plus)
    }
    
    func testIsNegative() {
        XCTAssertEqual(
            TimecodeInterval(Timecode(.zero, at: .fps24))
                .isNegative,
            false
        )
        
        XCTAssertEqual(
            TimecodeInterval(Timecode(.zero, at: .fps24), .minus)
                .isNegative,
            true
        )
    }
    
    func testTimecodeA() throws {
        // positive
        
        let intervalTC = try Timecode(.components(m: 1), at: .fps24)
        
        let interval = TimecodeInterval(intervalTC)
        
        XCTAssertEqual(interval.flattened(), intervalTC)
    }
    
    func testTimecodeB() throws {
        // negative, wrapping
        
        let intervalTC = try Timecode(.components(m: 1), at: .fps24)
        
        let interval = TimecodeInterval(intervalTC, .minus)
        
        XCTAssertEqual(
            interval.flattened(),
            try Timecode(.components(h: 23, m: 59, s: 00, f: 00), at: .fps24)
        )
    }
    
    func testTimecodeC() throws {
        // positive, wrapping
        
        let intervalTC = Timecode(.components(h: 26), at: .fps24, by: .allowingInvalid)
        
        let interval = TimecodeInterval(intervalTC)
        
        XCTAssertEqual(
            interval.flattened(),
            try Timecode(.components(h: 02, m: 00, s: 00, f: 00), at: .fps24)
        )
    }
    
    /// Requires @testable
    func testTimecodeOffsettingA() throws {
        // positive
        
        let intervalTC = Timecode(.components(m: 1), at: .fps24, by: .allowingInvalid)
        
        let interval = TimecodeInterval(intervalTC)
        
        XCTAssertEqual(
            try interval.timecode(offsetting: Timecode(.components(h: 1), at: .fps24)),
            try Timecode(.components(h: 01, m: 01, s: 00, f: 00), at: .fps24)
        )
    }
    
    /// Requires @testable
    func testTimecodeOffsettingB() throws {
        // negative
        
        let intervalTC = Timecode(.components(m: 1), at: .fps24, by: .allowingInvalid)
        
        let interval = TimecodeInterval(intervalTC, .minus)
        
        XCTAssertEqual(
            try interval.timecode(offsetting: Timecode(.components(h: 1), at: .fps24)),
            try Timecode(.components(h: 00, m: 59, s: 00, f: 00), at: .fps24)
        )
    }
    
    func testRealTimeValueA() throws {
        // positive
        
        let intervalTC = try Timecode(.components(h: 1), at: .fps24)
        
        let interval = TimecodeInterval(intervalTC)
        
        XCTAssertEqual(interval.realTimeValue, intervalTC.realTimeValue)
    }
    
    func testRealTimeValueB() throws {
        // negative
        
        let intervalTC = try Timecode(.components(h: 1), at: .fps24)
        
        let interval = TimecodeInterval(intervalTC, .minus)
        
        XCTAssertEqual(interval.realTimeValue, -intervalTC.realTimeValue)
    }
    
    func testStaticConstructors_Positive() throws {
        let interval: TimecodeInterval = try .positive(
            Timecode(.components(h: 1), at: .fps24)
        )
        XCTAssertEqual(
            interval.absoluteInterval,
            try Timecode(.components(h: 1), at: .fps24)
        )
        XCTAssertFalse(interval.isNegative)
    }
    
    func testStaticConstructors_Negative() throws {
        let interval: TimecodeInterval = try .negative(
            Timecode(.components(h: 1), at: .fps24)
        )
        XCTAssertEqual(
            interval.absoluteInterval,
            try Timecode(.components(h: 1), at: .fps24)
        )
        XCTAssertTrue(interval.isNegative)
    }
}
