//
//  Timecode Tests.swift
//  TimecodeKitTests
//
//  Created by Steffan Andrews on 2020-06-16.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

import XCTest
@testable import TimecodeKit

class Timecode_UT_Tests: XCTestCase {
	
	override func setUp() { }
	override func tearDown() { }
	
	func testCodable() {
		
		// set up JSON coders with default settings
		
		let encoder = JSONEncoder()
		let decoder = JSONDecoder()
		
		Timecode.FrameRate.allCases.forEach {
			
			// set up a timecode object that has all non-defaults
			
			let tc = "1 12:34:56:11.85"
				.toTimecode(at: $0,
							limit: ._100days,
							subFramesDivisor: 100,
                            displaySubFrames: true)!
			
			// encode
			
			guard let encoded = try? encoder.encode(tc)
			else {
				XCTFail("JSON encode failed.") ; return
			}
			
			// decode
			
			guard let decoded = try? decoder.decode(Timecode.self, from: encoded)
			else {
				XCTFail("JSON decode failed.") ; return
			}
			
			// compare original to reconstructed
			
			XCTAssertEqual(tc, decoded)
			
			XCTAssertEqual(tc.days, decoded.days)
			XCTAssertEqual(tc.hours, decoded.hours)
			XCTAssertEqual(tc.minutes, decoded.minutes)
			XCTAssertEqual(tc.seconds, decoded.seconds)
			XCTAssertEqual(tc.frames, decoded.frames)
			XCTAssertEqual(tc.frameRate, decoded.frameRate)
			XCTAssertEqual(tc.upperLimit, decoded.upperLimit)
			XCTAssertEqual(tc.subFramesDivisor, decoded.subFramesDivisor)
			XCTAssertEqual(tc.displaySubFrames, decoded.displaySubFrames)
			
		}
		
	}
	
}

#endif
