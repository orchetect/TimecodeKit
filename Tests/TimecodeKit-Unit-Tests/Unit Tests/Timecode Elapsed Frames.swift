//
//  Timecode Elapsed Frames.swift
//  TimecodeKitTests
//
//  Created by Steffan Andrews on 2020-06-16.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

import XCTest
@testable import TimecodeKit

class Timecode_UT_Elapsed_Frames: XCTestCase {
	
	override func setUp() { }
	override func tearDown() { }
	
	func testAllFrameRates_ElapsedFrames() {
		
		// duration of 24 hours elapsed, rolling over to 1 day
		
		// also helps ensure Strideable .distance(to:) returns the correct values
		
		Timecode.FrameRate.allCases.forEach {
			
			// max frames in 24 hours
			
			var maxFramesIn24hours = 0
			switch $0 {
			case ._23_976		: maxFramesIn24hours = 2073600
			case ._24			: maxFramesIn24hours = 2073600
			case ._24_98		: maxFramesIn24hours = 2160000
			case ._25			: maxFramesIn24hours = 2160000
			case ._29_97		: maxFramesIn24hours = 2592000
			case ._29_97_drop	: maxFramesIn24hours = 2589408
			case ._30			: maxFramesIn24hours = 2592000
			case ._30_drop		: maxFramesIn24hours = 2589408
			case ._47_952		: maxFramesIn24hours = 4147200
			case ._48			: maxFramesIn24hours = 4147200
			case ._50			: maxFramesIn24hours = 4320000
			case ._59_94		: maxFramesIn24hours = 5184000
			case ._59_94_drop	: maxFramesIn24hours = 5178816
			case ._60			: maxFramesIn24hours = 5184000
			case ._60_drop		: maxFramesIn24hours = 5178816
			case ._100			: maxFramesIn24hours = 8640000
			case ._119_88		: maxFramesIn24hours = 10368000
			case ._119_88_drop	: maxFramesIn24hours = 10357632
			case ._120			: maxFramesIn24hours = 10368000
			case ._120_drop		: maxFramesIn24hours = 10357632
			}
			
			XCTAssertEqual($0.maxTotalFrames(in: ._24hours),
						   maxFramesIn24hours,
						   "for \($0)")
			
		}
		
		// number of total elapsed frames in (24 hours - 1 frame), or essentially the maximum timecode expressable for each frame rate
		
		Timecode.FrameRate.allCases.forEach {
			
			// max frames in 24 hours - 1
			
			var maxFramesExpressibleIn24hours = 0
			switch $0 {
			case ._23_976		: maxFramesExpressibleIn24hours = 2073600 - 1
			case ._24			: maxFramesExpressibleIn24hours = 2073600 - 1
			case ._24_98		: maxFramesExpressibleIn24hours = 2160000 - 1
			case ._25			: maxFramesExpressibleIn24hours = 2160000 - 1
			case ._29_97		: maxFramesExpressibleIn24hours = 2592000 - 1
			case ._29_97_drop	: maxFramesExpressibleIn24hours = 2589408 - 1
			case ._30			: maxFramesExpressibleIn24hours = 2592000 - 1
			case ._30_drop		: maxFramesExpressibleIn24hours = 2589408 - 1
			case ._47_952		: maxFramesExpressibleIn24hours = 4147200 - 1
			case ._48			: maxFramesExpressibleIn24hours = 4147200 - 1
			case ._50			: maxFramesExpressibleIn24hours = 4320000 - 1
			case ._59_94		: maxFramesExpressibleIn24hours = 5184000 - 1
			case ._59_94_drop	: maxFramesExpressibleIn24hours = 5178816 - 1
			case ._60			: maxFramesExpressibleIn24hours = 5184000 - 1
			case ._60_drop		: maxFramesExpressibleIn24hours = 5178816 - 1
			case ._100			: maxFramesExpressibleIn24hours = 8640000 - 1
			case ._119_88		: maxFramesExpressibleIn24hours = 10368000 - 1
			case ._119_88_drop	: maxFramesExpressibleIn24hours = 10357632 - 1
			case ._120			: maxFramesExpressibleIn24hours = 10368000 - 1
			case ._120_drop		: maxFramesExpressibleIn24hours = 10357632 - 1
			}
			
			XCTAssertEqual($0.maxTotalFramesExpressible(in: ._24hours),
						   maxFramesExpressibleIn24hours,
						   "for \($0)")
			
		}
		
	}
	
}
