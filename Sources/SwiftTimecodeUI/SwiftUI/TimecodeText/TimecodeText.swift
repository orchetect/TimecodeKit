//
//  TimecodeText.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI)

import SwiftUI
import SwiftTimecodeCore

// ⚠️ NOTE:
//
// It's not possible to implement a custom `Text(_ timecode:) initializer since our formatting depends on custom view
// modifiers to format and style the text (such as `.timecodeFormat()` and `.timecodeValidationStyle()`).
//
// Implementing this init was already attempted experimentally in the past, but since these modifiers rely on the
// environment the result was that the text only took on the format and style attributes the first time it was rendered.
//
// Changes to state of those modifiers in the view would not update the `Text` instance. For this reason, we need our own
// custom `TimecodeText` view.
//
// Additionally, experimentation was done to attempt to allow `Text` concatenation but there was no way to allow for it
// without losing the format/style attributes entirely, or having the same result as before where they would only render
// when the view first appears and would not update from changes to the view modifiers' state.

/// Renders the timecode string as SwiftUI `Text`, allowing specialized format and style view modifiers
/// including the ability to colorize invalid timecode components.
///
/// This method will wraps a SwiftUI `Text` view colorizing individual invalid timecode components
/// to indicate to the user that they are not valid, among other style options.
///
/// The `Timecode` instance may be initialized using the `allowingInvalid` validation rule in order to allow
/// invalid component values.
///
/// ```swift
/// let timecode = Timecode(
///     .components(h: 1, m: 20, s: 75, f: 60),
///     at: .fps23_976,
///     by: .allowingInvalid
/// )
/// TimecodeText(timecode)
/// ```
///
/// ## Style and Format Modifiers
///
/// You can supply format and style options by using the available view modifiers.
///
/// ```swift
/// TimecodeText(timecode)
///     .font(.title) // font size and family may be set as usual
///     .foregroundColor(.primary) // default text color
///     .timecodeFormat([.showSubFrames]) // enable subframes component
///     .timecodeSeparatorStyle(.secondary) // colorize separators
///     .timecodeSubFramesStyle(.secondary, scale: .secondary) // colorize and/or set text size
///     .timecodeValidationStyle(.red) // colorize invalid components
/// ```
@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
public struct TimecodeText: View {
    @Environment(\.timecodeFormat) private var timecodeFormat
    @Environment(\.timecodeSeparatorStyle) private var timecodeSeparatorStyle
    @Environment(\.timecodeSubFramesStyle) private var timecodeSubFramesStyle
    @Environment(\.timecodeValidationStyle) private var timecodeValidationStyle
    
    var timecode: Timecode
    
    public init(_ timecode: Timecode) {
        self.timecode = timecode
    }
    
    public var body: Text {
        timecode.text(
            format: timecodeFormat,
            separatorStyle: timecodeSeparatorStyle,
            subFramesStyle: timecodeSubFramesStyle.style,
            subFramesScale: timecodeSubFramesStyle.scale,
            validationStyle: timecodeValidationStyle
        )
    }
}

extension Timecode {
    /// Returns a new SwiftUI `Text` instance using the specified format and style,
    /// including the ability to colorize invalid timecode components.
    ///
    /// This method is not meant to be used directly, and is thus not exposed as public.
    /// Instead, instantiate a ``TimecodeText`` view and use the provided custom view modifiers to supply the format and
    /// style attributes.
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
    func text(
        format: Timecode.StringFormat = .default(),
        separatorStyle: (some ShapeStyle)? = nil,
        subFramesStyle: (some ShapeStyle)? = nil,
        subFramesScale: Text.Scale = .default,
        validationStyle: (some ShapeStyle)? = nil
    ) -> Text {
        // proxy variables which makes it easier to copy/paste or refactor this code block
        let timecode = self
        let timecodeFormat = format
        let timecodeSeparatorStyle = separatorStyle
        let timecodeValidationStyle = validationStyle
        
        let invalidModifiers: (String) -> Text = {
            var str = Text($0)
            if let timecodeValidationStyle {
                str = str.foregroundStyle(timecodeValidationStyle)
            }
            return str
        }
        
        let separatorModifiers: (String) -> Text = {
            var str = Text($0)
            if let timecodeSeparatorStyle {
                str = str.foregroundStyle(timecodeSeparatorStyle)
            }
            return str
        }
        
        let sepDays = separatorModifiers(" ")
        let sepMain = timecodeFormat.filenameCompatible
            ? separatorModifiers("-")
            : separatorModifiers(":")
        let sepFrames = timecodeFormat.filenameCompatible
            ? separatorModifiers("-")
            : separatorModifiers(timecode.frameRate.isDrop ? ";" : ":")
        let sepSubFrames = separatorModifiers(".")
        
        let invalids = timecode.invalidComponents
        
        var output = Text("")
        
        // days
        if timecode.days != 0 || format.contains(.alwaysShowDays) {
            let daysText = "\(timecode.days)"
            if invalids.contains(.days) {
                output.append(invalidModifiers(daysText))
            } else {
                output.append(Text(daysText))
            }
            
            output.append(sepDays)
        }
        
        // hours
        
        let hoursText = String(format: "%02ld", timecode.hours)
        if invalids.contains(.hours) {
            output.append(invalidModifiers(hoursText))
        } else {
            output.append(Text(hoursText))
        }
        
        output.append(sepMain)
        
        // minutes
        
        let minutesText = String(format: "%02ld", timecode.minutes)
        if invalids.contains(.minutes) {
            output.append(invalidModifiers(minutesText))
        } else {
            output.append(Text(minutesText))
        }
        
        output.append(sepMain)
        
        // seconds
        
        let secondsText = String(format: "%02ld", timecode.seconds)
        if invalids.contains(.seconds) {
            output.append(invalidModifiers(secondsText))
        } else {
            output.append(Text(secondsText))
        }
        
        output.append(sepFrames)
        
        // frames
        
        let framesText = String(format: "%0\(timecode.frameRate.numberOfDigits)ld", timecode.frames)
        if invalids.contains(.frames) {
            output.append(invalidModifiers(framesText))
        } else {
            output.append(Text(framesText))
        }
        
        // subframes
        
        if timecodeFormat.showSubFrames {
            let numberOfSubFramesDigits = timecode.validRange(of: .subFrames).upperBound.numberOfDigits
            
            output.append(sepSubFrames)
            
            let subframesText = String(format: "%0\(numberOfSubFramesDigits)ld", timecode.subFrames)
            
            let baseSubFramesText: Text = if invalids.contains(.subFrames) {
                invalidModifiers(subframesText)
            } else {
                Text(subframesText).conditionalForegroundStyle(subFramesStyle)
            }
            
            output.append(baseSubFramesText.textScale(subFramesScale))
        }
        
        return output.monospacedDigit()
    }
}

#endif
