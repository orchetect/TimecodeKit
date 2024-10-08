//
//  TimecodeField Environment.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && (os(macOS) || os(iOS) || os(visionOS))

import SwiftUI
import TimecodeKit

// MARK: - TimecodeFormat

/// Sets the timecode string format for ``TimecodeField`` and ``Text(timecode:)`` views.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
struct TimecodeFormatKey: EnvironmentKey {
    public static var defaultValue: Timecode.StringFormat = .default()
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {
    /// Sets the timecode string format for ``TimecodeField`` and ``Text(timecode:)`` views.
    public var timecodeFormat: Timecode.StringFormat {
        get { self[TimecodeFormatKey.self] }
        set { self[TimecodeFormatKey.self] = newValue }
    }
}

// MARK: - TimecodeHighlightStyle

/// Sets the component highlight style for ``TimecodeField`` views.
/// By default, the application's `accentColor` is used.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
struct TimecodeHighlightStyleKey: EnvironmentKey {
    public static var defaultValue: Color? = .accentColor
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {
    /// Sets the component highlight style for ``TimecodeField`` views.
    /// By default, the application's `accentColor` is used.
    public var timecodeHighlightStyle: Color? {
        get { self[TimecodeHighlightStyleKey.self] }
        set { self[TimecodeHighlightStyleKey.self] = newValue }
    }
}

// MARK: - TimecodeSeparatorStyle

/// Sets the text separator style for ``TimecodeField`` and ``Text(timecode:)`` views.
/// If `color` is nil, the foreground style is used.
///
/// - Note: To set the default color of the component values, use `foregroundColor` or `foregroundStyle` view modifiers.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
struct TimecodeSeparatorStyleKey: EnvironmentKey {
    public static var defaultValue: Color? = nil
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {
    /// Sets the text separator style for ``TimecodeField`` and ``Text(timecode:)`` views.
    /// If `color` is nil, the foreground style is used.
    ///
    /// - Note: To set the default color of the component values, use `foregroundColor` or `foregroundStyle` view modifiers.
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public var timecodeSeparatorStyle: Color? {
        get { self[TimecodeSeparatorStyleKey.self] }
        set { self[TimecodeSeparatorStyleKey.self] = newValue }
    }
}

// MARK: - TimecodeValidationStyle

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
struct TimecodeValidationStyleKey: EnvironmentKey {
    public static var defaultValue: Color? = .red
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {
    /// Sets timecode component validation style for ``TimecodeField`` and ``Text(timecode:)`` views.
    ///
    /// This foreground color will be used only for any timecode component values that are invalid for the given
    /// properties (frame rate, subframes base, and upper limit).
    ///
    /// If `nil`, validation is disabled and invalid components will not be colorized.
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public var timecodeValidationStyle: Color? {
        get { self[TimecodeValidationStyleKey.self] }
        set { self[TimecodeValidationStyleKey.self] = newValue }
    }
}

#endif
