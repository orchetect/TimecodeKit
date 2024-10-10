//
//  Strideable Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import TimecodeKit // do NOT import as @testable in this file
import XCTest

final class Timecode_Strideable_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testAdvancedBy() throws {
        for item in TimecodeFrameRate.allCases {
            let frames = Timecode.frameCount(of: Timecode.Components(h: 1), at: item).wholeFrames
            
            let advanced = try Timecode(.components(f: 00), at: item)
                .advanced(by: frames)
                .components
            
            XCTAssertEqual(advanced, Timecode.Components(h: 1), "for \(item)")
        }
    }
    
    func testDistanceTo_24Hours() throws {
        // 24 hours stride frame count test
        
        for item in TimecodeFrameRate.allCases {
            let zero = Timecode(.zero, at: item)
            
            let target = try Timecode(
                .components(d: 00, h: 23, m: 59, s: 59, f: item.maxFrameNumberDisplayable),
                at: item
            )
            
            let delta = zero.distance(to: target)
            
            XCTAssertEqual(delta, item.maxTotalFramesExpressible(in: .max24Hours), "for \(item)")
        }
    }
    
    func testDistanceTo_100Days() throws {
        // 100 days stride frame count test
        
        for item in TimecodeFrameRate.allCases {
            let zero = Timecode(.zero, at: item, limit: .max100Days)
            
            let target = try Timecode(
                .components(d: 99, h: 23, m: 59, s: 59, f: item.maxFrameNumberDisplayable),
                at: item,
                limit: .max100Days
            )
            
            let delta = zero.distance(to: target)
            
            XCTAssertEqual(delta, item.maxTotalFramesExpressible(in: .max100Days), "for \(item)")
        }
    }
    
    // MARK: Integration Tests
    
    func testTimecode_Strideable_Ranges() throws {
        // Stride through & array
        
        let strideThrough = try stride(
            from: Timecode(.string("01:00:00:00"), at: .fps23_976),
            through: Timecode(.string("01:00:00:06"), at: .fps23_976),
            by: 2
        )
        var array = Array(strideThrough)
        
        XCTAssertEqual(array.count, 4)
        XCTAssertEqual(
            array,
            try [
                Timecode(.string("01:00:00:00"), at: .fps23_976),
                Timecode(.string("01:00:00:02"), at: .fps23_976),
                Timecode(.string("01:00:00:04"), at: .fps23_976),
                Timecode(.string("01:00:00:06"), at: .fps23_976)
            ]
        )
        
        // Stride to
        let strideTo = try stride(
            from: Timecode(.string("01:00:00:00"), at: .fps23_976),
            to: Timecode(.string("01:00:00:06"), at: .fps23_976),
            by: 2
        )
        array = Array(strideTo)
        
        XCTAssertEqual(array.count, 3)
        XCTAssertEqual(
            array,
            try [
                Timecode(.string("01:00:00:00"), at: .fps23_976),
                Timecode(.string("01:00:00:02"), at: .fps23_976),
                Timecode(.string("01:00:00:04"), at: .fps23_976)
            ]
        )
        
        // Strideable
        
        XCTAssertEqual(
            try Timecode(.string("01:00:00:00"), at: .fps23_976)
                .advanced(by: 6),
            try Timecode(.string("01:00:00:06"), at: .fps23_976)
        )
        
        XCTAssertEqual(
            try Timecode(.string("01:00:00:00"), at: .fps23_976)
                .distance(to: Timecode(.string("02:00:00:00"), at: .fps23_976)),
            try Timecode(.string("01:00:00:00"), at: .fps23_976).frameCount.wholeFrames
        )
        
        let strs = try Array(
            stride(
                from: Timecode(.string("01:00:00:05"), at: .fps23_976),
                through: Timecode(.string("01:00:10:05"), at: .fps23_976),
                by: Timecode(.components(s: 1), at: .fps23_976).frameCount.wholeFrames
            )
        )
        .map { $0.stringValue() }
        
        XCTAssertEqual(strs.count, 11)
        
        let strs2 = try Array(
            stride(
                from: Timecode(.string("01:00:00:05"), at: .fps23_976),
                to: Timecode(.string("01:00:10:07"), at: .fps23_976),
                by: Timecode(.components(s: 1), at: .fps23_976).frameCount.wholeFrames
            )
        )
        .map { $0.stringValue() }
        
        XCTAssertEqual(strs2.count, 11)
        
        // Strideable with drop rates
        
        // TODO: add Strideable drop rates tests
        
        // Range .contains
        
        XCTAssertTrue(
            try (
                Timecode(.string("01:00:00:00"), at: .fps23_976)
                    ... Timecode(.string("01:00:00:06"), at: .fps23_976)
            )
            .contains(Timecode(.string("01:00:00:02"), at: .fps23_976))
        )
        XCTAssertFalse(
            try (
                Timecode(.string("01:00:00:00"), at: .fps23_976)
                    ... Timecode(.string("01:00:00:06"), at: .fps23_976)
            )
            .contains(Timecode(.string("01:00:00:10"), at: .fps23_976))
        )
        XCTAssertTrue(
            try (Timecode(.string("01:00:00:00"), at: .fps23_976)...)
                .contains(Timecode(.string("01:00:00:02"), at: .fps23_976))
        )
        XCTAssertTrue(
            try (...Timecode(.string("01:00:00:06"), at: .fps23_976))
                .contains(Timecode(.string("01:00:00:02"), at: .fps23_976))
        )
        
        // (same tests, but with ~= operator instead of .contains(...) which should produce the same result)
        
        XCTAssertTrue(
            try (
                Timecode(.string("01:00:00:00"), at: .fps23_976)
                    ... Timecode(.string("01:00:00:06"), at: .fps23_976)
            )
                ~= Timecode(.string("01:00:00:02"), at: .fps23_976)
        )
        XCTAssertFalse(
            try Timecode(.string("01:00:00:00"), at: .fps23_976) ... Timecode(.string("01:00:00:06"), at: .fps23_976)
                ~= Timecode(.string("01:00:00:10"), at: .fps23_976)
        )
        XCTAssertTrue(
            try Timecode(.string("01:00:00:00"), at: .fps23_976)...
                ~= Timecode(.string("01:00:00:02"), at: .fps23_976)
        )
        XCTAssertTrue(
            try ...Timecode(.string("01:00:00:06"), at: .fps23_976)
                ~= Timecode(.string("01:00:00:02"), at: .fps23_976)
        )
    }
}
