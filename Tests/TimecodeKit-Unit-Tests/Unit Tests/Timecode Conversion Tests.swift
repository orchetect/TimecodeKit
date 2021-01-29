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
	
	func testConverted1to1() {
		
		// baseline check:
		// ensure frame rates convert to themselves
		
		Timecode.FrameRate.allCases.forEach {
			
			let tc = TCC(h: 1)
				.toTimecode(at: $0)
			
			let convertedTC = tc?.converted(to: $0)
			
			XCTAssertEqual(tc, convertedTC)
			
		}
		
	}
	
}

#endif
