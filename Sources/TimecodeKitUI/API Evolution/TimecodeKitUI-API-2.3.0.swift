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
