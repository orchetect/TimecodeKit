//
//  TimecodeFrameRate Formats Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftTimecodeCore
import XCTest

final class TimecodeFrameRate_Formats_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testAAFMetadata() throws {
        // ensure the EditRate calculation is correct
        // due to floating-point dithering, it tends to be accurate up to
        // 16 decimal places when stored in a Double (1 picosecond or less)
        
        for item in TimecodeFrameRate.allCases {
            let editRateComponents = item.aafMetadata.editRate
                .split(separator: "/")
                .compactMap { Int($0) }
            
            guard editRateComponents.count == 2 else {
                XCTFail("\(item) editRate parse failed.")
                continue // continue forEach loop
            }
            
            let editRateSeconds = Double(editRateComponents[1]) / Double(editRateComponents[0])
            
            let oneFrameDuration = try Timecode(.components(f: 1), at: item)
                .realTimeValue
            
            XCTAssertEqual(
                editRateSeconds,
                oneFrameDuration,
                accuracy: 0.0000_0000_0000_0001,
                "\(item) failed."
            )
        }
    }
}
