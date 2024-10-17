//
//  TimecodeField Environment.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && (os(macOS) || os(iOS) || os(visionOS))

import SwiftUI
import TimecodeKitCore

// MARK: - TimecodeFieldHighlightStyle

/// Sets the component highlight style for ``TimecodeField`` views.
/// By default, the application's `accentColor` is used.
@_documentation(visibility: internal)
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
struct TimecodeFieldHighlightStyleKey: EnvironmentKey {
    public static let defaultValue: Color? = .accentColor
}

@_documentation(visibility: internal)
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {
    /// Sets the component highlight style for ``TimecodeField`` views.
    /// By default, the application's `accentColor` is used.
    public var timecodeFieldHighlightStyle: Color? {
        get { self[TimecodeFieldHighlightStyleKey.self] }
        set { self[TimecodeFieldHighlightStyleKey.self] = newValue }
    }
}

// MARK: - TimecodeFieldInputStyle

/// Sets the data entry input style for ``TimecodeField`` views.
@_documentation(visibility: internal)
@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
struct TimecodeFieldInputStyleKey: EnvironmentKey {
    public static let defaultValue: TimecodeField.InputStyle = {
        #if os(macOS)
        .continuousWithinComponent
        #else
        .autoAdvance
        #endif
    }()
}

@_documentation(visibility: internal)
@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
extension EnvironmentValues {
    /// Sets the data entry input style for ``TimecodeField`` views.
    public var timecodeFieldInputStyle: TimecodeField.InputStyle {
        get { self[TimecodeFieldInputStyleKey.self] }
        set { self[TimecodeFieldInputStyleKey.self] = newValue }
    }
}

// MARK: - TimecodeFieldInputWrapping

/// Sets the focus wrapping behavior for ``TimecodeField`` views.
@_documentation(visibility: internal)
@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
struct TimecodeFieldInputWrappingKey: EnvironmentKey {
    public static let defaultValue: TimecodeField.InputWrapping = .noWrap
}

@_documentation(visibility: internal)
@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
extension EnvironmentValues {
    /// Sets the focus wrapping behavior for ``TimecodeField`` views.
    public var timecodeFieldInputWrapping: TimecodeField.InputWrapping {
        get { self[TimecodeFieldInputWrappingKey.self] }
        set { self[TimecodeFieldInputWrappingKey.self] = newValue }
    }
}

// MARK: - TimecodeFieldReturnAction

/// Sets the `Return` key action for ``TimecodeField`` views.
@_documentation(visibility: internal)
@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
struct TimecodeFieldReturnActionKey: EnvironmentKey {
    public static let defaultValue: TimecodeField.FieldAction? = nil
}

@_documentation(visibility: internal)
@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
extension EnvironmentValues {
    /// Sets the `Return` key action for ``TimecodeField`` views.
    public var timecodeFieldReturnAction: TimecodeField.FieldAction? {
        get { self[TimecodeFieldReturnActionKey.self] }
        set { self[TimecodeFieldReturnActionKey.self] = newValue }
    }
}

// MARK: - TimecodeFieldEscapeAction

/// Sets the `Escape` key action for ``TimecodeField`` views.
@_documentation(visibility: internal)
@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
struct TimecodeFieldEscapeActionKey: EnvironmentKey {
    public static let defaultValue: TimecodeField.FieldAction? = nil
}

@_documentation(visibility: internal)
@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
extension EnvironmentValues {
    /// Sets the `Escape` key action for ``TimecodeField`` views.
    public var timecodeFieldEscapeAction: TimecodeField.FieldAction? {
        get { self[TimecodeFieldEscapeActionKey.self] }
        set { self[TimecodeFieldEscapeActionKey.self] = newValue }
    }
}

// MARK: - TimecodeFieldValidationPolicy

@_documentation(visibility: internal)
@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
struct TimecodeFieldValidationPolicyKey: EnvironmentKey {
    public static let defaultValue: TimecodeField.ValidationPolicy = .enforceValid
}

@_documentation(visibility: internal)
@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
extension EnvironmentValues {
    /// Sets timecode component validation policy for ``TimecodeField`` views.
    public var timecodeFieldValidationPolicy: TimecodeField.ValidationPolicy {
        get { self[TimecodeFieldValidationPolicyKey.self] }
        set { self[TimecodeFieldValidationPolicyKey.self] = newValue }
    }
}

@_documentation(visibility: internal)
@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
struct TimecodeFieldValidationAnimationKey: EnvironmentKey {
    public static let defaultValue: Bool = {
        #if os(macOS)
        false
        #else
        true
        #endif
    }()
}

@_documentation(visibility: internal)
@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
extension EnvironmentValues {
    /// Enables or disables validation animation for ``TimecodeField`` views.
    public var timecodeFieldValidationAnimation: Bool {
        get { self[TimecodeFieldValidationAnimationKey.self] }
        set { self[TimecodeFieldValidationAnimationKey.self] = newValue }
    }
}

// MARK: - TimecodeFormat

/// Sets the timecode string format for ``TimecodeField`` and ``TimecodeText`` views.
@_documentation(visibility: internal)
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
struct TimecodeFormatKey: EnvironmentKey {
    public static let defaultValue: Timecode.StringFormat = .default()
}

@_documentation(visibility: internal)
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {
    /// Sets the timecode string format for ``TimecodeField`` and ``TimecodeText`` views.
    public var timecodeFormat: Timecode.StringFormat {
        get { self[TimecodeFormatKey.self] }
        set { self[TimecodeFormatKey.self] = newValue }
    }
}

// MARK: - TimecodeSeparatorStyle

/// Sets the text separator style for ``TimecodeField`` and ``TimecodeText`` views.
/// If `color` is nil, the foreground style is used.
///
/// - Note: To set the default color of the component values, use `foregroundColor` or `foregroundStyle` view modifiers.
@_documentation(visibility: internal)
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
struct TimecodeSeparatorStyleKey: EnvironmentKey {
    public static let defaultValue: Color? = nil
}

@_documentation(visibility: internal)
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {
    /// Sets the text separator style for ``TimecodeField`` and ``TimecodeText`` views.
    /// If `color` is nil, the foreground style is used.
    ///
    /// - Note: To set the default color of the component values, use `foregroundColor` or `foregroundStyle` view modifiers.
    public var timecodeSeparatorStyle: Color? {
        get { self[TimecodeSeparatorStyleKey.self] }
        set { self[TimecodeSeparatorStyleKey.self] = newValue }
    }
}

// MARK: - TimecodeSubFramesStyle

/// Sets the subframes timecode component foreground style and text scale for ``TimecodeField`` and ``TimecodeText`` views.
/// If `color` is nil, the foreground style is used.
@_documentation(visibility: internal)
@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
struct TimecodeSubFramesStyleKey: EnvironmentKey {
    public static let defaultValue: (color: Color?, scale: Text.Scale) = (nil, .default)
}

@_documentation(visibility: internal)
@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension EnvironmentValues {
    /// Sets the subframes timecode component foreground style and text scale for ``TimecodeField`` and ``TimecodeText`` views.
    /// If `color` is nil, the foreground style is used.
    public var timecodeSubFramesStyle: (color: Color?, scale: Text.Scale) {
        get { self[TimecodeSubFramesStyleKey.self] }
        set { self[TimecodeSubFramesStyleKey.self] = newValue }
    }
}

// MARK: - TimecodeValidationStyle

@_documentation(visibility: internal)
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
struct TimecodeValidationStyleKey: EnvironmentKey {
    public static let defaultValue: Color? = .red
}

@_documentation(visibility: internal)
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {
    /// Sets timecode component validation rendering style for ``TimecodeField`` and ``TimecodeText`` views.
    ///
    /// This foreground color will be used only for any timecode component values that are invalid based on the given
    /// properties (frame rate, subframes base, and upper limit).
    ///
    /// If `nil`, validation rendering is disabled and invalid components will not be colorized.
    ///
    /// This modifier only affects visual representation of invalid timecode, and does not have any effect on logical
    /// validation that may (or may not) be applied separately.
    public var timecodeValidationStyle: Color? {
        get { self[TimecodeValidationStyleKey.self] }
        set { self[TimecodeValidationStyleKey.self] = newValue }
    }
}

// MARK: - TimecodePasted (internal)

@_documentation(visibility: internal)
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
struct TimecodePastedAction {
    typealias Action = (_ pasteResult: Result<Timecode, Error>) -> Void
    let action: Action
    
    func callAsFunction(_ timecode: Timecode) {
        action(.success(timecode))
    }
    
    #if os(macOS)
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    @MainActor
    func callAsFunction(
        itemProvider: NSItemProvider,
        propertiesForString timecodeProperties: Timecode.Properties
    ) async {
        await callAsFunction(itemProviders: [itemProvider], propertiesForString: timecodeProperties)
    }
    
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    @MainActor
    func callAsFunction(
        itemProviders: [NSItemProvider],
        propertiesForString timecodeProperties: Timecode.Properties
    ) async {
        do {
            let timecode = try await Timecode(
                from: itemProviders,
                propertiesForString: timecodeProperties
            )
            action(.success(timecode))
        } catch {
            action(.failure(error))
            return
        }
    }
    #endif
    
    enum ParseResult: Equatable, Hashable, Sendable {
        case timecode(Timecode)
        case invalid
    }
}

@_documentation(visibility: internal)
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
struct TimecodePastedKey: EnvironmentKey {
    static let defaultValue: TimecodePastedAction? = nil
}

@_documentation(visibility: internal)
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {
    /// Environment method used to propagate a user-pasted timecode.
    var timecodePasted: TimecodePastedAction? {
        get { self[TimecodePastedKey.self] }
        set { self[TimecodePastedKey.self] = newValue }
    }
}

#endif
