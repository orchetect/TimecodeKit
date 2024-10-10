//
//  Timecode Integration Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import TimecodeKit
import XCTest

final class TimecodeIntegrationTests: XCTestCase {
    func testTimecode_Clamping() {
        // 24 hour
        
        TimecodeFrameRate.allCases.forEach {
            XCTAssertEqual(
                Timecode(
                    .components(h: -1, m: -1, s: -1, f: -1),
                    at: $0,
                    by: .clampingComponents
                )
                .components,
                Timecode.Components(d: 0, h: 0, m: 0, s: 0, f: 0),
                "for \($0)"
            )
        }
        
        TimecodeFrameRate.allCases.forEach {
            let clamped = Timecode(
                .components(h: 99, m: 99, s: 99, f: 10000),
                at: $0,
                by: .clampingComponents
            )
            .components
            
            XCTAssertEqual(
                clamped,
                Timecode.Components(d: 0, h: 23, m: 59, s: 59, f: $0.maxFrameNumberDisplayable),
                "for \($0)"
            )
        }
        
        // 24 hour - testing with days
        
        TimecodeFrameRate.allCases.forEach {
            XCTAssertEqual(
                Timecode(
                    .components(d: -1, h: -1, m: -1, s: -1, f: -1),
                    at: $0,
                    by: .clampingComponents
                )
                .components,
                Timecode.Components(d: 0, h: 0, m: 0, s: 0, f: 0),
                "for \($0)"
            )
        }
        
        TimecodeFrameRate.allCases.forEach {
            let clamped = Timecode(
                .components(d: 99, h: 99, m: 99, s: 99, f: 10000),
                at: $0,
                by: .clampingComponents
            )
            .components
            
            XCTAssertEqual(
                clamped,
                Timecode.Components(d: 0, h: 23, m: 59, s: 59, f: $0.maxFrameNumberDisplayable),
                "for \($0)"
            )
        }
        
        // 100 days
        
        TimecodeFrameRate.allCases.forEach {
            XCTAssertEqual(
                Timecode(
                    .components(h: -1, m: -1, s: -1, f: -1),
                    at: $0,
                    by: .clampingComponents
                )
                .components,
                Timecode.Components(d: 0, h: 0, m: 0, s: 0, f: 0),
                "for \($0)"
            )
        }
        
        TimecodeFrameRate.allCases.forEach {
            let clamped = Timecode(
                .components(h: 99, m: 99, s: 99, f: 10000),
                at: $0,
                by: .clampingComponents
            )
            .components
            
            XCTAssertEqual(
                clamped,
                Timecode.Components(d: 0, h: 23, m: 59, s: 59, f: $0.maxFrameNumberDisplayable),
                "for \($0)"
            )
        }
        
        // 100 days - testing with days
        
        TimecodeFrameRate.allCases.forEach {
            XCTAssertEqual(
                Timecode(
                    .components(d: -1, h: -1, m: -1, s: -1, f: -1),
                    at: $0,
                    limit: .max100Days,
                    by: .clampingComponents
                )
                .components,
                Timecode.Components(d: 0, h: 0, m: 0, s: 0, f: 0),
                "for \($0)"
            )
        }
        
        TimecodeFrameRate.allCases.forEach {
            let clamped = Timecode(
                .components(d: 99, h: 99, m: 99, s: 99, f: 10000),
                at: $0,
                limit: .max100Days,
                by: .clampingComponents
            )
            .components
            
            XCTAssertEqual(
                clamped,
                Timecode.Components(d: 99, h: 23, m: 59, s: 59, f: $0.maxFrameNumberDisplayable),
                "for \($0)"
            )
        }
    }
    
    func testTimecode_Wrapping() {
        // 24 hour
        
        TimecodeFrameRate.allCases.forEach {
            let wrapped = Timecode(
                .components(d: 1),
                at: $0,
                by: .wrapping
            )
            .components
            
            let result = Timecode.Components(d: 0, h: 0, m: 0, s: 0, f: 0)
            
            XCTAssertEqual(wrapped, result, "for \($0)")
        }
        
        TimecodeFrameRate.allCases.forEach {
            let wrapped = Timecode(
                .components(f: -1),
                at: $0,
                by: .wrapping
            )
            .components
            
            let result = Timecode.Components(d: 0, h: 23, m: 59, s: 59, f: $0.maxFrameNumberDisplayable, sf: 0)
            
            XCTAssertEqual(wrapped, result, "for \($0)")
        }
        
        // 24 hour - testing with days
        
        TimecodeFrameRate.allCases.forEach {
            let wrapped = Timecode(
                .components(d: 1, h: 2, m: 30, s: 20, f: 0),
                at: $0,
                by: .wrapping
            )
            .components
            
            let result = Timecode.Components(d: 0, h: 2, m: 30, s: 20, f: 0)
            
            XCTAssertEqual(wrapped, result, "for \($0)")
        }
        
        // 100 days
        
        TimecodeFrameRate.allCases.forEach {
            let wrapped = Timecode(
                .components(d: -1),
                at: $0,
                limit: .max100Days,
                by: .wrapping
            )
            .components
            
            let result = Timecode.Components(d: 99, h: 0, m: 0, s: 0, f: 0)
            
            XCTAssertEqual(wrapped, result, "for \($0)")
        }
    }
}
