//
//  Hashable Tests.swift
//  TimecodeUnitTests
//
//  Created by Steffan Andrews on 2020-06-16.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

import XCTest
@testable import TimecodeKit

class Timecode_UT_Hashable_Tests: XCTestCase {
	
	override func setUp() { }
	override func tearDown() { }
	
	func testHashValue() {
		
		// hashValues should be equal
		
		XCTAssertEqual(   "01:00:00:00".toTimecode(at: ._23_976)!.hashValue,
						  "01:00:00:00".toTimecode(at: ._23_976)!.hashValue)
		XCTAssertNotEqual("01:00:00:01".toTimecode(at: ._23_976)!.hashValue,
						  "01:00:00:00".toTimecode(at: ._23_976)!.hashValue)
		
		XCTAssertNotEqual("01:00:00:00".toTimecode(at: ._23_976)!.hashValue,
						  "01:00:00:00".toTimecode(at: ._24)!.hashValue)
		XCTAssertNotEqual("01:00:00:00".toTimecode(at: ._23_976)!.hashValue,
						  "01:00:00:00".toTimecode(at: ._29_97)!.hashValue)
		
	}
	
	func testDictionary() {
	
		// Dictionary / Set
		
		var dict: [Timecode : String] = [:]
		dict["01:00:00:00".toTimecode(at: ._23_976)!] = "A Spot Note Here"
		dict["01:00:00:06".toTimecode(at: ._23_976)!] = "A Spot Note Also Here"
		XCTAssertEqual(dict.count, 2)
		dict["01:00:00:00".toTimecode(at: ._24)!] = "This should not replace"
		XCTAssertEqual(dict.count, 3)
		
		XCTAssertEqual(dict["01:00:00:00".toTimecode(at: ._23_976)!], "A Spot Note Here")
		XCTAssertEqual(dict["01:00:00:00".toTimecode(at: ._24)!], "This should not replace")
		
	}
	
	func testSet() {
		
		// unique timecodes are based on frame counts, irrespective of frame rate
		
		let tcSet: Set<Timecode> = ["01:00:00:00".toTimecode(at: ._23_976)!,
									"01:00:00:00".toTimecode(at: ._24)!,
									"01:00:00:00".toTimecode(at: ._25)!,
									"01:00:00:00".toTimecode(at: ._29_97)!,
									"01:00:00:00".toTimecode(at: ._29_97_drop)!,
									"01:00:00:00".toTimecode(at: ._30)!,
									"01:00:00:00".toTimecode(at: ._59_94)!,
									"01:00:00:00".toTimecode(at: ._59_94_drop)!,
									"01:00:00:00".toTimecode(at: ._60)!]
		
		XCTAssertNotEqual(tcSet.count, 1)	// doesn't matter what frame rate it is, the same total elapsed frames matters
		
	}
	
}

#endif
