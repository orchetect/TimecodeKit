//
//  TimecodeField View Modifiers Syntax Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(watchOS)

import SwiftUI
import SwiftTimecodeUI
import XCTest

/// The goal in this test suite is to just ensure that our custom SwiftUI view modifiers
/// behave the same and accept the same syntax as standard native SwiftUI view modifiers.
///
/// This helps during refactors or feature-adds/bug-fixes to make sure there are no regressions.
///
/// If intentional changes occur to view modifiers during a refactor, this can help indicate
/// the need to add API evolution deprecations or renames.
@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
@MainActor final class TimecodeField_View_Modifiers_Syntax_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    // MARK: - Test Constants
    
    private let timecodeField = TimecodeField(components: .constant(.zero))
    private let isFoo = true
    private let anyShapeStyle: any ShapeStyle = .tint
    private let anyOptionalShapeStyle: (any ShapeStyle)? = .tint
    private let concreteStyle: TintShapeStyle = .tint
    private let optionalConcreteStyle: TintShapeStyle? = .tint
    
    // MARK: - Tests
    
    /// Establish baseline SwiftUI standard library behavior.
    func testShapeStyleViewModifier_Baseline() {
        // `any ShapeStyle` works
        _ = timecodeField
            .foregroundStyle(anyShapeStyle)
        
        // `(any ShapeStyle)?` does not work.
        // also, this wouldn't work because we can't nil-coalesce to a different concrete type
        // (underlying types are `TintShapeStyle` and `Color`).
        // _ = timecodeField
        //     .foregroundStyle(anyOptionalShapeStyle ?? .black)
        
        // concrete `TintShapeStyle` works
        _ = timecodeField
            .foregroundStyle(concreteStyle)
        
        // concrete `TintShapeStyle?` can't nil-coalesce to a different concrete type
        // _ = timecodeField
        //     .foregroundStyle(optionalConcreteStyle ?? Color.black)
    }
    
    // MARK: - .timecodeField
    
    func testViewModifier_timecodeField() {
        _ = timecodeField
            .timecodeFormat(.default())
        
        _ = timecodeField
            .timecodeFormat([])
        
        _ = timecodeField
            .timecodeFormat([.showSubFrames])
        
        _ = timecodeField
            .timecodeFormat([.alwaysShowDays, .showSubFrames])
    }
    
    // MARK: - .timecodeFieldHighlightStyle
    
    /// We'll use this view modifier as an exploratory deep-test candidate, so the other view modifiers
    /// only need perfunctory syntax checks.
    func testViewModifier_timecodeFieldHighlightStyle() {
        // MARK: Basic
        
        _ = timecodeField
            .timecodeFieldHighlightStyle(.black)
        _ = timecodeField
            .timecodeFieldHighlightStyle(.tint)
        _ = timecodeField
            .timecodeFieldHighlightStyle(nil)
        
        // MARK: Generics
        
        // this works because:
        // - the compiler can use `any ShapeStyle` with a generic non-Optional `ShapeStyle` method parameter
        _ = timecodeField
            .timecodeFieldHighlightStyle(anyShapeStyle)
        
        // MARK: Optional Generics
        
        // this works because:
        // - this a concrete Optional type
        _ = timecodeField
            .timecodeFieldHighlightStyle(optionalConcreteStyle)
        
        // won't work because:
        // - the compiler can't use `any ShapeStyle` with a generic `ShapeStyle?` method parameter
        // _ = timecodeField
        //     .timecodeFieldHighlightStyle(anyOptionalShapeStyle)
        
        // MARK: Ternary Optional Generics Using Static Members
        
        // won't work.
        // compiler can't intuit this expression because the parameter is an Optional protocol
        // _ = timecodeField
        //    .timecodeFieldHighlightStyle(isTest ? .tint : nil)
        
        // won't work.
        // must cast as optional to allow the use of `nil` in the ternary expression,
        // however this still does not play nice with the typing system:
        // "Type 'any ShapeStyle' cannot conform to 'ShapeStyle'"
        // _ = timecodeField
        //     .timecodeFieldHighlightStyle(isFoo ? .tint as (any ShapeStyle)? : nil)
        
        // this works because:
        // 1. it's cast as a concrete type, not a protocol
        // 2. casting as Optional allows the use of `nil` in the ternary expression
        // 3. both output types are of the same concrete type
        _ = timecodeField
            .timecodeFieldHighlightStyle(isFoo ? .tint as TintShapeStyle? : nil)
        _ = timecodeField
            .timecodeFieldHighlightStyle(isFoo ? .black : Color?.none)
        
        // MARK: Ternary Optional Generics Using Stored Variables
        
        // won't work.
        // but this is expected. the same behavior exists with built-in `foregroundStyle()`.
        // "Type 'any ShapeStyle' cannot conform to 'ShapeStyle'"
        // _ = timecodeField
        //     .timecodeFieldHighlightStyle(anyOptionalShapeStyle)
        
        // won't work.
        // "Type 'any ShapeStyle' cannot conform to 'ShapeStyle'"
        // _ = timecodeField
        //     .timecodeFieldHighlightStyle(isFoo ? anyShapeStyle : nil)
        
        // this works because:
        // - the stored variable is an Optional concrete type
        // - which allows the type checker to understand the implicit type of `nil`
        _ = timecodeField
            .timecodeFieldHighlightStyle(isFoo ? optionalConcreteStyle : nil)
    }
    
    // MARK: - .timecodeSeparatorStyle
    
    func testViewModifier_timecodeSeparatorStyle() {
        // MARK: Basic
        _ = timecodeField
            .timecodeSeparatorStyle(.black)
        _ = timecodeField
            .timecodeSeparatorStyle(.tint)
        _ = timecodeField
            .timecodeSeparatorStyle(nil)
        
        // MARK: Generics
        _ = timecodeField
            .timecodeSeparatorStyle(anyShapeStyle)
        
        // MARK: Optional Generics
        _ = timecodeField
            .timecodeSeparatorStyle(optionalConcreteStyle)
        
        // MARK: Ternary Optional Generics Using Static Members
        _ = timecodeField
            .timecodeSeparatorStyle(isFoo ? .tint as TintShapeStyle? : nil)
        _ = timecodeField
            .timecodeSeparatorStyle(isFoo ? .black : Color?.none)
        
        // MARK: Ternary Optional Generics Using Stored Variables
        _ = timecodeField
            .timecodeSeparatorStyle(isFoo ? optionalConcreteStyle : nil)
    }
    
    // MARK: - .timecodeSubFramesStyle
    
    func testViewModifier_timecodeSubFramesStyle_StyleOnly() {
        // MARK: Basic
        _ = timecodeField
            .timecodeSubFramesStyle(.black)
        _ = timecodeField
            .timecodeSubFramesStyle(.tint)
        _ = timecodeField
            .timecodeSubFramesStyle(nil)
        
        // MARK: Generics
        _ = timecodeField
            .timecodeSubFramesStyle(anyShapeStyle)
        
        // MARK: Optional Generics
        _ = timecodeField
            .timecodeSubFramesStyle(optionalConcreteStyle)
        
        // MARK: Ternary Optional Generics Using Static Members
        _ = timecodeField
            .timecodeSubFramesStyle(isFoo ? .tint as TintShapeStyle? : nil)
        _ = timecodeField
            .timecodeSubFramesStyle(isFoo ? .black : Color?.none)
        
        // MARK: Ternary Optional Generics Using Stored Variables
        _ = timecodeField
            .timecodeSubFramesStyle(isFoo ? optionalConcreteStyle : nil)
    }
    
    func testViewModifier_timecodeSubFramesStyle_ScaleOnly() {
        _ = timecodeField
            .timecodeSubFramesStyle(scale: .default)
    }
    
    func testViewModifier_timecodeSubFramesStyle_StyleAndScale() {
        // MARK: Basic
        _ = timecodeField
            .timecodeSubFramesStyle(.black, scale: .default)
        _ = timecodeField
            .timecodeSubFramesStyle(.tint, scale: .default)
        _ = timecodeField
            .timecodeSubFramesStyle(nil, scale: .default)
        
        // MARK: Generics
        _ = timecodeField
            .timecodeSubFramesStyle(anyShapeStyle, scale: .default)
        
        // MARK: Optional Generics
        _ = timecodeField
            .timecodeSubFramesStyle(optionalConcreteStyle, scale: .default)
        
        // MARK: Ternary Optional Generics Using Static Members
        _ = timecodeField
            .timecodeSubFramesStyle(isFoo ? .tint as TintShapeStyle? : nil, scale: .default)
        _ = timecodeField
            .timecodeSubFramesStyle(isFoo ? .black : Color?.none, scale: .default)
        
        // MARK: Ternary Optional Generics Using Stored Variables
        _ = timecodeField
            .timecodeSubFramesStyle(isFoo ? optionalConcreteStyle : nil, scale: .default)
    }
    
    // MARK: - .timecodeValidationStyle
    
    func testViewModifier_timecodeValidationStyle() {
        // MARK: Basic
        _ = timecodeField
            .timecodeValidationStyle(.black)
        _ = timecodeField
            .timecodeValidationStyle(.tint)
        _ = timecodeField
            .timecodeValidationStyle(nil)
        
        // MARK: Generics
        _ = timecodeField
            .timecodeValidationStyle(anyShapeStyle)
        
        // MARK: Optional Generics
        _ = timecodeField
            .timecodeValidationStyle(optionalConcreteStyle)
        
        // MARK: Ternary Optional Generics Using Static Members
        _ = timecodeField
            .timecodeValidationStyle(isFoo ? .tint as TintShapeStyle? : nil)
        _ = timecodeField
            .timecodeValidationStyle(isFoo ? .black : Color?.none)
        
        // MARK: Ternary Optional Generics Using Stored Variables
        _ = timecodeField
            .timecodeValidationStyle(isFoo ? optionalConcreteStyle : nil)
    }
    
    // MARK: - .timecodeFieldInputRejectionFeedback
    
    func testViewModifier_timecodeFieldInputRejectionFeedback() {
        _ = timecodeField
            .timecodeFieldInputRejectionFeedback(.validationBased(animation: .shake))
        
        _ = timecodeField
            .timecodeFieldInputRejectionFeedback(.validationBased(animation: nil))
        
        _ = timecodeField
            .timecodeFieldInputRejectionFeedback(.validationBased())
        
        _ = timecodeField
            .timecodeFieldInputRejectionFeedback(.validationBasedAndUndefinedKeys(animation: .shake))
        
        _ = timecodeField
            .timecodeFieldInputRejectionFeedback(.validationBasedAndUndefinedKeys(animation: nil))
        
        _ = timecodeField
            .timecodeFieldInputRejectionFeedback(.validationBasedAndUndefinedKeys())
        
        _ = timecodeField
            .timecodeFieldInputRejectionFeedback(.custom { rejectedUserAction in
                _ = rejectedUserAction
            })
        
        _ = timecodeField
            .timecodeFieldInputRejectionFeedback(nil)
    }
}

#endif
