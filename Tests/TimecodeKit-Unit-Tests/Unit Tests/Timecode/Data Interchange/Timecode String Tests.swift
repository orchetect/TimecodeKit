//
//  Timecode String Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform
import XCTest
@testable import TimecodeKit

class Timecode_UT_DI_String_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testTimecode_init_String_Exactly() throws {
        try Timecode.FrameRate.allCases.forEach {
            let tc = try Timecode(
                "00:00:00:00",
                at: $0,
                limit: ._24hours
            )
            
            XCTAssertEqual(tc.days, 0, "for \($0)")
            XCTAssertEqual(tc.hours, 0, "for \($0)")
            XCTAssertEqual(tc.minutes, 0, "for \($0)")
            XCTAssertEqual(tc.seconds, 0, "for \($0)")
            XCTAssertEqual(tc.frames, 0, "for \($0)")
            XCTAssertEqual(tc.subFrames, 0, "for \($0)")
        }
        
        try Timecode.FrameRate.allCases.forEach {
            let tc = try Timecode(
                "01:02:03:04",
                at: $0,
                limit: ._24hours
            )
            
            XCTAssertEqual(tc.days, 0, "for \($0)")
            XCTAssertEqual(tc.hours, 1, "for \($0)")
            XCTAssertEqual(tc.minutes, 2, "for \($0)")
            XCTAssertEqual(tc.seconds, 3, "for \($0)")
            XCTAssertEqual(tc.frames, 4, "for \($0)")
            XCTAssertEqual(tc.subFrames, 0, "for \($0)")
        }
    }
    
    func testTimecode_init_String_Clamping() throws {
        let tc = try Timecode(
            clamping: "25:00:00:00",
            at: ._24,
            limit: ._24hours
        )
        
        XCTAssertEqual(
            tc.components,
            TCC(h: 23, m: 59, s: 59, f: 23, sf: tc.subFramesBase.rawValue - 1)
        )
    }
    
    func testTimecode_init_String_ClampingEach() throws {
        let tc = try Timecode(
            clampingEach: "25:00:00:00",
            at: ._24,
            limit: ._24hours
        )
        
        XCTAssertEqual(
            tc.components,
            TCC(h: 23, m: 00, s: 00, f: 00)
        )
    }
    
    func testTimecode_init_String_Wrapping() throws {
        try Timecode.FrameRate.allCases.forEach {
            let tc = try Timecode(
                wrapping: "25:00:00:00",
                at: $0,
                limit: ._24hours
            )
            
            XCTAssertEqual(tc.days, 0, "for \($0)")
            XCTAssertEqual(tc.hours, 1, "for \($0)")
            XCTAssertEqual(tc.minutes, 0, "for \($0)")
            XCTAssertEqual(tc.seconds, 0, "for \($0)")
            XCTAssertEqual(tc.frames, 0, "for \($0)")
            XCTAssertEqual(tc.subFrames, 0, "for \($0)")
        }
    }
    
    func testTimecode_init_String_RawValues() throws {
        try Timecode.FrameRate.allCases.forEach {
            let tc = try Timecode(
                rawValues: "99 99:99:99:99.99",
                at: $0,
                limit: ._24hours
            )
            
            XCTAssertEqual(tc.days, 99, "for \($0)")
            XCTAssertEqual(tc.hours, 99, "for \($0)")
            XCTAssertEqual(tc.minutes, 99, "for \($0)")
            XCTAssertEqual(tc.seconds, 99, "for \($0)")
            XCTAssertEqual(tc.frames, 99, "for \($0)")
            XCTAssertEqual(tc.subFrames, 99, "for \($0)")
        }
    }
    
    func testStringValue_GetSet_Basic() throws {
        // basic getter tests
        
        var tc = Timecode(at: ._23_976, limit: ._24hours)
        
        try tc.setTimecode(exactly: "01:05:20:14")
        XCTAssertEqual(tc.stringValue, "01:05:20:14")
        
        XCTAssertThrowsError(try tc.setTimecode(exactly: "50:05:20:14"))
        XCTAssertEqual(tc.stringValue, "01:05:20:14") // no change
        
        try tc.setTimecode(clampingEach: "50:05:20:14")
        XCTAssertEqual(tc.stringValue, "23:05:20:14")
    }
    
    func testStringValue_Get_Formatting_Basic() throws {
        // basic string formatting - ie: HH:MM:SS:FF
        // using known valid timecode components; not testing for invalid values here
        
        // 24 hour limit
        
        // non-drop
        
        try Timecode.FrameRate.allNonDrop.forEach {
            let sv = try TCC(h: 1, m: 02, s: 03, f: 04)
                .toTimecode(at: $0)
                .stringValue
            
            let t = $0.numberOfDigits == 2 ? "" : "0"
            
            XCTAssertEqual(sv, "01:02:03:\(t)04", "for \($0)")
        }
        
        // drop
        
        try Timecode.FrameRate.allDrop.forEach {
            let sv = try TCC(h: 1, m: 02, s: 03, f: 04)
                .toTimecode(at: $0)
                .stringValue
            
            let t = $0.numberOfDigits == 2 ? "" : "0"
            
            XCTAssertEqual(sv, "01:02:03;\(t)04", "for \($0)")
        }
        
        // 100 days limit
        
        // non-drop
        
        try Timecode.FrameRate.allNonDrop.forEach {
            let sv = try TCC(h: 1, m: 02, s: 03, f: 04)
                .toTimecode(at: $0, limit: ._100days)
                .stringValue
            
            let t = $0.numberOfDigits == 2 ? "" : "0"
            
            XCTAssertEqual(sv, "01:02:03:\(t)04", "for \($0)")  // omits days since they are 0
        }
        
        // drop
        
        try Timecode.FrameRate.allDrop.forEach {
            let sv = try TCC(h: 1, m: 02, s: 03, f: 04)
                .toTimecode(at: $0, limit: ._100days)
                .stringValue
            
            let t = $0.numberOfDigits == 2 ? "" : "0"
            
            XCTAssertEqual(sv, "01:02:03;\(t)04", "for \($0)")  // omits days since they are 0
        }
    }
    
    func testStringValue_Get_Formatting_WithDays() throws {
        // string formatting with days - ie: "D HH:MM:SS:FF"
        // using known valid timecode components; not testing for invalid values here
        
        // non-drop
        
        try Timecode.FrameRate.allNonDrop.forEach {
            var tc = try TCC(h: 1, m: 02, s: 03, f: 04)
                .toTimecode(at: $0)
            tc.days = 2 // set days after init since init fails if we pass days
            
            let t = $0.numberOfDigits == 2 ? "" : "0"
            
            // still produces days since we have not clamped it yet
            var sv = tc.stringValue
            XCTAssertEqual(sv, "2 01:02:03:\(t)04", "for \($0)")
            
            // now omits days since our limit is 24hr and clamped
            tc.clampComponents()
            sv = tc.stringValue
            XCTAssertEqual(sv, "01:02:03:\(t)04", "for \($0)")
        }
        
        // drop
        
        try Timecode.FrameRate.allDrop.forEach {
            var tc = try TCC(h: 1, m: 02, s: 03, f: 04)
                .toTimecode(at: $0)
            tc
                .days =
                2                        // set days after init since init fails if we pass days
            
            let t = $0.numberOfDigits == 2 ? "" : "0"
            
            // still produces days since we have not clamped it yet
            var sv = tc.stringValue
            XCTAssertEqual(sv, "2 01:02:03;\(t)04", "for \($0)")
            
            // now omits days since our limit is 24hr and clamped
            tc.clampComponents()
            sv = tc.stringValue
            XCTAssertEqual(sv, "01:02:03;\(t)04", "for \($0)")
        }
        
        // 100 days limit
        
        // non-drop
        
        try Timecode.FrameRate.allNonDrop.forEach {
            let sv = try TCC(d: 2, h: 1, m: 02, s: 03, f: 04)
                .toTimecode(at: $0, limit: ._100days)
                .stringValue
            
            let t = $0.numberOfDigits == 2 ? "" : "0"
            
            XCTAssertEqual(sv, "2 01:02:03:\(t)04", "for \($0)")
        }
        
        // drop
        
        try Timecode.FrameRate.allDrop.forEach {
            let sv = try TCC(d: 2, h: 1, m: 02, s: 03, f: 04)
                .toTimecode(at: $0, limit: ._100days)
                .stringValue
            
            let t = $0.numberOfDigits == 2 ? "" : "0"
            
            XCTAssertEqual(sv, "2 01:02:03;\(t)04", "for \($0)")
        }
    }
    
    func testStringValue_Get_Formatting_WithSubframes() throws {
        // string formatting with subframes - ie: "HH:MM:SS:FF.sf" (or "D HH:MM:SS:FF.sf" in case of 100 days limit)
        // using known valid timecode components; not testing for invalid values here
        
        // non-drop
        
        try Timecode.FrameRate.allNonDrop.forEach {
            var tc = try TCC(h: 1, m: 02, s: 03, f: 04, sf: 12)
                .toTimecode(at: $0, format: [.showSubFrames])
            tc.days = 2 // set days after init since init @ ._24hour limit fails if we pass days
            
            let t = $0.numberOfDigits == 2 ? "" : "0"
            
            // still produces days since we have not clamped it yet
            var sv = tc.stringValue
            XCTAssertEqual(sv, "2 01:02:03:\(t)04.12", "for \($0)")
            
            // now omits days since our limit is 24hr and clamped
            tc.clampComponents()
            sv = tc.stringValue
            XCTAssertEqual(sv, "01:02:03:\(t)04.12", "for \($0)")
        }
        
        // drop
        
        try Timecode.FrameRate.allDrop.forEach {
            var tc = try TCC(h: 1, m: 02, s: 03, f: 04, sf: 12)
                .toTimecode(at: $0, format: [.showSubFrames])
            tc.days = 2 // set days after init since init @ ._24hour limit fails if we pass days
            
            let t = $0.numberOfDigits == 2 ? "" : "0"
            
            // still produces days since we have not clamped it yet
            var sv = tc.stringValue
            XCTAssertEqual(sv, "2 01:02:03;\(t)04.12", "for \($0)")
            
            // now omits days since our limit is 24hr and clamped
            tc.clampComponents()
            sv = tc.stringValue
            XCTAssertEqual(sv, "01:02:03;\(t)04.12", "for \($0)")
        }
        
        // 100 days limit
        
        // non-drop
        
        try Timecode.FrameRate.allNonDrop.forEach {
            let tc = try TCC(d: 2, h: 1, m: 02, s: 03, f: 04, sf: 12)
                .toTimecode(at: $0, limit: ._100days, format: [.showSubFrames])
            
            let t = $0.numberOfDigits == 2 ? "" : "0"
            
            let sv = tc.stringValue
            XCTAssertEqual(sv, "2 01:02:03:\(t)04.12", "for \($0)")
        }
        
        // drop
        
        try Timecode.FrameRate.allDrop.forEach {
            let tc = try TCC(d: 2, h: 1, m: 02, s: 03, f: 04, sf: 12)
                .toTimecode(at: $0, limit: ._100days, format: [.showSubFrames])
            
            let t = $0.numberOfDigits == 2 ? "" : "0"
            
            let sv = tc.stringValue
            XCTAssertEqual(sv, "2 01:02:03;\(t)04.12", "for \($0)")
        }
    }
    
    func testStringDecode() throws {
        // non-drop frame
        
        XCTAssertThrowsError(try Timecode.decode(timecode: ""))
        XCTAssertThrowsError(try Timecode.decode(timecode: "01564523"))
        XCTAssertEqual(
            try Timecode.decode(timecode: "0:0:0:0"),
            TCC(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "0:00:00:00"),
            TCC(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "00:00:00:00"),
            TCC(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "1:56:45:23"),
            TCC(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "01:56:45:23"),
            TCC(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "3 01:56:45:23"),
            TCC(d:  3, h: 01, m: 56, s: 45, f: 23, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "12 01:56:45:23"),
            TCC(d: 12, h: 1, m: 56, s: 45, f: 23, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "12:01:56:45:23"),
            TCC(d: 12, h: 1, m: 56, s: 45, f: 23, sf: 00)
        )
        
        // drop frame
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "0:0:0;0"),
            TCC(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "0:00:00;00"),
            TCC(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "00:00:00;00"),
            TCC(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "1:56:45;23"),
            TCC(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 0)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "01:56:45;23"),
            TCC(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 0)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "3 01:56:45;23"),
            TCC(d:  3, h: 01, m: 56, s: 45, f: 23, sf: 0)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "12 01:56:45;23"),
            TCC(d: 12, h: 01, m: 56, s: 45, f: 23, sf: 0)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "12:01:56:45;23"),
            TCC(d: 12, h: 01, m: 56, s: 45, f: 23, sf: 0)
        )
        
        // all semicolons (such as from Adobe Premiere in its XMP format)
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "0;0;0;0"),
            TCC(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "0;00;00;00"),
            TCC(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "00;00;00;00"),
            TCC(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "1;56;45;23"),
            TCC(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "01;56;45;23"),
            TCC(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "3 01;56;45;23"),
            TCC(d:  3, h: 01, m: 56, s: 45, f: 23, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "12 01;56;45;23"),
            TCC(d: 12, h: 1, m: 56, s: 45, f: 23, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "12;01;56;45;23"),
            TCC(d: 12, h: 1, m: 56, s: 45, f: 23, sf: 00)
        )
        
        // drop frame
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "0:0:0;0"),
            TCC(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "0:00:00;00"),
            TCC(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "00:00:00;00"),
            TCC(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "1:56:45;23"),
            TCC(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 0)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "01:56:45;23"),
            TCC(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 0)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "3 01:56:45;23"),
            TCC(d:  3, h: 01, m: 56, s: 45, f: 23, sf: 0)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "12 01:56:45;23"),
            TCC(d: 12, h: 01, m: 56, s: 45, f: 23, sf: 0)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "12:01:56:45;23"),
            TCC(d: 12, h: 01, m: 56, s: 45, f: 23, sf: 0)
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
            TCC(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 05)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "00:00:00:00.05"),
            TCC(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 05)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "1:56:45:23.05"),
            TCC(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 05)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "01:56:45:23.05"),
            TCC(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 05)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "3 01:56:45:23.05"),
            TCC(d:  3, h: 01, m: 56, s: 45, f: 23, sf: 05)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "12 01:56:45:23.05"),
            TCC(d: 12, h: 01, m: 56, s: 45, f: 23, sf: 05)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "12:01:56:45:23.05"),
            TCC(d: 12, h: 01, m: 56, s: 45, f: 23, sf: 05)
        )
        
        // subframes
        // all semicolons (such as from Adobe Premiere in its XMP format)
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "0;00;00;00.05"),
            TCC(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 05)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "00;00;00;00.05"),
            TCC(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 05)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "1;56;45;23.05"),
            TCC(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 05)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "01;56;45;23.05"),
            TCC(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 05)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "3 01;56;45;23.05"),
            TCC(d:  3, h: 01, m: 56, s: 45, f: 23, sf: 05)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "12 01;56;45;23.05"),
            TCC(d: 12, h: 01, m: 56, s: 45, f: 23, sf: 05)
        )
        
        XCTAssertEqual(
            try Timecode.decode(timecode: "12;01;56;45;23.05"),
            TCC(d: 12, h: 01, m: 56, s: 45, f: 23, sf: 05)
        )
    }
    
    // MARK: - .toTimecode()
    
    func testString_toTimeCode_at() throws {
        // toTimecode(at:)
        
        XCTAssertEqual(
            try "01:05:20:14".toTimecode(at: ._23_976),
            try Timecode(
                TCC(h: 1, m: 5, s: 20, f: 14),
                at: ._23_976
            )
        )
        
        // toTimecode(at:) with subframes
        
        let tcWithSubFrames = try "01:05:20:14.94"
            .toTimecode(
                at: ._23_976,
                base: ._100SubFrames,
                format: [.showSubFrames]
            )
        XCTAssertEqual(
            tcWithSubFrames,
            try Timecode(
                TCC(h: 1, m: 5, s: 20, f: 14, sf: 94),
                at: ._23_976,
                base: ._100SubFrames,
                format: [.showSubFrames]
            )
        )
        XCTAssertEqual(
            tcWithSubFrames.stringValue,
            "01:05:20:14.94"
        )
    }
    
    func testString_toTimeCode_rawValuesAt() throws {
        // toTimecode(rawValuesAt:)
        
        XCTAssertEqual(
            try "01:05:20:14".toTimecode(rawValuesAt: ._23_976),
            try Timecode(
                TCC(h: 1, m: 5, s: 20, f: 14),
                at: ._23_976
            )
        )
        
        // toTimecode(rawValuesAt:) with subframes
        
        let tcWithSubFrames = try "01:05:20:14.94"
            .toTimecode(
                rawValuesAt: ._23_976,
                base: ._100SubFrames,
                format: [.showSubFrames]
            )
        XCTAssertEqual(
            tcWithSubFrames,
            try Timecode(
                TCC(h: 1, m: 5, s: 20, f: 14, sf: 94),
                at: ._23_976,
                base: ._100SubFrames,
                format: [.showSubFrames]
            )
        )
        XCTAssertEqual(
            tcWithSubFrames.stringValue,
            "01:05:20:14.94"
        )
    }
}

#endif
