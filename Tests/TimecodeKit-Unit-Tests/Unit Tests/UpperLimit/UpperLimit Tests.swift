//
//  UpperLimit Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//

#if !os(watchOS)

import XCTest
@testable import TimecodeKit
import OTCore

class Timecode_UT_UpperLimit: XCTestCase {
    
    func test24Hours() {
        
        let upperLimit: Timecode.UpperLimit = ._24hours
        
        XCTAssertEqual(upperLimit.maxDays, 1)
        XCTAssertEqual(upperLimit.maxDaysExpressible, 0)
        
        XCTAssertEqual(upperLimit.maxHours, 24)
        XCTAssertEqual(upperLimit.maxHoursExpressible, 23)
        XCTAssertEqual(upperLimit.maxHoursTotal, 23)
        
    }
    
    func test100Days() {
        
        let upperLimit: Timecode.UpperLimit = ._100days
        
        XCTAssertEqual(upperLimit.maxDays, 100)
        XCTAssertEqual(upperLimit.maxDaysExpressible, 99)
        
        XCTAssertEqual(upperLimit.maxHours, 24)
        XCTAssertEqual(upperLimit.maxHoursExpressible, 23)
        XCTAssertEqual(upperLimit.maxHoursTotal, (24 * 100) - 1)
        
    }
    
}
#endif
