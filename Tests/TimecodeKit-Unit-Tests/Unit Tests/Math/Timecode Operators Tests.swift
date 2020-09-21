//
//  Timecode Operators Tests.swift
//  TimecodeUnitTests
//
//  Created by Steffan Andrews on 2020-06-16.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

import XCTest
@testable import TimecodeKit

class Timecode_UT_Operators_Tests: XCTestCase {
	
	override func setUp() { }
	override func tearDown() { }
	
	func testAdd_and_Subtract_Operators() {
		
		var tc = Timecode(at: ._30)
		
		// + and - operators
		
		tc =      TCC(h: 00, m: 00, s: 00, f: 00).toTimecode(at: ._30)!
		
		tc = tc + TCC(h: 00, m: 00, s: 00, f: 05).toTimecode(at: ._30)!
		XCTAssertEqual(tc.components, TCC(h: 00, m: 00, s: 00, f: 05))
		
		tc = tc - TCC(h: 00, m: 00, s: 00, f: 04).toTimecode(at: ._30)!
		XCTAssertEqual(tc.components, TCC(h: 00, m: 00, s: 00, f: 01))
		
		// += and -= operators
		
		tc =      TCC(h: 00, m: 00, s: 00, f: 00).toTimecode(at: ._30)!
		
		tc +=     TCC(h: 00, m: 00, s: 00, f: 05).toTimecode(at: ._30)!
		XCTAssertEqual(tc.components, TCC(h: 00, m: 00, s: 00, f: 05))
		
		tc -=     TCC(h: 00, m: 00, s: 00, f: 04).toTimecode(at: ._30)!
		XCTAssertEqual(tc.components, TCC(h: 00, m: 00, s: 00, f: 01))
		
	}
	
	func testMultiply_and_Divide_Operators() {
		
		var tc = Timecode(at: ._30)
		
		// * and / operators
		
		tc =      TCC(h: 01, m: 00, s: 00, f: 00).toTimecode(at: ._30)!
		
		tc = tc * 5
		XCTAssertEqual(tc.components, TCC(h: 05, m: 00, s: 00, f: 00))
		
		tc = tc / 5
		XCTAssertEqual(tc.components, TCC(h: 01, m: 00, s: 00, f: 00))
		
		// += and -= operators
		
		tc =      TCC(h: 01, m: 00, s: 00, f: 00).toTimecode(at: ._30)!
		
		tc *=     5
		XCTAssertEqual(tc.components, TCC(h: 05, m: 00, s: 00, f: 00))
		
		tc /=     5
		XCTAssertEqual(tc.components, TCC(h: 01, m: 00, s: 00, f: 00))
		
	}
	
}
