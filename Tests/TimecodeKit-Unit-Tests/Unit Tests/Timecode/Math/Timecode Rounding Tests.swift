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
            try Timecode(at: ._24).roundedUp(toNearest: .days)
                .components,
            TCC()
        )
        
        XCTAssertEqual(
            try Timecode(TCC(sf: 1), at: ._24, limit: ._100days).roundedUp(toNearest: .days)
                .components,
            TCC(d: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(f: 1), at: ._24, limit: ._100days).roundedUp(toNearest: .days)
                .components,
            TCC(d: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(s: 1), at: ._24, limit: ._100days).roundedUp(toNearest: .days)
                .components,
            TCC(d: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(m: 1), at: ._24, limit: ._100days).roundedUp(toNearest: .days)
                .components,
            TCC(d: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(h: 1), at: ._24, limit: ._100days).roundedUp(toNearest: .days)
                .components,
            TCC(d: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(m: 1, s: 1, f: 1, sf: 1), at: ._24, limit: ._100days)
                .roundedUp(toNearest: .days)
                .components,
            TCC(d: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(h: 1, m: 1, s: 1, f: 1, sf: 1), at: ._24, limit: ._100days)
                .roundedUp(toNearest: .days)
                .components,
            TCC(d: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(d: 1, h: 0, m: 1, s: 1, f: 1, sf: 1), at: ._24, limit: ._100days)
                .roundedUp(toNearest: .days)
                .components,
            TCC(d: 2)
        )
    }
    
    func testRoundedUp_hours() throws {
        XCTAssertEqual(
            try Timecode(at: ._24).roundedUp(toNearest: .hours)
                .components,
            TCC()
        )
        
        XCTAssertEqual(
            try Timecode(TCC(sf: 1), at: ._24).roundedUp(toNearest: .hours)
                .components,
            TCC(h: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(f: 1), at: ._24).roundedUp(toNearest: .hours)
                .components,
            TCC(h: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(s: 1), at: ._24).roundedUp(toNearest: .hours)
                .components,
            TCC(h: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(m: 1), at: ._24).roundedUp(toNearest: .hours)
                .components,
            TCC(h: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(h: 1), at: ._24).roundedUp(toNearest: .hours)
                .components,
            TCC(h: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(m: 1, s: 1, f: 1, sf: 1), at: ._24).roundedUp(toNearest: .hours)
                .components,
            TCC(h: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(d: 1, h: 0, m: 1, s: 1, f: 1, sf: 1), at: ._24, limit: ._100days)
                .roundedUp(toNearest: .hours)
                .components,
            TCC(d: 1, h: 1)
        )
    }
    
    func testRoundedUp_minutes() throws {
        XCTAssertEqual(
            try Timecode(at: ._24).roundedUp(toNearest: .minutes)
                .components,
            TCC()
        )
        
        XCTAssertEqual(
            try Timecode(TCC(sf: 1), at: ._24).roundedUp(toNearest: .minutes)
                .components,
            TCC(m: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(f: 1), at: ._24).roundedUp(toNearest: .minutes)
                .components,
            TCC(m: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(f: 1, sf: 1), at: ._24).roundedUp(toNearest: .minutes)
                .components,
            TCC(m: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(s: 2), at: ._24).roundedUp(toNearest: .minutes)
                .components,
            TCC(m: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(s: 2, sf: 1), at: ._24).roundedUp(toNearest: .minutes)
                .components,
            TCC(m: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(s: 2, f: 1), at: ._24).roundedUp(toNearest: .minutes)
                .components,
            TCC(m: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(s: 2, f: 1, sf: 1), at: ._24).roundedUp(toNearest: .minutes)
                .components,
            TCC(m: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(m: 1), at: ._24).roundedUp(toNearest: .minutes)
                .components,
            TCC(m: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(m: 1, sf: 1), at: ._24).roundedUp(toNearest: .minutes)
                .components,
            TCC(m: 2)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(m: 1, f: 1), at: ._24).roundedUp(toNearest: .minutes)
                .components,
            TCC(m: 2)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(m: 1, s: 1), at: ._24).roundedUp(toNearest: .minutes)
                .components,
            TCC(m: 2)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(h: 1), at: ._24).roundedUp(toNearest: .minutes)
                .components,
            TCC(h: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(h: 1, m: 1), at: ._24).roundedUp(toNearest: .minutes)
                .components,
            TCC(h: 1, m: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(h: 1, m: 1, f: 1), at: ._24).roundedUp(toNearest: .minutes)
                .components,
            TCC(h: 1, m: 2)
        )
    }
    
    func testRoundedUp_seconds() throws {
        XCTAssertEqual(
            try Timecode(at: ._24).roundedUp(toNearest: .seconds)
                .components,
            TCC()
        )
        
        XCTAssertEqual(
            try Timecode(TCC(sf: 1), at: ._24).roundedUp(toNearest: .seconds)
                .components,
            TCC(s: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(f: 1), at: ._24).roundedUp(toNearest: .seconds)
                .components,
            TCC(s: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(f: 1, sf: 1), at: ._24).roundedUp(toNearest: .seconds)
                .components,
            TCC(s: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(s: 2), at: ._24).roundedUp(toNearest: .seconds)
                .components,
            TCC(s: 2)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(s: 2, sf: 1), at: ._24).roundedUp(toNearest: .seconds)
                .components,
            TCC(s: 3)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(s: 2, f: 1), at: ._24).roundedUp(toNearest: .seconds)
                .components,
            TCC(s: 3)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(s: 2, f: 1, sf: 1), at: ._24).roundedUp(toNearest: .seconds)
                .components,
            TCC(s: 3)
        )
    }
    
    func testRoundedUp_frames() throws {
        XCTAssertEqual(
            try Timecode(at: ._24).roundedUp(toNearest: .frames)
                .components,
            TCC()
        )
        
        XCTAssertEqual(
            try Timecode(TCC(sf: 1), at: ._24).roundedUp(toNearest: .frames)
                .components,
            TCC(f: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(f: 1), at: ._24).roundedUp(toNearest: .frames)
                .components,
            TCC(f: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(f: 1, sf: 1), at: ._24).roundedUp(toNearest: .frames)
                .components,
            TCC(f: 2)
        )
    }
    
    func testRoundedUp_frames_EdgeCases() throws {
        XCTAssertEqual(
            try Timecode(TCC(h: 23, m: 59, s: 59, f: 23, sf: 0), at: ._24)
                .roundedUp(toNearest: .frames)
                .components,
            TCC(h: 23, m: 59, s: 59, f: 23, sf: 0)
        )
        
        // 'exactly' throws error because result would be 24:00:00:00
        XCTAssertThrowsError(
            try Timecode(TCC(h: 23, m: 59, s: 59, f: 23, sf: 1), at: ._24)
                .roundedUp(toNearest: .frames)
        )
    }
    
    func testRoundedUp_subFrames() throws {
        // subFrames has no effect
        
        XCTAssertEqual(
            try Timecode(at: ._24).roundedUp(toNearest: .subFrames)
                .components,
            TCC()
        )
        
        XCTAssertEqual(
            try Timecode(TCC(sf: 1), at: ._24).roundedUp(toNearest: .subFrames)
                .components,
            TCC(sf: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(f: 1), at: ._24).roundedUp(toNearest: .subFrames)
                .components,
            TCC(f: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(f: 1, sf: 1), at: ._24).roundedUp(toNearest: .subFrames)
                .components,
            TCC(f: 1, sf: 1)
        )
    }
    
    // MARK: - Rounding Down
    
    func testRoundedDown_days() throws {
        XCTAssertEqual(
            Timecode(at: ._24).roundedDown(toNearest: .days)
                .components,
            TCC()
        )
        
        XCTAssertEqual(
            try Timecode(TCC(sf: 1), at: ._24, limit: ._100days).roundedDown(toNearest: .days)
                .components,
            TCC(d: 0)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(f: 1), at: ._24, limit: ._100days).roundedDown(toNearest: .days)
                .components,
            TCC(d: 0)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(s: 1), at: ._24, limit: ._100days).roundedDown(toNearest: .days)
                .components,
            TCC(d: 0)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(m: 1), at: ._24, limit: ._100days).roundedDown(toNearest: .days)
                .components,
            TCC(d: 0)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(h: 1), at: ._24, limit: ._100days).roundedDown(toNearest: .days)
                .components,
            TCC(d: 0)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(m: 1, s: 1, f: 1, sf: 1), at: ._24, limit: ._100days)
                .roundedDown(toNearest: .days)
                .components,
            TCC(d: 0)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(h: 1, m: 1, s: 1, f: 1, sf: 1), at: ._24, limit: ._100days)
                .roundedDown(toNearest: .days)
                .components,
            TCC(d: 0)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(d: 1), at: ._24, limit: ._100days).roundedDown(toNearest: .days)
                .components,
            TCC(d: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(d: 1, h: 0, m: 1, s: 1, f: 1, sf: 1), at: ._24, limit: ._100days)
                .roundedDown(toNearest: .days)
                .components,
            TCC(d: 1)
        )
    }
    
    func testRoundedDown_hours() throws {
        XCTAssertEqual(
            Timecode(at: ._24).roundedDown(toNearest: .hours)
                .components,
            TCC()
        )
        
        XCTAssertEqual(
            try Timecode(TCC(sf: 1), at: ._24).roundedDown(toNearest: .hours)
                .components,
            TCC(h: 0)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(f: 1), at: ._24).roundedDown(toNearest: .hours)
                .components,
            TCC(h: 0)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(s: 1), at: ._24).roundedDown(toNearest: .hours)
                .components,
            TCC(h: 0)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(m: 1), at: ._24).roundedDown(toNearest: .hours)
                .components,
            TCC(h: 0)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(h: 1), at: ._24).roundedDown(toNearest: .hours)
                .components,
            TCC(h: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(m: 1, s: 1, f: 1, sf: 1), at: ._24).roundedDown(toNearest: .hours)
                .components,
            TCC(h: 0)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(d: 1, h: 0, m: 1, s: 1, f: 1, sf: 1), at: ._24, limit: ._100days)
                .roundedDown(toNearest: .hours)
                .components,
            TCC(d: 1, h: 0)
        )
    }
    
    func testRoundedDown_minutes() throws {
        XCTAssertEqual(
            Timecode(at: ._24).roundedDown(toNearest: .minutes)
                .components,
            TCC()
        )
        
        XCTAssertEqual(
            try Timecode(TCC(sf: 1), at: ._24).roundedDown(toNearest: .minutes)
                .components,
            TCC(m: 0)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(f: 1), at: ._24).roundedDown(toNearest: .minutes)
                .components,
            TCC(m: 0)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(f: 1, sf: 1), at: ._24).roundedDown(toNearest: .minutes)
                .components,
            TCC(m: 0)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(s: 2), at: ._24).roundedDown(toNearest: .minutes)
                .components,
            TCC(m: 0)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(s: 2, sf: 1), at: ._24).roundedDown(toNearest: .minutes)
                .components,
            TCC(m: 0)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(s: 2, f: 1), at: ._24).roundedDown(toNearest: .minutes)
                .components,
            TCC(m: 0)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(s: 2, f: 1, sf: 1), at: ._24).roundedDown(toNearest: .minutes)
                .components,
            TCC(m: 0)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(m: 1), at: ._24).roundedDown(toNearest: .minutes)
                .components,
            TCC(m: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(m: 1, sf: 1), at: ._24).roundedDown(toNearest: .minutes)
                .components,
            TCC(m: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(m: 1, f: 1), at: ._24).roundedDown(toNearest: .minutes)
                .components,
            TCC(m: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(m: 1, s: 1), at: ._24).roundedDown(toNearest: .minutes)
                .components,
            TCC(m: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(h: 1), at: ._24).roundedDown(toNearest: .minutes)
                .components,
            TCC(h: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(h: 1, m: 1), at: ._24).roundedDown(toNearest: .minutes)
                .components,
            TCC(h: 1, m: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(h: 1, m: 1, f: 1), at: ._24).roundedDown(toNearest: .minutes)
                .components,
            TCC(h: 1, m: 1)
        )
    }
    
    func testRoundedDown_seconds() throws {
        XCTAssertEqual(
            Timecode(at: ._24).roundedDown(toNearest: .seconds)
                .components,
            TCC()
        )
        
        XCTAssertEqual(
            try Timecode(TCC(sf: 1), at: ._24).roundedDown(toNearest: .seconds)
                .components,
            TCC(s: 0)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(f: 1), at: ._24).roundedDown(toNearest: .seconds)
                .components,
            TCC(s: 0)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(f: 1, sf: 1), at: ._24).roundedDown(toNearest: .seconds)
                .components,
            TCC(s: 0)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(s: 2), at: ._24).roundedDown(toNearest: .seconds)
                .components,
            TCC(s: 2)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(s: 2, sf: 1), at: ._24).roundedDown(toNearest: .seconds)
                .components,
            TCC(s: 2)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(s: 2, f: 1), at: ._24).roundedDown(toNearest: .seconds)
                .components,
            TCC(s: 2)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(s: 2, f: 1, sf: 1), at: ._24).roundedDown(toNearest: .seconds)
                .components,
            TCC(s: 2)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(h: 1, s: 2, f: 1, sf: 1), at: ._24).roundedDown(toNearest: .seconds)
                .components,
            TCC(h: 1, s: 2)
        )
    }
    
    func testRoundedDown_frames() throws {
        XCTAssertEqual(
            Timecode(at: ._23_976).roundedDown(toNearest: .frames)
                .components,
            TCC()
        )
        
        XCTAssertEqual(
            try Timecode(TCC(sf: 1), at: ._23_976).roundedDown(toNearest: .frames)
                .components,
            TCC()
        )
        
        XCTAssertEqual(
            try Timecode(TCC(f: 1), at: ._23_976).roundedDown(toNearest: .frames)
                .components,
            TCC(f: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(f: 1, sf: 1), at: ._23_976).roundedDown(toNearest: .frames)
                .components,
            TCC(f: 1)
        )
    }
    
    func testRoundedDown_subFrames() throws {
        // subFrames has no effect
        
        XCTAssertEqual(
            Timecode(at: ._23_976).roundedDown(toNearest: .subFrames)
                .components,
            TCC()
        )
        
        XCTAssertEqual(
            try Timecode(TCC(sf: 1), at: ._23_976).roundedDown(toNearest: .subFrames)
                .components,
            TCC(sf: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(f: 1), at: ._23_976).roundedDown(toNearest: .subFrames)
                .components,
            TCC(f: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(f: 1, sf: 1), at: ._23_976).roundedDown(toNearest: .subFrames)
                .components,
            TCC(f: 1, sf: 1)
        )
    }
}

#endif
