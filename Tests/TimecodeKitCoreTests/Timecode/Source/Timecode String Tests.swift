//
//  Timecode String Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import TimecodeKitCore // do NOT import as @testable in this file
import XCTest

final class Timecode_Source_String_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testTimecode_init_String() throws {
        for item in TimecodeFrameRate.allCases {
            let tc = try Timecode(
                .string("00:00:00:00"),
                at: item
            )
            
            XCTAssertEqual(tc.components, .zero, "for \(item)")
        }
        
        for item in TimecodeFrameRate.allCases {
            let tc = try Timecode(
                .string("01:02:03:04"),
                at: item
            )
            
            XCTAssertEqual(tc.components, .init(h: 01, m: 02, s: 03, f: 04), "for \(item)")
        }
    }
    
    func testTimecode_init_String_Clamping() throws {
        let tc = try Timecode(
            .string("25:00:00:00"),
            at: .fps24,
            by: .clamping
        )
        
        XCTAssertEqual(
            tc.components,
            Timecode.Components(h: 23, m: 59, s: 59, f: 23, sf: tc.subFramesBase.rawValue - 1)
        )
    }
    
    func testTimecode_init_String_ClampingEach() throws {
        let tc = try Timecode(
            .string("25:00:00:00"),
            at: .fps24,
            by: .clampingComponents
        )
        
        XCTAssertEqual(
            tc.components,
            Timecode.Components(h: 23, m: 00, s: 00, f: 00)
        )
    }
    
    func testTimecode_init_String_Wrapping() throws {
        for item in TimecodeFrameRate.allCases {
            let tc = try Timecode(
                .string("25:00:00:00"),
                at: item,
                by: .wrapping
            )
            
            XCTAssertEqual(tc.components, .init(h: 01), "for \(item)")
        }
    }
    
    func testTimecode_init_String_RawValues() throws {
        for item in TimecodeFrameRate.allCases {
            let tc = try Timecode(
                .string("99 99:99:99:99.99"),
                at: item,
                by: .allowingInvalid
            )
            
            XCTAssertEqual(tc.components, .init(d: 99, h: 99, m: 99, s: 99, f: 99, sf: 99), "for \(item)")
        }
    }
    
    func testStringValue_GetSet_Basic() throws {
        // basic getter tests
        
        var tc = Timecode(.zero, at: .fps23_976)
        
        try tc.set(.string("01:05:20:14"))
        XCTAssertEqual(tc.stringValue(), "01:05:20:14")
        
        XCTAssertThrowsError(try tc.set(.string("50:05:20:14")))
        XCTAssertEqual(tc.stringValue(), "01:05:20:14") // no change
        
        try tc.set(.string("50:05:20:14"), by: .clampingComponents)
        XCTAssertEqual(tc.stringValue(), "23:05:20:14")
    }
    
    func testStringValue_Get_Formatting_Basic() throws {
        // basic string formatting - ie: HH:MM:SS:FF
        // using known valid timecode components; not testing for invalid values here
        
        // 24 hour limit
        
        // non-drop
        
        for item in TimecodeFrameRate.allNonDrop {
            let sv = try Timecode(.components(h: 1, m: 02, s: 03, f: 04), at: item)
                .stringValue()
            
            let t = item.numberOfDigits == 2 ? "" : "0"
            
            XCTAssertEqual(sv, "01:02:03:\(t)04", "for \(item)")
        }
        
        // drop
        
        for item in TimecodeFrameRate.allDrop {
            let sv = try Timecode(.components(h: 1, m: 02, s: 03, f: 04), at: item)
                .stringValue()
            
            let t = item.numberOfDigits == 2 ? "" : "0"
            
            XCTAssertEqual(sv, "01:02:03;\(t)04", "for \(item)")
        }
        
        // 100 days limit
        
        // non-drop
        
        for item in TimecodeFrameRate.allNonDrop {
            let sv = try Timecode(.components(h: 1, m: 02, s: 03, f: 04), at: item, limit: .max100Days)
                .stringValue()
            
            let t = item.numberOfDigits == 2 ? "" : "0"
            
            XCTAssertEqual(sv, "01:02:03:\(t)04", "for \(item)")  // omits days since they are 0
        }
        
        // drop
        
        for item in TimecodeFrameRate.allDrop {
            let sv = try Timecode(.components(h: 1, m: 02, s: 03, f: 04), at: item, limit: .max100Days)
                .stringValue()
            
            let t = item.numberOfDigits == 2 ? "" : "0"
            
            XCTAssertEqual(sv, "01:02:03;\(t)04", "for \(item)")  // omits days since they are 0
        }
    }
    
    func testStringValue_Get_Formatting_WithDays() throws {
        // string formatting with days - ie: "D HH:MM:SS:FF"
        // using known valid timecode components; not testing for invalid values here
        
        // non-drop
        
        for item in TimecodeFrameRate.allNonDrop {
            var tc = try Timecode(.components(h: 1, m: 02, s: 03, f: 04), at: item)
            tc.days = 2 // set days after init since init fails if we pass days
            
            let t = item.numberOfDigits == 2 ? "" : "0"
            
            // still produces days since we have not clamped it yet
            var sv = tc.stringValue()
            XCTAssertEqual(sv, "2 01:02:03:\(t)04", "for \(item)")
            
            // now omits days since our limit is 24hr and clamped
            tc.clampComponents()
            sv = tc.stringValue()
            XCTAssertEqual(sv, "01:02:03:\(t)04", "for \(item)")
        }
        
        // drop
        
        for item in TimecodeFrameRate.allDrop {
            var tc = try Timecode(.components(h: 1, m: 02, s: 03, f: 04), at: item)
            tc.days = 2 // set days after init since init fails if we pass days
            
            let t = item.numberOfDigits == 2 ? "" : "0"
            
            // still produces days since we have not clamped it yet
            var sv = tc.stringValue()
            XCTAssertEqual(sv, "2 01:02:03;\(t)04", "for \(item)")
            
            // now omits days since our limit is 24hr and clamped
            tc.clampComponents()
            sv = tc.stringValue()
            XCTAssertEqual(sv, "01:02:03;\(t)04", "for \(item)")
        }
        
        // 100 days limit
        
        // non-drop
        
        for item in TimecodeFrameRate.allNonDrop {
            let sv = try Timecode(.components(d: 2, h: 1, m: 02, s: 03, f: 04), at: item, limit: .max100Days)
                .stringValue()
            
            let t = item.numberOfDigits == 2 ? "" : "0"
            
            XCTAssertEqual(sv, "2 01:02:03:\(t)04", "for \(item)")
        }
        
        // drop
        
        for item in TimecodeFrameRate.allDrop {
            let sv = try Timecode(.components(d: 2, h: 1, m: 02, s: 03, f: 04), at: item, limit: .max100Days)
                .stringValue()
            
            let t = item.numberOfDigits == 2 ? "" : "0"
            
            XCTAssertEqual(sv, "2 01:02:03;\(t)04", "for \(item)")
        }
    }
    
    func testStringValue_Get_Formatting_WithSubframes() throws {
        // string formatting with subframes - ie: "HH:MM:SS:FF.sf" (or "D HH:MM:SS:FF.sf" in case of 100 days limit)
        // using known valid timecode components; not testing for invalid values here
        
        // non-drop
        
        for item in TimecodeFrameRate.allNonDrop {
            var tc = try Timecode(.components(h: 1, m: 02, s: 03, f: 04, sf: 12), at: item)
            tc.days = 2 // set days after init since init @ .max24Hours limit fails if we pass days
            
            let t = item.numberOfDigits == 2 ? "" : "0"
            
            // still produces days since we have not clamped it yet
            var sv = tc.stringValue(format: .showSubFrames)
            XCTAssertEqual(sv, "2 01:02:03:\(t)04.12", "for \(item)")
            
            // now omits days since our limit is 24hr and clamped
            tc.clampComponents()
            sv = tc.stringValue(format: .showSubFrames)
            XCTAssertEqual(sv, "01:02:03:\(t)04.12", "for \(item)")
        }
        
        // drop
        
        for item in TimecodeFrameRate.allDrop {
            var tc = try Timecode(.components(h: 1, m: 02, s: 03, f: 04, sf: 12), at: item)
            tc.days = 2 // set days after init since init @ .max24Hours limit fails if we pass days
            
            let t = item.numberOfDigits == 2 ? "" : "0"
            
            // still produces days since we have not clamped it yet
            var sv = tc.stringValue(format: .showSubFrames)
            XCTAssertEqual(sv, "2 01:02:03;\(t)04.12", "for \(item)")
            
            // now omits days since our limit is 24hr and clamped
            tc.clampComponents()
            sv = tc.stringValue(format: .showSubFrames)
            XCTAssertEqual(sv, "01:02:03;\(t)04.12", "for \(item)")
        }
        
        // 100 days limit
        
        // non-drop
        
        for item in TimecodeFrameRate.allNonDrop {
            let tc = try Timecode(.components(d: 2, h: 1, m: 02, s: 03, f: 04, sf: 12), at: item, limit: .max100Days)
            
            let t = item.numberOfDigits == 2 ? "" : "0"
            
            let sv = tc.stringValue(format: .showSubFrames)
            XCTAssertEqual(sv, "2 01:02:03:\(t)04.12", "for \(item)")
        }
        
        // drop
        
        for item in TimecodeFrameRate.allDrop {
            let tc = try Timecode(.components(d: 2, h: 1, m: 02, s: 03, f: 04, sf: 12), at: item, limit: .max100Days)
            
            let t = item.numberOfDigits == 2 ? "" : "0"
            
            let sv = tc.stringValue(format: .showSubFrames)
            XCTAssertEqual(sv, "2 01:02:03;\(t)04.12", "for \(item)")
        }
    }
    
    func testEdgeCases() throws {
        // test for really large values
        
        XCTAssertEqual(
            Timecode(
                .components(
                    d: 1234567891234564567,
                    h: 1234567891234564567,
                    m: 1234567891234564567,
                    s: 1234567891234564567,
                    f: 1234567891234564567,
                    sf: 1234567891234564567
                ),
                at: .fps24,
                by: .allowingInvalid
            )
            .stringValue(format: [.showSubFrames]),
            "1234567891234564567 1234567891234564567:1234567891234564567:1234567891234564567:1234567891234564567.1234567891234564567"
        )
    }
    
    func testVerboseStringValue() throws {
        var tc = Timecode(.zero, at: .fps23_976)
        
        try tc.set(.string("01:05:20:14"))
        XCTAssertEqual(tc.verboseStringValue, "01:05:20:14.00 @ 23.976 fps")
        
        try tc.set(.string("02:07:08:10.20"))
        XCTAssertEqual(tc.verboseStringValue, "02:07:08:10.20 @ 23.976 fps")
        
    }
}
