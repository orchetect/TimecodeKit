//
//  Comparable Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import TimecodeKit // do NOT import as @testable in this file
import XCTest

class Timecode_Comparable_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testTimecode_Equatable() throws {
        // ==
        
        XCTAssertEqual(
            try Timecode(.string("01:00:00:00"), at: .fps23_976),
            try Timecode(.string("01:00:00:00"), at: .fps23_976)
        )
        // frame rate should always be the same, even if elapsed real time is equal
        XCTAssertNotEqual(
            try Timecode(.string("01:00:00:00"), at: .fps23_976),
            try Timecode(.string("01:00:00:00"), at: .fps29_97)
        )
        
        // == where elapsed frame count matches but frame rate differs (two frame rates where elapsed frames in 24 hours is identical)
        
        XCTAssertNotEqual(
            try Timecode(.string("01:00:00:00"), at: .fps23_976),
            try Timecode(.string("01:00:00:00"), at: .fps24)
        )
        
        try TimecodeFrameRate.allCases.forEach { frameRate in
            XCTAssertEqual(
                try Timecode(.string("01:00:00:00"), at: frameRate),
                try Timecode(.string("01:00:00:00"), at: frameRate)
            )
            
            XCTAssertEqual(
                try Timecode(.string("01:00:00:01"), at: frameRate),
                try Timecode(.string("01:00:00:01"), at: frameRate)
            )
        }
    }
    
    func testTimecode_Comparable() throws {
        // < >
        
        XCTAssertFalse(
            try Timecode(.string("01:00:00:00"), at: .fps23_976) // false because they're ==
                < Timecode(.string("01:00:00:00"), at: .fps29_97)
        )
        XCTAssertFalse(
            try Timecode(.string("01:00:00:00"), at: .fps23_976) // false because they're ==
                > Timecode(.string("01:00:00:00"), at: .fps29_97)
        )
        
        XCTAssertFalse(
            try Timecode(.string("01:00:00:00"), at: .fps23_976) // false because they're ==
                < Timecode(.string("01:00:00:00"), at: .fps23_976)
        )
        XCTAssertFalse(
            try Timecode(.string("01:00:00:00"), at: .fps23_976) // false because they're ==
                > Timecode(.string("01:00:00:00"), at: .fps23_976)
        )
        
        try TimecodeFrameRate.allCases.forEach { frameRate in
            XCTAssertTrue(
                try Timecode(.string("01:00:00:00"), at: frameRate) <
                    Timecode(.string("01:00:00:01"), at: frameRate),
                "\(frameRate)fps"
            )
            
            XCTAssertTrue(
                try Timecode(.string("01:00:00:01"), at: frameRate) >
                    Timecode(.string("01:00:00:00"), at: frameRate),
                "\(frameRate)fps"
            )
        }
    }
    
    /// Assumes timeline start of zero (00:00:00:00)
    func testTimecode_Comparable_Sorted() throws {
        try TimecodeFrameRate.allCases.forEach { frameRate in
            let presortedTimecodes: [Timecode] = try [
                Timecode(.string("00:00:00:00"), at: frameRate),
                Timecode(.string("00:00:00:01"), at: frameRate),
                Timecode(.string("00:00:00:14"), at: frameRate),
                Timecode(.string("00:00:00:15"), at: frameRate),
                Timecode(.string("00:00:00:15"), at: frameRate), // sequential dupe
                Timecode(.string("00:00:01:00"), at: frameRate),
                Timecode(.string("00:00:01:01"), at: frameRate),
                Timecode(.string("00:00:01:23"), at: frameRate),
                Timecode(.string("00:00:02:00"), at: frameRate),
                Timecode(.string("00:01:00:05"), at: frameRate),
                Timecode(.string("00:02:00:08"), at: frameRate),
                Timecode(.string("00:23:00:10"), at: frameRate),
                Timecode(.string("01:00:00:00"), at: frameRate),
                Timecode(.string("02:00:00:00"), at: frameRate),
                Timecode(.string("03:00:00:00"), at: frameRate)
            ]
            
            // shuffle
            var shuffledTimecodes = presortedTimecodes
            shuffledTimecodes.guaranteedShuffle()
            
            // sort the shuffled array
            let resortedTimecodes = shuffledTimecodes.sorted()
            
            XCTAssertEqual(resortedTimecodes, presortedTimecodes, "\(frameRate)fps")
        }
    }
    
    func testTimecode_Sorted_1HourStart() throws {
        try TimecodeFrameRate.allCases.forEach { frameRate in
            let presorted: [Timecode] = try [
                Timecode(.string("01:00:00:00"), at: frameRate),
                Timecode(.string("02:00:00:00"), at: frameRate),
                Timecode(.string("03:00:00:00"), at: frameRate),
                Timecode(.string("00:00:00:00"), at: frameRate),
                Timecode(.string("00:00:00:01"), at: frameRate),
                Timecode(.string("00:00:00:14"), at: frameRate),
                Timecode(.string("00:00:00:15"), at: frameRate),
                Timecode(.string("00:00:00:15"), at: frameRate), // sequential dupe
                Timecode(.string("00:00:01:00"), at: frameRate),
                Timecode(.string("00:00:01:01"), at: frameRate),
                Timecode(.string("00:00:01:23"), at: frameRate),
                Timecode(.string("00:00:02:00"), at: frameRate),
                Timecode(.string("00:01:00:05"), at: frameRate),
                Timecode(.string("00:02:00:08"), at: frameRate),
                Timecode(.string("00:23:00:10"), at: frameRate)
            ]
            
            // shuffle
            var shuffled = presorted
            shuffled.guaranteedShuffle()
            
            // sort the shuffled array ascending
            let sortedAscending = try shuffled.sorted(
                ascending: true,
                timelineStart: Timecode(.string("01:00:00:00"), at: frameRate)
            )
            XCTAssertEqual(sortedAscending, presorted, "\(frameRate)fps")
            
            // sort the shuffled array descending
            let sortedDecending = try shuffled.sorted(
                ascending: false,
                timelineStart: Timecode(.string("01:00:00:00"), at: frameRate)
            )
            let presortedReversed = Array(presorted.reversed())
            XCTAssertEqual(sortedDecending, presortedReversed, "\(frameRate)fps")
        }
    }
    
    func testTimecode_Sort_1HourStart() throws {
        try TimecodeFrameRate.allCases.forEach { frameRate in
            let presorted: [Timecode] = try [
                Timecode(.string("01:00:00:00"), at: frameRate),
                Timecode(.string("02:00:00:00"), at: frameRate),
                Timecode(.string("03:00:00:00"), at: frameRate),
                Timecode(.string("00:00:00:00"), at: frameRate),
                Timecode(.string("00:00:00:01"), at: frameRate),
                Timecode(.string("00:00:00:14"), at: frameRate),
                Timecode(.string("00:00:00:15"), at: frameRate),
                Timecode(.string("00:00:00:15"), at: frameRate), // sequential dupe
                Timecode(.string("00:00:01:00"), at: frameRate),
                Timecode(.string("00:00:01:01"), at: frameRate),
                Timecode(.string("00:00:01:23"), at: frameRate),
                Timecode(.string("00:00:02:00"), at: frameRate),
                Timecode(.string("00:01:00:05"), at: frameRate),
                Timecode(.string("00:02:00:08"), at: frameRate),
                Timecode(.string("00:23:00:10"), at: frameRate)
            ]
            
            // shuffle
            var shuffled = presorted
            shuffled.guaranteedShuffle()
            
            // sort the shuffled array ascending
            var sortedAscending = shuffled
            try sortedAscending.sort(
                ascending: true,
                timelineStart: Timecode(.string("01:00:00:00"), at: frameRate)
            )
            XCTAssertEqual(sortedAscending, presorted, "\(frameRate)fps")
            
            // sort the shuffled array descending
            var sortedDecending = shuffled
            try sortedDecending.sort(
                ascending: false,
                timelineStart: Timecode(.string("01:00:00:00"), at: frameRate)
            )
            let presortedReversed = Array(presorted.reversed())
            XCTAssertEqual(sortedDecending, presortedReversed, "\(frameRate)fps")
        }
    }
    
    func testTimecode_Sorted_TimecodeSortComparator_1HourStart() throws {
        guard #available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *) else {
            throw XCTSkip("Not available on this OS version.")
        }
        
        try TimecodeFrameRate.allCases.forEach { frameRate in
            let presorted: [Timecode] = try [
                Timecode(.string("01:00:00:00"), at: frameRate),
                Timecode(.string("02:00:00:00"), at: frameRate),
                Timecode(.string("03:00:00:00"), at: frameRate),
                Timecode(.string("00:00:00:00"), at: frameRate),
                Timecode(.string("00:00:00:01"), at: frameRate),
                Timecode(.string("00:00:00:14"), at: frameRate),
                Timecode(.string("00:00:00:15"), at: frameRate),
                Timecode(.string("00:00:00:15"), at: frameRate), // sequential dupe
                Timecode(.string("00:00:01:00"), at: frameRate),
                Timecode(.string("00:00:01:01"), at: frameRate),
                Timecode(.string("00:00:01:23"), at: frameRate),
                Timecode(.string("00:00:02:00"), at: frameRate),
                Timecode(.string("00:01:00:05"), at: frameRate),
                Timecode(.string("00:02:00:08"), at: frameRate),
                Timecode(.string("00:23:00:10"), at: frameRate)
            ]
            
            // shuffle
            var shuffled = presorted
            shuffled.guaranteedShuffle()
            
            // sort the shuffled array ascending
            let ascendingComparator = try TimecodeSortComparator(
                order: .forward,
                timelineStart: Timecode(.string("01:00:00:00"), at: frameRate)
            )
            let sortedAscending = shuffled
                .sorted(using: ascendingComparator)
            XCTAssertEqual(sortedAscending, presorted, "\(frameRate)fps")
            
            // sort the shuffled array descending
            let descendingComparator = try TimecodeSortComparator(
                order: .reverse,
                timelineStart: Timecode(.string("01:00:00:00"), at: frameRate)
            )
            let sortedDecending = shuffled
                .sorted(using: descendingComparator)
            let presortedReversed = Array(presorted.reversed())
            XCTAssertEqual(sortedDecending, presortedReversed, "\(frameRate)fps")
        }
    }
    
    /// For comparison with the context of a timeline that is != 00:00:00:00
    func testCompareTo() throws {
        let frameRate: TimecodeFrameRate = .fps24
        
        func tc(_ string: String) throws -> Timecode {
            try Timecode(.string(string), at: frameRate)
        }
        
        // orderedSame (==)
        
        XCTAssertEqual(
            try tc("00:00:00:00").compare(to: tc("00:00:00:00"),
                                          timelineStart: tc("00:00:00:00")),
            .orderedSame
        )
        
        XCTAssertEqual(
            try tc("00:00:00:00").compare(to: tc("00:00:00:00"),
                                          timelineStart: tc("01:00:00:00")),
            .orderedSame
        )
        
        XCTAssertEqual(
            try tc("00:00:00:00.01").compare(to: tc("00:00:00:00.01"),
                                             timelineStart: tc("00:00:00:00")),
            .orderedSame
        )
        
        XCTAssertEqual(
            try tc("01:00:00:00").compare(to: tc("01:00:00:00"),
                                          timelineStart: tc("00:00:00:00")),
            .orderedSame
        )
        
        XCTAssertEqual(
            try tc("01:00:00:00").compare(to: tc("01:00:00:00"),
                                          timelineStart: tc("01:00:00:00")),
            .orderedSame
        )
        
        XCTAssertEqual(
            try tc("01:00:00:00").compare(to: tc("01:00:00:00"),
                                          timelineStart: tc("02:00:00:00")),
            .orderedSame
        )
        
        // orderedAscending (<)
        
        XCTAssertEqual(
            try tc("00:00:00:00").compare(to: tc("00:00:00:00.01"),
                                          timelineStart: tc("00:00:00:00")),
            .orderedAscending
        )
        
        XCTAssertEqual(
            try tc("00:00:00:00").compare(to: tc("00:00:00:01"),
                                          timelineStart: tc("00:00:00:00")),
            .orderedAscending
        )
        
        XCTAssertEqual(
            try tc("00:00:00:00").compare(to: tc("00:00:00:01"),
                                          timelineStart: tc("01:00:00:00")),
            .orderedAscending
        )
        
        XCTAssertEqual(
            try tc("23:00:00:00").compare(to: tc("00:00:00:00"),
                                          timelineStart: tc("23:00:00:00")),
            .orderedAscending
        )
        
        XCTAssertEqual(
            try tc("23:30:00:00").compare(to: tc("00:00:00:00"),
                                          timelineStart: tc("23:00:00:00")),
            .orderedAscending
        )
        
        XCTAssertEqual(
            try tc("23:30:00:00").compare(to: tc("01:00:00:00"),
                                          timelineStart: tc("23:00:00:00")),
            .orderedAscending
        )
        
        // orderedDescending (>)
        
        XCTAssertEqual(
            try tc("00:00:00:00.01").compare(to: tc("00:00:00:00"),
                                             timelineStart: tc("00:00:00:00")),
            .orderedDescending
        )
        
        XCTAssertEqual(
            try tc("00:00:00:01").compare(to: tc("00:00:00:00"),
                                          timelineStart: tc("00:00:00:00")),
            .orderedDescending
        )
        
        XCTAssertEqual(
            try tc("23:30:00:00").compare(to: tc("00:00:00:00"),
                                          timelineStart: tc("00:00:00:00")),
            .orderedDescending
        )
        
        XCTAssertEqual(
            try tc("00:00:00:00").compare(to: tc("23:30:00:00"),
                                          timelineStart: tc("23:00:00:00")),
            .orderedDescending
        )
    }
    
    func testCollection_isSorted() throws {
        let frameRate: TimecodeFrameRate = .fps24
        
        func tc(_ string: String) throws -> Timecode {
            try Timecode(.string(string), at: frameRate)
        }
        
        XCTAssertTrue(
            try [
                tc("00:00:00:00"),
                tc("00:00:00:01"),
                tc("00:00:00:14"),
                tc("00:00:00:15"),
                tc("00:00:00:15"), // sequential dupe
                tc("00:00:01:00"),
                tc("00:00:01:01"),
                tc("00:00:01:23"),
                tc("00:00:02:00"),
                tc("00:01:00:05"),
                tc("00:02:00:08"),
                tc("00:23:00:10"),
                tc("01:00:00:00"),
                tc("02:00:00:00"),
                tc("03:00:00:00")
            ]
                .isSorted() // timelineStart of zero
        )
        
        XCTAssertFalse(
            try [
                tc("00:00:00:00"),
                tc("00:00:00:01"),
                tc("00:00:00:14"),
                tc("00:00:00:15"),
                tc("00:00:00:15"), // sequential dupe
                tc("00:00:01:00"),
                tc("00:00:01:01"),
                tc("00:00:01:23"),
                tc("00:00:02:00"),
                tc("00:01:00:05"),
                tc("00:02:00:08"),
                tc("00:23:00:10"),
                tc("01:00:00:00"),
                tc("02:00:00:00"),
                tc("03:00:00:00")
            ]
                .isSorted(timelineStart: tc("01:00:00:00"))
        )
        
        XCTAssertTrue(
            try [
                tc("01:00:00:00"),
                tc("02:00:00:00"),
                tc("03:00:00:00"),
                tc("00:00:00:00"),
                tc("00:00:00:01"),
                tc("00:00:00:14"),
                tc("00:00:00:15"),
                tc("00:00:00:15"), // sequential dupe
                tc("00:00:01:00"),
                tc("00:00:01:01"),
                tc("00:00:01:23"),
                tc("00:00:02:00"),
                tc("00:01:00:05"),
                tc("00:02:00:08"),
                tc("00:23:00:10"),
                tc("00:59:59:23") // 1 frame before wrap around
            ]
                .isSorted(timelineStart: tc("01:00:00:00"))
        )
        
        XCTAssertFalse(
            try [
                tc("01:00:00:00"),
                tc("02:00:00:00"),
                tc("03:00:00:00"),
                tc("00:00:00:00"),
                tc("00:00:00:01"),
                tc("00:00:00:14"),
                tc("00:00:00:15"),
                tc("00:00:00:15"), // sequential dupe
                tc("00:00:01:00"),
                tc("00:00:01:01"),
                tc("00:00:01:23"),
                tc("00:00:02:00"),
                tc("00:01:00:05"),
                tc("00:02:00:08"),
                tc("00:23:00:10"),
                tc("00:59:59:23") // 1 frame before wrap around
            ]
                .isSorted(ascending: false, timelineStart: tc("01:00:00:00"))
        )
        
        XCTAssertTrue(
            try [
                tc("00:59:59:23"), // 1 frame before wrap around
                tc("00:23:00:10"),
                tc("00:02:00:08"),
                tc("00:01:00:05"),
                tc("00:00:02:00"),
                tc("00:00:01:23"),
                tc("00:00:01:01"),
                tc("00:00:01:00"),
                tc("00:00:00:15"),
                tc("00:00:00:15"), // sequential dupe
                tc("00:00:00:14"),
                tc("00:00:00:01"),
                tc("00:00:00:00"),
                tc("03:00:00:00"),
                tc("02:00:00:00"),
                tc("01:00:00:00")
            ]
                .isSorted(ascending: false, timelineStart: tc("01:00:00:00"))
        )
    }
}

// MARK: - Helpers

extension MutableCollection where Self: RandomAccessCollection, Self: Equatable {
    /// Guarantees shuffled array is different than the input.
    fileprivate mutating func guaranteedShuffle() {
        // avoid endless loop with 0 or 1 array elements not being shuffleable
        guard count > 1 else { return }
        
        // randomize so timecodes are out of order;
        // loop in case shuffle produces identical ordering
        var shuffled = self
        var shuffleCount = 0
        while shuffleCount == 0 || shuffled == self {
            shuffled.shuffle()
            shuffleCount += 1
        }
        self = shuffled
    }
}

#endif
