//
//  FrameRate CompatibleGroup Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import TimecodeKit
import OTCore

class Timecode_UT_FrameRate_CompatibleGroup_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testCompatibleGroup_EnsureAllFrameRateCasesAreHandled() {
        // If an exception is thrown here, it means that a frame rate has not been added to the CompatibleGroup.table
        
        Timecode.FrameRate.allCases.forEach {
            _ = $0.compatibleGroup
        }
    }
    
    func testCompatibleGroup_compatibleGroup() {
        // methods basic spot-check
        
        // NTSC
        XCTAssertEqual(Timecode.FrameRate._29_97.compatibleGroup, .NTSC)
        XCTAssertEqual(Timecode.FrameRate._59_94.compatibleGroup, .NTSC)
        XCTAssertTrue(Timecode.FrameRate._29_97.isCompatible(with: ._59_94))
        
        // NTSC drop
        XCTAssertEqual(Timecode.FrameRate._29_97_drop.compatibleGroup, .NTSC_drop)
        XCTAssertEqual(Timecode.FrameRate._59_94_drop.compatibleGroup, .NTSC_drop)
        XCTAssertTrue(Timecode.FrameRate._29_97_drop.isCompatible(with: ._59_94_drop))
        
        // ATSC
        XCTAssertEqual(Timecode.FrameRate._24.compatibleGroup, .ATSC)
        XCTAssertEqual(Timecode.FrameRate._30.compatibleGroup, .ATSC)
        XCTAssertTrue(Timecode.FrameRate._24.isCompatible(with: ._30))
        
        // ATSC drop
        XCTAssertEqual(Timecode.FrameRate._30_drop.compatibleGroup, .ATSC_drop)
        XCTAssertEqual(Timecode.FrameRate._60_drop.compatibleGroup, .ATSC_drop)
        XCTAssertTrue(Timecode.FrameRate._30_drop.isCompatible(with: ._60_drop))
    }
    
    func testCompatibleGroup_compatibleGroupRates() {
        for grouping in Timecode.FrameRate.CompatibleGroup.table {
            let otherGroupingsRates = Timecode.FrameRate.CompatibleGroup.table
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
        for grouping in Timecode.FrameRate.CompatibleGroup.table {
            let otherGroupingsRates = Timecode.FrameRate.CompatibleGroup.table
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

#endif
