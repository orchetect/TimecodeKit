//
//  Timecode String Extensions Tests.swift
//  TimecodeKitTests
//
//  Created by Steffan Andrews on 2020-06-16.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

import XCTest
@testable import TimecodeKit

class Timecode_UT_Swift_Extensions_Tests: XCTestCase {
	
	override func setUp() { }
	override func tearDown() { }
	
	func testString_toTimeCode_at() {
		
		// toTimecode(at:)
		
		XCTAssertEqual(
			"01:05:20:14".toTimecode(at: ._23_976),
			Timecode(TCC(h: 1, m: 5, s: 20, f: 14),
					 at: ._23_976)
		)
		
		// toTimecode(at:) with subframes
		
		let tcWithSubFrames = "01:05:20:14.94"
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
	
	func testString_toTimeCode_rawValuesAt() {
		
		// toTimecode(rawValuesAt:)
		
		XCTAssertEqual(
			"01:05:20:14".toTimecode(rawValuesAt: ._23_976),
			Timecode(TCC(h: 1, m: 5, s: 20, f: 14),
					 at: ._23_976)
		)
		
		// toTimecode(rawValuesAt:) with subframes
		
		let tcWithSubFrames = "01:05:20:14.94"
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
			tcWithSubFrames?.stringValue,
			"01:05:20:14.94"
		)
		
	}
	
}

#endif
