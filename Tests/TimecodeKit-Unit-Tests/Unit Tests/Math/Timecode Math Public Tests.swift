//
//  Timecode Math Public Tests.swift
//  TimecodeUnitTests
//
//  Created by Steffan Andrews on 2020-06-16.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

import XCTest
@testable import TimecodeKit

class Timecode_UT_Math_Public_Tests: XCTestCase {
	
	override func setUp() { }
	override func tearDown() { }
	
	func testAdd_and_Subtract_Methods() {
		
		// .add / .subtract methods
		
		var tc = Timecode(at: ._23_976, limit: ._24hours)
		
		tc = Timecode(					TCC(h: 00, m: 00, s: 00, f: 00),
										at: ._23_976, limit: ._24hours)!
		XCTAssertTrue (tc.add(			TCC(h: 00, m: 00, s: 00, f: 23)))
		XCTAssertEqual(tc.components,	TCC(h: 00, m: 00, s: 00, f: 23))
		XCTAssertTrue (tc.add(			TCC(h: 00, m: 00, s: 00, f: 01)))
		XCTAssertEqual(tc.components,	TCC(h: 00, m: 00, s: 01, f: 00))
		
		tc = Timecode(					TCC(h: 00, m: 00, s: 00, f: 00),
										at: ._23_976, limit: ._24hours)!
		XCTAssertTrue (tc.add(			TCC(h: 01, m: 15, s: 30, f: 10)))
		XCTAssertEqual(tc.components,	TCC(h: 01, m: 15, s: 30, f: 10))
		XCTAssertTrue (tc.add(			TCC(h: 01, m: 15, s: 30, f: 10)))
		XCTAssertEqual(tc.components,	TCC(h: 02, m: 31, s: 00, f: 20))
		XCTAssertFalse(tc.add(			TCC(h: 23, m: 15, s: 30, f: 10)))
		XCTAssertEqual(tc.components,	TCC(h: 02, m: 31, s: 00, f: 20))	// unchanged value
		
		tc = Timecode(					TCC(h: 00, m: 00, s: 00, f: 00),
										at: ._23_976, limit: ._24hours)!
		XCTAssertFalse(tc.subtract(		TCC(h: 02, m: 31, s: 00, f: 20)))
		
		tc = Timecode(					TCC(h: 23, m: 59, s: 59, f: 23),
										at: ._23_976, limit: ._24hours)!
		XCTAssertTrue (tc.subtract(		TCC(h: 23, m: 59, s: 59, f: 23)))
		XCTAssertEqual(tc.components,	TCC(h: 00, m: 00, s: 00, f: 00))
		
		tc = Timecode(					TCC(h: 23, m: 59, s: 59, f: 23),
										at: ._23_976, limit: ._24hours)!
		XCTAssertFalse(tc.subtract(		TCC(h: 23, m: 59, s: 59, f: 24)))	// 1 frame too many
		XCTAssertEqual(tc.components,	TCC(h: 23, m: 59, s: 59, f: 23))	// unchanged value
		
		tc = Timecode(					TCC(h: 00, m: 00, s: 00, f: 00),
										at: ._23_976, limit: ._24hours)!
		XCTAssertTrue (tc.add(			TCC(f: 24)))						// roll up to 1 sec
		XCTAssertEqual(tc.components,	TCC(h: 00, m: 00, s: 01, f: 00))
		
		tc = Timecode(					TCC(h: 00, m: 00, s: 00, f: 00),
										at: ._23_976, limit: ._24hours)!
		XCTAssertTrue (tc.add(			TCC(s: 60)))						// roll up to 1 min
		XCTAssertEqual(tc.components,	TCC(h: 00, m: 01, s: 00, f: 00))
		
		tc = Timecode(					TCC(h: 00, m: 00, s: 00, f: 00),
										at: ._23_976, limit: ._24hours)!
		XCTAssertTrue (tc.add(			TCC(m: 60)))						// roll up to 1 hr
		XCTAssertEqual(tc.components,	TCC(h: 01, m: 00, s: 00, f: 00))
		
		tc = Timecode(					TCC(d: 0, h: 00, m: 00, s: 00, f: 00),
										at: ._23_976, limit: ._100days)!
		XCTAssertTrue (tc.add(			TCC(h: 24)))						// roll up to 1 day
		XCTAssertEqual(tc.components,	TCC(d: 01, h: 00, m: 00, s: 00, f: 00))
		
		tc = Timecode(					TCC(h: 00, m: 00, s: 00, f: 00),
										at: ._23_976, limit: ._24hours)!
		XCTAssertTrue (tc.add(			TCC(h: 00, m: 00, s: 00, f: 2073599)))
		XCTAssertEqual(tc.components,	TCC(h: 23, m: 59, s: 59, f: 23))
		
		tc = Timecode(					TCC(h: 23, m: 59, s: 59, f: 23),
										at: ._23_976, limit: ._24hours)!
		XCTAssertTrue (tc.subtract(		TCC(h: 00, m: 00, s: 00, f: 2073599)))
		XCTAssertEqual(tc.components,	TCC(h: 00, m: 00, s: 00, f: 00))
		
		XCTAssertTrue (tc.add(			TCC(h: 00, m: 00, s: 00, f: 200)))
		XCTAssertTrue (tc.subtract(		TCC(h: 00, m: 00, s: 00, f: 199)))
		XCTAssertEqual(tc.components,	TCC(h: 00, m: 00, s: 00, f: 01))
		
		// clamping
		
		tc = Timecode(					TCC(h: 00, m: 00, s: 00, f: 00),
										at: ._23_976, limit: ._24hours)!
		tc.add(clamping:				TCC(h: 25))
		XCTAssertEqual(tc.components,	TCC(h: 23, m: 59, s: 59, f: 23, sf: 79))
		
		tc = Timecode(					TCC(h: 00, m: 00, s: 00, f: 00),
										at: ._23_976, limit: ._24hours)!
		tc.subtract(clamping:			TCC(h: 4))
		XCTAssertEqual(tc.components,	TCC(h: 00, m: 00, s: 00, f: 00))
		
		// wrapping
		
		tc = Timecode(					TCC(h: 00, m: 00, s: 00, f: 00),
										at: ._23_976, limit: ._24hours)!
		tc.add(wrapping:				TCC(h: 25))
		XCTAssertEqual(tc.components,	TCC(h: 01, m: 00, s: 00, f: 00))
		
		tc = Timecode(					TCC(h: 00, m: 00, s: 00, f: 00),
										at: ._23_976, limit: ._24hours)!
		tc.add(wrapping:				TCC(f: -1))							// add negative number
		XCTAssertEqual(tc.components,	TCC(h: 23, m: 59, s: 59, f: 23))
		
		tc = Timecode(					TCC(h: 00, m: 00, s: 00, f: 00),
										at: ._23_976, limit: ._24hours)!
		tc.subtract(wrapping:			TCC(h: 4))
		XCTAssertEqual(tc.components,	TCC(h: 20, m: 00, s: 00, f: 00))
		
		tc = Timecode(					TCC(h: 00, m: 00, s: 00, f: 00),
										at: ._23_976, limit: ._24hours)!
		tc.subtract(wrapping:			TCC(h: -4))							// subtract negative number
		XCTAssertEqual(tc.components,	TCC(h: 04, m: 00, s: 00, f: 00))
		
		// drop-frame frame rates
		
		tc = Timecode(					TCC(h: 00, m: 00, s: 00, f: 00),
										at: ._29_97_drop, limit: ._24hours)!
		XCTAssertTrue (tc.add(			TCC(h: 00, m: 00, s: 00, f: 29)))
		XCTAssertEqual(tc.components,	TCC(h: 00, m: 00, s: 00, f: 29))
		XCTAssertTrue (tc.add(			TCC(h: 00, m: 00, s: 00, f: 01)))
		XCTAssertEqual(tc.components,	TCC(h: 00, m: 00, s: 01, f: 00))
		
		tc = Timecode(					TCC(h: 00, m: 00, s: 00, f: 00),
										at: ._29_97_drop, limit: ._24hours)!
		XCTAssertTrue (tc.add(			TCC(m: 60))) // roll up to 1 hr
		XCTAssertEqual(tc.components,	TCC(h: 01, m: 00, s: 00, f: 00))
		
		tc = Timecode(					TCC(h: 00, m: 00, s: 00, f: 00),
										at: ._29_97_drop, limit: ._24hours)!
		XCTAssertTrue (tc.add(			TCC(f: 30)))	// roll up to 1 sec
		XCTAssertEqual(tc.components,	TCC(h: 00, m: 00, s: 01, f: 00))
		
		tc = Timecode(					TCC(h: 00, m: 00, s: 59, f: 00),
										at: ._29_97_drop, limit: ._24hours)!
		XCTAssertTrue (tc.add(			TCC(f: 30)))	// roll up to 1 sec and 2 frames (2 dropped frames every minute except every 10th minute)
		XCTAssertEqual(tc.components,	TCC(h: 00, m: 01, s: 00, f: 02))
		
		tc = Timecode(					TCC(h: 00, m: 01, s: 00, f: 02),
										at: ._29_97_drop, limit: ._24hours)!
		XCTAssertTrue (tc.add(			TCC(m: 01)))	// roll up to 1 sec and 2 frames (2 dropped frames every minute except every 10th minute)
		XCTAssertEqual(tc.components,	TCC(h: 00, m: 02, s: 00, f: 02))
		XCTAssertTrue (tc.add(			TCC(m: 08)))
		XCTAssertEqual(tc.components,	TCC(h: 00, m: 10, s: 00, f: 00))
		
	}
	
	func testMultiply_and_Divide() {
		
		// .multiply / .divide methods
		
		var tc = Timecode(				TCC(h: 01, m: 00, s: 00, f: 00),
										at: ._23_976, limit: ._24hours)!
		XCTAssertTrue (tc.multiply(2))
		XCTAssertEqual(tc.components,	TCC(h: 02, m: 00, s: 00, f: 00))
		tc = Timecode(					TCC(h: 01, m: 00, s: 00, f: 00),
										at: ._23_976, limit: ._24hours)!
		XCTAssertTrue (tc.multiply(2.5))
		XCTAssertEqual(tc.components,	TCC(h: 02, m: 30, s: 00, f: 00))
		
		tc = Timecode(					TCC(h: 01, m: 00, s: 00, f: 00),
										at: ._29_97_drop, limit: ._24hours)!
		XCTAssertTrue (tc.multiply(2))
		XCTAssertEqual(tc.components,	TCC(h: 02, m: 00, s: 00, f: 00))
		tc = Timecode(					TCC(h: 01, m: 00, s: 00, f: 00),
										at: ._29_97_drop, limit: ._24hours)!
		XCTAssertTrue (tc.multiply(2.5))
		XCTAssertEqual(tc.components,	TCC(h: 02, m: 30, s: 00, f: 00))
		tc = Timecode(					TCC(h: 01, m: 00, s: 00, f: 00),
										at: ._29_97_drop, limit: ._24hours)!
		XCTAssertFalse(tc.multiply(25))
		XCTAssertEqual(tc.components,	TCC(h: 01, m: 00, s: 00, f: 00))	// unchanged
		
		// clamping
		
		tc = Timecode(					TCC(h: 01, m: 00, s: 00, f: 00),
										at: ._23_976, limit: ._24hours)!
		tc.multiply(clamping: 25.0)
		XCTAssertEqual(tc.components,	TCC(h: 23, m: 59, s: 59, f: 23))
		
		tc = Timecode(					TCC(h: 00, m: 00, s: 00, f: 00),
										at: ._23_976, limit: ._24hours)!
		tc.divide(clamping: 4)
		XCTAssertEqual(tc.components,	TCC(h: 00, m: 00, s: 00, f: 00))
		
		// wrapping - multiply
		
		tc = Timecode(					TCC(h: 01, m: 00, s: 00, f: 00),
										at: ._23_976, limit: ._24hours)!
		tc.multiply(wrapping: 25.0)
		XCTAssertEqual(tc.components,	TCC(h: 01, m: 00, s: 00, f: 00))
		
		tc = Timecode(					TCC(h: 01, m: 00, s: 00, f: 00),
										at: ._23_976, limit: ._24hours)!
		tc.multiply(wrapping: 2)
		XCTAssertEqual(tc.components,	TCC(h: 02, m: 00, s: 00, f: 00))	// normal, no wrap
		
		tc = Timecode(					TCC(h: 01, m: 00, s: 00, f: 00),
										at: ._23_976, limit: ._24hours)!
		tc.multiply(wrapping: 25)
		XCTAssertEqual(tc.components,	TCC(h: 01, m: 00, s: 00, f: 00))	// wraps
		
		// wrapping - divide
		
		tc = Timecode(					TCC(h: 01, m: 00, s: 00, f: 00),
										at: ._23_976, limit: ._24hours)!
		tc.divide(wrapping: -2)
		XCTAssertEqual(tc.components,	TCC(h: 23, m: 30, s: 00, f: 00))
		
		tc = Timecode(					TCC(h: 01, m: 00, s: 00, f: 00),
										at: ._23_976, limit: ._24hours)!
		tc.divide(wrapping: 2)
		XCTAssertEqual(tc.components,	TCC(h: 00, m: 30, s: 00, f: 00))	// normal, no wrap
		
		tc = Timecode(					TCC(h: 12, m: 00, s: 00, f: 00),
										at: ._23_976, limit: ._24hours)!
		tc.divide(wrapping: -2)
		XCTAssertEqual(tc.components,	TCC(h: 18, m: 00, s: 00, f: 00))	// wraps
		
	}
	
}

#endif
