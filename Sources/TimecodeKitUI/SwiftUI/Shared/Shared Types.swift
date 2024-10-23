//
//  Shared Types.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

// Types used by both ``TimecodeField`` and ``TimecodeText`` and sometimes any view,
// and available on all platforms.

#if canImport(SwiftUI)

import SwiftUI
import TimecodeKitCore

public enum TimecodePastePolicy: String, Equatable, Hashable, Sendable, CaseIterable {
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

extension TimecodePastePolicy: Identifiable {
    public var id: RawValue { rawValue }
}

#endif
