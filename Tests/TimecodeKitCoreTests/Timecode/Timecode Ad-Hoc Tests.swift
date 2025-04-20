//
//  Timecode Ad-Hoc Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import TimecodeKitCore
import XCTest

final class TimecodeAdHocTests: XCTestCase {
    func testTimecode_Clamping() {
        // 24 hour
        
        for item in TimecodeFrameRate.allCases {
            XCTAssertEqual(
                Timecode(
                    .components(h: -1, m: -1, s: -1, f: -1),
                    at: item,
                    by: .clampingComponents
                )
                .components,
                Timecode.Components(d: 0, h: 0, m: 0, s: 0, f: 0),
                "for \(item)"
            )
        }
        
        for item in TimecodeFrameRate.allCases {
            let clamped = Timecode(
                .components(h: 99, m: 99, s: 99, f: 10000),
                at: item,
                by: .clampingComponents
            )
            .components
            
            XCTAssertEqual(
                clamped,
                Timecode.Components(d: 0, h: 23, m: 59, s: 59, f: item.maxFrameNumberDisplayable),
                "for \(item)"
            )
        }
        
        // 24 hour - testing with days
        
        for item in TimecodeFrameRate.allCases {
            XCTAssertEqual(
                Timecode(
                    .components(d: -1, h: -1, m: -1, s: -1, f: -1),
                    at: item,
                    by: .clampingComponents
                )
                .components,
                Timecode.Components(d: 0, h: 0, m: 0, s: 0, f: 0),
                "for \(item)"
            )
        }
        
        for item in TimecodeFrameRate.allCases {
            let clamped = Timecode(
                .components(d: 99, h: 99, m: 99, s: 99, f: 10000),
                at: item,
                by: .clampingComponents
            )
            .components
            
            XCTAssertEqual(
                clamped,
                Timecode.Components(d: 0, h: 23, m: 59, s: 59, f: item.maxFrameNumberDisplayable),
                "for \(item)"
            )
        }
        
        // 100 days
        
        for item in TimecodeFrameRate.allCases {
            XCTAssertEqual(
                Timecode(
                    .components(h: -1, m: -1, s: -1, f: -1),
                    at: item,
                    by: .clampingComponents
                )
                .components,
                Timecode.Components(d: 0, h: 0, m: 0, s: 0, f: 0),
                "for \(item)"
            )
        }
        
        for item in TimecodeFrameRate.allCases {
            let clamped = Timecode(
                .components(h: 99, m: 99, s: 99, f: 10000),
                at: item,
                by: .clampingComponents
            )
            .components
            
            XCTAssertEqual(
                clamped,
                Timecode.Components(d: 0, h: 23, m: 59, s: 59, f: item.maxFrameNumberDisplayable),
                "for \(item)"
            )
        }
        
        // 100 days - testing with days
        
        for item in TimecodeFrameRate.allCases {
            XCTAssertEqual(
                Timecode(
                    .components(d: -1, h: -1, m: -1, s: -1, f: -1),
                    at: item,
                    limit: .max100Days,
                    by: .clampingComponents
                )
                .components,
                Timecode.Components(d: 0, h: 0, m: 0, s: 0, f: 0),
                "for \(item)"
            )
        }
        
        for item in TimecodeFrameRate.allCases {
            let clamped = Timecode(
                .components(d: 99, h: 99, m: 99, s: 99, f: 10000),
                at: item,
                limit: .max100Days,
                by: .clampingComponents
            )
            .components
            
            XCTAssertEqual(
                clamped,
                Timecode.Components(d: 99, h: 23, m: 59, s: 59, f: item.maxFrameNumberDisplayable),
                "for \(item)"
            )
        }
    }
    
    func testTimecode_Wrapping() {
        // 24 hour
        
        for item in TimecodeFrameRate.allCases {
            let wrapped = Timecode(
                .components(d: 1),
                at: item,
                by: .wrapping
            )
            .components
            
            let result = Timecode.Components(d: 0, h: 0, m: 0, s: 0, f: 0)
            
            XCTAssertEqual(wrapped, result, "for \(item)")
        }
        
        for item in TimecodeFrameRate.allCases {
            let wrapped = Timecode(
                .components(f: -1),
                at: item,
                by: .wrapping
            )
            .components
            
            let result = Timecode.Components(d: 0, h: 23, m: 59, s: 59, f: item.maxFrameNumberDisplayable, sf: 0)
            
            XCTAssertEqual(wrapped, result, "for \(item)")
        }
        
        // 24 hour - testing with days
        
        for item in TimecodeFrameRate.allCases {
            let wrapped = Timecode(
                .components(d: 1, h: 2, m: 30, s: 20, f: 0),
                at: item,
                by: .wrapping
            )
            .components
            
            let result = Timecode.Components(d: 0, h: 2, m: 30, s: 20, f: 0)
            
            XCTAssertEqual(wrapped, result, "for \(item)")
        }
        
        // 100 days
        
        for item in TimecodeFrameRate.allCases {
            let wrapped = Timecode(
                .components(d: -1),
                at: item,
                limit: .max100Days,
                by: .wrapping
            )
            .components
            
            let result = Timecode.Components(d: 99, h: 0, m: 0, s: 0, f: 0)
            
            XCTAssertEqual(wrapped, result, "for \(item)")
        }
    }
}
