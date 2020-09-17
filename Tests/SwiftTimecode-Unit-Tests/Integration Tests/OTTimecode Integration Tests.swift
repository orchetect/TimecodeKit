//
//  SwiftTimecodeTests.swift
//  SwiftTimecodeTests
//
//  Created by Steffan Andrews on 2019-09-30.
//  Copyright © 2019 Steffan Andrews. All rights reserved.
//

import XCTest
@testable import SwiftTimecode

class OTTimecode_IT_IntegrationTests: XCTestCase {
	
	func testOTTimecode_Clamping() {
		
		// 24 hour
		
		OTTimecode.FrameRate.allCases.forEach {
			
			XCTAssertEqual(OTTimecode(clamping: TCC(h: -1, m: -1, s: -1, f: -1), at: $0).components,
						   TCC(d: 0, h: 0, m: 0, s: 0, f: 0),
						   "for \($0)")
			
		}
		
		OTTimecode.FrameRate.allCases.forEach {
			let clamped = OTTimecode(clamping: TCC(h: 99, m: 99, s: 99, f: 10000), at: $0).components
			
			XCTAssertEqual(clamped, TCC(d: 0, h: 23, m: 59, s: 59, f: $0.maxFrameNumberDisplayable), "for \($0)")
		}
		
		// 24 hour - testing with days
		
		OTTimecode.FrameRate.allCases.forEach {
			
			XCTAssertEqual(OTTimecode(clamping: TCC(d: -1, h: -1, m: -1, s: -1, f: -1), at: $0).components,
						   TCC(d: 0, h: 0, m: 0, s: 0, f: 0),
						   "for \($0)")
			
		}
		
		OTTimecode.FrameRate.allCases.forEach {
			let clamped = OTTimecode(clamping: TCC(d: 99, h: 99, m: 99, s: 99, f: 10000), at: $0).components
			
			XCTAssertEqual(clamped, TCC(d: 0, h: 23, m: 59, s: 59, f: $0.maxFrameNumberDisplayable), "for \($0)")
			
		}
		
		// 100 days
		
		OTTimecode.FrameRate.allCases.forEach {
			
			XCTAssertEqual(OTTimecode(clamping: TCC(h: -1, m: -1, s: -1, f: -1), at: $0).components,
						   TCC(d: 0, h: 0, m: 0, s: 0, f: 0),
						   "for \($0)")
			
		}
		
		OTTimecode.FrameRate.allCases.forEach {
			let clamped = OTTimecode(clamping: TCC(h: 99, m: 99, s: 99, f: 10000), at: $0).components
			
			XCTAssertEqual(clamped, TCC(d: 0, h: 23, m: 59, s: 59, f: $0.maxFrameNumberDisplayable), "for \($0)")
			
		}
		
		// 100 days - testing with days
		
		OTTimecode.FrameRate.allCases.forEach {
			
			XCTAssertEqual(OTTimecode(clamping: TCC(d: -1, h: -1, m: -1, s: -1, f: -1), at: $0, limit: ._100days).components,
						   TCC(d: 0, h: 0, m: 0, s: 0, f: 0),
						   "for \($0)")
			
		}
		
		OTTimecode.FrameRate.allCases.forEach {
			let clamped = OTTimecode(clamping: TCC(d: 99, h: 99, m: 99, s: 99, f: 10000), at: $0, limit: ._100days).components
			
			XCTAssertEqual(clamped, TCC(d: 99, h: 23, m: 59, s: 59, f: $0.maxFrameNumberDisplayable), "for \($0)")
			
		}
		
	}
	
	func testOTTimecode_Wrapping() {
		
		// 24 hour
		
		OTTimecode.FrameRate.allCases.forEach {
			
			XCTAssertEqual(OTTimecode(wrapping: TCC(d: 1), at: $0).components,
						   TCC(d: 0, h: 0, m: 0, s: 0, f: 0),
						   "for \($0)")
			
		}
		
		OTTimecode.FrameRate.allCases.forEach {
			let wrapped = OTTimecode(wrapping: TCC(f: -1), at: $0).components
			
			XCTAssertEqual(wrapped, TCC(d: 0, h: 23, m: 59, s: 59, f: $0.maxFrameNumberDisplayable, sf: 0), "for \($0)")
			
		}
		
		// 24 hour - testing with days
		
		OTTimecode.FrameRate.allCases.forEach {
			let wrapped = OTTimecode(wrapping: TCC(d: 1, h: 2, m: 30, s: 20, f: 0), at: $0).components
			
			XCTAssertEqual(wrapped, TCC(d: 0, h: 2, m: 30, s: 20, f: 0), "for \($0)")
			
		}
		
		// 100 days
		
		OTTimecode.FrameRate.allCases.forEach {
			let wrapped = OTTimecode(wrapping: TCC(d: -1), at: $0, limit: ._100days).components
			
			XCTAssertEqual(wrapped, TCC(d: 99, h: 0, m: 0, s: 0, f: 0), "for \($0)")
			
		}
		
	}
	
}
