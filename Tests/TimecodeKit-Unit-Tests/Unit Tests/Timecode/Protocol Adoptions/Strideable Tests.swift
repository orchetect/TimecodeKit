//
//  Strideable Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import TimecodeKit // do NOT import as @testable in this file
import XCTest

class Timecode_Strideable_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testAdvancedBy() throws {
        try TimecodeFrameRate.allCases.forEach {
            let frames = Timecode.frameCount(of: Timecode.Components(h: 1), at: $0).wholeFrames
            
            let advanced = try Timecode(.components(f: 00), at: $0)
                .advanced(by: frames)
                .components
            
            XCTAssertEqual(advanced, Timecode.Components(h: 1), "for \($0)")
        }
    }
    
    func testDistanceTo_24Hours() throws {
        // 24 hours stride frame count test
        
        try TimecodeFrameRate.allCases.forEach {
            let zero = Timecode(.zero, at: $0)
            
            let target = try Timecode(.components(d: 00, h: 23, m: 59, s: 59, f: $0.maxFrameNumberDisplayable), at: $0)
            
            let delta = zero.distance(to: target)
            
            XCTAssertEqual(delta, $0.maxTotalFramesExpressible(in: .max24Hours), "for \($0)")
        }
    }
    
    func testDistanceTo_100Days() throws {
        // 100 days stride frame count test
        
        try TimecodeFrameRate.allCases.forEach {
            let zero = Timecode(.zero, at: $0, limit: .max100Days)
            
            let target = try Timecode(
                .components(d: 99, h: 23, m: 59, s: 59, f: $0.maxFrameNumberDisplayable),
                at: $0,
                limit: .max100Days
            )
            
            let delta = zero.distance(to: target)
            
            XCTAssertEqual(delta, $0.maxTotalFramesExpressible(in: .max100Days), "for \($0)")
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

#endif
