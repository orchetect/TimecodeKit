//
//  TimecodeField ComponentState Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(watchOS)

import SwiftUI
@testable import TimecodeKitUI
import XCTest

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
final class TimecodeField_ComponentState_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    // MARK: - Test Facilities
    
    private let testFrameRate: TimecodeFrameRate = .fps24
    private let testSubFramesBase: Timecode.SubFramesBase = .max100SubFrames
    private let testUpperLimit: Timecode.UpperLimit = .max24Hours
    
    /// Returns a new component state instance using the timecode properties constants.
    private func mockFactory(
        component: Timecode.Component,
        inputStyle: TimecodeField.InputStyle,
        policy: TimecodeField.ValidationPolicy,
        initialValue: Int
    ) -> MockComponentState {
        MockComponentState(
            component: component,
            rate: testFrameRate,
            base: testSubFramesBase,
            limit: testUpperLimit,
            inputStyle: inputStyle,
            policy: policy,
            initialValue: initialValue
        )
    }
    
    // MARK: - autoAdvance / enforceValid
    
    func testAutoAdvance_EnforceValid_Hours_00() {
        let state = mockFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .enforceValid,
            initialValue: 0
        )
        
        XCTAssertEqual(state.press(.num0), .init(.handled))
        XCTAssertEqual(state.value, 0)
        
        XCTAssertEqual(state.press(.num0), .init(.handled, .focusNextComponent))
        XCTAssertEqual(state.value, 0)
    }
    
    func testAutoAdvance_EnforceValid_Hours_01() {
        let state = mockFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .enforceValid,
            initialValue: 0
        )
        
        XCTAssertEqual(state.press(.num0), .init(.handled))
        XCTAssertEqual(state.value, 0)
        
        XCTAssertEqual(state.press(.num1), .init(.handled, .focusNextComponent))
        XCTAssertEqual(state.value, 1)
    }
    
    func testAutoAdvance_EnforceValid_Hours_12() {
        let state = mockFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .enforceValid,
            initialValue: 0
        )
        
        XCTAssertEqual(state.press(.num1), .init(.handled))
        XCTAssertEqual(state.value, 1)
        
        XCTAssertEqual(state.press(.num2), .init(.handled, .focusNextComponent))
        XCTAssertEqual(state.value, 12)
    }
    
    func testAutoAdvance_EnforceValid_Hours_a12() {
        let state = mockFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .enforceValid,
            initialValue: 0
        )
        
        XCTAssertEqual(state.press(.a), .init(.ignored, errorFeedback: true))
        XCTAssertEqual(state.value, 0)
        
        XCTAssertEqual(state.press(.num1), .init(.handled))
        XCTAssertEqual(state.value, 1)
        
        XCTAssertEqual(state.press(.num2), .init(.handled, .focusNextComponent))
        XCTAssertEqual(state.value, 12)
    }
    
    func testAutoAdvance_EnforceValid_Hours_1a2() {
        let state = mockFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .enforceValid,
            initialValue: 0
        )
        
        XCTAssertEqual(state.press(.num1), .init(.handled))
        XCTAssertEqual(state.value, 1)
        
        XCTAssertEqual(state.press(.a), .init(.ignored, errorFeedback: true))
        XCTAssertEqual(state.value, 1)
        
        XCTAssertEqual(state.press(.num2), .init(.handled, .focusNextComponent))
        XCTAssertEqual(state.value, 12)
    }
    
    func testAutoAdvance_EnforceValid_Hours_293() {
        let state = mockFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .enforceValid,
            initialValue: 0
        )
        
        XCTAssertEqual(state.press(.num2), .init(.handled))
        XCTAssertEqual(state.value, 2)
        
        XCTAssertEqual(state.press(.num9), .init(.handled, errorFeedback: true))
        XCTAssertEqual(state.value, 2)
        
        XCTAssertEqual(state.press(.num3), .init(.handled, .focusNextComponent))
        XCTAssertEqual(state.value, 23)
    }
    
    func testAutoAdvance_EnforceValid_Hours_period() {
        let state = mockFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .enforceValid,
            initialValue: 0
        )
        
        XCTAssertEqual(state.press(.period), .init(.handled, .focusNextComponent))
        XCTAssertEqual(state.value, 0)
    }
    
    func testAutoAdvance_EnforceValid_Hours_1period() {
        let state = mockFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .enforceValid,
            initialValue: 0
        )
        
        XCTAssertEqual(state.press(.num1), .init(.handled))
        XCTAssertEqual(state.value, 1)
        
        XCTAssertEqual(state.press(.period), .init(.handled, .focusNextComponent))
        XCTAssertEqual(state.value, 1)
    }
    
    func testAutoAdvance_EnforceValid_Hours_colon() {
        let state = mockFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .enforceValid,
            initialValue: 0
        )
        
        XCTAssertEqual(state.press(.colon), .init(.handled, .focusNextComponent))
        XCTAssertEqual(state.value, 0)
    }
    
    func testAutoAdvance_EnforceValid_Hours_1colon() {
        let state = mockFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .enforceValid,
            initialValue: 0
        )
        
        XCTAssertEqual(state.press(.num1), .init(.handled))
        XCTAssertEqual(state.value, 1)
        
        XCTAssertEqual(state.press(.colon), .init(.handled, .focusNextComponent))
        XCTAssertEqual(state.value, 1)
    }
    
    // MARK: - continuousWithinComponent / enforceValid
    
    func testContinuousWithinComponent_EnforceValid_Hours_00() {
        let state = mockFactory(
            component: .hours,
            inputStyle: .continuousWithinComponent,
            policy: .enforceValid,
            initialValue: 0
        )
        
        XCTAssertEqual(state.press(.num0), .init(.handled))
        XCTAssertEqual(state.value, 0)
        
        XCTAssertEqual(state.press(.num0), .init(.handled))
        XCTAssertEqual(state.value, 0)
        
        XCTAssertEqual(state.press(.num0), .init(.handled))
        XCTAssertEqual(state.value, 0)
    }
    
    func testContinuousWithinComponent_EnforceValid_Hours_012200() {
        let state = mockFactory(
            component: .hours,
            inputStyle: .continuousWithinComponent,
            policy: .enforceValid,
            initialValue: 0
        )
        
        XCTAssertEqual(state.press(.num0), .init(.handled))
        XCTAssertEqual(state.value, 0)
        
        XCTAssertEqual(state.press(.num1), .init(.handled))
        XCTAssertEqual(state.value, 1)
        
        XCTAssertEqual(state.press(.num2), .init(.handled))
        XCTAssertEqual(state.value, 12)
        
        XCTAssertEqual(state.press(.num2), .init(.handled))
        XCTAssertEqual(state.value, 22)
        
        XCTAssertEqual(state.press(.num0), .init(.handled))
        XCTAssertEqual(state.value, 20)
        
        XCTAssertEqual(state.press(.num0), .init(.handled))
        XCTAssertEqual(state.value, 0)
    }
    
    func testContinuousWithinComponent_EnforceValid_Hours_a12a3() {
        let state = mockFactory(
            component: .hours,
            inputStyle: .continuousWithinComponent,
            policy: .enforceValid,
            initialValue: 0
        )
        
        XCTAssertEqual(state.press(.a), .init(.ignored, errorFeedback: true))
        XCTAssertEqual(state.value, 0)
        
        XCTAssertEqual(state.press(.num1), .init(.handled))
        XCTAssertEqual(state.value, 1)
        
        XCTAssertEqual(state.press(.num2), .init(.handled))
        XCTAssertEqual(state.value, 12)
        
        XCTAssertEqual(state.press(.a), .init(.ignored, errorFeedback: true))
        XCTAssertEqual(state.value, 12)
        
        XCTAssertEqual(state.press(.num3), .init(.handled))
        XCTAssertEqual(state.value, 23)
    }
    
    func testContinuousWithinComponent_EnforceValid_Hours_1a2() {
        let state = mockFactory(
            component: .hours,
            inputStyle: .continuousWithinComponent,
            policy: .enforceValid,
            initialValue: 0
        )
        
        XCTAssertEqual(state.press(.num1), .init(.handled))
        XCTAssertEqual(state.value, 1)
        
        XCTAssertEqual(state.press(.a), .init(.ignored, errorFeedback: true))
        XCTAssertEqual(state.value, 1)
        
        XCTAssertEqual(state.press(.num2), .init(.handled))
        XCTAssertEqual(state.value, 12)
    }
    
    func testContinuousWithinComponent_EnforceValid_Hours_293() {
        let state = mockFactory(
            component: .hours,
            inputStyle: .continuousWithinComponent,
            policy: .enforceValid,
            initialValue: 0
        )
        
        XCTAssertEqual(state.press(.num2), .init(.handled))
        XCTAssertEqual(state.value, 2)
        
        XCTAssertEqual(state.press(.num9), .init(.handled, errorFeedback: true))
        XCTAssertEqual(state.value, 2)
        
        XCTAssertEqual(state.press(.num3), .init(.handled))
        XCTAssertEqual(state.value, 23)
    }
    
    func testContinuousWithinComponent_EnforceValid_Hours_period() {
        let state = mockFactory(
            component: .hours,
            inputStyle: .continuousWithinComponent,
            policy: .enforceValid,
            initialValue: 0
        )
        
        XCTAssertEqual(state.press(.period), .init(.handled, .focusNextComponent))
        XCTAssertEqual(state.value, 0)
    }
    
    func testContinuousWithinComponent_EnforceValid_Hours_1period() {
        let state = mockFactory(
            component: .hours,
            inputStyle: .continuousWithinComponent,
            policy: .enforceValid,
            initialValue: 0
        )
        
        XCTAssertEqual(state.press(.num1), .init(.handled))
        XCTAssertEqual(state.value, 1)
        
        XCTAssertEqual(state.press(.period), .init(.handled, .focusNextComponent))
        XCTAssertEqual(state.value, 1)
    }
    
    func testContinuousWithinComponent_EnforceValid_Hours_colon() {
        let state = mockFactory(
            component: .hours,
            inputStyle: .continuousWithinComponent,
            policy: .enforceValid,
            initialValue: 0
        )
        
        XCTAssertEqual(state.press(.colon), .init(.handled, .focusNextComponent))
        XCTAssertEqual(state.value, 0)
    }
    
    func testContinuousWithinComponent_EnforceValid_Hours_1colon() {
        let state = mockFactory(
            component: .hours,
            inputStyle: .continuousWithinComponent,
            policy: .enforceValid,
            initialValue: 0
        )
        
        XCTAssertEqual(state.press(.num1), .init(.handled))
        XCTAssertEqual(state.value, 1)
        
        XCTAssertEqual(state.press(.colon), .init(.handled, .focusNextComponent))
        XCTAssertEqual(state.value, 1)
    }
    
    func testContinuousWithinComponent_EnforceValid_Hours_123colon() {
        let state = mockFactory(
            component: .hours,
            inputStyle: .continuousWithinComponent,
            policy: .enforceValid,
            initialValue: 0
        )
        
        XCTAssertEqual(state.press(.num1), .init(.handled))
        XCTAssertEqual(state.value, 1)
        
        XCTAssertEqual(state.press(.num2), .init(.handled))
        XCTAssertEqual(state.value, 12)
        
        XCTAssertEqual(state.press(.num3), .init(.handled))
        XCTAssertEqual(state.value, 23)
        
        XCTAssertEqual(state.press(.colon), .init(.handled, .focusNextComponent))
        XCTAssertEqual(state.value, 23)
    }
    
    // MARK: - autoAdvance / allowInvalid
    
    func testAutoAdvance_AllowInvalid_Hours_00() {
        let state = mockFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        XCTAssertEqual(state.press(.num0), .init(.handled))
        XCTAssertEqual(state.value, 0)
        
        XCTAssertEqual(state.press(.num0), .init(.handled, .focusNextComponent))
        XCTAssertEqual(state.value, 0)
    }
    
    func testAutoAdvance_AllowInvalid_Hours_01() {
        let state = mockFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        XCTAssertEqual(state.press(.num0), .init(.handled))
        XCTAssertEqual(state.value, 0)
        
        XCTAssertEqual(state.press(.num1), .init(.handled, .focusNextComponent))
        XCTAssertEqual(state.value, 1)
    }
    
    func testAutoAdvance_AllowInvalid_Hours_12() {
        let state = mockFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        XCTAssertEqual(state.press(.num1), .init(.handled))
        XCTAssertEqual(state.value, 1)
        
        XCTAssertEqual(state.press(.num2), .init(.handled, .focusNextComponent))
        XCTAssertEqual(state.value, 12)
    }
    
    func testAutoAdvance_AllowInvalid_Hours_a12() {
        let state = mockFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        XCTAssertEqual(state.press(.a), .init(.ignored, errorFeedback: true))
        XCTAssertEqual(state.value, 0)
        
        XCTAssertEqual(state.press(.num1), .init(.handled))
        XCTAssertEqual(state.value, 1)
        
        XCTAssertEqual(state.press(.num2), .init(.handled, .focusNextComponent))
        XCTAssertEqual(state.value, 12)
    }
    
    func testAutoAdvance_AllowInvalid_Hours_1a2() {
        let state = mockFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        XCTAssertEqual(state.press(.num1), .init(.handled))
        XCTAssertEqual(state.value, 1)
        
        XCTAssertEqual(state.press(.a), .init(.ignored, errorFeedback: true))
        XCTAssertEqual(state.value, 1)
        
        XCTAssertEqual(state.press(.num2), .init(.handled, .focusNextComponent))
        XCTAssertEqual(state.value, 12)
    }
    
    func testAutoAdvance_AllowInvalid_Hours_29() {
        let state = mockFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        XCTAssertEqual(state.press(.num2), .init(.handled))
        XCTAssertEqual(state.value, 2)
        
        XCTAssertEqual(state.press(.num9), .init(.handled, .focusNextComponent))
        XCTAssertEqual(state.value, 29)
    }
    
    func testAutoAdvance_AllowInvalid_Hours_period() {
        let state = mockFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        XCTAssertEqual(state.press(.period), .init(.handled, .focusNextComponent))
        XCTAssertEqual(state.value, 0)
    }
    
    func testAutoAdvance_AllowInvalid_Hours_1period() {
        let state = mockFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        XCTAssertEqual(state.press(.num1), .init(.handled))
        XCTAssertEqual(state.value, 1)
        
        XCTAssertEqual(state.press(.period), .init(.handled, .focusNextComponent))
        XCTAssertEqual(state.value, 1)
    }
    
    func testAutoAdvance_AllowInvalid_Hours_colon() {
        let state = mockFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        XCTAssertEqual(state.press(.colon), .init(.handled, .focusNextComponent))
        XCTAssertEqual(state.value, 0)
    }
    
    func testAutoAdvance_AllowInvalid_Hours_1colon() {
        let state = mockFactory(
            component: .hours,
            inputStyle: .autoAdvance,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        XCTAssertEqual(state.press(.num1), .init(.handled))
        XCTAssertEqual(state.value, 1)
        
        XCTAssertEqual(state.press(.colon), .init(.handled, .focusNextComponent))
        XCTAssertEqual(state.value, 1)
    }
    
    // MARK: - continuousWithinComponent / allowInvalid
    
    func testContinuousWithinComponent_AllowInvalid_Hours_00() {
        let state = mockFactory(
            component: .hours,
            inputStyle: .continuousWithinComponent,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        XCTAssertEqual(state.press(.num0), .init(.handled))
        XCTAssertEqual(state.value, 0)
        
        XCTAssertEqual(state.press(.num0), .init(.handled))
        XCTAssertEqual(state.value, 0)
        
        XCTAssertEqual(state.press(.num0), .init(.handled))
        XCTAssertEqual(state.value, 0)
    }
    
    func testContinuousWithinComponent_AllowInvalid_Hours_01228900() {
        let state = mockFactory(
            component: .hours,
            inputStyle: .continuousWithinComponent,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        XCTAssertEqual(state.press(.num0), .init(.handled))
        XCTAssertEqual(state.value, 0)
        
        XCTAssertEqual(state.press(.num1), .init(.handled))
        XCTAssertEqual(state.value, 1)
        
        XCTAssertEqual(state.press(.num2), .init(.handled))
        XCTAssertEqual(state.value, 12)
        
        XCTAssertEqual(state.press(.num2), .init(.handled))
        XCTAssertEqual(state.value, 22)
        
        XCTAssertEqual(state.press(.num8), .init(.handled))
        XCTAssertEqual(state.value, 28)
        
        XCTAssertEqual(state.press(.num9), .init(.handled))
        XCTAssertEqual(state.value, 89)
        
        XCTAssertEqual(state.press(.num0), .init(.handled))
        XCTAssertEqual(state.value, 90)
        
        XCTAssertEqual(state.press(.num0), .init(.handled))
        XCTAssertEqual(state.value, 0)
    }
    
    func testContinuousWithinComponent_AllowInvalid_Hours_a12a3() {
        let state = mockFactory(
            component: .hours,
            inputStyle: .continuousWithinComponent,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        XCTAssertEqual(state.press(.a), .init(.ignored, errorFeedback: true))
        XCTAssertEqual(state.value, 0)
        
        XCTAssertEqual(state.press(.num1), .init(.handled))
        XCTAssertEqual(state.value, 1)
        
        XCTAssertEqual(state.press(.num2), .init(.handled))
        XCTAssertEqual(state.value, 12)
        
        XCTAssertEqual(state.press(.a), .init(.ignored, errorFeedback: true))
        XCTAssertEqual(state.value, 12)
        
        XCTAssertEqual(state.press(.num3), .init(.handled))
        XCTAssertEqual(state.value, 23)
    }
    
    func testContinuousWithinComponent_AllowInvalid_Hours_1a2() {
        let state = mockFactory(
            component: .hours,
            inputStyle: .continuousWithinComponent,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        XCTAssertEqual(state.press(.num1), .init(.handled))
        XCTAssertEqual(state.value, 1)
        
        XCTAssertEqual(state.press(.a), .init(.ignored, errorFeedback: true))
        XCTAssertEqual(state.value, 1)
        
        XCTAssertEqual(state.press(.num2), .init(.handled))
        XCTAssertEqual(state.value, 12)
    }
    
    func testContinuousWithinComponent_AllowInvalid_Hours_period() {
        let state = mockFactory(
            component: .hours,
            inputStyle: .continuousWithinComponent,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        XCTAssertEqual(state.press(.period), .init(.handled, .focusNextComponent))
        XCTAssertEqual(state.value, 0)
    }
    
    func testContinuousWithinComponent_AllowInvalid_Hours_1period() {
        let state = mockFactory(
            component: .hours,
            inputStyle: .continuousWithinComponent,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        XCTAssertEqual(state.press(.num1), .init(.handled))
        XCTAssertEqual(state.value, 1)
        
        XCTAssertEqual(state.press(.period), .init(.handled, .focusNextComponent))
        XCTAssertEqual(state.value, 1)
    }
    
    func testContinuousWithinComponent_AllowInvalid_Hours_colon() {
        let state = mockFactory(
            component: .hours,
            inputStyle: .continuousWithinComponent,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        XCTAssertEqual(state.press(.colon), .init(.handled, .focusNextComponent))
        XCTAssertEqual(state.value, 0)
    }
    
    func testContinuousWithinComponent_AllowInvalid_Hours_1colon() {
        let state = mockFactory(
            component: .hours,
            inputStyle: .continuousWithinComponent,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        XCTAssertEqual(state.press(.num1), .init(.handled))
        XCTAssertEqual(state.value, 1)
        
        XCTAssertEqual(state.press(.colon), .init(.handled, .focusNextComponent))
        XCTAssertEqual(state.value, 1)
    }
    
    func testContinuousWithinComponent_AllowInvalid_Hours_123colon() {
        let state = mockFactory(
            component: .hours,
            inputStyle: .continuousWithinComponent,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        XCTAssertEqual(state.press(.num1), .init(.handled))
        XCTAssertEqual(state.value, 1)
        
        XCTAssertEqual(state.press(.num2), .init(.handled))
        XCTAssertEqual(state.value, 12)
        
        XCTAssertEqual(state.press(.num3), .init(.handled))
        XCTAssertEqual(state.value, 23)
        
        XCTAssertEqual(state.press(.colon), .init(.handled, .focusNextComponent))
        XCTAssertEqual(state.value, 23)
    }
    
    func testContinuousWithinComponent_AllowInvalid_Hours_98colon() {
        let state = mockFactory(
            component: .hours,
            inputStyle: .continuousWithinComponent,
            policy: .allowInvalid,
            initialValue: 0
        )
        
        XCTAssertEqual(state.press(.num9), .init(.handled))
        XCTAssertEqual(state.value, 9)
        
        XCTAssertEqual(state.press(.num8), .init(.handled))
        XCTAssertEqual(state.value, 98)
        
        XCTAssertEqual(state.press(.colon), .init(.handled, .focusNextComponent))
        XCTAssertEqual(state.value, 98)
    }
    
    #warning("> TODO: test up/down arrow keys keys with all style/policy combinations")
    #warning("> TODO: test left/right arrow keys with all style/policy combinations, and when days/subframes are visible")
    #warning("> TODO: test return/escape keys keys with all style/policy combinations, and when days/subframes are visible")
    #warning("> TODO: test edge cases with a 3-digit frame rate")
}

// MARK: - Test Utilities

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
fileprivate class MockComponentState: TimecodeField.ComponentView.ComponentState {
    var inputStyle: TimecodeField.InputStyle
    var policy: TimecodeField.ValidationPolicy
    
    init(
        component: Timecode.Component,
        rate: TimecodeFrameRate,
        base: Timecode.SubFramesBase,
        limit: Timecode.UpperLimit,
        inputStyle: TimecodeField.InputStyle,
        policy: TimecodeField.ValidationPolicy,
        initialValue: Int
    ) {
        self.inputStyle = inputStyle
        self.policy = policy
        
        super.init(
            component: component,
            frameRate: rate,
            subFramesBase: base,
            upperLimit: limit,
            initialValue: initialValue
        )
    }
    
    /// Convenience caller for `handleKeyPress` for unit tests.
    func press(_ key: KeyEquivalent) -> TimecodeComponentStateResult {
        handleKeyPress(key: key, inputStyle: inputStyle, validationPolicy: policy)
    }
}

@available(iOS 14.0, macOS 11.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension KeyEquivalent {
    fileprivate static let num0 = Self("0")
    fileprivate static let num1 = Self("1")
    fileprivate static let num2 = Self("2")
    fileprivate static let num3 = Self("3")
    fileprivate static let num4 = Self("4")
    fileprivate static let num5 = Self("5")
    fileprivate static let num6 = Self("6")
    fileprivate static let num7 = Self("7")
    fileprivate static let num8 = Self("8")
    fileprivate static let num9 = Self("9")
    
    fileprivate static let period = Self(".")
    fileprivate static let comma = Self(",")
    fileprivate static let colon = Self(":")
    fileprivate static let semicolon = Self(";")
    
    fileprivate static let a = Self("A")
}

#endif
