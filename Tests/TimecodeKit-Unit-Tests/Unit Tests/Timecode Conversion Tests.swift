//
//  Timecode Conversion Tests.swift
//  TimecodeKitTests
//
//  Created by Steffan Andrews on 2020-10-26.
//  Copyright © 2020 Steffan Andrews. All rights reserved.

#if !os(watchOS)

import XCTest
@testable import TimecodeKit

class Timecode_UT_Conversion: XCTestCase {
	
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
                        subFramesDivisor: 100,
                        displaySubFrames: true)?
            .converted(to: ._30)
        
        XCTAssertNotNil(convertedTC)
        XCTAssertEqual(convertedTC?.frameRate, ._30)
        XCTAssertEqual(convertedTC?.components, TCC(h: 1, m: 00, s: 03, f: 18, sf: 00))
        
	}
	
}

#endif
