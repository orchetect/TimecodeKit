//
//  Timecode Conversion Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit

#if !os(watchOS)

import XCTest
@testable import TimecodeKit

class Timecode_UT_Conversion_Tests: XCTestCase {
    
    override func setUp() { }
    override func tearDown() { }
    
    func testConverted() {
        
        // baseline check:
        // ensure conversion produces identical output if frame rates are equal
        
        Timecode.FrameRate.allCases.forEach {
            
            let tc = TCC(h: 1)
                .toTimecode(at: $0)
            
            let convertedTC = tc?.converted(to: $0)
            
            XCTAssertNotNil(convertedTC)
            XCTAssertEqual(tc, convertedTC)
            
        }
        
        // spot-check an example conversion
        
        let convertedTC = TCC(h: 1)
            .toTimecode(at: ._23_976,
                        base: ._100SubFrames,
                        format: [.showSubFrames])?
            .converted(to: ._30)
        
        XCTAssertNotNil(convertedTC)
        XCTAssertEqual(convertedTC?.frameRate, ._30)
        XCTAssertEqual(convertedTC?.components, TCC(h: 1, m: 00, s: 03, f: 18, sf: 00))
        
    }
    
}

#endif
