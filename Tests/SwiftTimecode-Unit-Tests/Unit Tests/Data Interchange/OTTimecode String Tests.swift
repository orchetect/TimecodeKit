//
//  OTTimecode String Tests.swift
//  SwiftTimecodeTests
//
//  Created by Steffan Andrews on 2020-06-16.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

import XCTest
@testable import SwiftTimecode

class OTTimecode_UT_DI_String_Tests: XCTestCase {
	
	override func setUp() { }
	override func tearDown() { }
	
	func testStringValue_GetSet_Basic() {
		
		// basic set & get tests
		
		var tc = OTTimecode(at: ._23_976, limit: ._24hours)
		
		tc.stringValue = "01:05:20:14"
		XCTAssertEqual(tc.stringValue, "01:05:20:14")
		
		tc.stringValue = "50:05:20:14"							// fails silently
		XCTAssertEqual(tc.stringValue, "01:05:20:14")			// old value
		
		XCTAssertFalse(tc.setTimecode(exactly: "50:05:20:14"))
		XCTAssertEqual(tc.stringValue, "01:05:20:14")			// no change
		
		XCTAssertTrue(tc.setTimecode(clamping: "50:05:20:14"))
		XCTAssertEqual(tc.stringValue, "23:05:20:14")
		
	}
	
	func testStringValue_Get_Formatting_Basic() {
		
		// basic string formatting - ie: HH:MM:SS:FF
		// using known valid timecode components; not testing for invalid values here
		
		// 24 hour limit
		
		// non-drop
		
		OTTimecode.FrameRate.allNonDrop.forEach {
			let sv = TCC(h: 1, m: 02, s: 03, f: 04)
				.toTimecode(at: $0)?
				.stringValue
			
			let t = $0.numberOfDigits == 2 ? "" : "0"
			
			XCTAssertEqual(sv, "01:02:03:\(t)04", "for \($0)")
		}
		
		// drop
		
		OTTimecode.FrameRate.allDrop.forEach {
			let sv = TCC(h: 1, m: 02, s: 03, f: 04)
				.toTimecode(at: $0)?
				.stringValue
			
			let t = $0.numberOfDigits == 2 ? "" : "0"
			
			XCTAssertEqual(sv, "01:02:03;\(t)04", "for \($0)")
		}
		
		// 100 days limit
		
		// non-drop
		
		OTTimecode.FrameRate.allNonDrop.forEach {
			let sv = TCC(h: 1, m: 02, s: 03, f: 04)
				.toTimecode(at: $0, limit: ._100days)?
				.stringValue
			
			let t = $0.numberOfDigits == 2 ? "" : "0"
			
			XCTAssertEqual(sv, "01:02:03:\(t)04", "for \($0)")	// omits days since they are 0
		}
		
		// drop
		
		OTTimecode.FrameRate.allDrop.forEach {
			let sv = TCC(h: 1, m: 02, s: 03, f: 04)
				.toTimecode(at: $0, limit: ._100days)?
				.stringValue
			
			let t = $0.numberOfDigits == 2 ? "" : "0"
			
			XCTAssertEqual(sv, "01:02:03;\(t)04", "for \($0)")	// omits days since they are 0
		}
	}
	
	func testStringValue_Get_Formatting_WithDays() {
		
		// string formatting with days - ie: D:HH:MM:SS:FF
		// using known valid timecode components; not testing for invalid values here
		
		// non-drop
		
		OTTimecode.FrameRate.allNonDrop.forEach {
			var tc = TCC(h: 1, m: 02, s: 03, f: 04)
				.toTimecode(at: $0)
			tc?.days = 2						// set days after init since init fails if we pass days
			
			let t = $0.numberOfDigits == 2 ? "" : "0"
			
			// still produces days since we have not clamped it yet
			var sv = tc?.stringValue
			XCTAssertEqual(sv, "2 01:02:03:\(t)04", "for \($0)")
			
			// now omits days since our limit is 24hr and clamped
			tc!.clampComponents()
			sv = tc?.stringValue
			XCTAssertEqual(sv, "01:02:03:\(t)04", "for \($0)")
		}
		
		// drop
		
		OTTimecode.FrameRate.allDrop.forEach {
			var tc = TCC(h: 1, m: 02, s: 03, f: 04)
				.toTimecode(at: $0)
			tc?.days = 2						// set days after init since init fails if we pass days
			
			let t = $0.numberOfDigits == 2 ? "" : "0"
			
			// still produces days since we have not clamped it yet
			var sv = tc?.stringValue
			XCTAssertEqual(sv, "2 01:02:03;\(t)04", "for \($0)")
			
			// now omits days since our limit is 24hr and clamped
			tc?.clampComponents()
			sv = tc?.stringValue
			XCTAssertEqual(sv, "01:02:03;\(t)04", "for \($0)")
		}
		
		// 100 days limit
		
		// non-drop
		
		OTTimecode.FrameRate.allNonDrop.forEach {
			let sv = TCC(d: 2, h: 1, m: 02, s: 03, f: 04)
				.toTimecode(at: $0, limit: ._100days)?
				.stringValue
			
			let t = $0.numberOfDigits == 2 ? "" : "0"
			
			XCTAssertEqual(sv, "2 01:02:03:\(t)04", "for \($0)")	// omits days since they are 0
		}
		
		// drop
		
		OTTimecode.FrameRate.allDrop.forEach {
			let sv = TCC(d: 2, h: 1, m: 02, s: 03, f: 04)
				.toTimecode(at: $0, limit: ._100days)?
				.stringValue
			
			let t = $0.numberOfDigits == 2 ? "" : "0"
			
			XCTAssertEqual(sv, "2 01:02:03;\(t)04", "for \($0)")	// omits days since they are 0
		}
		
	}
	
	func testStringValue_Get_Formatting_WithSubframes() {
		
		// string formatting with subframes - ie: HH:MM:SS:FF.sf
		// using known valid timecode components; not testing for invalid values here
		
		// non-drop
		
		OTTimecode.FrameRate.allNonDrop.forEach {
			var tc = TCC(h: 1, m: 02, s: 03, f: 04, sf: 12)
				.toTimecode(at: $0)
			tc?.displaySubFrames = true
			tc?.days = 2						// set days after init since init fails if we pass days
			
			let t = $0.numberOfDigits == 2 ? "" : "0"
			
			// still produces days since we have not clamped it yet
			var sv = tc?.stringValue
			XCTAssertEqual(sv, "2 01:02:03:\(t)04.12", "for \($0)")
			
			// now omits days since our limit is 24hr and clamped
			tc!.clampComponents()
			sv = tc?.stringValue
			XCTAssertEqual(sv, "01:02:03:\(t)04.12", "for \($0)")
		}
		
		// drop
		
		OTTimecode.FrameRate.allDrop.forEach {
			var tc = TCC(h: 1, m: 02, s: 03, f: 04, sf: 12)
				.toTimecode(at: $0)
			tc?.displaySubFrames = true
			tc?.days = 2						// set days after init since init fails if we pass days
			
			let t = $0.numberOfDigits == 2 ? "" : "0"
			
			// still produces days since we have not clamped it yet
			var sv = tc?.stringValue
			XCTAssertEqual(sv, "2 01:02:03;\(t)04.12", "for \($0)")
			
			// now omits days since our limit is 24hr and clamped
			tc?.clampComponents()
			sv = tc?.stringValue
			XCTAssertEqual(sv, "01:02:03;\(t)04.12", "for \($0)")
		}
		
		// 100 days limit
		
		// non-drop
		
		OTTimecode.FrameRate.allNonDrop.forEach {
			var tc = TCC(d: 2, h: 1, m: 02, s: 03, f: 04, sf: 12)
				.toTimecode(at: $0, limit: ._100days)
			tc?.displaySubFrames = true
			
			let t = $0.numberOfDigits == 2 ? "" : "0"
			
			let sv = tc?.stringValue
			XCTAssertEqual(sv, "2 01:02:03:\(t)04.12", "for \($0)")	// omits days since they are 0
		}
		
		// drop
		
		OTTimecode.FrameRate.allDrop.forEach {
			var tc = TCC(d: 2, h: 1, m: 02, s: 03, f: 04, sf: 12)
				.toTimecode(at: $0, limit: ._100days)
			tc?.displaySubFrames = true
			
			let t = $0.numberOfDigits == 2 ? "" : "0"
			
			let sv = tc?.stringValue
			XCTAssertEqual(sv, "2 01:02:03;\(t)04.12", "for \($0)")	// omits days since they are 0
		}
		
	}
	
	func testStringDecode() {
		
		// non-drop frame
		
		XCTAssertNil(  OTTimecode.decode(timecode:		""))
		XCTAssertNil(  OTTimecode.decode(timecode:		"01564523"))
		XCTAssertEqual(OTTimecode.decode(timecode:		"0:0:0:0"),
					   TCC(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00))
		
		XCTAssertEqual(OTTimecode.decode(timecode:		"0:00:00:00"),
					   TCC(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00))
		
		XCTAssertEqual(OTTimecode.decode(timecode:    "00:00:00:00"),
					   TCC(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00))
		
		XCTAssertEqual(OTTimecode.decode(timecode:     "1:56:45:23"),
					   TCC(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 00))
		
		XCTAssertEqual(OTTimecode.decode(timecode:    "01:56:45:23"),
					   TCC(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 00))
		
		XCTAssertEqual(OTTimecode.decode(timecode:  "3 01:56:45:23"),
					   TCC(d:  3, h: 01, m: 56, s: 45, f: 23, sf: 00))
		
		XCTAssertEqual(OTTimecode.decode(timecode: "12 01:56:45:23"),
					   TCC(d: 12, h: 1, m: 56, s: 45, f: 23, sf: 00))
		
		XCTAssertEqual(OTTimecode.decode(timecode: "12:01:56:45:23"),
					   TCC(d: 12, h: 1, m: 56, s: 45, f: 23, sf: 00))
		
		// drop frame
		
		XCTAssertEqual(OTTimecode.decode(timecode:        "0:0:0;0"),
					   TCC(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00))
		
		XCTAssertEqual(OTTimecode.decode(timecode:     "0:00:00;00"),
					   TCC(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00))
		
		XCTAssertEqual(OTTimecode.decode(timecode:    "00:00:00;00"),
					   TCC(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 00))
		
		XCTAssertEqual(OTTimecode.decode(timecode:     "1:56:45;23"),
					   TCC(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 0))
		
		XCTAssertEqual(OTTimecode.decode(timecode:    "01:56:45;23"),
					   TCC(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 0))
		
		XCTAssertEqual(OTTimecode.decode(timecode:  "3 01:56:45;23"),
					   TCC(d:  3, h: 01, m: 56, s: 45, f: 23, sf: 0))
		
		XCTAssertEqual(OTTimecode.decode(timecode: "12 01:56:45;23"),
					   TCC(d: 12, h: 01, m: 56, s: 45, f: 23, sf: 0))
		
		XCTAssertEqual(OTTimecode.decode(timecode: "12:01:56:45;23"),
					   TCC(d: 12, h: 01, m: 56, s: 45, f: 23, sf: 0))
		
		
		// all periods - not supporting this.
		
		XCTAssertNil(OTTimecode.decode(timecode:        "0.0.0.0"))
		XCTAssertNil(OTTimecode.decode(timecode:     "0.00.00.00"))
		XCTAssertNil(OTTimecode.decode(timecode:    "00.00.00.00"))
		XCTAssertNil(OTTimecode.decode(timecode:     "1.56.45.23"))
		XCTAssertNil(OTTimecode.decode(timecode:    "01.56.45.23"))
		XCTAssertNil(OTTimecode.decode(timecode:  "3 01.56.45.23"))
		XCTAssertNil(OTTimecode.decode(timecode: "12.01.56.45.23"))
		XCTAssertNil(OTTimecode.decode(timecode: "12.01.56.45.23"))
		
		// subframes
		
		XCTAssertEqual(OTTimecode.decode(timecode:	   "0:00:00:00.05"),
					   TCC(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 05))
		
		XCTAssertEqual(OTTimecode.decode(timecode:    "00:00:00:00.05"),
					   TCC(d:  0, h: 00, m: 00, s: 00, f: 00, sf: 05))
		
		XCTAssertEqual(OTTimecode.decode(timecode:     "1:56:45:23.05"),
					   TCC(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 05))
		
		XCTAssertEqual(OTTimecode.decode(timecode:    "01:56:45:23.05"),
					   TCC(d:  0, h: 01, m: 56, s: 45, f: 23, sf: 05))
		
		XCTAssertEqual(OTTimecode.decode(timecode:  "3 01:56:45:23.05"),
					   TCC(d:  3, h: 01, m: 56, s: 45, f: 23, sf: 05))
		
		XCTAssertEqual(OTTimecode.decode(timecode: "12 01:56:45:23.05"),
					   TCC(d: 12, h: 01, m: 56, s: 45, f: 23, sf: 05))
		
		XCTAssertEqual(OTTimecode.decode(timecode: "12:01:56:45:23.05"),
					   TCC(d: 12, h: 01, m: 56, s: 45, f: 23, sf: 05))
		
		
	}
	
}
