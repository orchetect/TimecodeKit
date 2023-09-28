//
//  TimecodeFrameRate Formats Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import TimecodeKit
import XCTest

class TimecodeFrameRate_Formats_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testAAFMetadata() throws {
        // ensure the EditRate calculation is correct
        // due to floating-point dithering, it tends to be accurate up to
        // 16 decimal places when stored in a Double (1 picosecond or less)
        
        try TimecodeFrameRate.allCases.forEach {
            let editRateComponents = $0.aafMetadata.editRate
                .split(separator: "/")
                .compactMap { Int($0) }
            
            guard editRateComponents.count == 2 else {
                XCTFail("\($0) editRate parse failed.")
                return // continue forEach loop
            }
            
            let editRateSeconds = Double(editRateComponents[1]) / Double(editRateComponents[0])
            
            let oneFrameDuration = try Timecode(.components(f: 1), at: $0)
                .realTimeValue
            
            XCTAssertEqual(
                editRateSeconds,
                oneFrameDuration,
                accuracy: 0.0000_0000_0000_0001,
                "\($0) failed."
            )
        }
    }
}

#endif
