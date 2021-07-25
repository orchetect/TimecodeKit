//
//  Timecode init Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//

#if !os(watchOS)

import XCTest
@testable import TimecodeKit

class Timecode_UT_init_Tests: XCTestCase {
    
    override func setUp() { }
    override func tearDown() { }
    
    func testTimecode_init_Defaults() {
        
        // essential inits
        
        // defaults
        
        var tc = Timecode(at: ._24)
        XCTAssertEqual(tc.frameRate, ._24)
        XCTAssertEqual(tc.upperLimit, ._24hours)
        XCTAssertEqual(tc.totalElapsedFrames, 0)
        XCTAssertEqual(tc.components, TCC(d: 0, h: 0, m: 0, s: 0, f: 0))
        XCTAssertEqual(tc.stringValue, "00:00:00:00")
        
        // expected initializers
        
        tc = Timecode(at: ._24)
        tc = Timecode(at: ._24, limit: ._24hours)
        tc = Timecode(at: ._24, limit: ._24hours, subFramesDivisor: 80)
        tc = Timecode(at: ._24, limit: ._24hours, subFramesDivisor: 80, displaySubFrames: true)
        
    }
    
    // ____ basic inits, using (exactly: ) ____
    
    func testTimecode_init_String() {
        
        Timecode.FrameRate.allCases.forEach {
            let tc = Timecode("00:00:00:00",
                              at: $0,
                              limit: ._24hours)
            
            XCTAssertEqual(tc?.days		, 0		, "for \($0)")
            XCTAssertEqual(tc?.hours	, 0		, "for \($0)")
            XCTAssertEqual(tc?.minutes	, 0		, "for \($0)")
            XCTAssertEqual(tc?.seconds	, 0		, "for \($0)")
            XCTAssertEqual(tc?.frames	, 0		, "for \($0)")
            XCTAssertEqual(tc?.subFrames, 0		, "for \($0)")
        }
        
        Timecode.FrameRate.allCases.forEach {
            let tc = Timecode("01:02:03:04",
                              at: $0,
                              limit: ._24hours)
            
            XCTAssertEqual(tc?.days		, 0		, "for \($0)")
            XCTAssertEqual(tc?.hours	, 1		, "for \($0)")
            XCTAssertEqual(tc?.minutes	, 2		, "for \($0)")
            XCTAssertEqual(tc?.seconds	, 3		, "for \($0)")
            XCTAssertEqual(tc?.frames	, 4		, "for \($0)")
            XCTAssertEqual(tc?.subFrames, 0		, "for \($0)")
        }
        
    }
    
    func testTimecode_init_Components() {
        
        Timecode.FrameRate.allCases.forEach {
            let tc = Timecode(TCC(d: 0, h: 0, m: 0, s: 0, f: 0),
                              at: $0,
                              limit: ._24hours)
            
            XCTAssertEqual(tc?.days		, 0		, "for \($0)")
            XCTAssertEqual(tc?.hours	, 0		, "for \($0)")
            XCTAssertEqual(tc?.minutes	, 0		, "for \($0)")
            XCTAssertEqual(tc?.seconds	, 0		, "for \($0)")
            XCTAssertEqual(tc?.frames	, 0		, "for \($0)")
            XCTAssertEqual(tc?.subFrames, 0		, "for \($0)")
        }
        
        Timecode.FrameRate.allCases.forEach {
            let tc = Timecode(TCC(d: 0, h: 1, m: 2, s: 3, f: 4),
                              at: $0,
                              limit: ._24hours)
            
            XCTAssertEqual(tc?.days		, 0		, "for \($0)")
            XCTAssertEqual(tc?.hours	, 1		, "for \($0)")
            XCTAssertEqual(tc?.minutes	, 2		, "for \($0)")
            XCTAssertEqual(tc?.seconds	, 3		, "for \($0)")
            XCTAssertEqual(tc?.frames	, 4		, "for \($0)")
            XCTAssertEqual(tc?.subFrames, 0		, "for \($0)")
        }
        
    }
    
    func testTimecode_init_All_DisplaySubFrames() {
        
        Timecode.FrameRate.allCases.forEach {
            let tc = Timecode("00:00:00:00",
                              at: $0,
                              limit: ._24hours,
                              subFramesDivisor: 100,
                              displaySubFrames: true)
            
            var frm: String
            switch $0.numberOfDigits {
            case 2: frm = "00"
            case 3: frm = "000"
            default:
                XCTFail("Unhandled number of frames digits.")
                return
            }
            
            let frSep = $0.isDrop ? ";" : ":"
            
            XCTAssertEqual(tc?.stringValue, "00:00:00\(frSep)\(frm).00")
            
        }
        
    }
    
}

#endif
