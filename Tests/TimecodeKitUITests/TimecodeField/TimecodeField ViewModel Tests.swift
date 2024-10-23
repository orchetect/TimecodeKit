//
//  TimecodeField ViewModel Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(watchOS)

import SwiftUI
@testable import TimecodeKitUI
import XCTest

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
final class TimecodeField_ViewModel_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    // MARK: - Test Facilities
    
    private let testFrameRate: TimecodeFrameRate = .fps24
    private let testSubFramesBase: Timecode.SubFramesBase = .max100SubFrames
    
    private func viewModelFactory() -> MockViewModel {
        MockViewModel()
    }
    
    func testValidatePasteResult_AutoAdvance_EnforceValid_SameProperties_ValidValues() {
        let model = viewModelFactory()
        
        let timecode = Timecode(.zero, at: testFrameRate, base: testSubFramesBase, limit: .max24Hours)
        
        XCTAssertEqual(
            model.validate(
                pasteResult: .success(timecode),
                inputStyle: .autoAdvance,
                validationPolicy: .enforceValid,
                currentTimecodeProperties: timecode.properties
            ),
            .setTimecode(timecode)
        )
    }
    
    func testValidatePasteResult_AutoAdvance_EnforceValid_SameProperties_InalidValues() {
        let model = viewModelFactory()
        
        let timecode = Timecode(.components(f: 30), at: testFrameRate, base: testSubFramesBase, limit: .max24Hours, by: .allowingInvalid)
        
        XCTAssertEqual(
            model.validate(
                pasteResult: .success(timecode),
                inputStyle: .autoAdvance,
                validationPolicy: .enforceValid,
                currentTimecodeProperties: timecode.properties
            ),
            .inputRejectionFeedback(.fieldPasteRejected)
        )
    }
    
    func testValidatePasteResult_AutoAdvance_EnforceValid_DifferentProperties_ValidValues() {
        let model = viewModelFactory()
        
        let timecode = Timecode(.components(f: 22), at: .fps48, base: .max100SubFrames, limit: .max24Hours, by: .allowingInvalid)
        
        XCTAssertEqual(
            model.validate(
                pasteResult: .success(timecode),
                inputStyle: .autoAdvance,
                validationPolicy: .enforceValid,
                currentTimecodeProperties: timecode.properties
            ),
            .setTimecode(timecode)
        )
    }
    
    #warning("> TODO: finish writing tests")
}

// MARK: - Test Utilities

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
fileprivate class MockViewModel: TimecodeField.ViewModel {
    
}

#endif
