//
//  TimecodeField Types.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && (os(macOS) || os(iOS) || os(visionOS))

import SwiftUI
import TimecodeKitCore

// MARK: - FieldAction

@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
extension TimecodeField {
    /// An enum describing actions to perform in response to ``TimecodeField`` user input.
    ///
    /// This type is passed to the ``SwiftUICore/View/timecodeFieldReturnAction(_:)`` and/or
    /// ``SwiftUICore/View/timecodeFieldEscapeAction(_:)`` view modifiers.
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
extension TimecodeField.FieldAction: RawRepresentable {
    public typealias RawValue = String
    
    public init?(rawValue: String) {
        guard let match = Self.allCases.first(where: { $0.rawValue == rawValue })
        else {
            return nil
        }
        self = match
    }
    
    public var rawValue: String {
        switch self {
        case .endEditing: "endEditing"
        case .resetComponentFocus(let component):
            if let component {
                "resetComponentFocus-to-\(component)"
            } else {
                "resetComponentFocus"
            }
        case .focusNextComponent: "focusNextComponent"
        }
    }
}

// MARK: - InputStyle

@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
extension TimecodeField {
    /// An enum describing numeric data entry input style cases for ``TimecodeField``.
    ///
    /// This type is passed to the ``SwiftUICore/View/timecodeFieldInputStyle(_:)`` view modifier.
    public enum InputStyle: String, Equatable, Hashable, CaseIterable, Sendable {
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

// MARK: - InputWrapping

@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
extension TimecodeField {
    /// An enum describing focus wrapping behavior in response to ``TimecodeField`` user input.
    ///
    /// This type is passed to the ``SwiftUICore/View/timecodeFieldInputWrapping(_:)`` view modifier.
    public enum InputWrapping: String, Equatable, Hashable, CaseIterable, Sendable {
        /// When the timecode field advances focus to the next timecode component, the focus should wrap around to the
        /// first visible timecode component when advancing focus from the last visible timecode component.
        ///
        /// For example, when HH:MM:SS:FF components are visible, focus will advance from frames back around to hours.
        case wrap
        
        /// When the timecode field advances focus to the next timecode component, do not wrap around to the first
        /// timecode component when attempting to advance focus from the last visible timecode component.
        ///
        /// For example, when HH:MM:SS:FF components are visible, focus will not advance from frames but instead frames
        /// will remain focused.
        ///
        /// In order to move focus to a previous component, the user may either:
        /// - click or tap on a different component
        /// - use the hardware left or right arrow keys to navigate focus
        /// - use the Delete (backspace) key twice to delete the contents of the component and then move focus to the
        ///   previous component, repeating as desired
        case noWrap
    }
}

@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
extension TimecodeField.InputWrapping: Identifiable {
    public var id: Self { self }
}

#endif
