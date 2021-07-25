//
//  Timecode Components Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//

#if !os(watchOS)

import XCTest
@testable import TimecodeKit

class Timecode_UT_DI_Components_Tests: XCTestCase {
    
    override func setUp() { }
    override func tearDown() { }
    
    func testTimecode_components_24hours() {
        
        // default
        
        var tc = Timecode(at: ._30)
        
        XCTAssertEqual(tc.days		, 0)
        XCTAssertEqual(tc.hours		, 0)
        XCTAssertEqual(tc.minutes	, 0)
        XCTAssertEqual(tc.seconds	, 0)
        XCTAssertEqual(tc.frames	, 0)
        XCTAssertEqual(tc.subFrames	, 0)
        
        // setter
        
        tc.components = TCC(h: 1, m: 2, s: 3, f: 4, sf: 5)
        
        XCTAssertEqual(tc.days		, 0)
        XCTAssertEqual(tc.hours		, 1)
        XCTAssertEqual(tc.minutes	, 2)
        XCTAssertEqual(tc.seconds	, 3)
        XCTAssertEqual(tc.frames	, 4)
        XCTAssertEqual(tc.subFrames	, 5)
        
        // getter
        
        let c = tc.components
        
        XCTAssertEqual(c.d			, 0)
        XCTAssertEqual(c.h			, 1)
        XCTAssertEqual(c.m			, 2)
        XCTAssertEqual(c.s			, 3)
        XCTAssertEqual(c.f			, 4)
        XCTAssertEqual(c.sf			, 5)
        
    }
    
    func testTimecode_components_100days() {
        
        // default
        
        var tc = Timecode(at: ._30, limit: ._100days)
        
        XCTAssertEqual(tc.days		, 0)
        XCTAssertEqual(tc.hours		, 0)
        XCTAssertEqual(tc.minutes	, 0)
        XCTAssertEqual(tc.seconds	, 0)
        XCTAssertEqual(tc.frames	, 0)
        XCTAssertEqual(tc.subFrames	, 0)
        
        // setter
        
        tc.components = TCC(d: 5, h: 1, m: 2, s: 3, f: 4, sf: 5)
        
        XCTAssertEqual(tc.days		, 5)
        XCTAssertEqual(tc.hours		, 1)
        XCTAssertEqual(tc.minutes	, 2)
        XCTAssertEqual(tc.seconds	, 3)
        XCTAssertEqual(tc.frames	, 4)
        XCTAssertEqual(tc.subFrames	, 5)
        
        // getter
        
        let c = tc.components
        
        XCTAssertEqual(c.d			, 5)
        XCTAssertEqual(c.h			, 1)
        XCTAssertEqual(c.m			, 2)
        XCTAssertEqual(c.s			, 3)
        XCTAssertEqual(c.f			, 4)
        XCTAssertEqual(c.sf			, 5)
        
    }
    
    func testSetTimecodeExactly() {
        
        // this is not meant to test the underlying logic, simply that .setTimecode produces the intended outcome
        
        var tc = Timecode(at: ._30)
        
        tc.setTimecode(exactly: TCC(h: 1, m: 2, s: 3, f: 4, sf: 5))
        
        XCTAssertEqual(tc.days		, 0)
        XCTAssertEqual(tc.hours		, 1)
        XCTAssertEqual(tc.minutes	, 2)
        XCTAssertEqual(tc.seconds	, 3)
        XCTAssertEqual(tc.frames	, 4)
        XCTAssertEqual(tc.subFrames	, 5)
        
    }
    
    func testSetTimecodeClamping() {
        
        // this is not meant to test the underlying logic, simply that .setTimecode produces the intended outcome
        
        var tc = Timecode(at: ._30)
        
        tc.setTimecode(clamping: TCC(d: 1, h: 70, m: 70, s: 70, f: 70, sf: 500))
        
        XCTAssertEqual(tc.days		, 0)
        XCTAssertEqual(tc.hours		, 23)
        XCTAssertEqual(tc.minutes	, 59)
        XCTAssertEqual(tc.seconds	, 59)
        XCTAssertEqual(tc.frames	, 29)
        XCTAssertEqual(tc.subFrames	, 79)
        
    }
    
    func testSetTimecodeWrapping() {
        
        // this is not meant to test the underlying logic, simply that .setTimecode produces the intended outcome
        
        var tc = Timecode(at: ._30)
        
        tc.setTimecode(wrapping: TCC(f: -1))
        
        XCTAssertEqual(tc.days		, 0)
        XCTAssertEqual(tc.hours		, 23)
        XCTAssertEqual(tc.minutes	, 59)
        XCTAssertEqual(tc.seconds	, 59)
        XCTAssertEqual(tc.frames	, 29)
        XCTAssertEqual(tc.subFrames	, 0)
        
    }
    
}

#endif
