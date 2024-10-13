//
//  TimecodeField View Modifiers.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && (os(macOS) || os(iOS) || os(visionOS))

import SwiftUI
import TimecodeKit

// MARK: - TimecodeFieldInputStyle

/// Sets the data entry input style for ``TimecodeField`` views.
@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
struct TimecodeFieldInputStyleViewModifier: ViewModifier {
    let style: TimecodeField.InputStyle
    
    func body(content: Content) -> some View {
        content.environment(\.timecodeFieldInputStyle, style)
    }
}

@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
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
@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
struct TimecodeFieldInputWrappingViewModifier: ViewModifier {
    let wrapping: TimecodeField.InputWrapping
    
    func body(content: Content) -> some View {
        content.environment(\.timecodeFieldInputWrapping, wrapping)
    }
}

@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
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
@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
struct TimecodeFieldReturnActionViewModifier: ViewModifier {
    let format: TimecodeField.FieldAction?
    
    func body(content: Content) -> some View {
        content.environment(\.timecodeFieldReturnAction, format)
    }
}

@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
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
@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
struct TimecodeFieldEscapeActionViewModifier: ViewModifier {
    let format: TimecodeField.FieldAction?
    
    func body(content: Content) -> some View {
        content.environment(\.timecodeFieldEscapeAction, format)
    }
}

@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
extension View {
    /// Sets the `Escape` key action for ``TimecodeField`` views.
    public func timecodeFieldEscapeAction(
        _ format: TimecodeField.FieldAction?
    ) -> some View {
        modifier(TimecodeFieldEscapeActionViewModifier(format: format))
    }
}

// MARK: - TimecodeFormat

/// Sets the timecode string format for ``TimecodeField`` and ``TimecodeText`` views.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
struct TimecodeFormatViewModifier: ViewModifier {
    let format: Timecode.StringFormat
    
    func body(content: Content) -> some View {
        content.environment(\.timecodeFormat, format)
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {
    /// Sets the timecode string format for ``TimecodeField`` and ``TimecodeText`` views.
    public func timecodeFormat(
        _ format: Timecode.StringFormat
    ) -> some View {
        modifier(TimecodeFormatViewModifier(format: format))
    }
}

// MARK: - TimecodeFieldHighlightStyle

/// Sets the component highlight style for ``TimecodeField`` views.
/// By default, the application's `accentColor` is used.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
struct TimecodeFieldHighlightStyleViewModifier: ViewModifier {
    let color: Color?
    
    func body(content: Content) -> some View {
        content.environment(\.timecodeFieldHighlightStyle, color)
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {
    /// Sets the component highlight style for ``TimecodeField`` views.
    /// By default, the application's `accentColor` is used.
    public func timecodeFieldHighlightStyle(
        _ color: Color?
    ) -> some View {
        modifier(TimecodeFieldHighlightStyleViewModifier(color: color))
    }
}

// MARK: - TimecodeSeparatorStyle

/// Sets the text separator style for ``TimecodeField`` and ``TimecodeText`` views.
/// If `color` is nil, the foreground style is used.
///
/// - Note: To set the default color of the component values, use `foregroundColor` or `foregroundStyle` view
///   modifiers.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
struct TimecodeSeparatorStyleViewModifier: ViewModifier {
    let color: Color?
    
    func body(content: Content) -> some View {
        content.environment(\.timecodeSeparatorStyle, color)
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {
    /// Sets the text separator style for ``TimecodeField`` and ``TimecodeText`` views.
    /// If `color` is nil, the foreground style is used.
    ///
    /// - Note: To set the default color of the component values, use `foregroundColor` or `foregroundStyle` view
    ///   modifiers.
    public func timecodeSeparatorStyle(
        _ color: Color? = nil
    ) -> some View {
        modifier(TimecodeSeparatorStyleViewModifier(color: color))
    }
}

// MARK: - TimecodeValidationStyle

/// Sets timecode component validation style for ``TimecodeField`` and ``TimecodeText`` views.
///
/// This foreground color will be used only for any timecode component values that are invalid for the given
/// properties (frame rate, subframes base, and upper limit).
///
/// If `nil`, validation is disabled and invalid components will not be colorized.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
struct TimecodeValidationStyleViewModifier: ViewModifier {
    let color: Color?
    
    func body(content: Content) -> some View {
        content.environment(\.timecodeValidationStyle, color)
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {
    /// Sets timecode component validation style for ``TimecodeField`` and ``TimecodeText`` views.
    ///
    /// This foreground color will be used only for any timecode component values that are invalid for the given
    /// properties (frame rate, subframes base, and upper limit).
    ///
    /// If `nil`, validation is disabled and invalid components will not be colorized.
    public func timecodeValidationStyle(
        _ color: Color? = .red
    ) -> some View {
        modifier(TimecodeValidationStyleViewModifier(color: color))
    }
}

#endif
