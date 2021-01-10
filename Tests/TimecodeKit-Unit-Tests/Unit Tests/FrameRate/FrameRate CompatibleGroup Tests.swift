//
//  FrameRate CompatibleGroup Tests.swift
//  TimecodeKitTests
//
//  Created by Steffan Andrews on 2020-06-16.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

import XCTest
@testable import TimecodeKit

class Timecode_UT_FrameRate_CompatibleGroup: XCTestCase {
	
	override func setUp() { }
	override func tearDown() { }
	
	func testCompatibleGroup_EnsureAllFrameRateCasesAreHandled() {
		
		// If an exception is thrown here, it means that a frame rate has not been added to the CompatibleGroup.table
		
		Timecode.FrameRate.allCases.forEach {
			
			_ = $0.compatibleGroup
			
		}
		
	}
	
	func testCompatibleGroup_Basic() {
		
		// methods basic spot-check
		
		// NTSC
		XCTAssertEqual(Timecode.FrameRate._29_97.compatibleGroup, .NTSC)
		XCTAssertEqual(Timecode.FrameRate._59_94.compatibleGroup, .NTSC)
		XCTAssertTrue(Timecode.FrameRate._29_97.isCompatible(with: ._59_94))
		
		// NTSC drop
		XCTAssertEqual(Timecode.FrameRate._29_97_drop.compatibleGroup, .NTSC_drop)
		XCTAssertEqual(Timecode.FrameRate._59_94_drop.compatibleGroup, .NTSC_drop)
		XCTAssertTrue(Timecode.FrameRate._29_97_drop.isCompatible(with: ._59_94_drop))
		
		// ATSC
		XCTAssertEqual(Timecode.FrameRate._24.compatibleGroup, .ATSC)
		XCTAssertEqual(Timecode.FrameRate._30.compatibleGroup, .ATSC)
		XCTAssertTrue(Timecode.FrameRate._24.isCompatible(with: ._30))
		
		// ATSC drop
		XCTAssertEqual(Timecode.FrameRate._30_drop.compatibleGroup, .ATSC_drop)
		XCTAssertEqual(Timecode.FrameRate._60_drop.compatibleGroup, .ATSC_drop)
		XCTAssertTrue(Timecode.FrameRate._30_drop.isCompatible(with: ._60_drop))
		
	}
	
}
