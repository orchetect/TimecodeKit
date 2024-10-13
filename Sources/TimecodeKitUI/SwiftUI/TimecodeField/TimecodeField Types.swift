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
    }
}

#endif
