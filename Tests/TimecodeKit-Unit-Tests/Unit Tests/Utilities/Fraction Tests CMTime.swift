//
//  Fraction CMTime Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import TimecodeKit
import CoreMedia

class Fraction_CMTime_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testFraction_init_CMTime() {
        XCTAssertEqual(
            Fraction(CMTime(value: 3600, timescale: 1)),
            Fraction(3600, 1)
        )
        
        XCTAssertEqual(
            Fraction(CMTime(value: -3600, timescale: 1)),
            Fraction(-3600, 1)
        )
    }
    
    func testCMTime_init_Fraction() {
        XCTAssertEqual(
            CMTime(Fraction(3600, 1)),
            CMTime(value: 3600, timescale: 1)
        )
        
        XCTAssertEqual(
            CMTime(Fraction(-3600, 1)),
            CMTime(value: -3600, timescale: 1)
        )
    }
}

#endif
