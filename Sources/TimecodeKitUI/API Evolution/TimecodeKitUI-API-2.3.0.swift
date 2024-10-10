//
//  TimecodeKitUI-API-2.3.0.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI)

import SwiftUI
import TimecodeKit

// MARK: API Changes in TimecodeKit 2.0.0 UI

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension Timecode {
    @_disfavoredOverload
    @available(
        *,
        deprecated,
        renamed: "Text(timecode:format:invalidModifiers:defaultModifiers:)",
        message: "Method has been refactored as `Text()` init and string interpolation. To use custom validation style, see the new timecode view modifiers."
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

#endif
