//
//  API-2.0.0.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI)

import SwiftUI
import TimecodeKit

// MARK: API Changes in TimecodeKit 2.0.0 UI

@available(*, renamed: "stringValueValidatedText(format:invalidModifiers:defaultModifiers:)")
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Timecode {
    public func stringValueValidatedText(
        format: StringFormat = .default(),
        invalidModifiers: ((Text) -> Text)? = nil,
        withDefaultModifiers: ((Text) -> Text)?
    ) -> Text {
        stringValueValidatedText(
            format: format,
            invalidModifiers: invalidModifiers,
            defaultModifiers: withDefaultModifiers
        )
    }
}

#endif
