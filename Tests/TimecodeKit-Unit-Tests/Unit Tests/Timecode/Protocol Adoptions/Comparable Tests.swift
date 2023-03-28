//
//  Comparable Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import TimecodeKit

class Timecode_Comparable_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testTimecode_Equatable() throws {
        // ==
        
        XCTAssertEqual(
            try "01:00:00:00".timecode(using: ._23_976),
            try "01:00:00:00".timecode(using: ._23_976)
        )
        XCTAssertEqual(
            try "01:00:00:00".timecode(using: ._23_976),
            try "01:00:00:00".timecode(using: ._29_97)
        )
        
        // == where elapsed frame count matches but frame rate differs (two frame rates where elapsed frames in 24 hours is identical)
        
        XCTAssertNotEqual(
            try "01:00:00:00".timecode(using: ._23_976),
            try "01:00:00:00".timecode(using: ._24)
        )
        
        try TimecodeFrameRate.allCases.forEach { frameRate in
            XCTAssertEqual(
                try "01:00:00:00".timecode(using: frameRate),
                try "01:00:00:00".timecode(using: frameRate)
            )
            
            XCTAssertEqual(
                try "01:00:00:01".timecode(using: frameRate),
                try "01:00:00:01".timecode(using: frameRate)
            )
        }
    }
    
    func testTimecode_Comparable() throws {
        // < >
        
        XCTAssertFalse(
            try "01:00:00:00".timecode(using: ._23_976) // false because they're ==
                < "01:00:00:00".timecode(using: ._29_97)
        )
        XCTAssertFalse(
            try "01:00:00:00".timecode(using: ._23_976) // false because they're ==
                > "01:00:00:00".timecode(using: ._29_97)
        )
        
        XCTAssertFalse(
            try "01:00:00:00".timecode(using: ._23_976) // false because they're ==
                < "01:00:00:00".timecode(using: ._23_976)
        )
        XCTAssertFalse(
            try "01:00:00:00".timecode(using: ._23_976) // false because they're ==
                > "01:00:00:00".timecode(using: ._23_976)
        )
        
        try TimecodeFrameRate.allCases.forEach { frameRate in
            XCTAssertTrue(
                try "01:00:00:00".timecode(using: frameRate) <
                    "01:00:00:01".timecode(using: frameRate),
                "\(frameRate)fps"
            )
            
            XCTAssertTrue(
                try "01:00:00:01".timecode(using: frameRate) >
                    "01:00:00:00".timecode(using: frameRate),
                "\(frameRate)fps"
            )
        }
    }
    
    /// Assumes timeline start of zero (00:00:00:00)
    func testTimecode_Comparable_Sorted() throws {
        try TimecodeFrameRate.allCases.forEach { frameRate in
            let presortedTimecodes: [Timecode] = [
                try "00:00:00:00".timecode(using: frameRate),
                try "00:00:00:01".timecode(using: frameRate),
                try "00:00:00:14".timecode(using: frameRate),
                try "00:00:00:15".timecode(using: frameRate),
                try "00:00:00:15".timecode(using: frameRate), // sequential dupe
                try "00:00:01:00".timecode(using: frameRate),
                try "00:00:01:01".timecode(using: frameRate),
                try "00:00:01:23".timecode(using: frameRate),
                try "00:00:02:00".timecode(using: frameRate),
                try "00:01:00:05".timecode(using: frameRate),
                try "00:02:00:08".timecode(using: frameRate),
                try "00:23:00:10".timecode(using: frameRate),
                try "01:00:00:00".timecode(using: frameRate),
                try "02:00:00:00".timecode(using: frameRate),
                try "03:00:00:00".timecode(using: frameRate)
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
            let presorted: [Timecode] = [
                try "01:00:00:00".timecode(using: frameRate),
                try "02:00:00:00".timecode(using: frameRate),
                try "03:00:00:00".timecode(using: frameRate),
                try "00:00:00:00".timecode(using: frameRate),
                try "00:00:00:01".timecode(using: frameRate),
                try "00:00:00:14".timecode(using: frameRate),
                try "00:00:00:15".timecode(using: frameRate),
                try "00:00:00:15".timecode(using: frameRate), // sequential dupe
                try "00:00:01:00".timecode(using: frameRate),
                try "00:00:01:01".timecode(using: frameRate),
                try "00:00:01:23".timecode(using: frameRate),
                try "00:00:02:00".timecode(using: frameRate),
                try "00:01:00:05".timecode(using: frameRate),
                try "00:02:00:08".timecode(using: frameRate),
                try "00:23:00:10".timecode(using: frameRate)
            ]
            
            // shuffle
            var shuffled = presorted
            shuffled.guaranteedShuffle()
            
            // sort the shuffled array ascending
            let sortedAscending = shuffled.sorted(
                ascending: true,
                timelineStart: try "01:00:00:00".timecode(using: frameRate)
            )
            XCTAssertEqual(sortedAscending, presorted, "\(frameRate)fps")
            
            // sort the shuffled array descending
            let sortedDecending = shuffled.sorted(
                ascending: false,
                timelineStart: try "01:00:00:00".timecode(using: frameRate)
            )
            let presortedReversed = Array(presorted.reversed())
            XCTAssertEqual(sortedDecending, presortedReversed, "\(frameRate)fps")
        }
    }
    
    func testTimecode_Sort_1HourStart() throws {
        try TimecodeFrameRate.allCases.forEach { frameRate in
            let presorted: [Timecode] = [
                try "01:00:00:00".timecode(using: frameRate),
                try "02:00:00:00".timecode(using: frameRate),
                try "03:00:00:00".timecode(using: frameRate),
                try "00:00:00:00".timecode(using: frameRate),
                try "00:00:00:01".timecode(using: frameRate),
                try "00:00:00:14".timecode(using: frameRate),
                try "00:00:00:15".timecode(using: frameRate),
                try "00:00:00:15".timecode(using: frameRate), // sequential dupe
                try "00:00:01:00".timecode(using: frameRate),
                try "00:00:01:01".timecode(using: frameRate),
                try "00:00:01:23".timecode(using: frameRate),
                try "00:00:02:00".timecode(using: frameRate),
                try "00:01:00:05".timecode(using: frameRate),
                try "00:02:00:08".timecode(using: frameRate),
                try "00:23:00:10".timecode(using: frameRate)
            ]
            
            // shuffle
            var shuffled = presorted
            shuffled.guaranteedShuffle()
            
            // sort the shuffled array ascending
            var sortedAscending = shuffled
            sortedAscending.sort(
                ascending: true,
                timelineStart: try "01:00:00:00".timecode(using: frameRate)
            )
            XCTAssertEqual(sortedAscending, presorted, "\(frameRate)fps")
            
            // sort the shuffled array descending
            var sortedDecending = shuffled
            sortedDecending.sort(ascending: false,
                                 timelineStart: try "01:00:00:00".timecode(using: frameRate))
            let presortedReversed = Array(presorted.reversed())
            XCTAssertEqual(sortedDecending, presortedReversed, "\(frameRate)fps")
        }
    }
    
    func testTimecode_Sorted_TimecodeSortComparator_1HourStart() throws {
        guard #available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *) else {
            throw XCTSkip("Not available on this OS version.")
        }
        
        try TimecodeFrameRate.allCases.forEach { frameRate in
            let presorted: [Timecode] = [
                try "01:00:00:00".timecode(using: frameRate),
                try "02:00:00:00".timecode(using: frameRate),
                try "03:00:00:00".timecode(using: frameRate),
                try "00:00:00:00".timecode(using: frameRate),
                try "00:00:00:01".timecode(using: frameRate),
                try "00:00:00:14".timecode(using: frameRate),
                try "00:00:00:15".timecode(using: frameRate),
                try "00:00:00:15".timecode(using: frameRate), // sequential dupe
                try "00:00:01:00".timecode(using: frameRate),
                try "00:00:01:01".timecode(using: frameRate),
                try "00:00:01:23".timecode(using: frameRate),
                try "00:00:02:00".timecode(using: frameRate),
                try "00:01:00:05".timecode(using: frameRate),
                try "00:02:00:08".timecode(using: frameRate),
                try "00:23:00:10".timecode(using: frameRate)
            ]
            
            // shuffle
            var shuffled = presorted
            shuffled.guaranteedShuffle()
            
            // sort the shuffled array ascending
            let ascendingComparator = TimecodeSortComparator(
                order: .forward,
                timelineStart: try "01:00:00:00".timecode(using: frameRate)
            )
            let sortedAscending = shuffled
                .sorted(using: ascendingComparator)
            XCTAssertEqual(sortedAscending, presorted, "\(frameRate)fps")
            
            // sort the shuffled array descending
            let descendingComparator = TimecodeSortComparator(
                order: .reverse,
                timelineStart: try "01:00:00:00".timecode(using: frameRate)
            )
            let sortedDecending = shuffled
                .sorted(using: descendingComparator)
            let presortedReversed = Array(presorted.reversed())
            XCTAssertEqual(sortedDecending, presortedReversed, "\(frameRate)fps")
        }
    }
    
    /// For comparison with the context of a timeline that is != 00:00:00:00
    func testCompareTo() throws {
        let frameRate: TimecodeFrameRate = ._24
        
        func tc(_ string: String) throws -> Timecode {
            try string.timecode(using: frameRate)
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
        let frameRate: TimecodeFrameRate = ._24
        
        func tc(_ string: String) throws -> Timecode {
            try string.timecode(using: frameRate)
        }
        
        XCTAssertTrue(
            [
                try tc("00:00:00:00"),
                try tc("00:00:00:01"),
                try tc("00:00:00:14"),
                try tc("00:00:00:15"),
                try tc("00:00:00:15"), // sequential dupe
                try tc("00:00:01:00"),
                try tc("00:00:01:01"),
                try tc("00:00:01:23"),
                try tc("00:00:02:00"),
                try tc("00:01:00:05"),
                try tc("00:02:00:08"),
                try tc("00:23:00:10"),
                try tc("01:00:00:00"),
                try tc("02:00:00:00"),
                try tc("03:00:00:00")
            ]
            .isSorted() // timelineStart of zero
        )
        
        XCTAssertFalse(
            [
                try tc("00:00:00:00"),
                try tc("00:00:00:01"),
                try tc("00:00:00:14"),
                try tc("00:00:00:15"),
                try tc("00:00:00:15"), // sequential dupe
                try tc("00:00:01:00"),
                try tc("00:00:01:01"),
                try tc("00:00:01:23"),
                try tc("00:00:02:00"),
                try tc("00:01:00:05"),
                try tc("00:02:00:08"),
                try tc("00:23:00:10"),
                try tc("01:00:00:00"),
                try tc("02:00:00:00"),
                try tc("03:00:00:00")
            ]
            .isSorted(timelineStart: try tc("01:00:00:00"))
        )
        
        XCTAssertTrue(
            [
                try tc("01:00:00:00"),
                try tc("02:00:00:00"),
                try tc("03:00:00:00"),
                try tc("00:00:00:00"),
                try tc("00:00:00:01"),
                try tc("00:00:00:14"),
                try tc("00:00:00:15"),
                try tc("00:00:00:15"), // sequential dupe
                try tc("00:00:01:00"),
                try tc("00:00:01:01"),
                try tc("00:00:01:23"),
                try tc("00:00:02:00"),
                try tc("00:01:00:05"),
                try tc("00:02:00:08"),
                try tc("00:23:00:10"),
                try tc("00:59:59:23") // 1 frame before wrap around
            ]
            .isSorted(timelineStart: try tc("01:00:00:00"))
        )
        
        XCTAssertFalse(
            [
                try tc("01:00:00:00"),
                try tc("02:00:00:00"),
                try tc("03:00:00:00"),
                try tc("00:00:00:00"),
                try tc("00:00:00:01"),
                try tc("00:00:00:14"),
                try tc("00:00:00:15"),
                try tc("00:00:00:15"), // sequential dupe
                try tc("00:00:01:00"),
                try tc("00:00:01:01"),
                try tc("00:00:01:23"),
                try tc("00:00:02:00"),
                try tc("00:01:00:05"),
                try tc("00:02:00:08"),
                try tc("00:23:00:10"),
                try tc("00:59:59:23") // 1 frame before wrap around
            ]
            .isSorted(ascending: false, timelineStart: try tc("01:00:00:00"))
        )
        
        XCTAssertTrue(
            [
                try tc("00:59:59:23"), // 1 frame before wrap around
                try tc("00:23:00:10"),
                try tc("00:02:00:08"),
                try tc("00:01:00:05"),
                try tc("00:00:02:00"),
                try tc("00:00:01:23"),
                try tc("00:00:01:01"),
                try tc("00:00:01:00"),
                try tc("00:00:00:15"),
                try tc("00:00:00:15"), // sequential dupe
                try tc("00:00:00:14"),
                try tc("00:00:00:01"),
                try tc("00:00:00:00"),
                try tc("03:00:00:00"),
                try tc("02:00:00:00"),
                try tc("01:00:00:00")
            ]
            .isSorted(ascending: false, timelineStart: try tc("01:00:00:00"))
        )
    }
}

// MARK: - Helpers

private extension MutableCollection where Self: RandomAccessCollection, Self: Equatable {
    /// Guarantees shuffled array is different than the input.
    mutating func guaranteedShuffle() {
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
