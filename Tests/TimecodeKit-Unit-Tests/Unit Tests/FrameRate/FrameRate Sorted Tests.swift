//
//  FrameRate Sorted Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import TimecodeKit

class Timecode_UT_FrameRate_Sorted_Tests: XCTestCase {
    func testSortOrder() {
        let unsorted: [Timecode.FrameRate] = [
            ._29_97,
            ._30,
            ._24,
            ._120
        ]
        
        let correctOrder: [Timecode.FrameRate] = [
            ._24,
            ._29_97,
            ._30,
            ._120
        ]
        
        let sorted = unsorted.sorted()
        
        XCTAssertNotEqual(unsorted, sorted)
        
        XCTAssertEqual(sorted, correctOrder)
    }
}
#endif
