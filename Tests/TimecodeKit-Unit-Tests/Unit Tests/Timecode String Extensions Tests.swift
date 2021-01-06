//
//  Timecode String Extensions Tests.swift
//  TimecodeKitTests
//
//  Created by Steffan Andrews on 2020-06-16.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

import XCTest
@testable import TimecodeKit

class Timecode_UT_Swift_Extensions_Tests: XCTestCase {
	
	override func setUp() { }
	override func tearDown() { }
	
	func testString_toTimeCode() {
		
		XCTAssertEqual("01:05:20:14".toTimecode(at: ._23_976),
					   Timecode(TCC(h: 1, m: 5, s: 20, f: 14), at: ._23_976))
		
	}
	
}
