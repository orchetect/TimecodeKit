//
//  TimecodeKitUI-API-2.3.0.swift
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
        renamed: "Text(timecode:format:invalidModifiers:defaultModifiers:)",
        message: "Method has been refactored as `Text(timecode:)` init."
    )
    public func stringValueValidatedText(
        format: StringFormat = .default(),
        invalidModifiers: ((Text) -> Text)? = nil,
        defaultModifiers: ((Text) -> Text)? = nil
    ) -> Text {
        Text(
            timecode: self,
            format: format,
            invalidModifiers: invalidModifiers,
            defaultModifiers: defaultModifiers
        )
    }
}

#endif
