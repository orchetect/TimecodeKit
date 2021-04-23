//
//  Delta Tests.swift
//  TimecodeKitTests
//
//  Created by Steffan Andrews on 2021-04-23.
//  Copyright © 2021 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

import XCTest
@testable import TimecodeKit
import OTCore

class Timecode_UT_Delta_DeltaTests: XCTestCase {
	
	override func setUp() { }
	override func tearDown() { }
	
	func testInitA() {
		
		// positive
		
		let deltaTC = Timecode(TCC(m: 1), at: ._24)!
		
		let delta = Timecode.Delta(deltaTC)
		
		XCTAssertEqual(delta.delta, deltaTC)
		XCTAssertEqual(delta.sign, .positive)
		
	}
	
	func testInitB() {
		
		// negative
		
		let deltaTC = Timecode(TCC(m: 1), at: ._24)!
		
		let delta = Timecode.Delta(deltaTC, .negative)
		
		XCTAssertEqual(delta.delta, deltaTC)
		XCTAssertEqual(delta.sign, .negative)
		
	}
	
	func testInitC() {
		
		// TCC can contain negative values;
		// this should not alter the Delta sign however
		
		let deltaTC = Timecode(rawValues: TCC(m: -1), at: ._24)
		
		let delta = Timecode.Delta(deltaTC)
		
		XCTAssertEqual(delta.delta, deltaTC)
		XCTAssertEqual(delta.sign, .positive)
		
	}
	
	func testTimecodeA() {
		
		// positive
		
		let deltaTC = Timecode(TCC(m: 1), at: ._24)!
		
		let delta = Timecode.Delta(deltaTC)
		
		XCTAssertEqual(delta.timecode, deltaTC)
		
	}
	
	func testTimecodeB() {
		
		// negative, wrapping
		
		let deltaTC = Timecode(TCC(m: 1), at: ._24)!
		
		let delta = Timecode.Delta(deltaTC, .negative)
		
		XCTAssertEqual(delta.timecode,
					   Timecode(TCC(h: 23, m: 59, s: 00, f: 00), at: ._24)!)
		
	}
	
	func testTimecodeC() {
		
		// positive, wrapping
		
		let deltaTC = Timecode(rawValues: TCC(h: 26), at: ._24)
		
		let delta = Timecode.Delta(deltaTC)
		
		XCTAssertEqual(delta.timecode,
					   Timecode(TCC(h: 02, m: 00, s: 00, f: 00), at: ._24)!)
		
	}
	
	func testTimecodeOffsettingA() {
		
		// positive
		
		let deltaTC = Timecode(rawValues: TCC(m: 1), at: ._24)
		
		let delta = Timecode.Delta(deltaTC)
		
		XCTAssertEqual(
			delta.timecode(offsetting: Timecode(TCC(h: 1), at: ._24)!),
			Timecode(TCC(h: 01, m: 01, s: 00, f: 00), at: ._24)!
		)
		
	}
	
	func testTimecodeOffsettingB() {
		
		// negative
		
		let deltaTC = Timecode(rawValues: TCC(m: 1), at: ._24)
		
		let delta = Timecode.Delta(deltaTC, .negative)
		
		XCTAssertEqual(
			delta.timecode(offsetting: Timecode(TCC(h: 1), at: ._24)!),
			Timecode(TCC(h: 00, m: 59, s: 00, f: 00), at: ._24)!
		)
		
	}
	
	func testRealTimeValueA() {
		
		// positive
		
		let deltaTC = Timecode(TCC(h: 1), at: ._24)!
		
		let delta = Timecode.Delta(deltaTC)
		
		XCTAssertEqual(delta.realTimeValue, deltaTC.realTimeValue.seconds)
		
	}
	
	func testRealTimeValueB() {
		
		// negative
		
		let deltaTC = Timecode(TCC(h: 1), at: ._24)!
		
		let delta = Timecode.Delta(deltaTC, .negative)
		
		XCTAssertEqual(delta.realTimeValue, -deltaTC.realTimeValue.seconds)
		
	}
	
}

#endif
