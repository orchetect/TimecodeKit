//
//  TimecodeField Paste Policy Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(watchOS)

import SwiftUI
@testable import TimecodeKitUI
import XCTest

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
final class TimecodeField_Paste_Policy_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    // MARK: - Test Facilities
    
    private let testFrameRate: TimecodeFrameRate = .fps24
    private let testSubFramesBase: Timecode.SubFramesBase = .max100SubFrames
    
    
    func testValidatePasteResult_AutoAdvance_EnforceValid_SameProperties_ValidValues() {
        let timecode = Timecode(.zero, at: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        XCTAssertEqual(
            TimecodeField.validate(
                pasteResult: .success(timecode),
                inputStyle: .autoAdvance,
                validationPolicy: .enforceValid,
                currentTimecodeProperties: timecode.properties,
                pastePolicy: .preserveLocalProperties
            ),
            .allowed(timecode)
        )
    }
    
    func testValidatePasteResult_AutoAdvance_EnforceValid_SameProperties_InalidValues() {
        let timecode = Timecode(.components(f: 30), at: testFrameRate, base: testSubFramesBase, limit: .max24Hours, by: .allowingInvalid)
        
        XCTAssertEqual(
            TimecodeField.validate(
                pasteResult: .success(timecode),
                inputStyle: .autoAdvance,
                validationPolicy: .enforceValid,
                currentTimecodeProperties: timecode.properties,
                pastePolicy: .preserveLocalProperties
            ),
            .inputRejectionFeedback(.fieldPasteRejected)
        )
    }
    
    func testValidatePasteResult_AutoAdvance_EnforceValid_DifferentProperties_ValidValues() {
        let timecode = Timecode(.components(f: 22), at: .fps48, base: .max100SubFrames, limit: .max24Hours, by: .allowingInvalid)
        
        XCTAssertEqual(
            TimecodeField.validate(
                pasteResult: .success(timecode),
                inputStyle: .autoAdvance,
                validationPolicy: .enforceValid,
                currentTimecodeProperties: timecode.properties,
                pastePolicy: .preserveLocalProperties
            ),
            .allowed(timecode)
        )
    }
    
    #warning("> TODO: finish writing tests")
}

#endif
