//
//  Timecode Rounding Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import TimecodeKit

class Timecode_Rounding_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    // MARK: - Rounding Up
    
    func testRoundedUp_days() throws {
        XCTAssertEqual(
            try Timecode(.zero, using: ._24)
                .roundedUp(toNearest: .days)
                .components,
            Timecode.Components()
        )
        
        XCTAssertEqual(
            try Timecode(.components(sf: 1), using: .init(rate: ._24, limit: ._100days))
                .roundedUp(toNearest: .days)
                .components,
            Timecode.Components(d: 1)
        )
        
        XCTAssertEqual(
            try Timecode(.components(f: 1), using: .init(rate: ._24, limit: ._100days))
                .roundedUp(toNearest: .days)
                .components,
            Timecode.Components(d: 1)
        )
        
        XCTAssertEqual(
            try Timecode(.components(s: 1), using: .init(rate: ._24, limit: ._100days))
                .roundedUp(toNearest: .days)
                .components,
            Timecode.Components(d: 1)
        )
        
        XCTAssertEqual(
            try Timecode(.components(m: 1), using: .init(rate: ._24, limit: ._100days))
                .roundedUp(toNearest: .days)
                .components,
            Timecode.Components(d: 1)
        )
        
        XCTAssertEqual(
            try Timecode(.components(h: 1), using: .init(rate: ._24, limit: ._100days))
                .roundedUp(toNearest: .days)
                .components,
            Timecode.Components(d: 1)
        )
        
        XCTAssertEqual(
            try Timecode(.components(m: 1, s: 1, f: 1, sf: 1), using: .init(rate: ._24, limit: ._100days))
                .roundedUp(toNearest: .days)
                .components,
            Timecode.Components(d: 1)
        )
        
        XCTAssertEqual(
            try Timecode(.components(h: 1, m: 1, s: 1, f: 1, sf: 1), using: .init(rate: ._24, limit: ._100days))
                .roundedUp(toNearest: .days)
                .components,
            Timecode.Components(d: 1)
        )
        
        XCTAssertEqual(
            try Timecode(.components(d: 1, h: 0, m: 1, s: 1, f: 1, sf: 1), using: .init(rate: ._24, limit: ._100days))
                .roundedUp(toNearest: .days)
                .components,
            Timecode.Components(d: 2)
        )
    }
    
    func testRoundedUp_hours() throws {
        XCTAssertEqual(
            try Timecode(.zero, using: ._24)
                .roundedUp(toNearest: .hours)
                .components,
            Timecode.Components()
        )
        
        XCTAssertEqual(
            try Timecode(.components(sf: 1), using: ._24).roundedUp(toNearest: .hours)
                .components,
            Timecode.Components(h: 1)
        )
        
        XCTAssertEqual(
            try Timecode(.components(f: 1), using: ._24).roundedUp(toNearest: .hours)
                .components,
            Timecode.Components(h: 1)
        )
        
        XCTAssertEqual(
            try Timecode(.components(s: 1), using: ._24).roundedUp(toNearest: .hours)
                .components,
            Timecode.Components(h: 1)
        )
        
        XCTAssertEqual(
            try Timecode(.components(m: 1), using: ._24).roundedUp(toNearest: .hours)
                .components,
            Timecode.Components(h: 1)
        )
        
        XCTAssertEqual(
            try Timecode(.components(h: 1), using: ._24).roundedUp(toNearest: .hours)
                .components,
            Timecode.Components(h: 1)
        )
        
        XCTAssertEqual(
            try Timecode(.components(m: 1, s: 1, f: 1, sf: 1), using: ._24).roundedUp(toNearest: .hours)
                .components,
            Timecode.Components(h: 1)
        )
        
        XCTAssertEqual(
            try Timecode(.components(d: 1, h: 0, m: 1, s: 1, f: 1, sf: 1), using: .init(rate: ._24, limit: ._100days))
                .roundedUp(toNearest: .hours)
                .components,
            Timecode.Components(d: 1, h: 1)
        )
    }
    
    func testRoundedUp_minutes() throws {
        XCTAssertEqual(
            try Timecode(.zero, using: ._24)
                .roundedUp(toNearest: .minutes)
                .components,
            Timecode.Components()
        )
        
        XCTAssertEqual(
            try Timecode(.components(sf: 1), using: ._24).roundedUp(toNearest: .minutes)
                .components,
            Timecode.Components(m: 1)
        )
        
        XCTAssertEqual(
            try Timecode(.components(f: 1), using: ._24).roundedUp(toNearest: .minutes)
                .components,
            Timecode.Components(m: 1)
        )
        
        XCTAssertEqual(
            try Timecode(.components(f: 1, sf: 1), using: ._24).roundedUp(toNearest: .minutes)
                .components,
            Timecode.Components(m: 1)
        )
        
        XCTAssertEqual(
            try Timecode(.components(s: 2), using: ._24).roundedUp(toNearest: .minutes)
                .components,
            Timecode.Components(m: 1)
        )
        
        XCTAssertEqual(
            try Timecode(.components(s: 2, sf: 1), using: ._24).roundedUp(toNearest: .minutes)
                .components,
            Timecode.Components(m: 1)
        )
        
        XCTAssertEqual(
            try Timecode(.components(s: 2, f: 1), using: ._24).roundedUp(toNearest: .minutes)
                .components,
            Timecode.Components(m: 1)
        )
        
        XCTAssertEqual(
            try Timecode(.components(s: 2, f: 1, sf: 1), using: ._24).roundedUp(toNearest: .minutes)
                .components,
            Timecode.Components(m: 1)
        )
        
        XCTAssertEqual(
            try Timecode(.components(m: 1), using: ._24).roundedUp(toNearest: .minutes)
                .components,
            Timecode.Components(m: 1)
        )
        
        XCTAssertEqual(
            try Timecode(.components(m: 1, sf: 1), using: ._24).roundedUp(toNearest: .minutes)
                .components,
            Timecode.Components(m: 2)
        )
        
        XCTAssertEqual(
            try Timecode(.components(m: 1, f: 1), using: ._24).roundedUp(toNearest: .minutes)
                .components,
            Timecode.Components(m: 2)
        )
        
        XCTAssertEqual(
            try Timecode(.components(m: 1, s: 1), using: ._24).roundedUp(toNearest: .minutes)
                .components,
            Timecode.Components(m: 2)
        )
        
        XCTAssertEqual(
            try Timecode(.components(h: 1), using: ._24).roundedUp(toNearest: .minutes)
                .components,
            Timecode.Components(h: 1)
        )
        
        XCTAssertEqual(
            try Timecode(.components(h: 1, m: 1), using: ._24).roundedUp(toNearest: .minutes)
                .components,
            Timecode.Components(h: 1, m: 1)
        )
        
        XCTAssertEqual(
            try Timecode(.components(h: 1, m: 1, f: 1), using: ._24).roundedUp(toNearest: .minutes)
                .components,
            Timecode.Components(h: 1, m: 2)
        )
    }
    
    func testRoundedUp_seconds() throws {
        XCTAssertEqual(
            try Timecode(.zero, using: ._24).roundedUp(toNearest: .seconds)
                .components,
            Timecode.Components()
        )
        
        XCTAssertEqual(
            try Timecode(.components(sf: 1), using: ._24).roundedUp(toNearest: .seconds)
                .components,
            Timecode.Components(s: 1)
        )
        
        XCTAssertEqual(
            try Timecode(.components(f: 1), using: ._24).roundedUp(toNearest: .seconds)
                .components,
            Timecode.Components(s: 1)
        )
        
        XCTAssertEqual(
            try Timecode(.components(f: 1, sf: 1), using: ._24).roundedUp(toNearest: .seconds)
                .components,
            Timecode.Components(s: 1)
        )
        
        XCTAssertEqual(
            try Timecode(.components(s: 2), using: ._24).roundedUp(toNearest: .seconds)
                .components,
            Timecode.Components(s: 2)
        )
        
        XCTAssertEqual(
            try Timecode(.components(s: 2, sf: 1), using: ._24).roundedUp(toNearest: .seconds)
                .components,
            Timecode.Components(s: 3)
        )
        
        XCTAssertEqual(
            try Timecode(.components(s: 2, f: 1), using: ._24).roundedUp(toNearest: .seconds)
                .components,
            Timecode.Components(s: 3)
        )
        
        XCTAssertEqual(
            try Timecode(.components(s: 2, f: 1, sf: 1), using: ._24).roundedUp(toNearest: .seconds)
                .components,
            Timecode.Components(s: 3)
        )
    }
    
    func testRoundedUp_frames() throws {
        XCTAssertEqual(
            try Timecode(.zero, using: ._24).roundedUp(toNearest: .frames)
                .components,
            Timecode.Components()
        )
        
        XCTAssertEqual(
            try Timecode(.components(sf: 1), using: ._24).roundedUp(toNearest: .frames)
                .components,
            Timecode.Components(f: 1)
        )
        
        XCTAssertEqual(
            try Timecode(.components(f: 1), using: ._24).roundedUp(toNearest: .frames)
                .components,
            Timecode.Components(f: 1)
        )
        
        XCTAssertEqual(
            try Timecode(.components(f: 1, sf: 1), using: ._24).roundedUp(toNearest: .frames)
                .components,
            Timecode.Components(f: 2)
        )
    }
    
    func testRoundedUp_frames_EdgeCases() throws {
        XCTAssertEqual(
            try Timecode(.components(h: 23, m: 59, s: 59, f: 23, sf: 0), using: ._24)
                .roundedUp(toNearest: .frames)
                .components,
            Timecode.Components(h: 23, m: 59, s: 59, f: 23, sf: 0)
        )
        
        // 'exactly' throws error because result would be 24:00:00:00
        XCTAssertThrowsError(
            try Timecode(.components(h: 23, m: 59, s: 59, f: 23, sf: 1), using: ._24)
                .roundedUp(toNearest: .frames)
        )
    }
    
    func testRoundedUp_subFrames() throws {
        // subFrames has no effect
        
        XCTAssertEqual(
            try Timecode(.zero, using: ._24).roundedUp(toNearest: .subFrames)
                .components,
            Timecode.Components()
        )
        
        XCTAssertEqual(
            try Timecode(.components(sf: 1), using: ._24).roundedUp(toNearest: .subFrames)
                .components,
            Timecode.Components(sf: 1)
        )
        
        XCTAssertEqual(
            try Timecode(.components(f: 1), using: ._24).roundedUp(toNearest: .subFrames)
                .components,
            Timecode.Components(f: 1)
        )
        
        XCTAssertEqual(
            try Timecode(.components(f: 1, sf: 1), using: ._24).roundedUp(toNearest: .subFrames)
                .components,
            Timecode.Components(f: 1, sf: 1)
        )
    }
    
    // MARK: - Rounding Down
    
    func testRoundedDown_days() throws {
        XCTAssertEqual(
            Timecode(.zero, using: ._24).roundedDown(toNearest: .days)
                .components,
            Timecode.Components()
        )
        
        XCTAssertEqual(
            try Timecode(.components(sf: 1), using: .init(rate: ._24, limit: ._100days))
                .roundedDown(toNearest: .days)
                .components,
            Timecode.Components(d: 0)
        )
        
        XCTAssertEqual(
            try Timecode(.components(f: 1), using: .init(rate: ._24, limit: ._100days))
                .roundedDown(toNearest: .days)
                .components,
            Timecode.Components(d: 0)
        )
        
        XCTAssertEqual(
            try Timecode(.components(s: 1), using: .init(rate: ._24, limit: ._100days))
                .roundedDown(toNearest: .days)
                .components,
            Timecode.Components(d: 0)
        )
        
        XCTAssertEqual(
            try Timecode(.components(m: 1), using: .init(rate: ._24, limit: ._100days))
                .roundedDown(toNearest: .days)
                .components,
            Timecode.Components(d: 0)
        )
        
        XCTAssertEqual(
            try Timecode(.components(h: 1), using: .init(rate: ._24, limit: ._100days))
                .roundedDown(toNearest: .days)
                .components,
            Timecode.Components(d: 0)
        )
        
        XCTAssertEqual(
            try Timecode(.components(m: 1, s: 1, f: 1, sf: 1), using: .init(rate: ._24, limit: ._100days))
                .roundedDown(toNearest: .days)
                .components,
            Timecode.Components(d: 0)
        )
        
        XCTAssertEqual(
            try Timecode(.components(h: 1, m: 1, s: 1, f: 1, sf: 1), using: .init(rate: ._24, limit: ._100days))
                .roundedDown(toNearest: .days)
                .components,
            Timecode.Components(d: 0)
        )
        
        XCTAssertEqual(
            try Timecode(.components(d: 1), using: .init(rate: ._24, limit: ._100days))
                .roundedDown(toNearest: .days)
                .components,
            Timecode.Components(d: 1)
        )
        
        XCTAssertEqual(
            try Timecode(.components(d: 1, h: 0, m: 1, s: 1, f: 1, sf: 1), using: .init(rate: ._24, limit: ._100days))
                .roundedDown(toNearest: .days)
                .components,
            Timecode.Components(d: 1)
        )
    }
    
    func testRoundedDown_hours() throws {
        XCTAssertEqual(
            Timecode(.zero, using: ._24).roundedDown(toNearest: .hours)
                .components,
            Timecode.Components()
        )
        
        XCTAssertEqual(
            try Timecode(.components(sf: 1), using: ._24).roundedDown(toNearest: .hours)
                .components,
            Timecode.Components(h: 0)
        )
        
        XCTAssertEqual(
            try Timecode(.components(f: 1), using: ._24).roundedDown(toNearest: .hours)
                .components,
            Timecode.Components(h: 0)
        )
        
        XCTAssertEqual(
            try Timecode(.components(s: 1), using: ._24).roundedDown(toNearest: .hours)
                .components,
            Timecode.Components(h: 0)
        )
        
        XCTAssertEqual(
            try Timecode(.components(m: 1), using: ._24).roundedDown(toNearest: .hours)
                .components,
            Timecode.Components(h: 0)
        )
        
        XCTAssertEqual(
            try Timecode(.components(h: 1), using: ._24).roundedDown(toNearest: .hours)
                .components,
            Timecode.Components(h: 1)
        )
        
        XCTAssertEqual(
            try Timecode(.components(m: 1, s: 1, f: 1, sf: 1), using: ._24).roundedDown(toNearest: .hours)
                .components,
            Timecode.Components(h: 0)
        )
        
        XCTAssertEqual(
            try Timecode(.components(d: 1, h: 0, m: 1, s: 1, f: 1, sf: 1), using: .init(rate: ._24, limit: ._100days))
                .roundedDown(toNearest: .hours)
                .components,
            Timecode.Components(d: 1, h: 0)
        )
    }
    
    func testRoundedDown_minutes() throws {
        XCTAssertEqual(
            Timecode(.zero, using: ._24)
                .roundedDown(toNearest: .minutes)
                .components,
            Timecode.Components()
        )
        
        XCTAssertEqual(
            try Timecode(.components(sf: 1), using: ._24).roundedDown(toNearest: .minutes)
                .components,
            Timecode.Components(m: 0)
        )
        
        XCTAssertEqual(
            try Timecode(.components(f: 1), using: ._24).roundedDown(toNearest: .minutes)
                .components,
            Timecode.Components(m: 0)
        )
        
        XCTAssertEqual(
            try Timecode(.components(f: 1, sf: 1), using: ._24).roundedDown(toNearest: .minutes)
                .components,
            Timecode.Components(m: 0)
        )
        
        XCTAssertEqual(
            try Timecode(.components(s: 2), using: ._24).roundedDown(toNearest: .minutes)
                .components,
            Timecode.Components(m: 0)
        )
        
        XCTAssertEqual(
            try Timecode(.components(s: 2, sf: 1), using: ._24).roundedDown(toNearest: .minutes)
                .components,
            Timecode.Components(m: 0)
        )
        
        XCTAssertEqual(
            try Timecode(.components(s: 2, f: 1), using: ._24).roundedDown(toNearest: .minutes)
                .components,
            Timecode.Components(m: 0)
        )
        
        XCTAssertEqual(
            try Timecode(.components(s: 2, f: 1, sf: 1), using: ._24).roundedDown(toNearest: .minutes)
                .components,
            Timecode.Components(m: 0)
        )
        
        XCTAssertEqual(
            try Timecode(.components(m: 1), using: ._24).roundedDown(toNearest: .minutes)
                .components,
            Timecode.Components(m: 1)
        )
        
        XCTAssertEqual(
            try Timecode(.components(m: 1, sf: 1), using: ._24).roundedDown(toNearest: .minutes)
                .components,
            Timecode.Components(m: 1)
        )
        
        XCTAssertEqual(
            try Timecode(.components(m: 1, f: 1), using: ._24).roundedDown(toNearest: .minutes)
                .components,
            Timecode.Components(m: 1)
        )
        
        XCTAssertEqual(
            try Timecode(.components(m: 1, s: 1), using: ._24).roundedDown(toNearest: .minutes)
                .components,
            Timecode.Components(m: 1)
        )
        
        XCTAssertEqual(
            try Timecode(.components(h: 1), using: ._24).roundedDown(toNearest: .minutes)
                .components,
            Timecode.Components(h: 1)
        )
        
        XCTAssertEqual(
            try Timecode(.components(h: 1, m: 1), using: ._24).roundedDown(toNearest: .minutes)
                .components,
            Timecode.Components(h: 1, m: 1)
        )
        
        XCTAssertEqual(
            try Timecode(.components(h: 1, m: 1, f: 1), using: ._24).roundedDown(toNearest: .minutes)
                .components,
            Timecode.Components(h: 1, m: 1)
        )
    }
    
    func testRoundedDown_seconds() throws {
        XCTAssertEqual(
            Timecode(.zero, using: ._24).roundedDown(toNearest: .seconds)
                .components,
            Timecode.Components()
        )
        
        XCTAssertEqual(
            try Timecode(.components(sf: 1), using: ._24).roundedDown(toNearest: .seconds)
                .components,
            Timecode.Components(s: 0)
        )
        
        XCTAssertEqual(
            try Timecode(.components(f: 1), using: ._24).roundedDown(toNearest: .seconds)
                .components,
            Timecode.Components(s: 0)
        )
        
        XCTAssertEqual(
            try Timecode(.components(f: 1, sf: 1), using: ._24).roundedDown(toNearest: .seconds)
                .components,
            Timecode.Components(s: 0)
        )
        
        XCTAssertEqual(
            try Timecode(.components(s: 2), using: ._24).roundedDown(toNearest: .seconds)
                .components,
            Timecode.Components(s: 2)
        )
        
        XCTAssertEqual(
            try Timecode(.components(s: 2, sf: 1), using: ._24).roundedDown(toNearest: .seconds)
                .components,
            Timecode.Components(s: 2)
        )
        
        XCTAssertEqual(
            try Timecode(.components(s: 2, f: 1), using: ._24).roundedDown(toNearest: .seconds)
                .components,
            Timecode.Components(s: 2)
        )
        
        XCTAssertEqual(
            try Timecode(.components(s: 2, f: 1, sf: 1), using: ._24).roundedDown(toNearest: .seconds)
                .components,
            Timecode.Components(s: 2)
        )
        
        XCTAssertEqual(
            try Timecode(.components(h: 1, s: 2, f: 1, sf: 1), using: ._24).roundedDown(toNearest: .seconds)
                .components,
            Timecode.Components(h: 1, s: 2)
        )
    }
    
    func testRoundedDown_frames() throws {
        XCTAssertEqual(
            Timecode(.zero, using: ._23_976).roundedDown(toNearest: .frames)
                .components,
            Timecode.Components()
        )
        
        XCTAssertEqual(
            try Timecode(.components(sf: 1), using: ._23_976).roundedDown(toNearest: .frames)
                .components,
            Timecode.Components()
        )
        
        XCTAssertEqual(
            try Timecode(.components(f: 1), using: ._23_976).roundedDown(toNearest: .frames)
                .components,
            Timecode.Components(f: 1)
        )
        
        XCTAssertEqual(
            try Timecode(.components(f: 1, sf: 1), using: ._23_976).roundedDown(toNearest: .frames)
                .components,
            Timecode.Components(f: 1)
        )
    }
    
    func testRoundedDown_subFrames() throws {
        // subFrames has no effect
        
        XCTAssertEqual(
            Timecode(.zero, using: ._23_976).roundedDown(toNearest: .subFrames)
                .components,
            Timecode.Components()
        )
        
        XCTAssertEqual(
            try Timecode(.components(sf: 1), using: ._23_976).roundedDown(toNearest: .subFrames)
                .components,
            Timecode.Components(sf: 1)
        )
        
        XCTAssertEqual(
            try Timecode(.components(f: 1), using: ._23_976).roundedDown(toNearest: .subFrames)
                .components,
            Timecode.Components(f: 1)
        )
        
        XCTAssertEqual(
            try Timecode(.components(f: 1, sf: 1), using: ._23_976).roundedDown(toNearest: .subFrames)
                .components,
            Timecode.Components(f: 1, sf: 1)
        )
    }
}

#endif
