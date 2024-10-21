//
//  TimecodeField View Modifiers.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(watchOS)

import SwiftUI
import TimecodeKitCore

// MARK: - TimecodeFieldHighlightStyle

/// Sets the component highlight style for ``TimecodeField`` views.
/// By default, the application's `accentColor` is used.
@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
struct TimecodeFieldHighlightStyleViewModifier: ViewModifier {
    let style: AnyShapeStyle?
    
    init(style: AnyShapeStyle?) {
        self.style = style
    }
    
    @_disfavoredOverload
    init<S: ShapeStyle>(style: S?) {
        self.style = style?.asAnyShapeStyle()
    }
    
    func body(content: Content) -> some View {
        content.environment(\.timecodeFieldHighlightStyle, style)
    }
}

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension View {
    /// Sets the component highlight style for ``TimecodeField`` views.
    /// By default, the application's `accentColor` is used.
    public func timecodeFieldHighlightStyle<S: ShapeStyle>(
        _ style: S
    ) -> some View {
        modifier(TimecodeFieldHighlightStyleViewModifier(style: style))
    }
    
    /// Sets the component highlight style for ``TimecodeField`` views.
    /// By default, the application's `accentColor` is used.
    @_disfavoredOverload
    public func timecodeFieldHighlightStyle<S: ShapeStyle>(
        _ style: S?
    ) -> some View {
        modifier(TimecodeFieldHighlightStyleViewModifier(style: style))
    }
    
    /// Sets the component highlight style for ``TimecodeField`` views.
    /// By default, the application's `accentColor` is used.
    @_documentation(visibility: internal)
    @_disfavoredOverload
    public func timecodeFieldHighlightStyle(
        _ style: Never?
    ) -> some View {
        modifier(TimecodeFieldHighlightStyleViewModifier(style: nil))
    }
}

// MARK: - TimecodeFieldInputStyle

/// Sets the data entry input style for ``TimecodeField`` views.
@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
struct TimecodeFieldInputStyleViewModifier: ViewModifier {
    let style: TimecodeField.InputStyle
    
    func body(content: Content) -> some View {
        content.environment(\.timecodeFieldInputStyle, style)
    }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension View {
    /// Sets the data entry input style for ``TimecodeField`` views.
    public func timecodeFieldInputStyle(
        _ style: TimecodeField.InputStyle
    ) -> some View {
        modifier(TimecodeFieldInputStyleViewModifier(style: style))
    }
}

// MARK: - TimecodeFieldInputWrapping

/// An enum describing focus wrapping behavior in response to ``TimecodeField`` user input.
@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
struct TimecodeFieldInputWrappingViewModifier: ViewModifier {
    let wrapping: TimecodeField.InputWrapping
    
    func body(content: Content) -> some View {
        content.environment(\.timecodeFieldInputWrapping, wrapping)
    }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension View {
    /// An enum describing focus wrapping behavior in response to ``TimecodeField`` user input.
    public func timecodeFieldInputWrapping(
        _ wrapping: TimecodeField.InputWrapping
    ) -> some View {
        modifier(TimecodeFieldInputWrappingViewModifier(wrapping: wrapping))
    }
}

// MARK: - TimecodeFieldReturnAction

/// Sets the `Return` key action for ``TimecodeField`` views.
@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
struct TimecodeFieldReturnActionViewModifier: ViewModifier {
    let format: TimecodeField.FieldAction?
    
    func body(content: Content) -> some View {
        content.environment(\.timecodeFieldReturnAction, format)
    }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension View {
    /// Sets the `Return` key action for ``TimecodeField`` views.
    public func timecodeFieldReturnAction(
        _ format: TimecodeField.FieldAction?
    ) -> some View {
        modifier(TimecodeFieldReturnActionViewModifier(format: format))
    }
}

// MARK: - TimecodeFieldEscapeAction

/// Sets the `Escape` key action for ``TimecodeField`` views.
@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
struct TimecodeFieldEscapeActionViewModifier: ViewModifier {
    let format: TimecodeField.FieldAction?
    
    func body(content: Content) -> some View {
        content.environment(\.timecodeFieldEscapeAction, format)
    }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension View {
    /// Sets the `Escape` key action for ``TimecodeField`` views.
    public func timecodeFieldEscapeAction(
        _ format: TimecodeField.FieldAction?
    ) -> some View {
        modifier(TimecodeFieldEscapeActionViewModifier(format: format))
    }
}

// MARK: - TimecodeFieldValidationPolicy

/// Sets timecode component validation policy for ``TimecodeField`` views.
@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
struct TimecodeFieldValidationPolicyViewModifier: ViewModifier {
    @Environment(\.timecodeFieldValidationAnimation) private var timecodeFieldValidationAnimation
    
    let policy: TimecodeField.ValidationPolicy
    let animation: Bool?
    
    func body(content: Content) -> some View {
        content
            .environment(\.timecodeFieldValidationPolicy, policy)
            .environment(\.timecodeFieldValidationAnimation, animation ?? timecodeFieldValidationAnimation)
    }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension View {
    /// Sets timecode component validation policy for ``TimecodeField`` views.
    public func timecodeFieldValidationPolicy(
        _ policy: TimecodeField.ValidationPolicy,
        animation: Bool? = nil
    ) -> some View {
        modifier(TimecodeFieldValidationPolicyViewModifier(policy: policy, animation: animation))
    }
}

#endif
