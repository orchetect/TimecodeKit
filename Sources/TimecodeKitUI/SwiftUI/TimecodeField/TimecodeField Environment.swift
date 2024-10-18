//
//  TimecodeField Environment.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(watchOS)

import SwiftUI
import TimecodeKitCore

// MARK: - Environment Values

@_documentation(visibility: internal)
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {
    // MARK: - TimecodeFieldHighlightStyle
    
    /// Sets the component highlight style for ``TimecodeField`` views.
    /// By default, the application's `accentColor` is used.
    @Entry public var timecodeFieldHighlightStyle: Color? = .accentColor
    
    // MARK: - TimecodeFieldInputStyle
    
    /// Sets the data entry input style for ``TimecodeField`` views.
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Entry public var timecodeFieldInputStyle: TimecodeField.InputStyle = {
        #if os(macOS)
        .continuousWithinComponent
        #else
        .autoAdvance
        #endif
    }()
    
    // MARK: - TimecodeFieldInputWrapping
    
    /// Sets the focus wrapping behavior for ``TimecodeField`` views.
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Entry public var timecodeFieldInputWrapping: TimecodeField.InputWrapping = .noWrap
    
    // MARK: - TimecodeFieldReturnAction
    
    /// Sets the `Return` key action for ``TimecodeField`` views.
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Entry public var timecodeFieldReturnAction: TimecodeField.FieldAction? = nil
    
    // MARK: - TimecodeFieldEscapeAction
    
    /// Sets the `Escape` key action for ``TimecodeField`` views.
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Entry public var timecodeFieldEscapeAction: TimecodeField.FieldAction? = nil
    
    // MARK: - TimecodeFieldValidationPolicy
    
    /// Sets timecode component validation policy for ``TimecodeField`` views.
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Entry public var timecodeFieldValidationPolicy: TimecodeField.ValidationPolicy = .enforceValid
    
    /// Enables or disables validation animation for ``TimecodeField`` views.
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Entry public var timecodeFieldValidationAnimation: Bool = {
        #if os(macOS)
        false
        #else
        true
        #endif
    }()
}

#endif
