//
//  Timecode Conversion Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit

#if shouldTestCurrentPlatform

import XCTest
@testable import TimecodeKit

class Timecode_UT_Conversion_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testConverted() throws {
        // baseline check:
        // ensure conversion produces identical output if frame rates are equal
        
        try Timecode.FrameRate.allCases.forEach {
            let tc = try TCC(h: 1)
                .toTimecode(at: $0)
            
            let convertedTC = try tc.converted(to: $0)
            
            XCTAssertEqual(tc, convertedTC)
        }
        
        // spot-check an example conversion
        
        let convertedTC = try
            TCC(h: 1)
                .toTimecode(
                    at: ._23_976,
                    base: ._100SubFrames,
                    format: [.showSubFrames]
                )
                .converted(to: ._30)
        
        XCTAssertEqual(convertedTC.frameRate, ._30)
        XCTAssertEqual(convertedTC.components, TCC(h: 1, m: 00, s: 03, f: 18, sf: 00))
    }
    
    func testConverted_PreservingValues() throws {
        // baseline check:
        // ensure conversion produces identical output if frame rates are equal
        
        try Timecode.FrameRate.allCases.forEach {
            let tc = try TCC(h: 1)
                .toTimecode(at: $0)
            
            let convertedTC = try tc.converted(to: $0, preservingValues: true)
            
            XCTAssertEqual(tc, convertedTC)
        }
        
        // spot-check: arbitrary non-zero timecode values that should be able to be preserved across all frame rates
        
        try Timecode.FrameRate.allCases.forEach { sourceFrameRate in
            try Timecode.FrameRate.allCases.forEach { destinationFrameRate in
                
                let convertedTC = try
                    TCC(h: 2, m: 07, s: 24, f: 11)
                        .toTimecode(
                            at: sourceFrameRate,
                            base: ._100SubFrames,
                            format: [.showSubFrames]
                        )
                        .converted(to: destinationFrameRate, preservingValues: true)
                
                XCTAssertEqual(convertedTC.frameRate, destinationFrameRate)
                XCTAssertEqual(convertedTC.components, TCC(h: 2, m: 07, s: 24, f: 11, sf: 00))
            }
        }
        
        // spot-check: frames value too large to preserve; convert timecode instead
        
        let convertedTC = try
            TCC(h: 1, m: 0, s: 0, f: 96)
                .toTimecode(
                    at: ._100,
                    base: ._100SubFrames,
                    format: [.showSubFrames]
                )
                .converted(to: ._50, preservingValues: true)
        
        XCTAssertEqual(convertedTC.frameRate, ._50)
        XCTAssertEqual(convertedTC.components, TCC(h: 1, m: 00, s: 00, f: 48, sf: 00))
    }
}

#endif
