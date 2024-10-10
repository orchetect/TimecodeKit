//
//  TimecodeFrameRate CompatibleGroup Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import TimecodeKit
import XCTest

final class TimecodeFrameRate_CompatibleGroup_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testCompatibleGroup_EnsureAllFrameRateCasesAreHandled() {
        // If an exception is thrown here, it means that a frame rate has not been added to the CompatibleGroup.table
        
        TimecodeFrameRate.allCases.forEach {
            _ = $0.compatibleGroup
        }
    }
    
    func testCompatibleGroup_compatibleGroup() {
        // methods basic spot-check
        
        // NTSC
        XCTAssertEqual(TimecodeFrameRate.fps29_97.compatibleGroup, .ntscColor)
        XCTAssertEqual(TimecodeFrameRate.fps59_94.compatibleGroup, .ntscColor)
        XCTAssertTrue(TimecodeFrameRate.fps29_97.isCompatible(with: .fps59_94))
        
        // NTSC Drop
        XCTAssertEqual(TimecodeFrameRate.fps29_97d.compatibleGroup, .ntscDrop)
        XCTAssertEqual(TimecodeFrameRate.fps59_94d.compatibleGroup, .ntscDrop)
        XCTAssertTrue(TimecodeFrameRate.fps29_97d.isCompatible(with: .fps59_94d))
        
        // Whole
        XCTAssertEqual(TimecodeFrameRate.fps24.compatibleGroup, .whole)
        XCTAssertEqual(TimecodeFrameRate.fps30.compatibleGroup, .whole)
        XCTAssertTrue(TimecodeFrameRate.fps24.isCompatible(with: .fps30))
        
        // NTSC Color Wall Time
        XCTAssertEqual(TimecodeFrameRate.fps30d.compatibleGroup, .ntscColorWallTime)
        XCTAssertEqual(TimecodeFrameRate.fps60d.compatibleGroup, .ntscColorWallTime)
        XCTAssertTrue(TimecodeFrameRate.fps30d.isCompatible(with: .fps60d))
    }
    
    func testCompatibleGroup_compatibleGroupRates() {
        for grouping in TimecodeFrameRate.CompatibleGroup.table {
            let otherGroupingsRates = TimecodeFrameRate.CompatibleGroup.table
                .compactMap { $0.key != grouping.key ? $0 : nil }
                .reduce(into: []) { $0 += ($1.value) }
            
            for rate in grouping.value {
                XCTAssertEqual(
                    rate.compatibleGroupRates,
                    grouping.value
                )
            }
            
            for rate in otherGroupingsRates {
                XCTAssertNotEqual(
                    rate.compatibleGroupRates,
                    grouping.value
                )
            }
        }
    }
    
    func testCompatibleGroup_isCompatible() {
        for grouping in TimecodeFrameRate.CompatibleGroup.table {
            let otherGroupingsRates = TimecodeFrameRate.CompatibleGroup.table
                .compactMap { $0.key != grouping.key ? $0 : nil }
                .reduce(into: []) { $0 += ($1.value) }
            
            // test against other rates in the same grouping
            for srcRate in grouping.value {
                for destRate in grouping.value {
                    XCTAssertTrue(srcRate.isCompatible(with: destRate))
                }
            }
            
            // test against rates in all the other groupings
            for srcRate in grouping.value {
                for destRate in otherGroupingsRates {
                    XCTAssertFalse(srcRate.isCompatible(with: destRate))
                }
            }
        }
    }
}
