//
//  FrameRate Formats Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import TimecodeKit
import OTCore

class Timecode_UT_FrameRate_Formats_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testAAFMetadata() throws {
        // ensure the EditRate calculation is correct
        // due to floating-point dithering, it tends to be accurate up to
        // 16 decimal places when stored in a Double (1 picosecond or less)
        
        try Timecode.FrameRate.allCases.forEach {
            let editRateComponents = $0.aafMetadata.editRate
                .split(separator: "/")
                .compactMap { Int($0) }
            
            guard editRateComponents.count == 2 else {
                XCTFail("\($0) editRate parse failed.")
                return // continue forEach loop
            }
            
            let editRateSeconds = Double(editRateComponents[1]) / Double(editRateComponents[0])
            
            let oneFrameDuration = try TCC(f: 1)
                .toTimecode(at: $0)
                .realTimeValue
            
            XCTAssertEqual(
                editRateSeconds,
                oneFrameDuration,
                accuracy: 0.0000_0000_0000_0001,
                "\($0) failed."
            )
        }
    }
    
    func testFrameDurationCMTime() throws {
        // ensure the CMTime instance returns correct 1 frame duration in seconds.
        // due to floating-point dithering, it tends to be accurate up to
        // 16 decimal places when stored in a Double (1 picosecond or less)
        
        try Timecode.FrameRate.allCases.forEach {
            let cmTimeSeconds = $0.frameDurationCMTime.seconds
            
            let oneFrameDuration = try TCC(f: 1)
                .toTimecode(at: $0)
                .realTimeValue
            
            XCTAssertEqual(
                cmTimeSeconds,
                oneFrameDuration,
                accuracy: 0.0000_0000_0000_0001,
                "\($0) failed."
            )
        }
    }
}

#endif
