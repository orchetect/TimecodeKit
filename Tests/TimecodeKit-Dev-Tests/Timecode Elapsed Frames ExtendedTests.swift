//
//  Timecode Elapsed Frames ExtendedTests.swift
//  TimecodeExtendedTests
//
//  Created by Steffan Andrews on 2020-06-16.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

import XCTest
@testable import TimecodeKit

import SegmentedProgress

class Timecode_ET_ExtendedTests: XCTestCase {
	
	func testCalc() {
		
		let international = TCC(m: 0, s: 28, f: 07)
			.toTimecode(at: ._23_976,
                        subFramesDivisor: 1000,
                        displaySubFrames: true)!
		
		let domestic = TCC(s: 10, f: 9)
			.toTimecode(at: ._23_976,
                        subFramesDivisor: 1000,
                        displaySubFrames: true)!
		
		let calc = international - domestic
		
		print()
		print(calc.stringValue)
		print()
		
	}
	
	func testCalc2() {
		
		let tc1 = TCC(m: 0, s: 5, f: 17)
			.toTimecode(at: ._23_976,
                        subFramesDivisor: 1000,
                        displaySubFrames: true)!
		
		let tc2 = TCC(s: 9, f: 9)
			.toTimecode(at: ._23_976,
                        subFramesDivisor: 1000,
                        displaySubFrames: true)!
		
        let calc = tc2 - tc1
		
		print()
		print(calc.stringValue)
		print()
		
	}
	
	func testCalc3() {
		
		let tc = TCC(s: 5, f: 17)
			.toTimecode(at: ._23_976,
                        subFramesDivisor: 80,
                        displaySubFrames: true)!
		
        let calc = tc.converted(to: ._30)!
		
		print()
		print(calc.stringValue)
		print()
		
	}
	
	func testTimecode_Iterative() {
		
		// return early to bypass this dev-only test
		
		XCTAssertTrue(true)
		return
		
		// test conversions from components(from:) and totalElapsedFrames(of:)
		
		// ==============================================================================
		// NOTE:
		// ==============================================================================
		// this is a brute-force test not meant to be run frequently,
		// but as a diagnostic testbed only when major changes are made to the library
		// to ensure that conversions are accurate
		// ==============================================================================
		
		// ======= parameters =======
		
		let limit: Timecode.UpperLimit =
			._24hours
			//._100days
		
		let frameRatesToTest: [Timecode.FrameRate] =
			Timecode.FrameRate.allCases
			// Timecode.FrameRate.allDrop
			// Timecode.FrameRate.allNonDrop
			// [._60_drop, ._120_drop]
		
		// ======= run ==============
		
		for fr in frameRatesToTest {
			
			let tc = Timecode(at: fr, limit: limit)
			
			// log status
			print ("Testing all frames in \(tc.upperLimit) at \(fr.stringValue)... ", terminator: "")
			
			var failures: [(Int, TCC)] = []
			
			let ubound = tc.frameRate.maxTotalFrames(in: tc.upperLimit)
			
			var per = SegmentedProgress(0...ubound, segments: 20, roundedToPlaces: 0)
			
			for i in 0...ubound {
				let vals = Timecode.components(from: i,
											   at: tc.frameRate,
											   subFramesDivisor: tc.subFramesDivisor)
				
				if i != Int(floor(Timecode.totalElapsedFrames(of: vals, at: tc.frameRate,
															  subFramesDivisor: tc.subFramesDivisor)))
				
				{ failures.append((i, vals)) }
				
				// log status
				if let percentageToPrint = per.progress(value: i) {
					print("\(percentageToPrint) ", terminator: "")
				}
			}
			print("") // finalize log with newline char

			XCTAssertEqual(failures.count, 0, "Failed iterative test for \(fr) with \(failures.count) failures.")
			
			if failures.count > 0 {
				print("First",
					  fr,
					  "failure: input elapsed frames",
					  failures.first!.0,
					  "converted to components",
					  failures.first!.1,
					  "converted back to",
					  Timecode.totalElapsedFrames(of: failures.first!.1,
												  at: tc.frameRate,
												  subFramesDivisor: tc.subFramesDivisor),
					  "elapsed frames.")
				
			}
			if failures.count > 1 {
				print("Last",
					  fr,
					  "failure: input elapsed frames",
					  failures.last!.0,
					  "converted to components",
					  failures.last!.1,
					  "converted back to",
					  Timecode.totalElapsedFrames(of: failures.last!.1,
												  at: tc.frameRate,
												  subFramesDivisor: tc.subFramesDivisor),
					  "elapsed frames.")
				
			}
			
		}
		
		print("Done")
		
	}
	
}

#endif
