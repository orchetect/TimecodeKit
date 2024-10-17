//
//  TimecodeField View Modifiers.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && (os(macOS) || os(iOS) || os(visionOS))

import SwiftUI
import TimecodeKitCore

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

// MARK: - TimecodeFieldValidationPolicy

/// Sets timecode component validation policy for ``TimecodeField`` views.
@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
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

@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
extension View {
    /// Sets timecode component validation policy for ``TimecodeField`` views.
    public func timecodeFieldValidationPolicy(
        _ policy: TimecodeField.ValidationPolicy,
        animation: Bool? = nil
    ) -> some View {
        modifier(TimecodeFieldValidationPolicyViewModifier(policy: policy, animation: animation))
    }
}

// MARK: - TimecodeFormat

/// Sets the timecode string format for ``TimecodeField`` and ``TimecodeText`` views.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
struct TimecodeFormatViewModifier: ViewModifier {
    let format: Timecode.StringFormat
    
    func body(content: Content) -> some View {
        content.environment(\.timecodeFormat, format)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension View {
    /// Sets the timecode string format for ``TimecodeField`` and ``TimecodeText`` views.
    public func timecodeFormat(
        _ format: Timecode.StringFormat
    ) -> some View {
        modifier(TimecodeFormatViewModifier(format: format))
    }
}

// MARK: - TimecodeSeparatorStyle

/// Sets the text separator style for ``TimecodeField`` and ``TimecodeText`` views.
/// If `color` is nil, the foreground style is used.
///
/// - Note: To set the default color of the component values, use `foregroundColor` or `foregroundStyle` view
///   modifiers.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
struct TimecodeSeparatorStyleViewModifier: ViewModifier {
    let color: Color?
    
    func body(content: Content) -> some View {
        content.environment(\.timecodeSeparatorStyle, color)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
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

// MARK: - TimecodeSubFramesStyle

/// Sets the subframes timecode component foreground style and text scale for ``TimecodeField`` and ``TimecodeText`` views.
/// If `color` is nil, the foreground style is used.
@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
struct TimecodeSubFramesStyleViewModifier: ViewModifier {
    let color: Color?
    let scale: Text.Scale
    
    func body(content: Content) -> some View {
        content.environment(\.timecodeSubFramesStyle, (color: color, scale: scale))
    }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension View {
    /// Sets the subframes timecode component foreground style and text scale for ``TimecodeField`` and ``TimecodeText`` views.
    /// If `color` is nil, the foreground style is used.
    public func timecodeSubFramesStyle(
        _ color: Color? = nil,
        scale: Text.Scale
    ) -> some View {
        modifier(TimecodeSubFramesStyleViewModifier(color: color, scale: scale))
    }
}

// MARK: - TimecodeValidationStyle

/// Sets timecode component validation rendering style for ``TimecodeField`` and ``TimecodeText`` views.
///
/// This foreground color will be used only for any timecode component values that are invalid based on the given
/// properties (frame rate, subframes base, and upper limit).
///
/// If `nil`, validation rendering is disabled and invalid components will not be colorized.
///
/// This modifier only affects visual representation of invalid timecode, and does not have any effect on logical
/// validation that may (or may not) be applied separately.
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
struct TimecodeValidationStyleViewModifier: ViewModifier {
    let color: Color?
    
    func body(content: Content) -> some View {
        content.environment(\.timecodeValidationStyle, color)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension View {
    /// Sets timecode component validation rendering style for ``TimecodeField`` and ``TimecodeText`` views.
    ///
    /// This foreground color will be used only for any timecode component values that are invalid based on the given
    /// properties (frame rate, subframes base, and upper limit).
    ///
    /// If `nil`, validation rendering is disabled and invalid components will not be colorized.
    ///
    /// This modifier only affects visual representation of invalid timecode, and does not have any effect on logical
    /// validation that may (or may not) be applied separately.
    public func timecodeValidationStyle(
        _ color: Color? = .red
    ) -> some View {
        modifier(TimecodeValidationStyleViewModifier(color: color))
    }
}

// MARK: - TimecodePasted (internal)

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension View {
    /// Environment method used to propagate a user-pasted timecode up the view hierarchy.
    func onPastedTimecode(_ action: @escaping TimecodePastedAction.Action) -> some View {
        self.environment(\.timecodePasted, TimecodePastedAction(action: action))
    }
}

@available(macOS 13.0, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension View {
    /// Implements `onPasteCommand` to catch paste events and calls the action closure with the pasteboard parse result.
    func onPasteCommandOfTimecode(
        propertiesForString: Timecode.Properties,
        _ action: @escaping TimecodePastedAction.Action
    ) -> some View {
        self.onPastedTimecode(action)
            .onPasteCommandOfTimecode(
                propertiesForString: propertiesForString,
                forwardTo: TimecodePastedAction(action: action)
            )
    }
    
    /// Implements `onPasteCommand` to catch paste events and forwards the pasteboard parse result to the given SwiftUI
    /// environment method.
    func onPasteCommandOfTimecode(
        propertiesForString: Timecode.Properties,
        forwardTo environmentMethod: TimecodePastedAction?
    ) -> some View {
        self.onPasteCommand(of: Timecode.pasteUTTypes) { itemProviders in
            Task {
                await environmentMethod?(
                    itemProviders: itemProviders,
                    propertiesForString: propertiesForString
                )
            }
        }
    }
}

#endif
