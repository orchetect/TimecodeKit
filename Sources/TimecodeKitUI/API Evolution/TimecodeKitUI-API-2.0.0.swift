//
//  TimecodeKitUI-API-2.0.0.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

// NOTE:
// These are disabled because the API changes from 1.x to 2.x were too extensive to fully/properly
// implement using @available() attributes and was actually causing issues with Xcode's autocomplete
// in the IDE's code editor.
// So instead, a 1.x -> 2.x Migration Guide was written and included in TimecodeKit 2's documentation.

#if ENABLE_EXTENDED_API_DEPRECATIONS

#if canImport(SwiftUI)

import SwiftUI
import TimecodeKitCore

// MARK: API Changes in TimecodeKit 2.0.0 UI

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Timecode {
    @_disfavoredOverload
    @available(
        *,
        deprecated,
        renamed: "stringValueValidatedText(format:invalidModifiers:defaultModifiers:)",
        message: "`withDefaultModifiers` parameter has been renamed to `defaultModifiers`."
    )
    public func stringValueValidatedText(
        format: StringFormat = .default(),
        invalidModifiers: ((Text) -> Text)? = nil,
        withDefaultModifiers: ((Text) -> Text)? = nil
    ) -> Text {
        stringValueValidatedText(
            format: format,
            invalidModifiers: invalidModifiers,
            defaultModifiers: withDefaultModifiers
        )
    }
}

#endif

#endif
