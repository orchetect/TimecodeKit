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
    
    func testTimecode_Equatable_Comparable() throws {
        
        // ==
        
        XCTAssertEqual(try "01:00:00:00".toTimecode(at: ._23_976),
                       try "01:00:00:00".toTimecode(at: ._23_976))
        XCTAssertEqual(try "01:00:00:00".toTimecode(at: ._23_976),
                       try "01:00:00:00".toTimecode(at: ._29_97))
        
        // == where elapsed frame count matches but frame rate differs (two frame rates where elapsed frames in 24 hours is identical)
        
        XCTAssertNotEqual(try "01:00:00:00".toTimecode(at: ._23_976),
                          try "01:00:00:00".toTimecode(at: ._24))
        
        // < >
        
        XCTAssertFalse(try "01:00:00:00".toTimecode(at: ._23_976) // false because they're ==
                        < "01:00:00:00".toTimecode(at: ._29_97))
        XCTAssertFalse(try "01:00:00:00".toTimecode(at: ._23_976) // false because they're ==
                        > "01:00:00:00".toTimecode(at: ._29_97))
        
        XCTAssertFalse(try "01:00:00:00".toTimecode(at: ._23_976) // false because they're ==
                        < "01:00:00:00".toTimecode(at: ._23_976))
        XCTAssertFalse(try "01:00:00:00".toTimecode(at: ._23_976) // false because they're ==
                        > "01:00:00:00".toTimecode(at: ._23_976))
        
    }
    
}

#endif
