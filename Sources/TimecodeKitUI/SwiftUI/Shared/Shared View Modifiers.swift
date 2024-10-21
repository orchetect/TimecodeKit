//
//  Shared View Modifiers.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

// View modifiers used by both ``TimecodeField`` and ``TimecodeText``
// and available on all platforms.

#if canImport(SwiftUI)

import SwiftUI
import TimecodeKitCore

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
@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
struct TimecodeSeparatorStyleViewModifier: ViewModifier {
    let style: AnyShapeStyle?
    
    init(style: AnyShapeStyle?) {
        self.style = style
    }
    
    @_disfavoredOverload
    init<S: ShapeStyle>(style: S?) {
        self.style = style?.asAnyShapeStyle()
    }
    
    func body(content: Content) -> some View {
        content.environment(\.timecodeSeparatorStyle, style)
    }
}

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension View {
    /// Sets the text separator style for ``TimecodeField`` and ``TimecodeText`` views.
    /// If `color` is nil, the foreground style is used.
    ///
    /// - Note: To set the default color of the component values, use `foregroundColor` or `foregroundStyle` view
    ///   modifiers.
    public func timecodeSeparatorStyle<S: ShapeStyle>(
        _ style: S
    ) -> some View {
        modifier(TimecodeSeparatorStyleViewModifier(style: style))
    }
    
    /// Sets the text separator style for ``TimecodeField`` and ``TimecodeText`` views.
    /// If `color` is nil, the foreground style is used.
    ///
    /// - Note: To set the default color of the component values, use `foregroundColor` or `foregroundStyle` view
    ///   modifiers.
    @_disfavoredOverload
    public func timecodeSeparatorStyle<S: ShapeStyle>(
        _ style: S?
    ) -> some View {
        modifier(TimecodeSeparatorStyleViewModifier(style: style))
    }
    
    /// Sets the text separator style for ``TimecodeField`` and ``TimecodeText`` views.
    /// If `color` is nil, the foreground style is used.
    ///
    /// - Note: To set the default color of the component values, use `foregroundColor` or `foregroundStyle` view
    ///   modifiers.
    @_documentation(visibility: internal)
    @_disfavoredOverload
    public func timecodeSeparatorStyle(
        _ style: Never?
    ) -> some View {
        modifier(TimecodeSeparatorStyleViewModifier(style: nil))
    }
}

// MARK: - TimecodeSubFramesStyle

/// Sets the subframes timecode component foreground style and text scale for ``TimecodeField`` and ``TimecodeText`` views.
/// If `color` is nil, the foreground style is used.
@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
struct TimecodeSubFramesStyleViewModifier: ViewModifier {
    let style: AnyShapeStyle?
    let scale: Text.Scale
    
    init(style: AnyShapeStyle?, scale: Text.Scale) {
        self.style = style
        self.scale = scale
    }
    
    @_disfavoredOverload
    init<S: ShapeStyle>(style: S?, scale: Text.Scale) {
        self.style = style?.asAnyShapeStyle()
        self.scale = scale
    }
    
    func body(content: Content) -> some View {
        content.environment(\.timecodeSubFramesStyle, (style: style, scale: scale))
    }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension View {
    /// Sets the subframes timecode component foreground style and text scale for ``TimecodeField`` and ``TimecodeText`` views.
    /// If `color` is nil, the foreground style is used.
    public func timecodeSubFramesStyle<S: ShapeStyle>(
        _ style: S,
        scale: Text.Scale
    ) -> some View {
        modifier(TimecodeSubFramesStyleViewModifier(style: style, scale: scale))
    }
    
    /// Sets the subframes timecode component foreground style and text scale for ``TimecodeField`` and ``TimecodeText`` views.
    /// If `color` is nil, the foreground style is used.
    @_disfavoredOverload
    public func timecodeSubFramesStyle<S: ShapeStyle>(
        _ style: S?,
        scale: Text.Scale
    ) -> some View {
        modifier(TimecodeSubFramesStyleViewModifier(style: style, scale: scale))
    }
    
    /// Sets the subframes timecode component foreground style and text scale for ``TimecodeField`` and ``TimecodeText`` views.
    /// If `color` is nil, the foreground style is used.
    @_documentation(visibility: internal)
    @_disfavoredOverload
    public func timecodeSubFramesStyle(
        _ style: Never? = nil,
        scale: Text.Scale
    ) -> some View {
        modifier(TimecodeSubFramesStyleViewModifier(style: nil, scale: scale))
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
@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
struct TimecodeValidationStyleViewModifier: ViewModifier {
    let style: AnyShapeStyle?
    
    init(style: AnyShapeStyle?) {
        self.style = style
    }
    
    @_disfavoredOverload
    init<S: ShapeStyle>(style: S?) {
        self.style = style?.asAnyShapeStyle()
    }
    
    func body(content: Content) -> some View {
        content.environment(\.timecodeValidationStyle, style)
    }
}

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
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
    public func timecodeValidationStyle<S: ShapeStyle>(
        _ style: S
    ) -> some View {
        modifier(TimecodeValidationStyleViewModifier(style: style))
    }
    
    /// Sets timecode component validation rendering style for ``TimecodeField`` and ``TimecodeText`` views.
    ///
    /// This foreground color will be used only for any timecode component values that are invalid based on the given
    /// properties (frame rate, subframes base, and upper limit).
    ///
    /// If `nil`, validation rendering is disabled and invalid components will not be colorized.
    ///
    /// This modifier only affects visual representation of invalid timecode, and does not have any effect on logical
    /// validation that may (or may not) be applied separately.
    @_disfavoredOverload
    public func timecodeValidationStyle<S: ShapeStyle>(
        _ style: S?
    ) -> some View {
        modifier(TimecodeValidationStyleViewModifier(style: style))
    }
    
    /// Sets timecode component validation rendering style for ``TimecodeField`` and ``TimecodeText`` views.
    ///
    /// This foreground color will be used only for any timecode component values that are invalid based on the given
    /// properties (frame rate, subframes base, and upper limit).
    ///
    /// If `nil`, validation rendering is disabled and invalid components will not be colorized.
    ///
    /// This modifier only affects visual representation of invalid timecode, and does not have any effect on logical
    /// validation that may (or may not) be applied separately.
    @_documentation(visibility: internal)
    @_disfavoredOverload
    public func timecodeValidationStyle(
        _ style: Never?
    ) -> some View {
        modifier(TimecodeValidationStyleViewModifier(style: nil))
    }
}

// MARK: - TimecodePasted (internal)

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension View {
    /// Environment method used to propagate a user-pasted timecode up the view hierarchy.
    func onPastedTimecode(_ action: @escaping TimecodePastedAction.Action) -> some View {
        environment(\.timecodePasted, TimecodePastedAction(action: action))
    }
}

#if os(macOS)
@available(macOS 13.0, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension View {
    // /// Implements `onPasteCommand` to catch paste events and calls the action closure with the pasteboard parse result.
    // func onPasteCommandOfTimecode(
    //     propertiesForString: Timecode.Properties,
    //     _ action: @escaping TimecodePastedAction.Action
    // ) -> some View {
    //     self.onPastedTimecode(action)
    //         .onPasteCommandOfTimecode(
    //             propertiesForString: propertiesForString,
    //             forwardTo: TimecodePastedAction(action: action)
    //         )
    // }
    
    /// Implements `onPasteCommand` to catch paste events and forwards the pasteboard parse result to the given SwiftUI
    /// environment method.
    func onPasteCommandOfTimecode(
        propertiesForString: Timecode.Properties,
        forwardTo block: sending @escaping @autoclosure () -> TimecodePastedAction?
    ) -> some View {
        onPasteCommand(of: Timecode.pasteUTTypes) { itemProviders in
            Task {
                guard let block = block() else { return }
                await block(
                    itemProviders: itemProviders,
                    propertiesForString: propertiesForString
                )
            }
        }
    }
}
#endif

#endif
