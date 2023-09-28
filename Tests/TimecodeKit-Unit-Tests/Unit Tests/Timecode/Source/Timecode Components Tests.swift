//
//  Timecode Components Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

@testable import TimecodeKit
import XCTest

class Timecode_Components_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testTimecode_init_Components_Exactly() throws {
        try TimecodeFrameRate.allCases.forEach {
            let tc = try Timecode(
                .components(d: 0, h: 0, m: 0, s: 0, f: 0),
                at: $0
            )
            
            XCTAssertEqual(tc.components, .zero, "for \($0)")
        }
        
        try TimecodeFrameRate.allCases.forEach {
            let tc = try Timecode(
                .components(d: 0, h: 1, m: 2, s: 3, f: 4),
                at: $0
            )
            
            XCTAssertEqual(
                tc.components,
                Timecode.Components(d: 0, h: 1, m: 2, s: 3, f: 4),
                "for \($0)"
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
        TimecodeFrameRate.allCases.forEach {
            let tc = Timecode(
                .components(h: 25),
                at: $0,
                by: .wrapping
            )
            
            XCTAssertEqual(tc.components, Timecode.Components(h: 1), "for \($0)")
        }
    }
    
    func testTimecode_init_Components_RawValues() {
        TimecodeFrameRate.allCases.forEach {
            let tc = Timecode(
                .components(d: 99, h: 99, m: 99, s: 99, f: 99, sf: 99),
                at: $0,
                by: .allowingInvalid
            )
            
            XCTAssertEqual(
                tc.components,
                Timecode.Components(d: 99, h: 99, m: 99, s: 99, f: 99, sf: 99),
                "for \($0)"
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
    
    // MARK: - .timecode()
    
    func testTimecode_Components_toTimecode() throws {
        // timecode(rawValuesAt:)
        
        XCTAssertEqual(
            try Timecode.Components(h: 1, m: 5, s: 20, f: 14)
                .timecode(at: .fps23_976),
            try Timecode(
                .components(h: 1, m: 5, s: 20, f: 14),
                at: .fps23_976
            )
        )
        
        // timecode(rawValuesAt:) with subframes
        
        let tcWithSubFrames = try Timecode.Components(h: 1, m: 5, s: 20, f: 14, sf: 94)
            .timecode(at: .fps23_976, base: .max100SubFrames)
        XCTAssertEqual(
            tcWithSubFrames,
            try Timecode(
                .components(h: 1, m: 5, s: 20, f: 14, sf: 94),
                at: .fps23_976,
                base: .max100SubFrames
            )
        )
        XCTAssertEqual(
            tcWithSubFrames.stringValue(format: .showSubFrames),
            "01:05:20:14.94"
        )
    }
    
    func testTimecode_Components_toTimecode_rawValuesAt() throws {
        // timecode(rawValuesAt:)
        
        XCTAssertEqual(
            Timecode.Components(h: 1, m: 5, s: 20, f: 14)
                .timecode(at: .fps23_976, by: .allowingInvalid),
            Timecode(
                .components(h: 1, m: 5, s: 20, f: 14),
                at: .fps23_976,
                by: .allowingInvalid
            )
        )
        
        // toTimecode(rawValuesAt:) with subframes
        
        let tcWithSubFrames = Timecode.Components(h: 1, m: 5, s: 20, f: 14, sf: 94)
            .timecode(
                at: .fps23_976,
                base: .max100SubFrames,
                by: .allowingInvalid
            )
        XCTAssertEqual(
            tcWithSubFrames,
            try Timecode(
                .components(h: 1, m: 5, s: 20, f: 14, sf: 94),
                at: .fps23_976,
                base: .max100SubFrames
            )
        )
        XCTAssertEqual(
            tcWithSubFrames.stringValue(format: .showSubFrames),
            "01:05:20:14.94"
        )
    }
}

#endif
