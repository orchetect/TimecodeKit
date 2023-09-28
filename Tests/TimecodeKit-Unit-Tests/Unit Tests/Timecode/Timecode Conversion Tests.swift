//
//  Timecode Conversion Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import TimecodeKit
import XCTest

class Timecode_Conversion_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testConverted() throws {
        // baseline check:
        // ensure conversion produces identical output if frame rates are equal
        
        try TimecodeFrameRate.allCases.forEach {
            let tc = try Timecode(.components(h: 1), at: $0)
            
            let convertedTC = try tc.converted(to: $0)
            
            XCTAssertEqual(tc, convertedTC)
        }
        
        // spot-check an example conversion
        
        let convertedTC = try Timecode(
            .components(h: 1),
            at: .fps23_976,
            base: .max100SubFrames
        )
        .converted(to: .fps30)
        
        XCTAssertEqual(convertedTC.frameRate, .fps30)
        XCTAssertEqual(convertedTC.components, Timecode.Components(h: 1, m: 00, s: 03, f: 18, sf: 00))
    }
    
    func testConverted_PreservingValues() throws {
        // baseline check:
        // ensure conversion produces identical output if frame rates are equal
        
        try TimecodeFrameRate.allCases.forEach {
            let tc = try Timecode(.components(h: 1), at: $0)
            
            let convertedTC = try tc.converted(to: $0, preservingValues: true)
            
            XCTAssertEqual(tc, convertedTC)
        }
        
        // spot-check: arbitrary non-zero timecode values that should be able to be preserved across all frame rates
        
        try TimecodeFrameRate.allCases.forEach { sourceFrameRate in
            try TimecodeFrameRate.allCases.forEach { destinationFrameRate in
                let convertedTC = try Timecode(
                    .components(h: 2, m: 07, s: 24, f: 11),
                    at: sourceFrameRate,
                    base: .max100SubFrames
                )
                .converted(to: destinationFrameRate, preservingValues: true)
                
                XCTAssertEqual(convertedTC.frameRate, destinationFrameRate)
                XCTAssertEqual(convertedTC.components, Timecode.Components(h: 2, m: 07, s: 24, f: 11, sf: 00))
            }
        }
        
        // spot-check: frames value too large to preserve; convert timecode instead
        
        let convertedTC = try Timecode(
            .components(h: 1, m: 0, s: 0, f: 96),
            at: .fps100,
            base: .max100SubFrames
        )
        .converted(to: .fps50, preservingValues: true)
            
        XCTAssertEqual(convertedTC.frameRate, .fps50)
        XCTAssertEqual(convertedTC.components, Timecode.Components(h: 1, m: 00, s: 00, f: 48, sf: 00))
    }
    
    func testTransform() throws {
        var tc = try Timecode(.components(m: 1), at: .fps24)
        
        let transformer = TimecodeTransformer(.offset(by: .positive(tc)))
        tc.transform(using: transformer)
        
        XCTAssertEqual(tc, try Timecode(.components(m: 2), at: .fps24))
    }
    
    func testTransformed() throws {
        let tc = try Timecode(.components(m: 1), at: .fps24)
        
        let transformer = TimecodeTransformer(.offset(by: .positive(tc)))
        let newTC = tc.transformed(using: transformer)
        
        XCTAssertEqual(newTC, try Timecode(.components(m: 2), at: .fps24))
    }
}

#endif
