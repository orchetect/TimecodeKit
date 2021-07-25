//
//  Components Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//

#if !os(watchOS)

import XCTest
@testable import TimecodeKit

class Timecode_UT_Components_Tests: XCTestCase {
    
    override func setUp() { }
    override func tearDown() { }
    
    func testTCC_toTimecode() {
        
        // toTimecode(rawValuesAt:)
        
        XCTAssertEqual(
            TCC(h: 1, m: 5, s: 20, f: 14)
                .toTimecode(at: ._23_976),
            Timecode(TCC(h: 1, m: 5, s: 20, f: 14),
                     at: ._23_976)
        )
        
        // toTimecode(rawValuesAt:) with subframes
        
        let tcWithSubFrames = TCC(h: 1, m: 5, s: 20, f: 14, sf: 94)
            .toTimecode(at: ._23_976,
                        subFramesDivisor: 100,
                        displaySubFrames: true)
        XCTAssertEqual(
            tcWithSubFrames,
            Timecode(TCC(h: 1, m: 5, s: 20, f: 14, sf: 94),
                     at: ._23_976,
                     subFramesDivisor: 100,
                     displaySubFrames: true)
        )
        XCTAssertEqual(
            tcWithSubFrames?.stringValue,
            "01:05:20:14.94"
        )
        
    }
    
    func testTCC_toTimeCode_rawValuesAt() {
        
        // toTimecode(rawValuesAt:)
        
        XCTAssertEqual(
            TCC(h: 1, m: 5, s: 20, f: 14)
                .toTimecode(rawValuesAt: ._23_976),
            Timecode(TCC(h: 1, m: 5, s: 20, f: 14),
                     at: ._23_976)
        )
        
        // toTimecode(rawValuesAt:) with subframes
        
        let tcWithSubFrames = TCC(h: 1, m: 5, s: 20, f: 14, sf: 94)
            .toTimecode(rawValuesAt: ._23_976,
                        subFramesDivisor: 100,
                        displaySubFrames: true)
        XCTAssertEqual(
            tcWithSubFrames,
            Timecode(TCC(h: 1, m: 5, s: 20, f: 14, sf: 94),
                     at: ._23_976,
                     subFramesDivisor: 100,
                     displaySubFrames: true)
        )
        XCTAssertEqual(
            tcWithSubFrames.stringValue,
            "01:05:20:14.94"
        )
        
    }
    
}

#endif
