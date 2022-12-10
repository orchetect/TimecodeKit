//
//  Timecode Components Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import TimecodeKit

class Timecode_UT_DI_Components_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testTimecode_init_Components_Exactly() throws {
        try TimecodeFrameRate.allCases.forEach {
            let tc = try Timecode(
                TCC(d: 0, h: 0, m: 0, s: 0, f: 0),
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
        
        try TimecodeFrameRate.allCases.forEach {
            let tc = try Timecode(
                TCC(d: 0, h: 1, m: 2, s: 3, f: 4),
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
    
    func testTimecode_init_Components_Clamping() {
        let tc = Timecode(
            clamping: TCC(h: 25),
            at: ._24,
            limit: ._24hours
        )
        
        XCTAssertEqual(
            tc.components,
            TCC(h: 23, m: 59, s: 59, f: 23, sf: tc.subFramesBase.rawValue - 1)
        )
    }
    
    func testTimecode_init_Components_ClampingEach() {
        let tc = Timecode(
            clampingEach: TCC(h: 25),
            at: ._24,
            limit: ._24hours
        )
        
        XCTAssertEqual(
            tc.components,
            TCC(h: 23, m: 00, s: 00, f: 00)
        )
    }
    
    func testTimecode_init_Components_Wrapping() {
        TimecodeFrameRate.allCases.forEach {
            let tc = Timecode(
                wrapping: TCC(h: 25),
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
    
    func testTimecode_init_Components_RawValues() {
        TimecodeFrameRate.allCases.forEach {
            let tc = Timecode(
                rawValues: TCC(d: 99, h: 99, m: 99, s: 99, f: 99, sf: 99),
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
    
    func testTimecode_components_24hours() {
        // default
        
        var tc = Timecode(at: ._30)
        
        XCTAssertEqual(tc.days, 0)
        XCTAssertEqual(tc.hours, 0)
        XCTAssertEqual(tc.minutes, 0)
        XCTAssertEqual(tc.seconds, 0)
        XCTAssertEqual(tc.frames, 0)
        XCTAssertEqual(tc.subFrames, 0)
        
        // setter
        
        tc.components = TCC(h: 1, m: 2, s: 3, f: 4, sf: 5)
        
        XCTAssertEqual(tc.days, 0)
        XCTAssertEqual(tc.hours, 1)
        XCTAssertEqual(tc.minutes, 2)
        XCTAssertEqual(tc.seconds, 3)
        XCTAssertEqual(tc.frames, 4)
        XCTAssertEqual(tc.subFrames, 5)
        
        // getter
        
        let c = tc.components
        
        XCTAssertEqual(c.d, 0)
        XCTAssertEqual(c.h, 1)
        XCTAssertEqual(c.m, 2)
        XCTAssertEqual(c.s, 3)
        XCTAssertEqual(c.f, 4)
        XCTAssertEqual(c.sf, 5)
    }
    
    func testTimecode_components_100days() {
        // default
        
        var tc = Timecode(at: ._30, limit: ._100days)
        
        XCTAssertEqual(tc.days, 0)
        XCTAssertEqual(tc.hours, 0)
        XCTAssertEqual(tc.minutes, 0)
        XCTAssertEqual(tc.seconds, 0)
        XCTAssertEqual(tc.frames, 0)
        XCTAssertEqual(tc.subFrames, 0)
        
        // setter
        
        tc.components = TCC(d: 5, h: 1, m: 2, s: 3, f: 4, sf: 5)
        
        XCTAssertEqual(tc.days, 5)
        XCTAssertEqual(tc.hours, 1)
        XCTAssertEqual(tc.minutes, 2)
        XCTAssertEqual(tc.seconds, 3)
        XCTAssertEqual(tc.frames, 4)
        XCTAssertEqual(tc.subFrames, 5)
        
        // getter
        
        let c = tc.components
        
        XCTAssertEqual(c.d, 5)
        XCTAssertEqual(c.h, 1)
        XCTAssertEqual(c.m, 2)
        XCTAssertEqual(c.s, 3)
        XCTAssertEqual(c.f, 4)
        XCTAssertEqual(c.sf, 5)
    }
    
    func testSetTimecodeExactly() throws {
        // this is not meant to test the underlying logic, simply that .setTimecode produces the intended outcome
        
        var tc = Timecode(at: ._30)
        
        try tc.setTimecode(exactly: TCC(h: 1, m: 2, s: 3, f: 4, sf: 5))
        
        XCTAssertEqual(tc.days, 0)
        XCTAssertEqual(tc.hours, 1)
        XCTAssertEqual(tc.minutes, 2)
        XCTAssertEqual(tc.seconds, 3)
        XCTAssertEqual(tc.frames, 4)
        XCTAssertEqual(tc.subFrames, 5)
    }
    
    func testSetTimecodeClamping() {
        // this is not meant to test the underlying logic, simply that .setTimecode produces the intended outcome
        
        var tc = Timecode(at: ._30, base: ._80SubFrames)
        
        tc.setTimecode(clampingEach: TCC(d: 1, h: 70, m: 70, s: 70, f: 70, sf: 500))
        
        XCTAssertEqual(tc.days, 0)
        XCTAssertEqual(tc.hours, 23)
        XCTAssertEqual(tc.minutes, 59)
        XCTAssertEqual(tc.seconds, 59)
        XCTAssertEqual(tc.frames, 29)
        XCTAssertEqual(tc.subFrames, 79)
    }
    
    func testSetTimecodeWrapping() {
        // this is not meant to test the underlying logic, simply that .setTimecode produces the intended outcome
        
        var tc = Timecode(at: ._30)
        
        tc.setTimecode(wrapping: TCC(f: -1))
        
        XCTAssertEqual(tc.days, 0)
        XCTAssertEqual(tc.hours, 23)
        XCTAssertEqual(tc.minutes, 59)
        XCTAssertEqual(tc.seconds, 59)
        XCTAssertEqual(tc.frames, 29)
        XCTAssertEqual(tc.subFrames, 0)
    }
    
    // MARK: - .toTimecode()
    
    func testTCC_toTimecode() throws {
        // toTimecode(rawValuesAt:)
        
        XCTAssertEqual(
            try TCC(h: 1, m: 5, s: 20, f: 14)
                .toTimecode(at: ._23_976),
            try Timecode(
                TCC(h: 1, m: 5, s: 20, f: 14),
                at: ._23_976
            )
        )
        
        // toTimecode(rawValuesAt:) with subframes
        
        let tcWithSubFrames = try TCC(h: 1, m: 5, s: 20, f: 14, sf: 94)
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
    
    func testTCC_toTimeCode_rawValuesAt() throws {
        // toTimecode(rawValuesAt:)
        
        XCTAssertEqual(
            TCC(h: 1, m: 5, s: 20, f: 14)
                .toTimecode(rawValuesAt: ._23_976),
            try Timecode(
                TCC(h: 1, m: 5, s: 20, f: 14),
                at: ._23_976
            )
        )
        
        // toTimecode(rawValuesAt:) with subframes
        
        let tcWithSubFrames = TCC(h: 1, m: 5, s: 20, f: 14, sf: 94)
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
