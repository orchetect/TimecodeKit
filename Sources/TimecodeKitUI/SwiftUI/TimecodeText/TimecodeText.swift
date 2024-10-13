//
//  TimecodeText.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI)

import SwiftUI
import TimecodeKit

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
///     .foregroundColor(.primary)
///     .timecodeFormat([.showSubFrames])
///     .timecodeSeparatorStyle(.secondary)
///     .timecodeValidationStyle(.red)
/// ```
@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
public struct TimecodeText: View {
    @Environment(\.timecodeFormat) private var timecodeFormat
    @Environment(\.timecodeSeparatorStyle) private var timecodeSeparatorStyle
    @Environment(\.timecodeValidationStyle) private var timecodeValidationStyle
    
    var timecode: Timecode
    
    public init(_ timecode: Timecode) {
        self.timecode = timecode
    }
    
    public var body: Text {
        timecode.text(
            format: timecodeFormat,
            separatorStyle: timecodeSeparatorStyle,
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
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func text(
        format: Timecode.StringFormat = .default(),
        separatorStyle: Color? = nil,
        validationStyle: Color? = .red
    ) -> Text {
        // proxy variables which makes it easier to copy/paste or refactor this code block
        let timecode = self
        let timecodeFormat = format
        let timecodeSeparatorStyle = separatorStyle
        let timecodeValidationStyle = validationStyle
        
        let invalidModifiers: (String) -> Text = {
            var str = Text($0)
            if let timecodeValidationStyle {
                str = str.foregroundColor(timecodeValidationStyle)
            }
            return str
        }
        
        let separatorModifiers: (String) -> Text = {
            var str = Text($0)
            if let timecodeSeparatorStyle {
                str = str.foregroundColor(timecodeSeparatorStyle)
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
        if timecode.days != 0 {
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
            if invalids.contains(.subFrames) {
                output.append(invalidModifiers(subframesText))
            } else {
                output.append(Text(subframesText))
            }
        }
        
        return output.monospacedDigit()
    }
}

#if DEBUG

@available(macOS 14, iOS 17, watchOS 10.0, *)
#Preview {
    @Previewable @TimecodeState var timecode = Timecode(
        .components(d: 02, h: 04, m: 20, s: 30, f: 25, sf: 82),
        using: Timecode.Properties(
            rate: .fps24,
            base: .max100SubFrames,
            limit: .max100Days
        ),
        by: .allowingInvalid
    )
    @Previewable @State var timecodeFormat: Timecode.StringFormat = [.showSubFrames]
    
    VStack {
        VStack {
            Text("\(timecode)") // no modifiers are applied, just here to test
            TimecodeText(timecode)
            TimecodeText(timecode)
                .foregroundColor(.blue)
        }
        .font(.largeTitle)
        .timecodeFormat(timecodeFormat)
        .timecodeSeparatorStyle(.secondary)
        .timecodeValidationStyle(.red)
        
        Form {
            LabeledContent("Frame Rate") {
                Button("24") { timecode.frameRate = .fps24 }
                Button("30") { timecode.frameRate = .fps30 }
            }
            LabeledContent("SubFrames Base") {
                Button("80") { timecode.subFramesBase = .max80SubFrames }
                Button("100") { timecode.subFramesBase = .max100SubFrames }
            }
            LabeledContent("Upper Limit") {
                Button("24 Hours") { timecode.upperLimit = .max24Hours }
                Button("100 Days") { timecode.upperLimit = .max100Days }
            }
            LabeledContent("Randomize Invalid Components") {
                Button("Randomize") {
                    timecode = .init(
                        .randomComponentsAndProperties(in: .unsafeRandomRanges),
                        by: .allowingInvalid
                    )
                }
            }
            Toggle("Show SubFrames", isOn: $timecodeFormat.option(.showSubFrames))
        }
        .formStyle(.grouped)
    }
    .padding()
    .frame(minWidth: 400)
}

#endif

#endif
