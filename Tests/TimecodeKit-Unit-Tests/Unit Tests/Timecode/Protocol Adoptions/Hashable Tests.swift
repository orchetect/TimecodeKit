//
//  Hashable Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import TimecodeKit // do NOT import as @testable in this file
import XCTest

final class Timecode_Hashable_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testHashValue() throws {
        // hashValues should be equal
        
        XCTAssertEqual(
            try Timecode(.string("01:00:00:00"), at: .fps23_976).hashValue,
            try Timecode(.string("01:00:00:00"), at: .fps23_976).hashValue
        )
        XCTAssertNotEqual(
            try Timecode(.string("01:00:00:01"), at: .fps23_976).hashValue,
            try Timecode(.string("01:00:00:00"), at: .fps23_976).hashValue
        )
        
        XCTAssertNotEqual(
            try Timecode(.string("01:00:00:00"), at: .fps23_976).hashValue,
            try Timecode(.string("01:00:00:00"), at: .fps24).hashValue
        )
        XCTAssertNotEqual(
            try Timecode(.string("01:00:00:00"), at: .fps23_976).hashValue,
            try Timecode(.string("01:00:00:00"), at: .fps29_97).hashValue
        )
    }
    
    func testDictionary() throws {
        // Dictionary / Set
        
        var dict: [Timecode: String] = [:]
        try dict[Timecode(.string("01:00:00:00"), at: .fps23_976)] = "A Spot Note Here"
        try dict[Timecode(.string("01:00:00:06"), at: .fps23_976)] = "A Spot Note Also Here"
        XCTAssertEqual(dict.count, 2)
        try dict[Timecode(.string("01:00:00:00"), at: .fps24)] = "This should not replace"
        XCTAssertEqual(dict.count, 3)
        
        XCTAssertEqual(try dict[Timecode(.string("01:00:00:00"), at: .fps23_976)], "A Spot Note Here")
        XCTAssertEqual(try dict[Timecode(.string("01:00:00:00"), at: .fps24)], "This should not replace")
    }
    
    func testSet() throws {
        // unique timecodes are based on frame counts, irrespective of frame rate
        
        let tcSet: Set<Timecode> = try [
            Timecode(.string("01:00:00:00"), at: .fps23_976),
            Timecode(.string("01:00:00:00"), at: .fps24),
            Timecode(.string("01:00:00:00"), at: .fps25),
            Timecode(.string("01:00:00:00"), at: .fps29_97),
            Timecode(.string("01:00:00:00"), at: .fps29_97d),
            Timecode(.string("01:00:00:00"), at: .fps30),
            Timecode(.string("01:00:00:00"), at: .fps59_94),
            Timecode(.string("01:00:00:00"), at: .fps59_94d),
            Timecode(.string("01:00:00:00"), at: .fps60)
        ]
        
        XCTAssertNotEqual(
            tcSet.count,
            1
        ) // doesn't matter what frame rate it is, the same total elapsed frames matters
    }
}
