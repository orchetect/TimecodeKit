//
//  OTTimecode init Tests.swift
//  SwiftTimecodeTests
//
//  Created by Steffan Andrews on 2020-06-16.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

import XCTest
@testable import SwiftTimecode

class OTTimecode_UT_init_Tests: XCTestCase {
	
	override func setUp() { }
	override func tearDown() { }
	
	
	func testOTTimecode_init_Defaults() {
		// essential inits
		
		// defaults
		
		var tc = OTTimecode(at: ._24)
		XCTAssertEqual(tc.frameRate, ._24)
		XCTAssertEqual(tc.upperLimit, ._24hours)
		XCTAssertEqual(tc.totalElapsedFrames, 0)
		XCTAssertEqual(tc.components, TCC(d: 0, h: 0, m: 0, s: 0, f: 0))
		XCTAssertEqual(tc.stringValue, "00:00:00:00")
		
		// expected intitalizers
		
		tc = OTTimecode(at: ._24)
		tc = OTTimecode(at: ._24, limit: ._24hours)
		
	}
	
	// ____ basic inits, using (exactly: ) ____
	
	func testOTTimecode_init_String() {
		
		OTTimecode.FrameRate.allCases.forEach {
			let tc = OTTimecode("00:00:00:00", at: $0, limit: ._24hours)
			
			XCTAssertEqual(tc?.days		, 0		, "for \($0)")
			XCTAssertEqual(tc?.hours	, 0		, "for \($0)")
			XCTAssertEqual(tc?.minutes	, 0		, "for \($0)")
			XCTAssertEqual(tc?.seconds	, 0		, "for \($0)")
			XCTAssertEqual(tc?.frames	, 0		, "for \($0)")
			XCTAssertEqual(tc?.subFrames, 0		, "for \($0)")
		}
		
		OTTimecode.FrameRate.allCases.forEach {
			let tc = OTTimecode("01:02:03:04", at: $0, limit: ._24hours)
			
			XCTAssertEqual(tc?.days		, 0		, "for \($0)")
			XCTAssertEqual(tc?.hours	, 1		, "for \($0)")
			XCTAssertEqual(tc?.minutes	, 2		, "for \($0)")
			XCTAssertEqual(tc?.seconds	, 3		, "for \($0)")
			XCTAssertEqual(tc?.frames	, 4		, "for \($0)")
			XCTAssertEqual(tc?.subFrames, 0		, "for \($0)")
		}
		
	}
	
	func testOTTimecode_init_Components() {
		
		OTTimecode.FrameRate.allCases.forEach {
			let tc = OTTimecode(TCC(d: 0, h: 0, m: 0, s: 0, f: 0),
									 at: $0,
									 limit: ._24hours)
			
			XCTAssertEqual(tc?.days		, 0		, "for \($0)")
			XCTAssertEqual(tc?.hours	, 0		, "for \($0)")
			XCTAssertEqual(tc?.minutes	, 0		, "for \($0)")
			XCTAssertEqual(tc?.seconds	, 0		, "for \($0)")
			XCTAssertEqual(tc?.frames	, 0		, "for \($0)")
			XCTAssertEqual(tc?.subFrames, 0		, "for \($0)")
		}
		
		OTTimecode.FrameRate.allCases.forEach {
			let tc = OTTimecode(TCC(d: 0, h: 1, m: 2, s: 3, f: 4),
									 at: $0,
									 limit: ._24hours)
			
			XCTAssertEqual(tc?.days		, 0		, "for \($0)")
			XCTAssertEqual(tc?.hours	, 1		, "for \($0)")
			XCTAssertEqual(tc?.minutes	, 2		, "for \($0)")
			XCTAssertEqual(tc?.seconds	, 3		, "for \($0)")
			XCTAssertEqual(tc?.frames	, 4		, "for \($0)")
			XCTAssertEqual(tc?.subFrames, 0		, "for \($0)")
		}
		
	}
	
}
