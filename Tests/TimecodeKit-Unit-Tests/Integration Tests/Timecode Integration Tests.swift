//
//  Timecode Integration Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import TimecodeKit

class Timecode_IT_IntegrationTests: XCTestCase {
    func testTimecode_Clamping() {
        // 24 hour
        
        Timecode.FrameRate.allCases.forEach {
            XCTAssertEqual(
                Timecode(
                    clampingEach: TCC(h: -1, m: -1, s: -1, f: -1),
                    at: $0
                )
                .components,
                TCC(d: 0, h: 0, m: 0, s: 0, f: 0),
                "for \($0)"
            )
        }
        
        Timecode.FrameRate.allCases.forEach {
            let clamped = Timecode(
                clampingEach: TCC(h: 99, m: 99, s: 99, f: 10000),
                at: $0
            )
            .components
            
            XCTAssertEqual(
                clamped,
                TCC(d: 0, h: 23, m: 59, s: 59, f: $0.maxFrameNumberDisplayable),
                "for \($0)"
            )
        }
        
        // 24 hour - testing with days
        
        Timecode.FrameRate.allCases.forEach {
            XCTAssertEqual(
                Timecode(
                    clampingEach: TCC(d: -1, h: -1, m: -1, s: -1, f: -1),
                    at: $0
                )
                .components,
                TCC(d: 0, h: 0, m: 0, s: 0, f: 0),
                "for \($0)"
            )
        }
        
        Timecode.FrameRate.allCases.forEach {
            let clamped = Timecode(
                clampingEach: TCC(d: 99, h: 99, m: 99, s: 99, f: 10000),
                at: $0
            )
            .components
            
            XCTAssertEqual(
                clamped,
                TCC(d: 0, h: 23, m: 59, s: 59, f: $0.maxFrameNumberDisplayable),
                "for \($0)"
            )
        }
        
        // 100 days
        
        Timecode.FrameRate.allCases.forEach {
            XCTAssertEqual(
                Timecode(
                    clampingEach: TCC(h: -1, m: -1, s: -1, f: -1),
                    at: $0
                )
                .components,
                TCC(d: 0, h: 0, m: 0, s: 0, f: 0),
                "for \($0)"
            )
        }
        
        Timecode.FrameRate.allCases.forEach {
            let clamped = Timecode(
                clampingEach: TCC(h: 99, m: 99, s: 99, f: 10000),
                at: $0
            )
            .components
            
            XCTAssertEqual(
                clamped,
                TCC(d: 0, h: 23, m: 59, s: 59, f: $0.maxFrameNumberDisplayable),
                "for \($0)"
            )
        }
        
        // 100 days - testing with days
        
        Timecode.FrameRate.allCases.forEach {
            XCTAssertEqual(
                Timecode(
                    clampingEach: TCC(d: -1, h: -1, m: -1, s: -1, f: -1),
                    at: $0,
                    limit: ._100days
                )
                .components,
                TCC(d: 0, h: 0, m: 0, s: 0, f: 0),
                "for \($0)"
            )
        }
        
        Timecode.FrameRate.allCases.forEach {
            let clamped = Timecode(
                clampingEach: TCC(d: 99, h: 99, m: 99, s: 99, f: 10000),
                at: $0,
                limit: ._100days
            )
            .components
            
            XCTAssertEqual(
                clamped,
                TCC(d: 99, h: 23, m: 59, s: 59, f: $0.maxFrameNumberDisplayable),
                "for \($0)"
            )
        }
    }
    
    func testTimecode_Wrapping() {
        // 24 hour
        
        Timecode.FrameRate.allCases.forEach {
            let wrapped = Timecode(
                wrapping: TCC(d: 1),
                at: $0
            )
            .components
            
            let result = TCC(d: 0, h: 0, m: 0, s: 0, f: 0)
            
            XCTAssertEqual(wrapped, result, "for \($0)")
        }
        
        Timecode.FrameRate.allCases.forEach {
            let wrapped = Timecode(
                wrapping: TCC(f: -1),
                at: $0
            )
            .components
            
            let result = TCC(d: 0, h: 23, m: 59, s: 59, f: $0.maxFrameNumberDisplayable, sf: 0)
            
            XCTAssertEqual(wrapped, result, "for \($0)")
        }
        
        // 24 hour - testing with days
        
        Timecode.FrameRate.allCases.forEach {
            let wrapped = Timecode(
                wrapping: TCC(d: 1, h: 2, m: 30, s: 20, f: 0),
                at: $0
            )
            .components
            
            let result = TCC(d: 0, h: 2, m: 30, s: 20, f: 0)
            
            XCTAssertEqual(wrapped, result, "for \($0)")
        }
        
        // 100 days
        
        Timecode.FrameRate.allCases.forEach {
            let wrapped = Timecode(
                wrapping: TCC(d: -1),
                at: $0,
                limit: ._100days
            )
            .components
            
            let result = TCC(d: 99, h: 0, m: 0, s: 0, f: 0)
            
            XCTAssertEqual(wrapped, result, "for \($0)")
        }
    }
}

#endif
