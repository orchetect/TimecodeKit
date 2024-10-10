//
//  SwiftUI Utilities.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI)

import SwiftUI

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Text {
    /// Utility method to concatenate `Text` instances.
    @_disfavoredOverload
    mutating func append(_ other: Text) {
        self = self + other
    }
    
    /// Utility method to concatenate `Text` instances.
    @_disfavoredOverload
    func appending(_ other: Text) -> Text {
        self + other
    }
}

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
struct ConditionalForegroundStyleViewModifier<S: ShapeStyle>: ViewModifier {
    let style: S?
    
    init(style: S?) {
        self.style = style
    }
    
    func body(content: Content) -> some View {
        if let style {
            content.foregroundStyle(style)
        } else {
            content
        }
    }
}

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension View {
    func conditionalForegroundStyle<S: ShapeStyle>(_ style: S?) -> some View {
        modifier(ConditionalForegroundStyleViewModifier<S>(style: style))
    }
}

@available(iOS 14.0, macOS 11.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension KeyEquivalent {
    /// Delete (ASCII 127)
    ///
    /// Returns the Delete key by being formed using Unicode scalar 127.
    static let deleteScalar = KeyEquivalent(Character(UnicodeScalar(127)))
}

#endif
