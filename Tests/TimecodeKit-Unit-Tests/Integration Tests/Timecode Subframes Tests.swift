//
//  Timecode Subframes Tests.swift
//  TimecodeKitTests
//
//  Created by Steffan Andrews on 2020-10-27.
//  Copyright © 2019 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

import XCTest
@testable import TimecodeKit

class Timecode_IT_SubframesTests: XCTestCase {
	
	// common subframes usage is tested in various places throughout the rest of the unit tests, but subframes edge cases are distilled here for sake of organization
	
	func testTimecode_Subframes_EdgeCases() {
		
		// edge cases: subframes with uncommon divisors
		
		// testing every framerate is not necessary since subframes are framerate-agnostic, so an arbitrary rate of 24 fps is fine here
		
		// set up vars
		var tc: Timecode
		var sfDiv: Int
		
		
		
		// ---- <0 is illegal ----
		
		sfDiv = -1
		
		tc = Timecode(at: ._24, subFramesDivisor: sfDiv)
		tc.displaySubFrames = true
		
		// init allows illegal divisor to be stored
		XCTAssertEqual(tc.subFramesDivisor, sfDiv)
		
		// single digit width
		XCTAssertEqual(tc.stringValue, "00:00:00:00.0")
		
		XCTAssertTrue(tc.setTimecode(clamping: "01:00:00:00.20"))
		
		// clamps to min of 0
		XCTAssertEqual(tc.components, TCC(h: 1, sf: 0))
		
		// single digit width
		XCTAssertEqual(tc.stringValue, "01:00:00:00.0")
		
		
		
		// ---- 0 is illegal ----
		
		sfDiv = 0
		
		tc = Timecode(at: ._24, subFramesDivisor: sfDiv)
		tc.displaySubFrames = true
		
		// init allows illegal divisor to be stored
		XCTAssertEqual(tc.subFramesDivisor, sfDiv)
		
		// single digit width
		XCTAssertEqual(tc.stringValue, "00:00:00:00.0")
		
		XCTAssertTrue(tc.setTimecode(clamping: "01:00:00:00.20"))
		
		// clamps to min of 0
		XCTAssertEqual(tc.components, TCC(h: 1, sf: 0))
		
		// single digit width
		XCTAssertEqual(tc.stringValue, "01:00:00:00.0")
		
		
		
		// ---- 1 is illegal ----
		
		sfDiv = 1
		
		tc = Timecode(at: ._24, subFramesDivisor: sfDiv)
		tc.displaySubFrames = true
		
		// init allows illegal divisor to be stored
		XCTAssertEqual(tc.subFramesDivisor, sfDiv)
		
		// single digit width
		XCTAssertEqual(tc.stringValue, "00:00:00:00.0")
		
		XCTAssertTrue(tc.setTimecode(clamping: "01:00:00:00.20"))
		
		// clamps to min of 0
		XCTAssertEqual(tc.components, TCC(h: 1, sf: 0))
		
		// single digit width
		XCTAssertEqual(tc.stringValue, "01:00:00:00.0")
		
		
		
		// ---- >1 is legal ----
		
		sfDiv = 2 // max value displayable: 1, 1 digit wide
		
		tc = Timecode(at: ._24, subFramesDivisor: sfDiv)
		tc.displaySubFrames = true
		
		XCTAssertEqual(tc.subFramesDivisor, sfDiv)
		
		// single digit width
		XCTAssertEqual(tc.stringValue, "00:00:00:00.0")
		
		XCTAssertTrue(tc.setTimecode(clamping: "01:00:00:00.20"))
		
		// clamps to max of 1
		XCTAssertEqual(tc.components, TCC(h: 1, sf: 1))
		
		// single digit width
		XCTAssertEqual(tc.stringValue, "01:00:00:00.1")
		
		
		
		// ---- very large divisors are allowed ----
		
		sfDiv = 1_000_000 // max value displayable: 999999, 6 digits wide
		
		tc = Timecode(at: ._24, subFramesDivisor: sfDiv)
		tc.displaySubFrames = true
		
		XCTAssertEqual(tc.subFramesDivisor, sfDiv)
		
		// 6-digit width
		XCTAssertEqual(tc.stringValue, "00:00:00:00.000000")
		
		XCTAssertTrue(tc.setTimecode(clamping: "01:00:00:00.2000000"))
		
		// clamps to max of 999,999
		XCTAssertEqual(tc.components, TCC(h: 1, sf: 999_999))
		
		// 6-digit width
		XCTAssertEqual(tc.stringValue, "01:00:00:00.999999")
		
	}
	
}

#endif
