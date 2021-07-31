//
//  Comparable Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//

#if !os(watchOS)

import XCTest
@testable import TimecodeKit

class Timecode_UT_Comparable_Tests: XCTestCase {
    
    override func setUp() { }
    override func tearDown() { }
    
    func testTimecode_Equatable_Comparable() {
        
        // ==
        
        XCTAssertEqual(   "01:00:00:00".toTimecode(at: ._23_976)!,  "01:00:00:00".toTimecode(at: ._23_976)!)
        XCTAssertEqual(   "01:00:00:00".toTimecode(at: ._23_976)!,  "01:00:00:00".toTimecode(at: ._29_97)!)
        
        // == where elapsed frame count matches but frame rate differs (two frame rates where elapsed frames in 24 hours is identical)
        
        XCTAssertNotEqual("01:00:00:00".toTimecode(at: ._23_976)!,  "01:00:00:00".toTimecode(at: ._24)!)
        
        // < >
        
        XCTAssertFalse(   "01:00:00:00".toTimecode(at: ._23_976)! < "01:00:00:00".toTimecode(at: ._29_97)!)  // false because they're ==
        XCTAssertFalse(   "01:00:00:00".toTimecode(at: ._23_976)! > "01:00:00:00".toTimecode(at: ._29_97)!)  // false because they're ==
        
        XCTAssertFalse(   "01:00:00:00".toTimecode(at: ._23_976)! < "01:00:00:00".toTimecode(at: ._23_976)!) // false because they're ==
        XCTAssertFalse(   "01:00:00:00".toTimecode(at: ._23_976)! > "01:00:00:00".toTimecode(at: ._23_976)!) // false because they're ==
        
    }
    
}

#endif
