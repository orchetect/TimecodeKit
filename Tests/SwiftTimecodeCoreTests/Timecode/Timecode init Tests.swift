//
//  Timecode init Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

@testable import SwiftTimecodeCore
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
        for item in TimecodeFrameRate.allCases {
            let tc = try Timecode(
                .string("00:00:00:00"),
                at: item,
                base: .max100SubFrames,
                limit: .max24Hours
            )
            
            var frm: String
            switch item.numberOfDigits {
            case 2: frm = "00"
            case 3: frm = "000"
            default:
                XCTFail("Unhandled number of frames digits.")
                continue
            }
            
            let frSep = item.isDrop ? ";" : ":"
            
            XCTAssertEqual(tc.stringValue(format: [.showSubFrames]), "00:00:00\(frSep)\(frm).00")
        }
    }
}
