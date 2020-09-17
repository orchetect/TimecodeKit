//
//  OTTimecode Real Time Tests.swift
//  OTTimecodeUnitTests
//
//  Created by Steffan Andrews on 2020-06-16.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

import XCTest
@testable import SwiftTimecode

class OTTimecode_UT_DI_Real_Time_Tests: XCTestCase {
	
	override func setUp() { }
	override func tearDown() { }
	
	func testOTTimecode_RealTime() {
		
		// pre-computed constants
		
		let msIn10Hr_ShrunkFrameRates = 864864000.0
		let msIn10Hr_BaseFrameRates = 864000000.0
		let msIn10Hr_DropFrameRates = 863999136.0
		
		
		// get real time
		
		// allow for the over-estimate padding value that gets added in the TC->realtime method
		let accuracy = 0.0001
		
		OTTimecode.FrameRate.allCases.forEach {
			
			let tc = OTTimecode(TCC(d: 10), at: $0, limit: ._100days)!
			
			switch $0 {
			case ._23_976,
				 ._24_98,
				 ._29_97,
				 ._47_952,
				 ._59_94,
				 ._119_88:
				
				XCTAssertEqual(tc.realTime.ms, msIn10Hr_ShrunkFrameRates, accuracy: accuracy, "at: \($0)")
				
			case ._24,
				 ._25,
				 ._30,
				 ._48,
				 ._50,
				 ._60,
				 ._100,
				 ._120:
				
				XCTAssertEqual(tc.realTime.ms, msIn10Hr_BaseFrameRates, accuracy: accuracy, "at: \($0)")
				
			case ._29_97_drop,
				 ._30_drop,
				 ._59_94_drop,
				 ._60_drop,
				 ._119_88_drop,
				 ._120_drop:
				
				XCTAssertEqual(tc.realTime.ms, msIn10Hr_DropFrameRates, accuracy: accuracy, "at: \($0)")
				
			}
		}
		
		// set timecode from real time
		
		let tcc = TCC(d: 10)
		
		OTTimecode.FrameRate.allCases.forEach {
			
			var tc = OTTimecode(tcc, at: $0, limit: ._100days)!
			
			switch $0 {
			case ._23_976,
				 ._24_98,
				 ._29_97,
				 ._47_952,
				 ._59_94,
				 ._119_88:
				
				XCTAssertTrue(tc.setTimecode(from: OTTime(ms: msIn10Hr_ShrunkFrameRates)), "at: \($0)")
				XCTAssertEqual(tc.components, tcc, "at: \($0)")
				
			case ._24,
				 ._25,
				 ._30,
				 ._48,
				 ._50,
				 ._60,
				 ._100,
				 ._120:
				
				XCTAssertTrue(tc.setTimecode(from: OTTime(ms: msIn10Hr_BaseFrameRates)), "at: \($0)")
				XCTAssertEqual(tc.components, tcc, "at: \($0)")
				
			case ._29_97_drop,
				 ._30_drop,
				 ._59_94_drop,
				 ._60_drop,
				 ._119_88_drop,
				 ._120_drop:
				
				XCTAssertTrue(tc.setTimecode(from: OTTime(ms: msIn10Hr_DropFrameRates)), "at: \($0)")
				XCTAssertEqual(tc.components, tcc, "at: \($0)")
				
			}
			
		}
		
	}
	
	func testOTTimecode_RealTime_SubFrames() {
		
		// ensure subframes are calculated correctly
		
		// test for precision and rounding issues by iterating every subframe for each frame rate
		
		for subframe in 0...79 {
			
			let tcc = TCC(d: 99, h: 23, sf: subframe)
			
			OTTimecode.FrameRate.allCases.forEach {
				
				var tc = OTTimecode(tcc,
									at: $0,
									limit: ._100days,
									subFramesDivisor: 80)!
				
				// timecode to samples
				
				let realTime = tc.realTime
				
				// samples to timecode
				
				XCTAssertTrue(tc.setTimecode(from: realTime),
							  "at: \($0) subframe: \(subframe)")
				
				XCTAssertEqual(tc.components,
							   tcc,
							   "at: \($0) subframe: \(subframe)")
				
			}
			
		}
		
	}
	
}
