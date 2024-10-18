//
//  TimecodeField Environment.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && (os(macOS) || os(iOS) || os(visionOS))

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
    @available(macOS 14, iOS 17, *)
    @available(watchOS, unavailable)
    @available(tvOS, unavailable)
    @Entry public var timecodeFieldInputStyle: TimecodeField.InputStyle = {
        #if os(macOS)
        .continuousWithinComponent
        #else
        .autoAdvance
        #endif
    }()
    
    // MARK: - TimecodeFieldInputWrapping
    
    /// Sets the focus wrapping behavior for ``TimecodeField`` views.
    @available(macOS 14, iOS 17, *)
    @available(watchOS, unavailable)
    @available(tvOS, unavailable)
    @Entry public var timecodeFieldInputWrapping: TimecodeField.InputWrapping = .noWrap
    
    // MARK: - TimecodeFieldReturnAction
    
    /// Sets the `Return` key action for ``TimecodeField`` views.
    @available(macOS 14, iOS 17, *)
    @available(watchOS, unavailable)
    @available(tvOS, unavailable)
    @Entry public var timecodeFieldReturnAction: TimecodeField.FieldAction? = nil
    
    // MARK: - TimecodeFieldEscapeAction
    
    /// Sets the `Escape` key action for ``TimecodeField`` views.
    @available(macOS 14, iOS 17, *)
    @available(watchOS, unavailable)
    @available(tvOS, unavailable)
    @Entry public var timecodeFieldEscapeAction: TimecodeField.FieldAction? = nil
    
    // MARK: - TimecodeFieldValidationPolicy
    
    /// Sets timecode component validation policy for ``TimecodeField`` views.
    @available(macOS 14, iOS 17, *)
    @available(watchOS, unavailable)
    @available(tvOS, unavailable)
    @Entry public var timecodeFieldValidationPolicy: TimecodeField.ValidationPolicy = .enforceValid
    
    /// Enables or disables validation animation for ``TimecodeField`` views.
    @available(macOS 14, iOS 17, *)
    @available(watchOS, unavailable)
    @available(tvOS, unavailable)
    @Entry public var timecodeFieldValidationAnimation: Bool = {
        #if os(macOS)
        false
        #else
        true
        #endif
    }()
    
    // MARK: - TimecodeFormat
    
    /// Sets the timecode string format for ``TimecodeField`` and ``TimecodeText`` views.
    @Entry public var timecodeFormat: Timecode.StringFormat = .default()
    
    // MARK: - TimecodeSeparatorStyle
    
    /// Sets the text separator style for ``TimecodeField`` and ``TimecodeText`` views.
    /// If `color` is nil, the foreground style is used.
    ///
    /// - Note: To set the default color of the component values, use `foregroundColor` or `foregroundStyle` view modifiers.
    @Entry public var timecodeSeparatorStyle: Color? = nil
    
    // MARK: - TimecodeSubFramesStyle
    
    /// Sets the subframes timecode component foreground style and text scale for ``TimecodeField`` and ``TimecodeText`` views.
    /// If `color` is nil, the foreground style is used.
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Entry public var timecodeSubFramesStyle: (color: Color?, scale: Text.Scale) = (nil, .default)
    
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
    @Entry var timecodeValidationStyle: Color? = .red
    
}

// MARK: - Environment Methods

// MARK: - TimecodePasted (internal)

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
struct TimecodePastedAction {
    typealias Action = (_ pasteResult: Result<Timecode, Error>) -> Void
    let action: Action
    
    enum ParseResult: Equatable, Hashable, Sendable {
        case timecode(Timecode)
        case invalid
    }
    
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
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {
    /// Environment method used to propagate a user-pasted timecode.
    @Entry var timecodePasted: TimecodePastedAction? = nil
}

#endif
