//
//  TimecodeField Types.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && (os(macOS) || os(iOS) || os(visionOS))

import SwiftUI
import TimecodeKit

@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
extension TimecodeField {
    /// An enum describing actions to perform in response to ``TimecodeField`` user input.
    public enum FieldAction: Equatable, Hashable, Sendable {
        /// End editing.
        /// Removes focus from the timecode field.
        case endEditing
        
        /// Resets component focus to the specified component.
        /// If `nil`, focus is reset to the first visible component.
        case resetComponentFocus(component: Timecode.Component? = nil)
        
        /// Advances the focus to the next timecode component.
        case focusNextComponent
    }
}

@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
extension TimecodeField.FieldAction: Identifiable {
    public var id: Self { self }
}

@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
extension TimecodeField.FieldAction: CaseIterable {
    public static let allCases: [Self] = [.endEditing]
    + Timecode.Component.allCases.map { .resetComponentFocus(component: $0) }
}

@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
extension TimecodeField {
    /// An enum describing numeric data entry input style cases for ``TimecodeField``.
    public enum InputStyle: Equatable, Hashable, CaseIterable, Sendable {
        /// Auto-advance focus to next timecode component once all digits for the currently-focused component are
        /// populated by user data entry.
        ///
        /// All components will auto-advance except subframes will not auto-advance back around to the first timecode
        /// component.
        case autoAdvance
        
        /// Numeric entry remains continuous within the currently-focused timecode component.
        ///
        /// Digit places will populate normally until all available digit places are occupied for the currently-focused
        /// timecode component, after which the most-significant digit will be discarded to accommodate the newly
        /// entered digit.
        case continuousWithinComponent
        
        /// Unbounded timecode component values are allowed.
        /// Entry will accept arbitrarily large numbers for all timecode components.
        ///
        /// This is useful for testing purposes or non-standard timecode entry.
        case unbounded
    }
}

@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
extension TimecodeField.InputStyle: Identifiable {
    public var id: Self { self }
}

#endif
