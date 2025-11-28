//
//  SwiftTimecodeUI-API-2.3.0.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI)

import SwiftUI
import SwiftTimecodeCore

#if canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
import UIKit
#endif

// MARK: API Changes in swift-timecode 2.3.0 UI

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

@_documentation(visibility: internal)
extension Timecode {
    @available(
        *,
        deprecated,
        renamed: "nsAttributedString(format:defaultAttributes:invalidAttributes:)",
        message: "Method has been renamed and moved to the SwiftTimecodeUI module."
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

@_documentation(visibility: internal)
extension Timecode.TextFormatter {
    @available(*, deprecated, renamed: "invalidAttributes")
    public var validationAttributes: [NSAttributedString.Key: Any] {
        get { invalidAttributes }
        set { invalidAttributes = newValue }
    }
    
    @available(*, deprecated, renamed: "init(using:stringFormat:showsValidation:invalidAttributes:)")
    public convenience init(
        using properties: Timecode.Properties? = nil,
        stringFormat: Timecode.StringFormat? = nil,
        showsValidation: Bool = false,
        validationAttributes: [NSAttributedString.Key: Any]? = nil
    ) {
        self.init(
            using: properties,
            stringFormat: stringFormat,
            showsValidation: showsValidation,
            invalidAttributes: validationAttributes
        )
    }
}

#endif
