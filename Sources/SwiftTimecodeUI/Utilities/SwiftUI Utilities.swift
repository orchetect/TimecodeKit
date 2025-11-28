//
//  SwiftUI Utilities.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
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

/// Applies the given foreground style only if it is non-`nil`.
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

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension View {
    /// Applies the given foreground style only if it is non-`nil`.
    func conditionalForegroundStyle<S: ShapeStyle>(_ style: S?) -> some View {
        modifier(ConditionalForegroundStyleViewModifier<S>(style: style))
    }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension Text {
     /// Applies the given foreground style only if it is non-`nil` and retains the view as `Text`.
     nonisolated func conditionalForegroundStyle<S: ShapeStyle>(_ style: S?) -> Text {
         if let style {
             return foregroundStyle(style)
         } else {
             return self
         }
     }
}

@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension ShapeStyle {
    func asAnyShapeStyle() -> AnyShapeStyle {
        AnyShapeStyle(self)
    }
}

@available(iOS 14.0, macOS 11.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension KeyEquivalent {
    /// Delete (ASCII 127)
    ///
    /// Returns the `DEL` key by being formed using Unicode scalar 127.
    static let asciiDEL = KeyEquivalent(Character(UnicodeScalar(127)))
    
    /// End of Text (ASCII 3)
    ///
    /// The keyboard number-pad `Enter` key is received as this key equivalent.
    static let asciiEndOfText = KeyEquivalent(Character(UnicodeScalar(3)))
}

#endif
