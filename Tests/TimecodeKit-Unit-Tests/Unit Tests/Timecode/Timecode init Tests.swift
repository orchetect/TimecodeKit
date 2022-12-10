//
//  Timecode init Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import TimecodeKit

class Timecode_UT_init_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    // MARK: - Basic
    
    func testTimecode_init_Defaults() {
        // essential inits
        
        // defaults
        
        var tc = Timecode(at: ._24)
        XCTAssertEqual(tc.frameRate, ._24)
        XCTAssertEqual(tc.upperLimit, ._24hours)
        XCTAssertEqual(tc.frameCount.subFrameCount, 0)
        XCTAssertEqual(tc.components, TCC(d: 0, h: 0, m: 0, s: 0, f: 0))
        XCTAssertEqual(tc.stringValue, "00:00:00:00")
        
        // expected initializers
        
        tc = Timecode(at: ._24)
        tc = Timecode(at: ._24, limit: ._24hours)
        tc = Timecode(at: ._24, limit: ._24hours, base: ._100SubFrames)
        tc = Timecode(at: ._24, limit: ._24hours, base: ._100SubFrames, format: [.showSubFrames])
        
        tc = Timecode(at: ._24, base: ._100SubFrames)
        tc = Timecode(at: ._24, base: ._100SubFrames, format: [.showSubFrames])
        
        tc = Timecode(at: ._24, format: [.showSubFrames])
    }
    
    // MARK: - Misc
    
    func testTimecode_init_All_DisplaySubFrames() throws {
        try TimecodeFrameRate.allCases.forEach {
            let tc = try Timecode(
                "00:00:00:00",
                at: $0,
                limit: ._24hours,
                base: ._100SubFrames,
                format: [.showSubFrames]
            )
            
            var frm: String
            switch $0.numberOfDigits {
            case 2: frm = "00"
            case 3: frm = "000"
            default:
                XCTFail("Unhandled number of frames digits.")
                return
            }
            
            let frSep = $0.isDrop ? ";" : ":"
            
            XCTAssertEqual(tc.stringValue, "00:00:00\(frSep)\(frm).00")
        }
    }
}

#endif
