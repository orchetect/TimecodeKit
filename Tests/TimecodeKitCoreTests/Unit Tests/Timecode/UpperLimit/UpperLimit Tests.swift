//
//  UpperLimit Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

@testable import TimecodeKitCore
import XCTest

final class Timecode_UpperLimit: XCTestCase {
    func test24Hours() {
        let upperLimit: Timecode.UpperLimit = .max24Hours
        
        XCTAssertEqual(upperLimit.maxDays, 1)
        XCTAssertEqual(upperLimit.maxDaysExpressible, 0)
        
        XCTAssertEqual(upperLimit.maxHours, 24)
        XCTAssertEqual(upperLimit.maxHoursExpressible, 23)
        XCTAssertEqual(upperLimit.maxHoursTotal, 23)
    }
    
    func test100Days() {
        let upperLimit: Timecode.UpperLimit = .max100Days
        
        XCTAssertEqual(upperLimit.maxDays, 100)
        XCTAssertEqual(upperLimit.maxDaysExpressible, 99)
        
        XCTAssertEqual(upperLimit.maxHours, 24)
        XCTAssertEqual(upperLimit.maxHoursExpressible, 23)
        XCTAssertEqual(upperLimit.maxHoursTotal, (24 * 100) - 1)
    }
}
