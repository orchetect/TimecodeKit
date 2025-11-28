//
//  Timecode Conversion Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftTimecodeCore
import XCTest

final class Timecode_Conversion_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testConverted_NewFrameRate() throws {
        // baseline check:
        // ensure conversion produces identical output if frame rates are equal
        
        for item in TimecodeFrameRate.allCases {
            let tc = try Timecode(.components(h: 1), at: item, base: .max100SubFrames)
            
            let convertedTC = try tc.converted(to: item)
            
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
        XCTAssertEqual(convertedTC.subFramesBase, .max100SubFrames)
        XCTAssertEqual(convertedTC.components, Timecode.Components(h: 1, m: 00, s: 03, f: 18, sf: 00))
    }
    
    func testConverted_NewFrameRate_NewSubFramesBaseA() throws {
        // spot-check an example conversion
        
        let convertedTC = try Timecode(
            .components(sf: 50),
            at: .fps30,
            base: .max100SubFrames
        )
        .converted(to: .fps60, base: .max80SubFrames)
        
        XCTAssertEqual(convertedTC.frameRate, .fps60)
        XCTAssertEqual(convertedTC.subFramesBase, .max80SubFrames)
        XCTAssertEqual(convertedTC.components, Timecode.Components(f: 1))
    }
    
    func testConverted_NewFrameRate_NewSubFramesBaseB() throws {
        // spot-check an example conversion
        
        let convertedTC = try Timecode(
            .components(h: 1, sf: 40),
            at: .fps23_976,
            base: .max80SubFrames
        )
        .converted(to: .fps30, base: .max100SubFrames)
        
        XCTAssertEqual(convertedTC.frameRate, .fps30)
        XCTAssertEqual(convertedTC.subFramesBase, .max100SubFrames)
        XCTAssertEqual(convertedTC.components, Timecode.Components(h: 1, m: 00, s: 03, f: 18, sf: 62))
    }
    
    func testConverted_NewFrameRate_PreservingValues() throws {
        // baseline check:
        // ensure conversion produces identical output if frame rates are equal
        
        for item in TimecodeFrameRate.allCases {
            let tc = try Timecode(.components(h: 1), at: item)
            
            let convertedTC = try tc.converted(to: item, preservingValues: true)
            
            XCTAssertEqual(tc, convertedTC)
        }
        
        // spot-check: arbitrary non-zero timecode values that should be able to be preserved across all frame rates
        
        for sourceFrameRate in TimecodeFrameRate.allCases {
            for destinationFrameRate in TimecodeFrameRate.allCases {
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
