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
        self.onPasteCommand(of: Timecode.pasteUTTypes) { itemProviders in
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
