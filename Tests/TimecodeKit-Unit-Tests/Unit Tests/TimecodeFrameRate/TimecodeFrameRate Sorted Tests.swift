//
//  TimecodeFrameRate Sorted Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import TimecodeKit
import XCTest

final class TimecodeFrameRate_Sorted_Tests: XCTestCase {
    func testSortOrder() {
        let unsorted: [TimecodeFrameRate] = [
            .fps29_97,
            .fps30,
            .fps24,
            .fps120
        ]
        
        let correctOrder: [TimecodeFrameRate] = [
            .fps24,
            .fps29_97,
            .fps30,
            .fps120
        ]
        
        let sorted = unsorted.sorted()
        
        XCTAssertNotEqual(unsorted, sorted)
        
        XCTAssertEqual(sorted, correctOrder)
    }
}
