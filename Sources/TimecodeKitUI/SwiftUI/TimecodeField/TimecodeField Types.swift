//
//  TimecodeField Types.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(watchOS)

import SwiftUI
import TimecodeKitCore

// MARK: - FieldAction

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension TimecodeField {
    /// An enum describing actions to perform in response to ``TimecodeField`` user input.
    ///
    /// This type is passed to the ``SwiftUICore/View/timecodeFieldReturnAction(_:)`` and/or
    /// ``SwiftUICore/View/timecodeFieldEscapeAction(_:)`` view modifiers.
    public enum FieldAction: Equatable, Hashable, Sendable {
        /// End editing.
        /// Removes focus from the timecode field.
        /// Passes the key event through the receiver chain and does not capture it.
        case endEditing
        
        /// Advances the focus to the next timecode component.
        /// Passes the key event through the receiver chain and does not capture it.
        case focusNextComponent
        
        /// Resets component focus to the specified component.
        /// If `nil`, focus is reset to the first visible component.
        /// Captures the key event and does not pass it through to the receiver chain.
        case resetComponentFocus(component: Timecode.Component? = nil)
    }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension TimecodeField.FieldAction: Identifiable {
    public var id: RawValue { rawValue }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension TimecodeField.FieldAction: CaseIterable {
    public static let allCases: [Self] = [.endEditing, .focusNextComponent]
        + Timecode.Component.allCases.map { .resetComponentFocus(component: $0) }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
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
        case .endEditing:
            "endEditing"
        case .focusNextComponent:
            "focusNextComponent"
        case let .resetComponentFocus(component):
            if let component {
                "resetComponentFocus-to-\(component)"
            } else {
                "resetComponentFocus"
            }
        }
    }
}

// MARK: - InputStyle

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
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

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension TimecodeField.InputStyle: Identifiable {
    public var id: RawValue { rawValue }
}

// MARK: - InputWrapping

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension TimecodeField {
    /// An enum describing focus wrapping behavior in response to ``TimecodeField`` user input.
    ///
    /// This type is passed to the ``SwiftUICore/View/timecodeFieldInputWrapping(_:)`` view modifier.
    public enum InputWrapping: String, Equatable, Hashable, CaseIterable, Sendable {
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
        
        /// When the timecode field advances focus to the next timecode component, the focus should wrap around to the
        /// first visible timecode component when advancing focus from the last visible timecode component.
        ///
        /// For example, when HH:MM:SS:FF components are visible, focus will advance from frames back around to hours.
        case wrap
    }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension TimecodeField.InputWrapping: Identifiable {
    public var id: RawValue { rawValue }
}

// MARK: - PastePolicy

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension TimecodeField {
    public enum PastePolicy: String, Equatable, Hashable, Sendable, CaseIterable {
        /// (Recommended)
        /// Only allow pasted timecode that matches local properties can conform to local properties.
        /// Validation policy set by ``SwiftUICore/View/timecodeFieldValidationPolicy(_:)`` is still also applied.
        case preserveLocalProperties
        
        // /// Only allow pasted timecode that strictly complies with the validation rules, converting from different frame rate if necessary.
        // ///
        // /// This may result in the timecode component values themselves changing, but the timecode will be converted to the
        // /// corresponding timecode in the local frame rate such that it equals the same real wall-clock elapsed time.
        // ///
        // /// - Invalid values will cause the paste event to be rejected.
        // /// - In the event rich timecode is pasted that includes properties (frame rate, subframes base, upper limit), the
        // ///   timecode will be converted to the local properties.
        // case convertIfNeeded
        
        /// Allow pasted timecode to overwrite local timecode properties if it contains properties.
        /// Validation policy set by ``SwiftUICore/View/timecodeFieldValidationPolicy(_:)`` is still also applied.
        ///
        /// - Pasting a timecode string will preserve local timecode properties, pasting only component values if they are
        ///   valid based on the validation rules.
        /// - In the event rich timecode is pasted that includes properties (frame rate, subframes base, upper limit), the
        ///   local properties will be overridden by the new properties. The benefit of this is that the pasted timecode's
        ///   context is maintained. However, if local context needs to remain stable, it is recommended to use
        ///   ``preserveLocalProperties`` instead.
        case allowNewProperties
        
        /// Pasted timecode will paste component values only, discarding the pasted timecode properties, if any.
        ///
        /// > Note:
        /// >
        /// > This option is discouraged, as timecode is only meaningful within the context it is used (including frame
        /// > rate, subframes base, and upper limit).
        /// >
        /// > Stripping timecode properties and allowing component values to be pasted as-is will allow timecode from
        /// > differing contexts to be mixed, which could create inconsistency in both logic and user experience.
        case discardProperties
    }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension TimecodeField.PastePolicy: Identifiable {
    public var id: RawValue { rawValue }
}

// MARK: - RejectedInputFeedback

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension TimecodeField {
    /// An enum describing rejected input feedback behaviors (visual & audible) in response to invalid ``TimecodeField``
    /// user input.
    ///
    /// This setting does not affect user input or validation at all. It only determines the style of visual & audible
    /// feedback to provide to the user in the event of the field rejecting invalid user input.
    ///
    /// This type is passed to the ``SwiftUICore/View/timecodeFieldInputRejectionFeedback(_:)`` view modifier.
    public enum InputRejectionFeedback: Sendable {
        /// Error feedback is based on invalid input based on the field's validation rule.
        case validationBased(animation: RejectionAnimation? = .shake)
        
        /// Error feedback is based on invalid input based on the field's validation rule as well as all undefined keys.
        /// Use this if you know that none of the field's parent views
        case validationBasedAndUndefinedKeys(animation: RejectionAnimation? = .shake)
        
        /// Custom error feedback closure.
        ///
        /// Note that this closure is only called in the event of rejected input due to violation of the timecode
        /// field's validation rule or if the user presses a key that is not designated to be handled by the timecode
        /// field.
        case custom(action: CustomInputRejectionFeedback)
    }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension TimecodeField.InputRejectionFeedback {
    /// Custom error feedback closure used with the ``custom(action:)`` enum case.
    ///
    /// Note that this closure is only called in the event of rejected input due to violation of the timecode
    /// field's validation rule or if the user presses a key that is not designated to be handled by the timecode
    /// field.
    public typealias CustomInputRejectionFeedback = @Sendable (
        _ rejectedUserAction: UserAction
    ) -> Void
    
    public enum UserAction: Equatable, Hashable, Sendable {
        /// User keyboard input was rejected.
        case keyRejected(component: Timecode.Component, key: KeyEquivalent, reason: Reason)
        
        /// User pasted pasteboard contents but it was rejected.
        case pasteRejected
    }
    
    public enum Reason: String, Equatable, Hashable, Sendable, CaseIterable {
        /// Rejected because accepting the key would have violated the validation policy.
        case invalid
        
        /// Rejected because the key is not defined by the timecode field.
        case undefinedKey
    }
    
    public enum RejectionAnimation: String, Equatable, Hashable, Sendable, CaseIterable {
        case shake
        case pulse
        
        /// Returns the best default for the current platform.
        static let platformDefault: Self = {
            #if os(macOS)
            .pulse
            #else
            .shake
            #endif
        }()
    }
    
    /// Returns `true` if the case specifies the feedback should be animated.
    /// The ``custom(action:)`` case always returns `nil`.
    var rejectionAnimation: RejectionAnimation? {
        switch self {
        case let .validationBased(animation):
            animation
        case let .validationBasedAndUndefinedKeys(animation):
            animation
        case .custom:
            nil
        }
    }
    
    /// Returns the best default for the current platform.
    static let platformDefault: Self = .validationBased(animation: .platformDefault)
}

// MARK: - ValidationPolicy

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension TimecodeField {
    /// An enum describing timecode validation policies in response to ``TimecodeField`` user input.
    ///
    /// This type is passed to the ``SwiftUICore/View/timecodeFieldValidationPolicy(_:)`` view modifier.
    public enum ValidationPolicy: String, Equatable, Hashable, CaseIterable, Sendable {
        /// Invalid timecode component values are allowed.
        /// Entry will accept arbitrarily large numbers for any individual timecode component.
        ///
        /// This is useful for testing purposes or non-standard timecode entry.
        case allowInvalid
        
        /// Strictly enforce valid timecode component values at the given frame rate, subframes base, and upper limit
        /// properties.
        /// Invalid component values are rejected during user input and will revert to a valid value.
        ///
        /// Note that this method is unidirectional and not applied bidirectionally to the timecode binding.
        /// This is to say that values entered by the user are validated, but values pushed to the binding will not be
        /// corrected but merely displayed as-is. They are only then subsequently validated if the user edits the
        /// component value.
        case enforceValid
    }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension TimecodeField.ValidationPolicy: Identifiable {
    public var id: RawValue { rawValue }
}

#endif
