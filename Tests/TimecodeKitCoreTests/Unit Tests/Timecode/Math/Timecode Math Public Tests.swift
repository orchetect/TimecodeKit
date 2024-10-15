//
//  Timecode Math Public Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import TimecodeKitCore // do NOT import as @testable in this file
import XCTest

final class Timecode_Math_Public_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testAddTimecode() throws {
        var tc = Timecode(.zero, at: .fps23_976, limit: .max24Hours)
        
        let tc1 = try Timecode(
            .components(h: 01, m: 02, s: 03, f: 04),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        try tc.add(tc1)
        XCTAssertEqual(tc.components, Timecode.Components(h: 01, m: 02, s: 03, f: 04))
        
        try tc.add(tc1)
        XCTAssertEqual(tc.components, Timecode.Components(h: 02, m: 04, s: 06, f: 08))
    }
    
    func testAddTimecodeByClamping() throws {
        var tc = try Timecode(
            .components(h: 10, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        let tc1 = try Timecode(
            .components(h: 15, m: 02, s: 03, f: 04),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        try tc.add(tc1, by: .clamping)
        XCTAssertEqual(tc.components, Timecode.Components(h: 23, m: 59, s: 59, f: 23, sf: 99))
    }
    
    func testAddTimecodeByWrapping() throws {
        var tc = try Timecode(
            .components(h: 10, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        let tc1 = try Timecode(
            .components(h: 15, m: 02, s: 03, f: 04),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        try tc.add(tc1, by: .wrapping)
        XCTAssertEqual(tc.components, Timecode.Components(h: 01, m: 02, s: 03, f: 04))
        
        try tc.add(tc1, by: .wrapping)
        XCTAssertEqual(tc.components, Timecode.Components(h: 16, m: 04, s: 06, f: 08))
    }
    
    func testAddDifferingFrameRates() throws {
        var tc = try Timecode(.components(h: 1), at: .fps25)
        let tc1 = try Timecode(.components(h: 1), at: .fps29_97) // 1:00:03:15 @ 25fps
        
        try tc.add(tc1)
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 02, m: 00, s: 03, f: 15))
    }
    
    func testAddingTimecode() throws {
        var tc = Timecode(.zero, at: .fps23_976, limit: .max24Hours)
        
        let tc1 = try Timecode(
            .components(h: 01, m: 02, s: 03, f: 04),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        tc = try tc.adding(tc1)
        XCTAssertEqual(tc.components, Timecode.Components(h: 01, m: 02, s: 03, f: 04))
        
        tc = try tc.adding(tc1)
        XCTAssertEqual(tc.components, Timecode.Components(h: 02, m: 04, s: 06, f: 08))
    }
    
    func testAddingTimecodeByClamping() throws {
        let tc = try Timecode(
            .components(h: 10, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        let tc1 = try Timecode(
            .components(h: 15, m: 02, s: 03, f: 04),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        let tc2 = try tc.adding(tc1, by: .clamping)
        XCTAssertEqual(tc2.components, Timecode.Components(h: 23, m: 59, s: 59, f: 23, sf: 99))
    }
    
    func testAddingTimecodeByWrapping() throws {
        let tc = try Timecode(
            .components(h: 10, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        let tc1 = try Timecode(
            .components(h: 15, m: 02, s: 03, f: 04),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        let tc2 = try tc.adding(tc1, by: .wrapping)
        XCTAssertEqual(tc2.components, Timecode.Components(h: 01, m: 02, s: 03, f: 04))
        
        let tc3 = try tc2.adding(tc1, by: .wrapping)
        XCTAssertEqual(tc3.components, Timecode.Components(h: 16, m: 04, s: 06, f: 08))
    }
    
    func testAddingDifferingFrameRates() throws {
        let tc = try Timecode(.components(h: 1), at: .fps25)
        let tc1 = try Timecode(.components(h: 1), at: .fps29_97) // 1:00:03:15 @ 25fps
        
        let tc2 = try tc.adding(tc1)
        XCTAssertEqual(tc2.components, Timecode.Components(h: 02, m: 00, s: 03, f: 15))
    }
    
    func testSubtractTimecode() throws {
        var tc = try Timecode(
            .components(h: 10, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        let tc1 = try Timecode(
            .components(h: 00, m: 00, s: 00, f: 01),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        try tc.subtract(tc1)
        XCTAssertEqual(tc.components, Timecode.Components(h: 09, m: 59, s: 59, f: 23))
        
        try tc.subtract(tc1)
        XCTAssertEqual(tc.components, Timecode.Components(h: 09, m: 59, s: 59, f: 22))
    }
    
    func testSubtractTimecodeByClamping() throws {
        var tc = try Timecode(
            .components(h: 10, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        let tc1 = try Timecode(
            .components(h: 06, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        try tc.subtract(tc1, by: .clamping)
        XCTAssertEqual(tc.components, Timecode.Components(h: 04, m: 00, s: 00, f: 00))
        
        try tc.subtract(tc1, by: .clamping)
        XCTAssertEqual(tc.components, Timecode.Components(h: 00, m: 00, s: 00, f: 00))
    }
    
    func testSubtractTimecodeByWrapping() throws {
        var tc = try Timecode(
            .components(h: 10, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        let tc1 = try Timecode(
            .components(h: 06, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        try tc.subtract(tc1, by: .wrapping)
        XCTAssertEqual(tc.components, Timecode.Components(h: 04, m: 00, s: 00, f: 00))
        
        try tc.subtract(tc1, by: .wrapping)
        XCTAssertEqual(tc.components, Timecode.Components(h: 22, m: 00, s: 00, f: 00))
    }
    
    func testSubtractDifferingFrameRates() throws {
        var tc = try Timecode(.components(h: 2), at: .fps25)
        let tc1 = try Timecode(.components(h: 1), at: .fps29_97) // 1:00:03:15 @ 25fps
        
        try tc.subtract(tc1)
        XCTAssertEqual(tc.components, Timecode.Components(h: 00, m: 59, s: 56, f: 10))
    }
    
    func testSubtractingTimecode() throws {
        let tc = try Timecode(
            .components(h: 10, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        let tc1 = try Timecode(
            .components(h: 00, m: 00, s: 00, f: 01),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        let tc2 = try tc.subtracting(tc1)
        XCTAssertEqual(tc2.components, Timecode.Components(h: 09, m: 59, s: 59, f: 23))
        
        let tc3 = try tc2.subtracting(tc1)
        XCTAssertEqual(tc3.components, Timecode.Components(h: 09, m: 59, s: 59, f: 22))
    }
    
    func testSubtractingTimecodeByClamping() throws {
        let tc = try Timecode(
            .components(h: 10, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        let tc1 = try Timecode(
            .components(h: 06, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        let tc2 = try tc.subtracting(tc1, by: .clamping)
        XCTAssertEqual(tc2.components, Timecode.Components(h: 04, m: 00, s: 00, f: 00))
        
        let tc3 = try tc2.subtracting(tc1, by: .clamping)
        XCTAssertEqual(tc3.components, Timecode.Components(h: 00, m: 00, s: 00, f: 00))
    }
    
    func testSubtractingTimecodeByWrapping() throws {
        let tc = try Timecode(
            .components(h: 10, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        let tc1 = try Timecode(
            .components(h: 06, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        let tc2 = try tc.subtracting(tc1, by: .wrapping)
        XCTAssertEqual(tc2.components, Timecode.Components(h: 04, m: 00, s: 00, f: 00))
        
        let tc3 = try tc2.subtracting(tc1, by: .wrapping)
        XCTAssertEqual(tc3.components, Timecode.Components(h: 22, m: 00, s: 00, f: 00))
    }
    
    func testSubtractingDifferingFrameRates() throws {
        let tc = try Timecode(.components(h: 2), at: .fps25)
        let tc1 = try Timecode(.components(h: 1), at: .fps29_97) // 1:00:03:15 @ 25fps
        
        let tc2 = try tc.subtracting(tc1)
        XCTAssertEqual(tc2.components, Timecode.Components(h: 00, m: 59, s: 56, f: 10))
    }
    
    func testAddTimecodeSourceValue() throws {
        var tc = Timecode(.zero, at: .fps23_976, limit: .max24Hours)
        
        try tc.add(.components(h: 1))
        XCTAssertEqual(tc.components, Timecode.Components(h: 01, m: 00, s: 00, f: 00))
        
        try tc.add(.string("01:00:00:00"))
        XCTAssertEqual(tc.components, Timecode.Components(h: 02, m: 00, s: 00, f: 00))
    }
    
    /// Just test one of the validation rules to make sure they work.
    func testAddTimecodeSourceValueByClamping() throws {
        var tc = try Timecode(
            .components(h: 10, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        try tc.add(.components(h: 10), by: .clamping)
        XCTAssertEqual(tc.components, Timecode.Components(h: 20, m: 00, s: 00, f: 00))
        
        try tc.add(.string("10:00:00:00"), by: .clamping)
        XCTAssertEqual(tc.components, Timecode.Components(h: 23, m: 59, s: 59, f: 23, sf: 99))
    }
    
    func testAddingTimecodeSourceValue() throws {
        let tc = Timecode(.zero, at: .fps23_976, limit: .max24Hours)
        
        let tc2 = try tc.adding(.components(h: 1))
        XCTAssertEqual(tc2.components, Timecode.Components(h: 01, m: 00, s: 00, f: 00))
        
        let tc3 = try tc2.adding(.string("01:00:00:00"))
        XCTAssertEqual(tc3.components, Timecode.Components(h: 02, m: 00, s: 00, f: 00))
    }
    
    /// Just test one of the validation rules to make sure they work.
    func testAddingTimecodeSourceValueByClamping() throws {
        let tc = try Timecode(
            .components(h: 10, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        let tc2 = try tc.adding(.components(h: 10), by: .clamping)
        XCTAssertEqual(tc2.components, Timecode.Components(h: 20, m: 00, s: 00, f: 00))
        
        let tc3 = try tc2.adding(.string("10:00:00:00"), by: .clamping)
        XCTAssertEqual(tc3.components, Timecode.Components(h: 23, m: 59, s: 59, f: 23, sf: 99))
    }
    
    func testSubtractTimecodeSourceValue() throws {
        var tc = try Timecode(
            .components(h: 10, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        try tc.subtract(.components(f: 1))
        XCTAssertEqual(tc.components, Timecode.Components(h: 09, m: 59, s: 59, f: 23))
        
        try tc.subtract(.string("00:00:00:01"))
        XCTAssertEqual(tc.components, Timecode.Components(h: 09, m: 59, s: 59, f: 22))
    }
    
    /// Just test one of the validation rules to make sure they work.
    func testSubtractTimecodeSourceValueByClamping() throws {
        var tc = try Timecode(
            .components(h: 10, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        try tc.subtract(.components(h: 6), by: .clamping)
        XCTAssertEqual(tc.components, Timecode.Components(h: 04, m: 00, s: 00, f: 00))
        
        try tc.subtract(.string("06:00:00:00"), by: .clamping)
        XCTAssertEqual(tc.components, Timecode.Components(h: 00, m: 00, s: 00, f: 00))
    }
    
    func testSubtractingTimecodeSourceValue() throws {
        let tc = try Timecode(
            .components(h: 10, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        let tc2 = try tc.subtracting(.components(f: 1))
        XCTAssertEqual(tc2.components, Timecode.Components(h: 09, m: 59, s: 59, f: 23))
        
        let tc3 = try tc2.subtracting(.string("00:00:00:01"))
        XCTAssertEqual(tc3.components, Timecode.Components(h: 09, m: 59, s: 59, f: 22))
    }
    
    /// Just test one of the validation rules to make sure they work.
    func testSubtractingTimecodeSourceValueByClamping() throws {
        let tc = try Timecode(
            .components(h: 10, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        let tc2 = try tc.subtracting(.components(h: 06), by: .clamping)
        XCTAssertEqual(tc2.components, Timecode.Components(h: 04, m: 00, s: 00, f: 00))
        
        let tc3 = try tc2.subtracting(.string("06:00:00:00"), by: .clamping)
        XCTAssertEqual(tc3.components, Timecode.Components(h: 00, m: 00, s: 00, f: 00))
    }
    
    func testAdd_and_Subtract_Components_Methods() throws {
        // .add / .subtract methods
        
        var tc = Timecode(.zero, at: .fps23_976, limit: .max24Hours)
        
        tc = try Timecode(
            .components(h: 00, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        try tc.add(Timecode.Components(h: 00, m: 00, s: 00, f: 23))
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 00, m: 00, s: 00, f: 23))
        
        try tc.add(Timecode.Components(h: 00, m: 00, s: 00, f: 01))
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 00, m: 00, s: 01, f: 00))
        
        tc = try Timecode(
            .components(h: 00, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        try tc.add(Timecode.Components(h: 01, m: 15, s: 30, f: 10))
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 01, m: 15, s: 30, f: 10))
        
        try tc.add(Timecode.Components(h: 01, m: 15, s: 30, f: 10))
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 02, m: 31, s: 00, f: 20))
        
        XCTAssertThrowsError(try tc.add(Timecode.Components(h: 23, m: 15, s: 30, f: 10)))
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 02, m: 31, s: 00, f: 20)) // unchanged value
        
        tc = try Timecode(
            .components(h: 00, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        XCTAssertThrowsError(try tc.subtract(Timecode.Components(h: 02, m: 31, s: 00, f: 20)))
        
        tc = try Timecode(
            .components(h: 23, m: 59, s: 59, f: 23),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        try tc.subtract(Timecode.Components(h: 23, m: 59, s: 59, f: 23))
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 00, m: 00, s: 00, f: 00))
        
        tc = try Timecode(
            .components(h: 23, m: 59, s: 59, f: 23),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        XCTAssertThrowsError(try tc.subtract(Timecode.Components(h: 23, m: 59, s: 59, f: 24))) // 1 frame too many
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 23, m: 59, s: 59, f: 23)) // unchanged value
        
        tc = try Timecode(
            .components(h: 00, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        try tc.add(Timecode.Components(f: 24)) // roll up to 1 sec
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 00, m: 00, s: 01, f: 00))
        
        tc = try Timecode(
            .components(h: 00, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        try tc.add(Timecode.Components(s: 60)) // roll up to 1 min
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 00, m: 01, s: 00, f: 00))
        
        tc = try Timecode(
            .components(h: 00, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        try tc.add(Timecode.Components(m: 60)) // roll up to 1 hr
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 01, m: 00, s: 00, f: 00))
        
        tc = try Timecode(
            .components(d: 0, h: 00, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max100Days
        )
        
        try tc.add(Timecode.Components(h: 24)) // roll up to 1 day
        
        XCTAssertEqual(tc.components, Timecode.Components(d: 01, h: 00, m: 00, s: 00, f: 00))
        
        tc = try Timecode(
            .components(h: 00, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        try tc.add(Timecode.Components(h: 00, m: 00, s: 00, f: 2_073_599))
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 23, m: 59, s: 59, f: 23))
        
        tc = try Timecode(
            .components(h: 23, m: 59, s: 59, f: 23),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        try tc.subtract(Timecode.Components(h: 00, m: 00, s: 00, f: 2_073_599))
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 00, m: 00, s: 00, f: 00))
        
        try tc.add(Timecode.Components(h: 00, m: 00, s: 00, f: 200))
        
        try tc.subtract(Timecode.Components(h: 00, m: 00, s: 00, f: 199))
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 00, m: 00, s: 00, f: 01))
        
        // clamping
        
        tc = try Timecode(
            .components(h: 00, m: 00, s: 00, f: 00),
            at: .fps23_976,
            base: .max80SubFrames,
            limit: .max24Hours
        )
        
        tc.add(Timecode.Components(h: 25), by: .clamping)
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 23, m: 59, s: 59, f: 23, sf: 79))
        
        tc = try Timecode(
            .components(h: 00, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        tc.subtract(Timecode.Components(h: 4), by: .clamping)
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 00, m: 00, s: 00, f: 00))
        
        // wrapping
        
        tc = try Timecode(
            .components(h: 00, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        tc.add(Timecode.Components(h: 25), by: .wrapping)
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 01, m: 00, s: 00, f: 00))
        
        tc = try Timecode(
            .components(h: 00, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        tc.add(Timecode.Components(f: -1), by: .wrapping) // add negative number
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 23, m: 59, s: 59, f: 23))
        
        tc = try Timecode(
            .components(h: 00, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        tc.subtract(Timecode.Components(h: 4), by: .wrapping)
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 20, m: 00, s: 00, f: 00))
        
        tc = try Timecode(
            .components(h: 00, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        tc.subtract(Timecode.Components(h: -4), by: .wrapping) // subtract negative number
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 04, m: 00, s: 00, f: 00))
        
        // drop rates
        
        tc = try Timecode(
            .components(h: 00, m: 00, s: 00, f: 00),
            at: .fps29_97d,
            limit: .max24Hours
        )
        
        try tc.add(Timecode.Components(h: 00, m: 00, s: 00, f: 29))
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 00, m: 00, s: 00, f: 29))
        
        try tc.add(Timecode.Components(h: 00, m: 00, s: 00, f: 01))
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 00, m: 00, s: 01, f: 00))
        
        tc = try Timecode(
            .components(h: 00, m: 00, s: 00, f: 00),
            at: .fps29_97d,
            limit: .max24Hours
        )
        
        try tc.add(Timecode.Components(m: 60)) // roll up to 1 hr
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 01, m: 00, s: 00, f: 00))
        
        try tc = Timecode(
            .components(h: 00, m: 00, s: 00, f: 00),
            at: .fps29_97d,
            limit: .max24Hours
        )
        
        try tc.add(Timecode.Components(f: 30)) // roll up to 1 sec
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 00, m: 00, s: 01, f: 00))
        
        try tc = Timecode(
            .components(h: 00, m: 00, s: 59, f: 00),
            at: .fps29_97d,
            limit: .max24Hours
        )
        
        // roll up to 1 sec and 2 frames (2 dropped frames every minute except every 10th minute)
        try tc.add(Timecode.Components(f: 30))
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 00, m: 01, s: 00, f: 02))
        
        tc = try Timecode(
            .components(h: 00, m: 01, s: 00, f: 02),
            at: .fps29_97d,
            limit: .max24Hours
        )
        
        // roll up to 1 sec and 2 frames (2 dropped frames every minute except every 10th minute)
        try tc.add(Timecode.Components(m: 01))
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 00, m: 02, s: 00, f: 02))
        
        try tc.add(Timecode.Components(m: 08))
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 00, m: 10, s: 00, f: 00))
    }
    
    func testAdding_Components_Methods() throws {
        // .adding()
        
        let tc = try Timecode(
            .components(h: 00, m: 10, s: 00, f: 00),
            at: .fps29_97d,
            limit: .max24Hours
        )
        
        // exactly
        XCTAssertEqual(
            try tc.adding(Timecode.Components(h: 1)).components,
            Timecode.Components(h: 1, m: 10, s: 00, f: 00)
        )
        
        XCTAssertEqual(
            tc.adding(Timecode.Components(h: 26), by: .wrapping).components,
            Timecode.Components(h: 2, m: 10, s: 00, f: 00)
        )
        
        XCTAssertEqual(
            tc.adding(Timecode.Components(h: 26), by: .clamping).components,
            Timecode.Components(h: 23, m: 59, s: 59, f: 29, sf: tc.subFramesBase.rawValue - 1)
        )
    }
    
    func testSubtracting_Components_Methods() throws {
        // .subtracting()
        
        let tc = try Timecode(
            .components(h: 00, m: 10, s: 00, f: 00),
            at: .fps29_97d,
            limit: .max24Hours
        )
        
        // exactly
        XCTAssertEqual(
            try tc.subtracting(Timecode.Components(m: 5)).components,
            Timecode.Components(h: 0, m: 05, s: 00, f: 02) // remember, we're using drop rate!
        )
    }
    
    func testMultiply_and_Divide() throws {
        // .multiply / .divide methods
        
        var tc = try Timecode(
            .components(h: 01, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        try tc.multiply(2)
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 02, m: 00, s: 00, f: 00))
        
        tc = try Timecode(
            .components(h: 01, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        try tc.multiply(2.5)
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 02, m: 30, s: 00, f: 00))
        
        tc = try Timecode(
            .components(h: 01, m: 00, s: 00, f: 00),
            at: .fps29_97d,
            limit: .max24Hours
        )
        
        try tc.multiply(2)
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 02, m: 00, s: 00, f: 00))
        
        tc = try Timecode(
            .components(h: 01, m: 00, s: 00, f: 00),
            at: .fps29_97d,
            limit: .max24Hours
        )
        
        try tc.multiply(2.5)
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 02, m: 30, s: 00, f: 00))
        
        tc = try Timecode(
            .components(h: 01, m: 00, s: 00, f: 00),
            at: .fps29_97d,
            limit: .max24Hours
        )
        
        XCTAssertThrowsError(try tc.multiply(25))
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 01, m: 00, s: 00, f: 00)) // unchanged
        
        // clamping
        
        tc = try Timecode(
            .components(h: 01, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        tc.multiply(25.0, by: .clamping)
        
        XCTAssertEqual(
            tc.components,
            Timecode.Components(h: 23, m: 59, s: 59, f: 23, sf: tc.subFramesBase.rawValue - 1)
        )
        
        tc = try Timecode(
            .components(h: 00, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        tc.divide(4, by: .clamping)
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 00, m: 00, s: 00, f: 00))
        
        // wrapping - multiply
        
        tc = try Timecode(
            .components(h: 01, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        tc.multiply(25.0, by: .wrapping)
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 01, m: 00, s: 00, f: 00))
        
        tc = try Timecode(
            .components(h: 01, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        tc.multiply(2, by: .wrapping)
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 02, m: 00, s: 00, f: 00)) // normal, no wrap
        
        tc = try Timecode(
            .components(h: 01, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        tc.multiply(25, by: .wrapping)
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 01, m: 00, s: 00, f: 00)) // wraps
        
        // wrapping - divide
        
        tc = try Timecode(
            .components(h: 01, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        tc.divide(-2, by: .wrapping)
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 23, m: 30, s: 00, f: 00))
        
        tc = try Timecode(
            .components(h: 01, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        tc.divide(2, by: .wrapping)
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 00, m: 30, s: 00, f: 00)) // normal, no wrap
        
        tc = try Timecode(
            .components(h: 12, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        tc.divide(-2, by: .wrapping)
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 18, m: 00, s: 00, f: 00)) // wraps
    }
    
    func testMultiplying() throws {
        // .multiplying()
        
        let tc = try Timecode(
            .components(h: 04, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        // exactly
        XCTAssertEqual(
            try tc.multiplying(2).components,
            Timecode.Components(h: 08, m: 00, s: 00, f: 00)
        )
    }
    
    func testDividing() throws {
        // .dividing()
        
        let tc = try Timecode(
            .components(h: 04, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        // exactly
        XCTAssertEqual(
            try tc.dividing(2).components,
            Timecode.Components(h: 02, m: 00, s: 00, f: 00)
        )
    }
    
    func testOffset() throws {
        var tc = try Timecode(
            .components(h: 01, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        let intervalTC = try Timecode(
            .components(h: 00, m: 01, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        tc.offset(by: .init(intervalTC, .plus))
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 01, m: 01, s: 00, f: 00))
        
        tc.offset(by: .init(intervalTC, .plus))
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 01, m: 02, s: 00, f: 00))
        
        tc.offset(by: .init(intervalTC, .minus))
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 01, m: 01, s: 00, f: 00))
    }
    
    func testOffsetting() throws {
        let tc = try Timecode(
            .components(h: 01, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        let intervalTC = try Timecode(
            .components(h: 00, m: 01, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        XCTAssertEqual(
            tc
                .offsetting(by: .init(intervalTC, .plus))
                .components,
            Timecode.Components(h: 01, m: 01, s: 00, f: 00)
        )
    }
    
    func testIntervalTo() throws {
        let tc1 = try Timecode(
            .components(h: 01, m: 00, s: 00, f: 00),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        let tc2 = try Timecode(
            .components(h: 01, m: 04, s: 37, f: 15),
            at: .fps23_976,
            limit: .max24Hours
        )
        
        // positive
        
        var interval = tc1.interval(to: tc2)
        
        XCTAssertEqual(interval.isNegative, false)
        XCTAssertEqual(
            interval.flattened(),
            try Timecode(
                .components(h: 00, m: 04, s: 37, f: 15),
                at: .fps23_976,
                limit: .max24Hours
            )
        )
        
        // negative
        
        interval = tc2.interval(to: tc1)
        
        XCTAssertEqual(interval.isNegative, true) // 23:55:22:09
        XCTAssertEqual(
            interval.absoluteInterval,
            try Timecode(
                .components(h: 00, m: 04, s: 37, f: 15),
                at: .fps23_976,
                limit: .max24Hours
            )
        )
        XCTAssertEqual(
            interval.flattened(),
            try Timecode(
                .components(h: 23, m: 55, s: 22, f: 09),
                at: .fps23_976,
                limit: .max24Hours
            )
        )
        
        // edge cases
        
        let tc3 = try Timecode(
            .components(d: 1, h: 03, m: 04, s: 37, f: 15),
            at: .fps23_976,
            limit: .max100Days
        )
        
        // positive, > 24 hours delta
        
        interval = tc1.interval(to: tc3)
        
        XCTAssertEqual(interval.isNegative, false)
        XCTAssertEqual(
            interval.absoluteInterval,
            try Timecode(
                .components(d: 1, h: 02, m: 04, s: 37, f: 15),
                at: .fps23_976,
                limit: .max100Days
            )
        )
        XCTAssertEqual(
            interval.flattened(),
            try Timecode(
                .components(h: 02, m: 04, s: 37, f: 15),
                at: .fps23_976,
                limit: .max24Hours
            )
        )
        
        // negative, > 24 hours delta, 100 days limit
        
        interval = tc3.interval(to: tc1)
        
        XCTAssertEqual(interval.isNegative, true)
        XCTAssertEqual(
            interval.absoluteInterval,
            try Timecode(
                .components(d: 1, h: 02, m: 04, s: 37, f: 15),
                at: .fps23_976,
                limit: .max100Days
            )
        )
        XCTAssertEqual(
            interval.flattened(),
            Timecode(
                .components(d: 98, h: 21, m: 55, s: 22, f: 09),
                at: .fps23_976,
                limit: .max100Days,
                by: .allowingInvalid
            )
        )
    }
    
    func testTimecodeInterval() throws {
        let interval = try Timecode(
            .components(h: 02, m: 04, s: 37, f: 15),
            at: .fps24
        ).asInterval(.minus)
        
        XCTAssertEqual(
            interval.flattened().components,
            Timecode.Components(h: 21, m: 55, s: 22, f: 9)
        )
        XCTAssertEqual(interval.flattened().frameRate, .fps24)
        XCTAssertTrue(interval.isNegative)
    }
}
