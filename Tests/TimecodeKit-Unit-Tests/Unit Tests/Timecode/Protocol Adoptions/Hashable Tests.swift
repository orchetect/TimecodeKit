//
//  Hashable Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

@testable import TimecodeKit
import XCTest

class Timecode_Hashable_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testHashValue() throws {
        // hashValues should be equal
        
        XCTAssertEqual(
            try "01:00:00:00".timecode(at: ._23_976).hashValue,
            try "01:00:00:00".timecode(at: ._23_976).hashValue
        )
        XCTAssertNotEqual(
            try "01:00:00:01".timecode(at: ._23_976).hashValue,
            try "01:00:00:00".timecode(at: ._23_976).hashValue
        )
        
        XCTAssertNotEqual(
            try "01:00:00:00".timecode(at: ._23_976).hashValue,
            try "01:00:00:00".timecode(at: ._24).hashValue
        )
        XCTAssertNotEqual(
            try "01:00:00:00".timecode(at: ._23_976).hashValue,
            try "01:00:00:00".timecode(at: ._29_97).hashValue
        )
    }
    
    func testDictionary() throws {
        // Dictionary / Set
        
        var dict: [Timecode: String] = [:]
        try dict["01:00:00:00".timecode(at: ._23_976)] = "A Spot Note Here"
        try dict["01:00:00:06".timecode(at: ._23_976)] = "A Spot Note Also Here"
        XCTAssertEqual(dict.count, 2)
        try dict["01:00:00:00".timecode(at: ._24)] = "This should not replace"
        XCTAssertEqual(dict.count, 3)
        
        XCTAssertEqual(try dict["01:00:00:00".timecode(at: ._23_976)], "A Spot Note Here")
        XCTAssertEqual(try dict["01:00:00:00".timecode(at: ._24)], "This should not replace")
    }
    
    func testSet() throws {
        // unique timecodes are based on frame counts, irrespective of frame rate
        
        let tcSet: Set<Timecode> = try [
            "01:00:00:00".timecode(at: ._23_976),
            "01:00:00:00".timecode(at: ._24),
            "01:00:00:00".timecode(at: ._25),
            "01:00:00:00".timecode(at: ._29_97),
            "01:00:00:00".timecode(at: ._29_97_drop),
            "01:00:00:00".timecode(at: ._30),
            "01:00:00:00".timecode(at: ._59_94),
            "01:00:00:00".timecode(at: ._59_94_drop),
            "01:00:00:00".timecode(at: ._60)
        ]
        
        XCTAssertNotEqual(
            tcSet.count,
            1
        ) // doesn't matter what frame rate it is, the same total elapsed frames matters
    }
}

#endif
