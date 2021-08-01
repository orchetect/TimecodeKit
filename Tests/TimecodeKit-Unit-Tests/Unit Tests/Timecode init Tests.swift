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
    
    
    // MARK: - Total Elapsed Frames (FrameCount)
    
    func testTimecode_init_FrameCountValue_Exactly() {
        
        let tc = Timecode(.frames(670907),
                          at: ._30,
                          limit: ._24hours)
        
        XCTAssertEqual(tc?.days      , 0)
        XCTAssertEqual(tc?.hours     , 6)
        XCTAssertEqual(tc?.minutes   , 12)
        XCTAssertEqual(tc?.seconds   , 43)
        XCTAssertEqual(tc?.frames    , 17)
        XCTAssertEqual(tc?.subFrames , 0)
        
    }
    
    func testTimecode_init_FrameCount_Exactly() {
        
        let tc = Timecode(.init(.frames(670907), base: ._80SubFrames),
                          at: ._30,
                          limit: ._24hours)
        
        XCTAssertEqual(tc?.days      , 0)
        XCTAssertEqual(tc?.hours     , 6)
        XCTAssertEqual(tc?.minutes   , 12)
        XCTAssertEqual(tc?.seconds   , 43)
        XCTAssertEqual(tc?.frames    , 17)
        XCTAssertEqual(tc?.subFrames , 0)
        
    }
    
    
    // MARK: - Components
    
    func testTimecode_init_Components_Exactly() {
        
        Timecode.FrameRate.allCases.forEach {
            let tc = Timecode(TCC(d: 0, h: 0, m: 0, s: 0, f: 0),
                              at: $0,
                              limit: ._24hours)
            
            XCTAssertEqual(tc?.days      , 0     , "for \($0)")
            XCTAssertEqual(tc?.hours     , 0     , "for \($0)")
            XCTAssertEqual(tc?.minutes   , 0     , "for \($0)")
            XCTAssertEqual(tc?.seconds   , 0     , "for \($0)")
            XCTAssertEqual(tc?.frames    , 0     , "for \($0)")
            XCTAssertEqual(tc?.subFrames , 0     , "for \($0)")
        }
        
        Timecode.FrameRate.allCases.forEach {
            let tc = Timecode(TCC(d: 0, h: 1, m: 2, s: 3, f: 4),
                              at: $0,
                              limit: ._24hours)
            
            XCTAssertEqual(tc?.days      , 0     , "for \($0)")
            XCTAssertEqual(tc?.hours     , 1     , "for \($0)")
            XCTAssertEqual(tc?.minutes   , 2     , "for \($0)")
            XCTAssertEqual(tc?.seconds   , 3     , "for \($0)")
            XCTAssertEqual(tc?.frames    , 4     , "for \($0)")
            XCTAssertEqual(tc?.subFrames , 0     , "for \($0)")
        }
        
    }
    
    func testTimecode_init_Components_Clamping() {
        
        let tc = Timecode(clamping: TCC(h: 25),
                          at: ._24,
                          limit: ._24hours)
        
        XCTAssertEqual(tc.components,
                       TCC(h: 23, m: 59, s: 59, f: 23, sf: tc.subFramesBase.rawValue - 1))
        
    }
    
    func testTimecode_init_Components_ClampingEach() {
        
        let tc = Timecode(clampingEach: TCC(h: 25),
                          at: ._24,
                          limit: ._24hours)
        
        XCTAssertEqual(tc.components,
                       TCC(h: 23, m: 00, s: 00, f: 00))
        
    }
    
    func testTimecode_init_Components_Wrapping() {
        
        Timecode.FrameRate.allCases.forEach {
            let tc = Timecode(wrapping: TCC(h: 25),
                              at: $0,
                              limit: ._24hours)
            
            XCTAssertEqual(tc.days       , 0     , "for \($0)")
            XCTAssertEqual(tc.hours      , 1     , "for \($0)")
            XCTAssertEqual(tc.minutes    , 0     , "for \($0)")
            XCTAssertEqual(tc.seconds    , 0     , "for \($0)")
            XCTAssertEqual(tc.frames     , 0     , "for \($0)")
            XCTAssertEqual(tc.subFrames  , 0     , "for \($0)")
        }
        
    }
    
    func testTimecode_init_Components_RawValues() {
    
        Timecode.FrameRate.allCases.forEach {
            let tc = Timecode(rawValues: TCC(d: 99, h: 99, m: 99, s: 99, f: 99, sf: 99),
                              at: $0,
                              limit: ._24hours)
            
            XCTAssertEqual(tc.days       , 99    , "for \($0)")
            XCTAssertEqual(tc.hours      , 99    , "for \($0)")
            XCTAssertEqual(tc.minutes    , 99    , "for \($0)")
            XCTAssertEqual(tc.seconds    , 99    , "for \($0)")
            XCTAssertEqual(tc.frames     , 99    , "for \($0)")
            XCTAssertEqual(tc.subFrames  , 99    , "for \($0)")
        }
        
    }
    
    
    // MARK: - String
    
    func testTimecode_init_String_Exactly() {
        
        Timecode.FrameRate.allCases.forEach {
            let tc = Timecode("00:00:00:00",
                              at: $0,
                              limit: ._24hours)
            
            XCTAssertEqual(tc?.days      , 0     , "for \($0)")
            XCTAssertEqual(tc?.hours     , 0     , "for \($0)")
            XCTAssertEqual(tc?.minutes   , 0     , "for \($0)")
            XCTAssertEqual(tc?.seconds   , 0     , "for \($0)")
            XCTAssertEqual(tc?.frames    , 0     , "for \($0)")
            XCTAssertEqual(tc?.subFrames , 0     , "for \($0)")
        }
        
        Timecode.FrameRate.allCases.forEach {
            let tc = Timecode("01:02:03:04",
                              at: $0,
                              limit: ._24hours)
            
            XCTAssertEqual(tc?.days      , 0     , "for \($0)")
            XCTAssertEqual(tc?.hours     , 1     , "for \($0)")
            XCTAssertEqual(tc?.minutes   , 2     , "for \($0)")
            XCTAssertEqual(tc?.seconds   , 3     , "for \($0)")
            XCTAssertEqual(tc?.frames    , 4     , "for \($0)")
            XCTAssertEqual(tc?.subFrames , 0     , "for \($0)")
        }
        
    }
    
    func testTimecode_init_String_Clamping() {
        
        let tc = Timecode(clamping: "25:00:00:00",
                          at: ._24,
                          limit: ._24hours)!
        
        XCTAssertEqual(tc.components,
                       TCC(h: 23, m: 59, s: 59, f: 23, sf: tc.subFramesBase.rawValue - 1))
        
    }
    
    func testTimecode_init_String_ClampingEach() {
        
        let tc = Timecode(clampingEach: "25:00:00:00",
                          at: ._24,
                          limit: ._24hours)!
        
        XCTAssertEqual(tc.components,
                       TCC(h: 23, m: 00, s: 00, f: 00))
        
    }
    
    func testTimecode_init_String_Wrapping() {
        
        Timecode.FrameRate.allCases.forEach {
            let tc = Timecode(wrapping: "25:00:00:00",
                              at: $0,
                              limit: ._24hours)
            
            XCTAssertEqual(tc?.days      , 0     , "for \($0)")
            XCTAssertEqual(tc?.hours     , 1     , "for \($0)")
            XCTAssertEqual(tc?.minutes   , 0     , "for \($0)")
            XCTAssertEqual(tc?.seconds   , 0     , "for \($0)")
            XCTAssertEqual(tc?.frames    , 0     , "for \($0)")
            XCTAssertEqual(tc?.subFrames , 0     , "for \($0)")
        }
    
    }
    
    func testTimecode_init_String_RawValues() {
        
        Timecode.FrameRate.allCases.forEach {
            let tc = Timecode(rawValues: "99 99:99:99:99.99",
                              at: $0,
                              limit: ._24hours)
            
            XCTAssertEqual(tc?.days      , 99    , "for \($0)")
            XCTAssertEqual(tc?.hours     , 99    , "for \($0)")
            XCTAssertEqual(tc?.minutes   , 99    , "for \($0)")
            XCTAssertEqual(tc?.seconds   , 99    , "for \($0)")
            XCTAssertEqual(tc?.frames    , 99    , "for \($0)")
            XCTAssertEqual(tc?.subFrames , 99    , "for \($0)")
        }
        
    }
    
    
    // MARK: - Real time
    
    func testTimecode_init_RealTimeValue() {
        
        Timecode.FrameRate.allCases.forEach {
            let tc = Timecode(realTimeValue: 2,
                              at: $0,
                              limit: ._24hours)
            
            // don't imperatively check each result, just make sure that a value was set;
            // realTimeValue setter logic is unit-tested elsewhere, we just want to check the Timecode.init interface here.
            XCTAssertNotEqual(tc?.seconds, 0, "for \($0)")
        }
        
    }
    
    
    // MARK: - Audio samples
    
    func testTimecode_init_Samples() {
        
        Timecode.FrameRate.allCases.forEach {
            let tc = Timecode(samples: 48000 * 2,
                              sampleRate: 48000,
                              at: $0,
                              limit: ._24hours)
            
            // don't imperatively check each result, just make sure that a value was set;
            // samples setter logic is unit-tested elsewhere, we just want to check the Timecode.init interface here.
            XCTAssertNotEqual(tc?.seconds, 0, "for \($0)")
        }
        
    }
    
    
    // MARK: - Misc
    
    func testTimecode_init_All_DisplaySubFrames() {
        
        Timecode.FrameRate.allCases.forEach {
            let tc = Timecode("00:00:00:00",
                              at: $0,
                              limit: ._24hours,
                              base: ._100SubFrames,
                              format: [.showSubFrames])
            
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
