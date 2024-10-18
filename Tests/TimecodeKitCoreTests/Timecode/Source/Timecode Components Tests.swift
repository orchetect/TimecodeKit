//
//  Timecode Components Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import TimecodeKitCore // do NOT import as @testable in this file
import XCTest

final class Timecode_Source_Components_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testTimecode_init_Components_Exactly() throws {
        for item in TimecodeFrameRate.allCases {
            let tc = try Timecode(
                .components(d: 0, h: 0, m: 0, s: 0, f: 0),
                at: item
            )
            
            XCTAssertEqual(tc.components, .zero, "for \(item)")
        }
        
        for item in TimecodeFrameRate.allCases {
            let tc = try Timecode(
                .components(d: 0, h: 1, m: 2, s: 3, f: 4),
                at: item
            )
            
            XCTAssertEqual(
                tc.components,
                Timecode.Components(d: 0, h: 1, m: 2, s: 3, f: 4),
                "for \(item)"
            )
        }
    }
    
    func testTimecode_init_Components_Clamping() {
        let tc = Timecode(
            .components(h: 25),
            at: .fps24,
            by: .clamping
        )
        
        XCTAssertEqual(
            tc.components,
            Timecode.Components(h: 23, m: 59, s: 59, f: 23, sf: tc.subFramesBase.rawValue - 1)
        )
    }
    
    func testTimecode_init_Components_ClampingEach() {
        let tc = Timecode(
            .components(h: 25),
            at: .fps24,
            by: .clampingComponents
        )
        
        XCTAssertEqual(
            tc.components,
            Timecode.Components(h: 23, m: 00, s: 00, f: 00)
        )
    }
    
    func testTimecode_init_Components_Wrapping() {
        for item in TimecodeFrameRate.allCases {
            let tc = Timecode(
                .components(h: 25),
                at: item,
                by: .wrapping
            )
            
            XCTAssertEqual(tc.components, Timecode.Components(h: 1), "for \(item)")
        }
    }
    
    func testTimecode_init_Components_RawValues() {
        for item in TimecodeFrameRate.allCases {
            let tc = Timecode(
                .components(d: 99, h: 99, m: 99, s: 99, f: 99, sf: 99),
                at: item,
                by: .allowingInvalid
            )
            
            XCTAssertEqual(
                tc.components,
                Timecode.Components(d: 99, h: 99, m: 99, s: 99, f: 99, sf: 99),
                "for \(item)"
            )
        }
    }
    
    func testTimecode_components_24Hours() {
        // default
        
        var tc = Timecode(.zero, at: .fps30)
        
        XCTAssertEqual(tc.components, Timecode.Components.zero)
        
        // setter
        
        tc.components = Timecode.Components(h: 1, m: 2, s: 3, f: 4, sf: 5)
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 1, m: 2, s: 3, f: 4, sf: 5))
    }
    
    func testTimecode_components_100Days() {
        // default
        
        var tc = Timecode(.zero, at: .fps30, limit: .max100Days)
        
        XCTAssertEqual(tc.components, Timecode.Components.zero)
        
        // setter
        
        tc.components = Timecode.Components(d: 5, h: 1, m: 2, s: 3, f: 4, sf: 5)
        
        XCTAssertEqual(tc.components, Timecode.Components(d: 5, h: 1, m: 2, s: 3, f: 4, sf: 5))
    }
    
    func testSetTimecodeExactly() throws {
        // this is not meant to test the underlying logic, simply that set() produces the intended outcome
        
        var tc = Timecode(.zero, at: .fps30)
        
        try tc.set(.components(h: 1, m: 2, s: 3, f: 4, sf: 5))
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 1, m: 2, s: 3, f: 4, sf: 5))
    }
    
    func testSetTimecodeClamping() {
        // this is not meant to test the underlying logic, simply that set() produces the intended outcome
        
        var tc = Timecode(.zero, at: .fps30, base: .max80SubFrames)
        
        tc.set(.components(d: 1, h: 70, m: 70, s: 70, f: 70, sf: 500), by: .clamping)
        
        XCTAssertEqual(tc.components, Timecode.Components(d: 0, h: 23, m: 59, s: 59, f: 29, sf: 79))
    }
    
    func testSetTimecodeClampingEach() {
        // this is not meant to test the underlying logic, simply that set() produces the intended outcome
        
        var tc = Timecode(.zero, at: .fps30, base: .max80SubFrames)
        
        tc.set(.components(h: 70, m: 00, s: 70, f: 00, sf: 500), by: .clampingComponents)
        
        XCTAssertEqual(tc.components, Timecode.Components(d: 0, h: 23, m: 00, s: 59, f: 00, sf: 79))
    }
    
    func testSetTimecodeWrapping() {
        // this is not meant to test the underlying logic, simply that set() produces the intended outcome
        
        var tc = Timecode(.zero, at: .fps30)
        
        tc.set(.components(f: -1), by: .wrapping)
        
        XCTAssertEqual(tc.components, Timecode.Components(d: 0, h: 23, m: 59, s: 59, f: 29, sf: 00))
    }
}
