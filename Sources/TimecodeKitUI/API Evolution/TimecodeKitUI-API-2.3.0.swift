//
//  TimecodeKitUI-API-2.3.0.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI)

import SwiftUI
import TimecodeKitCore

// MARK: API Changes in TimecodeKit 2.0.0 UI

@_documentation(visibility: internal)
@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension Timecode {
    @MainActor @_disfavoredOverload
    @available(
        *,
        deprecated,
        renamed: "TimecodeText(_:)",
        message: "Method has been refactored as the new `TimecodeText()` type. To use custom validation style, see the new timecode view modifiers."
    )
    public func stringValueValidatedText(
        format: StringFormat = .default(),
        invalidModifiers: ((Text) -> Text)? = nil,
        defaultModifiers: ((Text) -> Text)? = nil
    ) -> some View {
        TimecodeText(self)
            .timecodeFormat(format)
    }
}

#if canImport(AppKit)

import AppKit

@_documentation(visibility: internal)
extension Timecode {
    @available(
        *,
        deprecated,
        renamed: "nsAttributedString(format:defaultAttributes:invalidAttributes:)",
        message: "Method has been renamed and moved to the TimecodeKitUI module."
    )
    public func stringValueValidated(
        format: StringFormat = .default(),
        invalidAttributes: [NSAttributedString.Key: Any]? = nil,
        defaultAttributes: [NSAttributedString.Key: Any]? = nil
    ) -> NSAttributedString {
        nsAttributedString(
            format: format,
            defaultAttributes: defaultAttributes,
            invalidAttributes: invalidAttributes
        )
    }
}

#endif

#endif
