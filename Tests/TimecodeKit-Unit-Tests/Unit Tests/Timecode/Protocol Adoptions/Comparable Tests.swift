//
//  Comparable Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import TimecodeKit

class Timecode_UT_Comparable_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testTimecode_Equatable() throws {
        // ==
        
        XCTAssertEqual(
            try "01:00:00:00".toTimecode(at: ._23_976),
            try "01:00:00:00".toTimecode(at: ._23_976)
        )
        XCTAssertEqual(
            try "01:00:00:00".toTimecode(at: ._23_976),
            try "01:00:00:00".toTimecode(at: ._29_97)
        )
        
        // == where elapsed frame count matches but frame rate differs (two frame rates where elapsed frames in 24 hours is identical)
        
        XCTAssertNotEqual(
            try "01:00:00:00".toTimecode(at: ._23_976),
            try "01:00:00:00".toTimecode(at: ._24)
        )
        
        try Timecode.FrameRate.allCases.forEach { frameRate in
            XCTAssertEqual(
                try "01:00:00:00".toTimecode(at: frameRate),
                try "01:00:00:00".toTimecode(at: frameRate)
            )
            
            XCTAssertEqual(
                try "01:00:00:01".toTimecode(at: frameRate),
                try "01:00:00:01".toTimecode(at: frameRate)
            )
        }
    }
    
    func testTimecode_Comparable() throws {
        // < >
        
        XCTAssertFalse(
            try "01:00:00:00".toTimecode(at: ._23_976) // false because they're ==
                < "01:00:00:00".toTimecode(at: ._29_97)
        )
        XCTAssertFalse(
            try "01:00:00:00".toTimecode(at: ._23_976) // false because they're ==
                > "01:00:00:00".toTimecode(at: ._29_97)
        )
        
        XCTAssertFalse(
            try "01:00:00:00".toTimecode(at: ._23_976) // false because they're ==
                < "01:00:00:00".toTimecode(at: ._23_976)
        )
        XCTAssertFalse(
            try "01:00:00:00".toTimecode(at: ._23_976) // false because they're ==
                > "01:00:00:00".toTimecode(at: ._23_976)
        )
        
        try Timecode.FrameRate.allCases.forEach { frameRate in
            XCTAssertTrue(
                try "01:00:00:00".toTimecode(at: frameRate) <
                "01:00:00:01".toTimecode(at: frameRate),
                "\(frameRate)fps"
            )
            
            XCTAssertTrue(
                try "01:00:00:01".toTimecode(at: frameRate) >
                "01:00:00:00".toTimecode(at: frameRate),
                "\(frameRate)fps"
            )
        }
    }
}

#endif
