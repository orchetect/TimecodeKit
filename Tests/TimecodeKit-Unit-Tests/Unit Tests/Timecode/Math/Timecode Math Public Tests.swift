//
//  Timecode Math Public Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import TimecodeKit

class Timecode_Math_Public_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testAdd_and_Subtract_Methods() throws {
        // .add / .subtract methods
        
        var tc = Timecode(.zero, using: ._23_976, limit: ._24hours)
        
        tc = try Timecode(
            .components(h: 00, m: 00, s: 00, f: 00),
            using: ._23_976,
            limit: ._24hours
        )
        
        try tc.add(.components(h: 00, m: 00, s: 00, f: 23))
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 00, m: 00, s: 00, f: 23))
        
        try tc.add(.components(h: 00, m: 00, s: 00, f: 01))
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 00, m: 00, s: 01, f: 00))
        
        tc = try Timecode(
            .components(h: 00, m: 00, s: 00, f: 00),
            using: ._23_976,
            limit: ._24hours
        )
        
        try tc.add(.components(h: 01, m: 15, s: 30, f: 10))
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 01, m: 15, s: 30, f: 10))
        
        try tc.add(.components(h: 01, m: 15, s: 30, f: 10))
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 02, m: 31, s: 00, f: 20))
        
        XCTAssertThrowsError(try tc.add(.components(h: 23, m: 15, s: 30, f: 10)))
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 02, m: 31, s: 00, f: 20)) // unchanged value
        
        tc = try Timecode(
            .components(h: 00, m: 00, s: 00, f: 00),
            using: ._23_976,
            limit: ._24hours
        )
        
        XCTAssertThrowsError(try tc.subtract(.components(h: 02, m: 31, s: 00, f: 20)))
        
        tc = try Timecode(
            .components(h: 23, m: 59, s: 59, f: 23),
            using: ._23_976,
            limit: ._24hours
        )
        
        try tc.subtract(.components(h: 23, m: 59, s: 59, f: 23))
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 00, m: 00, s: 00, f: 00))
        
        tc = try Timecode(
            .components(h: 23, m: 59, s: 59, f: 23),
            using: ._23_976,
            limit: ._24hours
        )
        
        XCTAssertThrowsError(try tc.subtract(.components(h: 23, m: 59, s: 59, f: 24))) // 1 frame too many
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 23, m: 59, s: 59, f: 23)) // unchanged value
        
        tc = try Timecode(
            .components(h: 00, m: 00, s: 00, f: 00),
            using: ._23_976,
            limit: ._24hours
        )
        
        try tc.add(.components(f: 24)) // roll up to 1 sec
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 00, m: 00, s: 01, f: 00))
        
        tc = try Timecode(
            .components(h: 00, m: 00, s: 00, f: 00),
            using: ._23_976,
            limit: ._24hours
        )
        
        try tc.add(.components(s: 60)) // roll up to 1 min
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 00, m: 01, s: 00, f: 00))
        
        tc = try Timecode(
            .components(h: 00, m: 00, s: 00, f: 00),
            using: ._23_976,
            limit: ._24hours
        )
        
        try tc.add(.components(m: 60)) // roll up to 1 hr
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 01, m: 00, s: 00, f: 00))
        
        tc = try Timecode(
            .components(d: 0, h: 00, m: 00, s: 00, f: 00),
            using: ._23_976,
            limit: ._100days
        )
        
        try tc.add(.components(h: 24)) // roll up to 1 day
        
        XCTAssertEqual(tc.components, Timecode.Components(d: 01, h: 00, m: 00, s: 00, f: 00))
        
        tc = try Timecode(
            .components(h: 00, m: 00, s: 00, f: 00),
            using: ._23_976,
            limit: ._24hours
        )
        
        try tc.add(.components(h: 00, m: 00, s: 00, f: 2_073_599))
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 23, m: 59, s: 59, f: 23))
        
        tc = try Timecode(
            .components(h: 23, m: 59, s: 59, f: 23),
            using: ._23_976,
            limit: ._24hours
        )
        
        try tc.subtract(.components(h: 00, m: 00, s: 00, f: 2_073_599))
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 00, m: 00, s: 00, f: 00))
        
        try tc.add(.components(h: 00, m: 00, s: 00, f: 200))
        
        try tc.subtract(.components(h: 00, m: 00, s: 00, f: 199))
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 00, m: 00, s: 00, f: 01))
        
        // clamping
        
        tc = try Timecode(
            .components(h: 00, m: 00, s: 00, f: 00),
            using: ._23_976,
            base: ._80SubFrames,
            limit: ._24hours
        )
        
        tc.add(clamping: Timecode.Components(h: 25))
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 23, m: 59, s: 59, f: 23, sf: 79))
        
        tc = try Timecode(
            .components(h: 00, m: 00, s: 00, f: 00),
            using: ._23_976,
            limit: ._24hours
        )
        
        tc.subtract(clamping: Timecode.Components(h: 4))
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 00, m: 00, s: 00, f: 00))
        
        // wrapping
        
        tc = try Timecode(
            .components(h: 00, m: 00, s: 00, f: 00),
            using: ._23_976,
            limit: ._24hours
        )
        
        tc.add(wrapping: Timecode.Components(h: 25))
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 01, m: 00, s: 00, f: 00))
        
        tc = try Timecode(
            .components(h: 00, m: 00, s: 00, f: 00),
            using: ._23_976,
            limit: ._24hours
        )
        
        tc.add(wrapping: Timecode.Components(f: -1)) // add negative number
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 23, m: 59, s: 59, f: 23))
        
        tc = try Timecode(
            .components(h: 00, m: 00, s: 00, f: 00),
            using: ._23_976,
            limit: ._24hours
        )
        
        tc.subtract(wrapping: Timecode.Components(h: 4))
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 20, m: 00, s: 00, f: 00))
        
        tc = try Timecode(
            .components(h: 00, m: 00, s: 00, f: 00),
            using: ._23_976,
            limit: ._24hours
        )
        
        tc.subtract(wrapping: Timecode.Components(h: -4)) // subtract negative number
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 04, m: 00, s: 00, f: 00))
        
        // drop rates
        
        tc = try Timecode(
            .components(h: 00, m: 00, s: 00, f: 00),
            using: ._29_97_drop,
            limit: ._24hours
        )
        
        try tc.add(.components(h: 00, m: 00, s: 00, f: 29))
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 00, m: 00, s: 00, f: 29))
        
        try tc.add(.components(h: 00, m: 00, s: 00, f: 01))
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 00, m: 00, s: 01, f: 00))
        
        tc = try Timecode(
            .components(h: 00, m: 00, s: 00, f: 00),
            using: ._29_97_drop,
            limit: ._24hours
        )
        
        try tc.add(.components(m: 60)) // roll up to 1 hr
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 01, m: 00, s: 00, f: 00))
        
        try tc = Timecode(
            .components(h: 00, m: 00, s: 00, f: 00),
            using: ._29_97_drop,
            limit: ._24hours
        )
        
        try tc.add(.components(f: 30)) // roll up to 1 sec
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 00, m: 00, s: 01, f: 00))
        
        try tc = Timecode(
            .components(h: 00, m: 00, s: 59, f: 00),
            using: ._29_97_drop,
            limit: ._24hours
        )
        
        // roll up to 1 sec and 2 frames (2 dropped frames every minute except every 10th minute)
        try tc.add(.components(f: 30))
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 00, m: 01, s: 00, f: 02))
        
        tc = try Timecode(
            .components(h: 00, m: 01, s: 00, f: 02),
            using: ._29_97_drop,
            limit: ._24hours
        )
        
        // roll up to 1 sec and 2 frames (2 dropped frames every minute except every 10th minute)
        try tc.add(.components(m: 01))
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 00, m: 02, s: 00, f: 02))
        
        try tc.add(.components(m: 08))
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 00, m: 10, s: 00, f: 00))
        
        // .adding()
        
        tc = try Timecode(
            .components(h: 00, m: 10, s: 00, f: 00),
            using: ._29_97_drop,
            limit: ._24hours
        )
        
        // exactly
        XCTAssertEqual(
            try tc.adding(Timecode.Components(h: 1)).components,
            Timecode.Components(h: 1, m: 10, s: 00, f: 00)
        )
        
        XCTAssertEqual(
            tc.adding(wrapping: Timecode.Components(h: 26)).components,
            Timecode.Components(h: 2, m: 10, s: 00, f: 00)
        )
        
        XCTAssertEqual(
            tc.adding(clamping: Timecode.Components(h: 26)).components,
            Timecode.Components(h: 23, m: 59, s: 59, f: 29, sf: tc.subFramesBase.rawValue - 1)
        )
        
        // .subtracting()
        
        tc = try Timecode(
            .components(h: 00, m: 10, s: 00, f: 00),
            using: ._29_97_drop,
            limit: ._24hours
        )
        
        // exactly
        XCTAssertEqual(
            try tc.subtracting(.components(m: 5)).components,
            Timecode.Components(h: 0, m: 05, s: 00, f: 02)
        ) // remember, we're using drop rate!
    }
    
    func testMultiply_and_Divide() throws {
        // .multiply / .divide methods
        
        var tc = try Timecode(
            .components(h: 01, m: 00, s: 00, f: 00),
            using: ._23_976,
            limit: ._24hours
        )
        try tc.multiply(2)
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 02, m: 00, s: 00, f: 00))
        
        tc = try Timecode(
            .components(h: 01, m: 00, s: 00, f: 00),
            using: ._23_976,
            limit: ._24hours
        )
        
        try tc.multiply(2.5)
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 02, m: 30, s: 00, f: 00))
        
        tc = try Timecode(
            .components(h: 01, m: 00, s: 00, f: 00),
            using: ._29_97_drop,
            limit: ._24hours
        )
        
        try tc.multiply(2)
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 02, m: 00, s: 00, f: 00))
        
        tc = try Timecode(
            .components(h: 01, m: 00, s: 00, f: 00),
            using: ._29_97_drop,
            limit: ._24hours
        )
        
        try tc.multiply(2.5)
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 02, m: 30, s: 00, f: 00))
        
        tc = try Timecode(
            .components(h: 01, m: 00, s: 00, f: 00),
            using: ._29_97_drop,
            limit: ._24hours
        )
        
        XCTAssertThrowsError(try tc.multiply(25))
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 01, m: 00, s: 00, f: 00)) // unchanged
        
        // clamping
        
        tc = try Timecode(
            .components(h: 01, m: 00, s: 00, f: 00),
            using: ._23_976,
            limit: ._24hours
        )
        
        tc.multiply(clamping: 25.0)
        
        XCTAssertEqual(
            tc.components,
            Timecode.Components(h: 23, m: 59, s: 59, f: 23, sf: tc.subFramesBase.rawValue - 1)
        )
        
        tc = try Timecode(
            .components(h: 00, m: 00, s: 00, f: 00),
            using: ._23_976,
            limit: ._24hours
        )
        
        tc.divide(clamping: 4)
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 00, m: 00, s: 00, f: 00))
        
        // wrapping - multiply
        
        tc = try Timecode(
            .components(h: 01, m: 00, s: 00, f: 00),
            using: ._23_976,
            limit: ._24hours
        )
        
        tc.multiply(wrapping: 25.0)
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 01, m: 00, s: 00, f: 00))
        
        tc = try Timecode(
            .components(h: 01, m: 00, s: 00, f: 00),
            using: ._23_976,
            limit: ._24hours
        )
        
        tc.multiply(wrapping: 2)
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 02, m: 00, s: 00, f: 00)) // normal, no wrap
        
        tc = try Timecode(
            .components(h: 01, m: 00, s: 00, f: 00),
            using: ._23_976,
            limit: ._24hours
        )
        
        tc.multiply(wrapping: 25)
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 01, m: 00, s: 00, f: 00)) // wraps
        
        // wrapping - divide
        
        tc = try Timecode(
            .components(h: 01, m: 00, s: 00, f: 00),
            using: ._23_976,
            limit: ._24hours
        )
        
        tc.divide(wrapping: -2)
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 23, m: 30, s: 00, f: 00))
        
        tc = try Timecode(
            .components(h: 01, m: 00, s: 00, f: 00),
            using: ._23_976,
            limit: ._24hours
        )
        
        tc.divide(wrapping: 2)
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 00, m: 30, s: 00, f: 00)) // normal, no wrap
        
        tc = try Timecode(
            .components(h: 12, m: 00, s: 00, f: 00),
            using: ._23_976,
            limit: ._24hours
        )
        
        tc.divide(wrapping: -2)
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 18, m: 00, s: 00, f: 00)) // wraps
        
        // .multiplying()
        
        tc = try Timecode(
            .components(h: 04, m: 00, s: 00, f: 00),
            using: ._23_976,
            limit: ._24hours
        )
        
        // exactly
        XCTAssertEqual(
            try tc.multiplying(2).components,
            Timecode.Components(h: 08, m: 00, s: 00, f: 00)
        )
        
        // .dividing()
        
        tc = try Timecode(
            .components(h: 04, m: 00, s: 00, f: 00),
            using: ._23_976,
            limit: ._24hours
        )
        
        // exactly
        XCTAssertEqual(
            try tc.dividing(2).components,
            Timecode.Components(h: 02, m: 00, s: 00, f: 00)
        )
    }
    
    func testOffset() throws {
        // mutating
        
        var tc = try Timecode(
            .components(h: 01, m: 00, s: 00, f: 00),
            using: ._23_976,
            limit: ._24hours
        )
        
        let intervalTC = try Timecode(
            .components(h: 00, m: 01, s: 00, f: 00),
            using: ._23_976,
            limit: ._24hours
        )
        
        tc.offset(by: .init(intervalTC, .plus))
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 01, m: 01, s: 00, f: 00))
        
        tc.offset(by: .init(intervalTC, .plus))
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 01, m: 02, s: 00, f: 00))
        
        tc.offset(by: .init(intervalTC, .minus))
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 01, m: 01, s: 00, f: 00))
        
        // non-mutating
        
        tc = try Timecode(
            .components(h: 01, m: 00, s: 00, f: 00),
            using: ._23_976,
            limit: ._24hours
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
            using: ._23_976,
            limit: ._24hours
        )
        
        let tc2 = try Timecode(
            .components(h: 01, m: 04, s: 37, f: 15),
            using: ._23_976,
            limit: ._24hours
        )
        
        // positive
        
        var interval = tc1.interval(to: tc2)
        
        XCTAssertEqual(interval.isNegative, false)
        XCTAssertEqual(
            interval.flattened(),
            try Timecode(
                .components(h: 00, m: 04, s: 37, f: 15),
                using: ._23_976,
                limit: ._24hours
            )
        )
        
        // negative
        
        interval = tc2.interval(to: tc1)
        
        XCTAssertEqual(interval.isNegative, true) // 23:55:22:09
        XCTAssertEqual(
            interval.absoluteInterval,
            try Timecode(
                .components(h: 00, m: 04, s: 37, f: 15),
                using: ._23_976,
                limit: ._24hours
            )
        )
        XCTAssertEqual(
            interval.flattened(),
            try Timecode(
                .components(h: 23, m: 55, s: 22, f: 09),
                using: ._23_976,
                limit: ._24hours
            )
        )
        
        // edge cases
        
        let tc3 = try Timecode(
            .components(d: 1, h: 03, m: 04, s: 37, f: 15),
            using: ._23_976,
            limit: ._100days
        )
        
        // positive, > 24 hours delta
        
        interval = tc1.interval(to: tc3)
        
        XCTAssertEqual(interval.isNegative, false)
        XCTAssertEqual(
            interval.absoluteInterval,
            try Timecode(
                .components(d: 1, h: 02, m: 04, s: 37, f: 15),
                using: ._23_976,
                limit: ._100days
            )
        )
        XCTAssertEqual(
            interval.flattened(),
            try Timecode(
                .components(h: 02, m: 04, s: 37, f: 15),
                using: ._23_976,
                limit: ._24hours
            )
        )
        
        // negative, > 24 hours delta, 100 days limit
        
        interval = tc3.interval(to: tc1)
        
        XCTAssertEqual(interval.isNegative, true)
        XCTAssertEqual(
            interval.absoluteInterval,
            try Timecode(
                .components(d: 1, h: 02, m: 04, s: 37, f: 15),
                using: ._23_976,
                limit: ._100days
            )
        )
        XCTAssertEqual(
            interval.flattened(),
            Timecode(
                .components(d: 98, h: 21, m: 55, s: 22, f: 09),
                using: ._23_976,
                limit: ._100days,
                by: .allowingInvalid
            )
        )
    }
    
    func testTimecodeInterval() throws {
        let interval = try Timecode(
            .components(h: 02, m: 04, s: 37, f: 15),
            using: ._24
        ).asInterval(.minus)
        
        XCTAssertEqual(
            interval.flattened().components,
            Timecode.Components(h: 21, m: 55, s: 22, f: 9)
        )
        XCTAssertEqual(interval.flattened().frameRate, ._24)
        XCTAssertTrue(interval.isNegative)
    }
}

#endif
