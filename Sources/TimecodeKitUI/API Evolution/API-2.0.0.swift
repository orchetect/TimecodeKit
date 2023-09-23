//
//  API-2.0.0.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI)

import SwiftUI
import TimecodeKit

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
