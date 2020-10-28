//
//  Timecode Validation Tests.swift
//  TimecodeKitTests
//
//  Created by Steffan Andrews on 2020-06-16.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

import XCTest
@testable import TimecodeKit

class Timecode_UT_Validation_Tests: XCTestCase {
	
	override func setUp() { }
	override func tearDown() { }
	
	func testValidWithinRanges() {
		
		// typical valid values
		
		let fr = Timecode.FrameRate._24
		let limit = Timecode.UpperLimit._24hours
		
		let tc = Timecode(at: fr, limit: limit)
		
		XCTAssertEqual(tc.invalidComponents, [])
		XCTAssertEqual(tc.components.invalidComponents(at: fr, limit: limit, subFramesDivisor: 80), [])
		
		XCTAssertEqual(tc.validRange(of: .days), 0...0)
		XCTAssertEqual(tc.validRange(of: .hours), 0...23)
		XCTAssertEqual(tc.validRange(of: .minutes), 0...59)
		XCTAssertEqual(tc.validRange(of: .seconds), 0...59)
		XCTAssertEqual(tc.validRange(of: .frames), 0...23)
		//XCTAssertThrowsError(tc.validRange(of: .subFrames)) // *****
		
	}
	
	func testInvalidOverRanges() {
		
		// invalid - over ranges
		
		let fr = Timecode.FrameRate._24
		let limit = Timecode.UpperLimit._24hours
		
		var tc = Timecode(at: fr, limit: limit)
		tc.days = 5
		tc.hours = 25
		tc.minutes = 75
		tc.seconds = 75
		tc.frames = 52
		tc.subFrames = 500
		
		XCTAssertEqual(tc.invalidComponents,
					   [.days, .hours, .minutes, .seconds, .frames, .subFrames])
		XCTAssertEqual(tc.components.invalidComponents(at: fr, limit: limit, subFramesDivisor: 80),
					   [.days, .hours, .minutes, .seconds, .frames, .subFrames])
		
	}
	
	func testInvalidUnderRanges() {
		
		// invalid - under ranges
		
		let fr = Timecode.FrameRate._24
		let limit = Timecode.UpperLimit._24hours
		
		var tc = Timecode(at: fr, limit: limit)
		tc.days = -1
		tc.hours = -1
		tc.minutes = -1
		tc.seconds = -1
		tc.frames = -1
		tc.subFrames = -1
		
		XCTAssertEqual(tc.invalidComponents,
					   [.days, .hours, .minutes, .seconds, .frames, .subFrames])
		XCTAssertEqual(tc.components.invalidComponents(at: fr, limit: limit, subFramesDivisor: 80),
					   [.days, .hours, .minutes, .seconds, .frames, .subFrames])
		
	}
	
	func testDropFrame() {
		
		// perform a spot-check to ensure drop-frame timecode validation works as expected
		
		Timecode.FrameRate.allDrop.forEach {
			
			let limit = Timecode.UpperLimit._24hours
			
			// every 10 minutes, no frames are skipped
			
			do {
				var tc = Timecode(at: $0, limit: limit)
				tc.minutes = 0
				tc.frames = 0
				
				XCTAssertEqual(tc.invalidComponents,
							   [], "for \($0)")
				XCTAssertEqual(tc.components.invalidComponents(at: $0, limit: limit, subFramesDivisor: 80),
							   [], "for \($0)")
			}
			
			// all other minutes each skip frame 0 and 1
			
			for minute in 1...9 {
				var tc = Timecode(at: $0, limit: limit)
				tc.minutes = minute
				tc.frames = 0
				
				XCTAssertEqual(tc.invalidComponents,
							   [.frames], "for \($0) at \(minute) minutes")
				XCTAssertEqual(tc.components.invalidComponents(at: $0, limit: limit, subFramesDivisor: 80),
							   [.frames], "for \($0) at \(minute) minutes")
				
				tc = Timecode(at: $0, limit: limit)
				tc.minutes = minute
				tc.frames = 1
				
				XCTAssertEqual(tc.invalidComponents,
							   [.frames], "for \($0) at \(minute) minutes")
				XCTAssertEqual(tc.components.invalidComponents(at: $0, limit: limit, subFramesDivisor: 80),
							   [.frames], "for \($0) at \(minute) minutes")
			}
			
		}
		
	}
	
	func testMaxFrames() {
		
		let subFramesDivisor = 80
		
		let tc = Timecode(at: ._24,
						  limit: ._24hours,
						  subFramesDivisor: subFramesDivisor)
		
		let mf = tc.maxFramesAndSubframesExpressible
		
		let tcc = Timecode.components(from: mf,
									  at: tc.frameRate,
									  subFramesDivisor: tc.subFramesDivisor)
		
		XCTAssertEqual(tc.validRange(of: .subFrames), 0...(subFramesDivisor-1))
		XCTAssertEqual(mf, 2073599.9875)
		XCTAssertEqual(tc.subFrames, 0)
		XCTAssertEqual(tc.subFramesDivisor, subFramesDivisor)
		
		XCTAssertEqual(tcc, TCC(d: 0,
								h: 23,
								m: 59,
								s: 59,
								f: 23,
								sf: subFramesDivisor-1) )
		
	}
	
}


