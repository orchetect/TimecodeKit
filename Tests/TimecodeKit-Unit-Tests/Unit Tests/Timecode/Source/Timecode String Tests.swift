//
//  Timecode String Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform
import XCTest
@testable import TimecodeKit

class Timecode_String_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testTimecode_init_String_Exactly() throws {
        try TimecodeFrameRate.allCases.forEach {
            let tc = try Timecode(
                "00:00:00:00",
                at: $0
            )
            
            XCTAssertEqual(tc.components, .zero, "for \($0)")
        }
        
        try TimecodeFrameRate.allCases.forEach {
            let tc = try Timecode(
                "01:02:03:04",
                at: $0
            )
            
            XCTAssertEqual(tc.components, Timecode.Components(h: 01, m: 02, s: 03, f: 04), "for \($0)")
        }
    }
    
    func testTimecode_init_String_Clamping() throws {
        let tc = try Timecode(
            "25:00:00:00",
            at: ._24,
            by: .clamping
        )
        
        XCTAssertEqual(
            tc.components,
            Timecode.Components(h: 23, m: 59, s: 59, f: 23, sf: tc.subFramesBase.rawValue - 1)
        )
    }
    
    func testTimecode_init_String_ClampingEach() throws {
        let tc = try Timecode(
            "25:00:00:00",
            at: ._24,
            by: .clampingComponents
        )
        
        XCTAssertEqual(
            tc.components,
            Timecode.Components(h: 23, m: 00, s: 00, f: 00)
        )
    }
    
    func testTimecode_init_String_Wrapping() throws {
        try TimecodeFrameRate.allCases.forEach {
            let tc = try Timecode(
                "25:00:00:00",
                at: $0,
                by: .wrapping
            )
            
            XCTAssertEqual(tc.components, Timecode.Components(h: 01), "for \($0)")
        }
    }
    
    func testTimecode_init_String_RawValues() throws {
        try TimecodeFrameRate.allCases.forEach {
            let tc = try Timecode(
                "99 99:99:99:99.99",
                at: $0,
                by: .allowingInvalid
            )
            
            XCTAssertEqual(tc.components, Timecode.Components(d: 99, h: 99, m: 99, s: 99, f: 99, sf: 99), "for \($0)")
        }
    }
    
    func testStringValue_GetSet_Basic() throws {
        // basic getter tests
        
        var tc = Timecode(.zero, at: ._23_976)
        
        try tc.set("01:05:20:14")
        XCTAssertEqual(tc.stringValue(), "01:05:20:14")
        
        XCTAssertThrowsError(try tc.set("50:05:20:14"))
        XCTAssertEqual(tc.stringValue(), "01:05:20:14") // no change
        
        try tc.set("50:05:20:14", by: .clampingComponents)
        XCTAssertEqual(tc.stringValue(), "23:05:20:14")
    }
    
    func testStringValue_Get_Formatting_Basic() throws {
        // basic string formatting - ie: HH:MM:SS:FF
        // using known valid timecode components; not testing for invalid values here
        
        // 24 hour limit
        
        // non-drop
        
        try TimecodeFrameRate.allNonDrop.forEach {
            let sv = try Timecode.Components(h: 1, m: 02, s: 03, f: 04)
                .timecode(at: $0)
                .stringValue()
            
            let t = $0.numberOfDigits == 2 ? "" : "0"
            
            XCTAssertEqual(sv, "01:02:03:\(t)04", "for \($0)")
        }
        
        // drop
        
        try TimecodeFrameRate.allDrop.forEach {
            let sv = try Timecode.Components(h: 1, m: 02, s: 03, f: 04)
                .timecode(at: $0)
                .stringValue()
            
            let t = $0.numberOfDigits == 2 ? "" : "0"
            
            XCTAssertEqual(sv, "01:02:03;\(t)04", "for \($0)")
        }
        
        // 100 days limit
        
        // non-drop
        
        try TimecodeFrameRate.allNonDrop.forEach {
            let sv = try Timecode.Components(h: 1, m: 02, s: 03, f: 04)
                .timecode(at: $0, limit: ._100days)
                .stringValue()
            
            let t = $0.numberOfDigits == 2 ? "" : "0"
            
            XCTAssertEqual(sv, "01:02:03:\(t)04", "for \($0)")  // omits days since they are 0
        }
        
        // drop
        
        try TimecodeFrameRate.allDrop.forEach {
            let sv = try Timecode.Components(h: 1, m: 02, s: 03, f: 04)
                .timecode(at: $0, limit: ._100days)
                .stringValue()
            
            let t = $0.numberOfDigits == 2 ? "" : "0"
            
            XCTAssertEqual(sv, "01:02:03;\(t)04", "for \($0)")  // omits days since they are 0
        }
    }
    
    func testStringValue_Get_Formatting_WithDays() throws {
        // string formatting with days - ie: "D HH:MM:SS:FF"
        // using known valid timecode components; not testing for invalid values here
        
        // non-drop
        
        try TimecodeFrameRate.allNonDrop.forEach {
            var tc = try Timecode.Components(h: 1, m: 02, s: 03, f: 04)
                .timecode(at: $0)
            tc.days = 2 // set days after init since init fails if we pass days
            
            let t = $0.numberOfDigits == 2 ? "" : "0"
            
            // still produces days since we have not clamped it yet
            var sv = tc.stringValue()
            XCTAssertEqual(sv, "2 01:02:03:\(t)04", "for \($0)")
            
            // now omits days since our limit is 24hr and clamped
            tc.clampComponents()
            sv = tc.stringValue()
            XCTAssertEqual(sv, "01:02:03:\(t)04", "for \($0)")
        }
        
        // drop
        
        try TimecodeFrameRate.allDrop.forEach {
            var tc = try Timecode.Components(h: 1, m: 02, s: 03, f: 04)
                .timecode(at: $0)
            tc.days = 2 // set days after init since init fails if we pass days
            
            let t = $0.numberOfDigits == 2 ? "" : "0"
            
            // still produces days since we have not clamped it yet
            var sv = tc.stringValue()
            XCTAssertEqual(sv, "2 01:02:03;\(t)04", "for \($0)")
            
            // now omits days since our limit is 24hr and clamped
            tc.clampComponents()
            sv = tc.stringValue()
            XCTAssertEqual(sv, "01:02:03;\(t)04", "for \($0)")
        }
        
        // 100 days limit
        
        // non-drop
        
        try TimecodeFrameRate.allNonDrop.forEach {
            let sv = try Timecode.Components(d: 2, h: 1, m: 02, s: 03, f: 04)
                .timecode(at: $0, limit: ._100days)
                .stringValue()
            
            let t = $0.numberOfDigits == 2 ? "" : "0"
            
            XCTAssertEqual(sv, "2 01:02:03:\(t)04", "for \($0)")
        }
        
        // drop
        
        try TimecodeFrameRate.allDrop.forEach {
            let sv = try Timecode.Components(d: 2, h: 1, m: 02, s: 03, f: 04)
                .timecode(at: $0, limit: ._100days)
                .stringValue()
            
            let t = $0.numberOfDigits == 2 ? "" : "0"
            
            XCTAssertEqual(sv, "2 01:02:03;\(t)04", "for \($0)")
        }
    }
    
    func testStringValue_Get_Formatting_WithSubframes() throws {
        // string formatting with subframes - ie: "HH:MM:SS:FF.sf" (or "D HH:MM:SS:FF.sf" in case of 100 days limit)
        // using known valid timecode components; not testing for invalid values here
        
        // non-drop
        
        try TimecodeFrameRate.allNonDrop.forEach {
            var tc = try Timecode.Components(h: 1, m: 02, s: 03, f: 04, sf: 12)
                .timecode(at: $0)
            tc.days = 2 // set days after init since init @ ._24hour limit fails if we pass days
            
            let t = $0.numberOfDigits == 2 ? "" : "0"
            
            // still produces days since we have not clamped it yet
            var sv = tc.stringValue(format: .showSubFrames)
            XCTAssertEqual(sv, "2 01:02:03:\(t)04.12", "for \($0)")
            
            // now omits days since our limit is 24hr and clamped
            tc.clampComponents()
            sv = tc.stringValue(format: .showSubFrames)
            XCTAssertEqual(sv, "01:02:03:\(t)04.12", "for \($0)")
        }
        
        // drop
        
        try TimecodeFrameRate.allDrop.forEach {
            var tc = try Timecode.Components(h: 1, m: 02, s: 03, f: 04, sf: 12)
                .timecode(at: $0)
            tc.days = 2 // set days after init since init @ ._24hour limit fails if we pass days
            
            let t = $0.numberOfDigits == 2 ? "" : "0"
            
            // still produces days since we have not clamped it yet
            var sv = tc.stringValue(format: .showSubFrames)
            XCTAssertEqual(sv, "2 01:02:03;\(t)04.12", "for \($0)")
            
            // now omits days since our limit is 24hr and clamped
            tc.clampComponents()
            sv = tc.stringValue(format: .showSubFrames)
            XCTAssertEqual(sv, "01:02:03;\(t)04.12", "for \($0)")
        }
        
        // 100 days limit
        
        // non-drop
        
        try TimecodeFrameRate.allNonDrop.forEach {
            let tc = try Timecode.Components(d: 2, h: 1, m: 02, s: 03, f: 04, sf: 12)
                .timecode(at: $0, limit: ._100days)
            
            let t = $0.numberOfDigits == 2 ? "" : "0"
            
            let sv = tc.stringValue(format: .showSubFrames)
            XCTAssertEqual(sv, "2 01:02:03:\(t)04.12", "for \($0)")
        }
        
        // drop
        
        try TimecodeFrameRate.allDrop.forEach {
            let tc = try Timecode.Components(d: 2, h: 1, m: 02, s: 03, f: 04, sf: 12)
                .timecode(at: $0, limit: ._100days)
            
            let t = $0.numberOfDigits == 2 ? "" : "0"
            
            let sv = tc.stringValue(format: .showSubFrames)
            XCTAssertEqual(sv, "2 01:02:03;\(t)04.12", "for \($0)")
        }
    }
    
    func testStringDecode() throws {
        // non-drop frame
        
        XCTAssertThrowsError(try Timecode.decode(timecode: ""))
        XCTAssertThrowsError(try Timecode.decode(timecode: "01564523"))
        XCTAssertEqual(
            try Timecode.decode(timecode: "0:0:0:0"),
            Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "0:00:00:00"),
            Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "00:00:00:00"),
            Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "1:56:45:23"),
            Timecode.Components(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "01:56:45:23"),
            Timecode.Components(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "3 01:56:45:23"),
            Timecode.Components(d:  3, h: 01, m: 56, s: 45, f: 23, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "12 01:56:45:23"),
            Timecode.Components(d: 12, h: 1, m: 56, s: 45, f: 23, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "12:01:56:45:23"),
            Timecode.Components(d: 12, h: 1, m: 56, s: 45, f: 23, sf: 00)
        )
        
        // drop frame
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "0:0:0;0"),
            Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "0:00:00;00"),
            Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "00:00:00;00"),
            Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "1:56:45;23"),
            Timecode.Components(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 0)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "01:56:45;23"),
            Timecode.Components(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 0)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "3 01:56:45;23"),
            Timecode.Components(d:  3, h: 01, m: 56, s: 45, f: 23, sf: 0)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "12 01:56:45;23"),
            Timecode.Components(d: 12, h: 01, m: 56, s: 45, f: 23, sf: 0)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "12:01:56:45;23"),
            Timecode.Components(d: 12, h: 01, m: 56, s: 45, f: 23, sf: 0)
        )
        
        // all semicolons (such as from Adobe Premiere in its XMP format)
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "0;0;0;0"),
            Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "0;00;00;00"),
            Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "00;00;00;00"),
            Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "1;56;45;23"),
            Timecode.Components(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "01;56;45;23"),
            Timecode.Components(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "3 01;56;45;23"),
            Timecode.Components(d:  3, h: 01, m: 56, s: 45, f: 23, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "12 01;56;45;23"),
            Timecode.Components(d: 12, h: 1, m: 56, s: 45, f: 23, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "12;01;56;45;23"),
            Timecode.Components(d: 12, h: 1, m: 56, s: 45, f: 23, sf: 00)
        )
        
        // drop frame
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "0:0:0;0"),
            Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "0:00:00;00"),
            Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "00:00:00;00"),
            Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "1:56:45;23"),
            Timecode.Components(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 0)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "01:56:45;23"),
            Timecode.Components(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 0)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "3 01:56:45;23"),
            Timecode.Components(d:  3, h: 01, m: 56, s: 45, f: 23, sf: 0)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "12 01:56:45;23"),
            Timecode.Components(d: 12, h: 01, m: 56, s: 45, f: 23, sf: 0)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "12:01:56:45;23"),
            Timecode.Components(d: 12, h: 01, m: 56, s: 45, f: 23, sf: 0)
        )
        
        // all periods - not supporting this.
        
        XCTAssertThrowsError(try Timecode.decode(timecode: "0.0.0.0"))
        XCTAssertThrowsError(try Timecode.decode(timecode: "0.00.00.00"))
        XCTAssertThrowsError(try Timecode.decode(timecode: "00.00.00.00"))
        XCTAssertThrowsError(try Timecode.decode(timecode: "1.56.45.23"))
        XCTAssertThrowsError(try Timecode.decode(timecode: "01.56.45.23"))
        XCTAssertThrowsError(try Timecode.decode(timecode: "3 01.56.45.23"))
        XCTAssertThrowsError(try Timecode.decode(timecode: "12.01.56.45.23"))
        XCTAssertThrowsError(try Timecode.decode(timecode: "12.01.56.45.23"))
        
        // subframes
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "0:00:00:00.05"),
            Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 05)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "00:00:00:00.05"),
            Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 05)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "1:56:45:23.05"),
            Timecode.Components(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 05)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "01:56:45:23.05"),
            Timecode.Components(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 05)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "3 01:56:45:23.05"),
            Timecode.Components(d:  3, h: 01, m: 56, s: 45, f: 23, sf: 05)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "12 01:56:45:23.05"),
            Timecode.Components(d: 12, h: 01, m: 56, s: 45, f: 23, sf: 05)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "12:01:56:45:23.05"),
            Timecode.Components(d: 12, h: 01, m: 56, s: 45, f: 23, sf: 05)
        )
        
        // subframes
        // all semicolons (such as from Adobe Premiere in its XMP format)
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "0;00;00;00.05"),
            Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 05)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "00;00;00;00.05"),
            Timecode.Components(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 05)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "1;56;45;23.05"),
            Timecode.Components(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 05)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "01;56;45;23.05"),
            Timecode.Components(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 05)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "3 01;56;45;23.05"),
            Timecode.Components(d:  3, h: 01, m: 56, s: 45, f: 23, sf: 05)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "12 01;56;45;23.05"),
            Timecode.Components(d: 12, h: 01, m: 56, s: 45, f: 23, sf: 05)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "12;01;56;45;23.05"),
            Timecode.Components(d: 12, h: 01, m: 56, s: 45, f: 23, sf: 05)
        )
    }
    
    // MARK: - .timecode()
    
    func testString_toTimeCode_at() throws {
        // timecode(at:)
        
        XCTAssertEqual(
            try "01:05:20:14".timecode(at: ._23_976),
            try Timecode(
                .components(h: 1, m: 5, s: 20, f: 14),
                at: ._23_976
            )
        )
        
        // timecode(at:) with subframes
        
        let tcWithSubFrames = try "01:05:20:14.94"
            .timecode(
                at: ._23_976,
                base: ._100SubFrames
            )
        XCTAssertEqual(
            tcWithSubFrames,
            try Timecode(
                .components(h: 1, m: 5, s: 20, f: 14, sf: 94),
                at: ._23_976,
                base: ._100SubFrames
            )
        )
        XCTAssertEqual(
            tcWithSubFrames.stringValue(format: .showSubFrames),
            "01:05:20:14.94"
        )
    }
    
    func testString_toTimeCode_rawValuesAt() throws {
        // timecode(rawValuesAt:)
        
        XCTAssertEqual(
            try "01:05:20:14".timecode(at: ._23_976, by: .allowingInvalid),
            try Timecode(
                .components(h: 1, m: 5, s: 20, f: 14),
                at: ._23_976
            )
        )
        
        // timecode(rawValuesAt:) with subframes
        
        let tcWithSubFrames = try "01:05:20:14.94"
            .timecode(
                at: ._23_976,
                base: ._100SubFrames,
                by: .allowingInvalid
            )
        XCTAssertEqual(
            tcWithSubFrames,
            try Timecode(
                .components(h: 1, m: 5, s: 20, f: 14, sf: 94),
                at: ._23_976,
                base: ._100SubFrames
            )
        )
        XCTAssertEqual(
            tcWithSubFrames.stringValue(format: .showSubFrames),
            "01:05:20:14.94"
        )
    }
}

#endif
