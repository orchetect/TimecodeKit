//
//  Timecode init Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

@testable import TimecodeKit
import XCTest

final class Timecode_init_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    // MARK: - Basic
    
    func testTimecode_init_Defaults() {
        // essential inits
        
        // defaults
        
        let tc = Timecode(.zero, at: .fps24)
        XCTAssertEqual(tc.frameRate, .fps24)
        XCTAssertEqual(tc.upperLimit, .max24Hours)
        XCTAssertEqual(tc.frameCount.subFrameCount, 0)
        XCTAssertEqual(tc.components, Timecode.Components(d: 0, h: 0, m: 0, s: 0, f: 0))
        XCTAssertEqual(tc.stringValue(), "00:00:00:00")
    }
    
    // MARK: - Misc
    
    func testTimecode_init_All_DisplaySubFrames() throws {
        try TimecodeFrameRate.allCases.forEach {
            let tc = try Timecode(
                .string("00:00:00:00"),
                at: $0,
                base: .max100SubFrames,
                limit: .max24Hours
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
            
            XCTAssertEqual(tc.stringValue(format: .showSubFrames), "00:00:00\(frSep)\(frm).00")
        }
    }
}
