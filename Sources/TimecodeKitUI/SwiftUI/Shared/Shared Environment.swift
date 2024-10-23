//
//  Shared Environment.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

// Environment contents used by both ``TimecodeField`` and ``TimecodeText``
// and available on all platforms.

#if canImport(SwiftUI)

import SwiftUI
import TimecodeKitCore

@_documentation(visibility: internal)
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension EnvironmentValues {
    // MARK: - TimecodeFormat
    
    /// Sets the timecode string format for ``TimecodeField`` and ``TimecodeText`` views.
    @Entry public var timecodeFormat: Timecode.StringFormat = .default()
    
    // MARK: - TimecodeSeparatorStyle
    
    /// Sets the text separator style for ``TimecodeField`` and ``TimecodeText`` views.
    /// If `color` is nil, the foreground style is used.
    ///
    /// - Note: To set the default color of the component values, use `foregroundColor` or `foregroundStyle` view modifiers.
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    @Entry public var timecodeSeparatorStyle: AnyShapeStyle? = nil
    
    // MARK: - TimecodeSubFramesStyle
    
    /// Sets the subframes timecode component foreground style and text scale for ``TimecodeField`` and ``TimecodeText`` views.
    /// If `color` is nil, the foreground style is used.
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    @Entry public var timecodeSubFramesStyle: (style: AnyShapeStyle?, scale: Text.Scale) = (nil, .default)
    
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
    @Entry var timecodeValidationStyle: AnyShapeStyle? = AnyShapeStyle(.red)
}

// MARK: - Environment Methods

// MARK: - TimecodePasted (internal)

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct TimecodePasteAction {
    public typealias Action = (_ pasteResult: Result<Timecode, Error>) -> Void
    let action: Action
    
    public enum ParseResult: Equatable, Hashable, Sendable {
        case timecode(Timecode)
        case invalid
    }
    
    public func callAsFunction(_ timecode: Timecode) {
        action(.success(timecode))
    }
    
    #if os(macOS)
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    @MainActor
    public func callAsFunction(
        itemProvider: NSItemProvider,
        propertiesForString timecodeProperties: Timecode.Properties
    ) async {
        await callAsFunction(itemProviders: [itemProvider], propertiesForString: timecodeProperties)
    }
    
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    @MainActor
    public func callAsFunction(
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
    @Entry var timecodePasted: TimecodePasteAction? = nil
}

#endif
