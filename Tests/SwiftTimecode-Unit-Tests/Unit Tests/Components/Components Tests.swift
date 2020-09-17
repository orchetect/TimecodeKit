//
//  Components Tests.swift
//  SwiftTimecodeTests
//
//  Created by Steffan Andrews on 2020-06-16.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

import XCTest
@testable import SwiftTimecode

class OTTimecode_UT_Components_Tests: XCTestCase {
	
	override func setUp() { }
	override func tearDown() { }
	
	func testTCC_toTimecode() {
		
		XCTAssertEqual(TCC(d: 0, h: 1, m: 2, s: 3, f: 4, sf: 0).toTimecode(at: ._23_976),
		OTTimecode(TCC(h: 1, m: 2, s: 3, f: 4), at: ._23_976))
		
	}
	
}
