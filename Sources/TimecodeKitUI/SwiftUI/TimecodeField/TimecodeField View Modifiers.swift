//
//  TimecodeField View Modifiers.swift
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
    /// Sets the timecode field text separator style.
    /// If `color` is nil, the foreground style is used.
    ///
    /// - Note: To set the default color of the component values, use `foregroundColor` or `foregroundStyle` view modifiers.
    public func timecodeFieldSeparatorStyle(
        _ color: Color? = nil
    ) -> TimecodeField {
        var copy = self
        copy.separatorColor = color
        return copy
    }
    
    /// Sets timecode field validation style.
    /// This foreground color will be used only for any timecode component values that are invalid at the given timecode
    /// properties (frame rate, subframes base, and upper limit).
    /// If `nil`, validation is disabled and invalid components will not be colorized.
    public func timecodeFieldValidationStyle(
        _ color: Color? = .red
    ) -> TimecodeField {
        var copy = self
        copy.invalidComponentColor = color
        return copy
    }
    
    /// Sets the timecode field component highlight style.
    /// By default, the application's `accentColor` is used.
    public func timecodeFieldHighlightStyle(
        _ color: Color?
    ) -> TimecodeField {
        var copy = self
        copy.highlightColor = color ?? .accentColor
        return copy
    }
}

#endif
