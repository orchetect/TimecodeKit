//
//  Strideable Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import TimecodeKit

class Timecode_Strideable_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testAdvancedBy() throws {
        try TimecodeFrameRate.allCases.forEach {
            let frames = Timecode.frameCount(of: Timecode.Components(h: 1), using: $0).wholeFrames
            
            let advanced = try Timecode.Components(f: 00)
                .timecode(using: $0)
                .advanced(by: frames)
                .components
            
            XCTAssertEqual(advanced, Timecode.Components(h: 1), "for \($0)")
        }
    }
    
    func testDistanceTo_24Hours() throws {
        // 24 hours stride frame count test
        
        try TimecodeFrameRate.allCases.forEach {
            let zero = try Timecode.Components(h: 00, m: 00, s: 00, f: 00)
                .timecode(using: $0)
            
            let target = try Timecode.Components(d: 00, h: 23, m: 59, s: 59, f: $0.maxFrameNumberDisplayable)
                .timecode(using: $0)
            
            let delta = zero.distance(to: target)
            
            XCTAssertEqual(delta, $0.maxTotalFramesExpressible(in: ._24hours), "for \($0)")
        }
    }
    
    func testDistanceTo_100Days() throws {
        // 100 days stride frame count test
        
        try TimecodeFrameRate.allCases.forEach {
            let zero = try Timecode.Components(h: 00, m: 00, s: 00, f: 00)
                .timecode(using: $0, limit: ._100days)
            
            let target = try Timecode.Components(d: 99, h: 23, m: 59, s: 59, f: $0.maxFrameNumberDisplayable)
                .timecode(using: $0, limit: ._100days)
            
            let delta = zero.distance(to: target)
            
            XCTAssertEqual(delta, $0.maxTotalFramesExpressible(in: ._100days), "for \($0)")
        }
    }
    
    // MARK: Integration Tests
    
    func testTimecode_Strideable_Ranges() throws {
        // Stride through & array
        
        let strideThrough = stride(
            from: try "01:00:00:00".timecode(using: ._23_976),
            through: try "01:00:00:06".timecode(using: ._23_976),
            by: 2
        )
        var array = Array(strideThrough)
        
        XCTAssertEqual(array.count, 4)
        XCTAssertEqual(
            array,
            [
                try "01:00:00:00".timecode(using: ._23_976),
                try "01:00:00:02".timecode(using: ._23_976),
                try "01:00:00:04".timecode(using: ._23_976),
                try "01:00:00:06".timecode(using: ._23_976)
            ]
        )
        
        // Stride to
        let strideTo = stride(
            from: try "01:00:00:00".timecode(using: ._23_976),
            to: try "01:00:00:06".timecode(using: ._23_976),
            by: 2
        )
        array = Array(strideTo)
        
        XCTAssertEqual(array.count, 3)
        XCTAssertEqual(
            array,
            [
                try "01:00:00:00".timecode(using: ._23_976),
                try "01:00:00:02".timecode(using: ._23_976),
                try "01:00:00:04".timecode(using: ._23_976)
            ]
        )
        
        // Strideable
        
        XCTAssertEqual(
            try "01:00:00:00".timecode(using: ._23_976)
                .advanced(by: 6),
            try "01:00:00:06".timecode(using: ._23_976)
        )
        
        XCTAssertEqual(
            try "01:00:00:00".timecode(using: ._23_976)
                .distance(to: "02:00:00:00".timecode(using: ._23_976)),
            try "01:00:00:00".timecode(using: ._23_976).frameCount.wholeFrames
        )
        
        let strs = Array(
            stride(
                from: try "01:00:00:05".timecode(using: ._23_976),
                through: try "01:00:10:05".timecode(using: ._23_976),
                by: try Timecode(.components(s: 1), using: ._23_976).frameCount.wholeFrames
            )
        )
        .map { $0.stringValue() }
        
        XCTAssertEqual(strs.count, 11)
        
        let strs2 = Array(
            stride(
                from: try "01:00:00:05".timecode(using: ._23_976),
                to: try "01:00:10:07".timecode(using: ._23_976),
                by: try Timecode(.components(s: 1), using: ._23_976).frameCount.wholeFrames
            )
        )
        .map { $0.stringValue() }
        
        XCTAssertEqual(strs2.count, 11)
        
        // Strideable with drop rates
        
        // TODO: add strideable drop rates tests
        
        // Range .contains
        
        XCTAssertTrue(
            try ("01:00:00:00".timecode(using: ._23_976) ... "01:00:00:06".timecode(using: ._23_976))
                .contains(Timecode("01:00:00:02", using: ._23_976))
        )
        XCTAssertFalse(
            try ("01:00:00:00".timecode(using: ._23_976) ... "01:00:00:06".timecode(using: ._23_976))
                .contains(Timecode("01:00:00:10", using: ._23_976))
        )
        XCTAssertTrue(
            try ("01:00:00:00".timecode(using: ._23_976)...)
                .contains(Timecode("01:00:00:02", using: ._23_976))
        )
        XCTAssertTrue(
            try (..."01:00:00:06".timecode(using: ._23_976))
                .contains(Timecode("01:00:00:02", using: ._23_976))
        )
        
        // (same tests, but with ~= operator instead of .contains(...) which should produce the same result)
        
        XCTAssertTrue(
            try "01:00:00:00".timecode(using: ._23_976) ... "01:00:00:06".timecode(using: ._23_976)
                ~= Timecode("01:00:00:02", using: ._23_976)
        )
        XCTAssertFalse(
            try "01:00:00:00".timecode(using: ._23_976) ... "01:00:00:06".timecode(using: ._23_976)
                ~= Timecode("01:00:00:10", using: ._23_976)
        )
        XCTAssertTrue(
            try "01:00:00:00".timecode(using: ._23_976)...
                ~= Timecode("01:00:00:02", using: ._23_976)
        )
        XCTAssertTrue(
            try ..."01:00:00:06".timecode(using: ._23_976)
                ~= Timecode("01:00:00:02", using: ._23_976)
        )
    }
}

#endif
