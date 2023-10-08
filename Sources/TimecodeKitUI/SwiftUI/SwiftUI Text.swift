//
//  SwiftUI Text.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI)

import SwiftUI
import TimecodeKit

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Timecode {
    /// Returns the same output of `stringValue(format:)` as SwiftUI `Text`, colorizing invalid values.
    ///
    /// This method will produce a SwiftUI `Text` view colorizing individual invalid timecode components
    /// to indicate to the user that they are not valid.
    ///
    /// The `Timecode` instance must be initialized using the `.allowingInvalid` validation rule.
    ///
    /// ```swift
    /// Timecode(.components(h: 1, m: 20, s: 75, f: 60), at: .fps23_976, by: .allowingInvalid)
    ///     .stringValueValidatedText()
    /// ```
    ///
    /// You can alternatively supply your own invalid component modifiers by setting the `invalidModifiers` argument.
    ///
    /// ```swift
    /// Timecode(.components(h: 1, m: 20, s: 75, f: 60), at: .fps23_976, by: .allowingInvalid)
    ///     .stringValueValidatedText(
    ///         invalidModifiers: {
    ///             $0.foregroundColor(.blue)
    ///         }, defaultModifiers: {
    ///             $0.foregroundColor(.black)
    ///         }
    ///     )
    /// ```
    ///
    /// - Parameters:
    ///   - format: Raw string format options.
    ///   - invalidModifiers: View modifiers to apply to invalid timecode components. Defaults to `.red` foreground color.
    ///   - defaultModifiers: Default view modifiers to apply to valid timecode components.
    /// - Returns: SwiftUI `Text` view.
    public func stringValueValidatedText(
        format: StringFormat = .default(),
        invalidModifiers: ((Text) -> Text)? = nil,
        defaultModifiers: ((Text) -> Text)? = nil
    ) -> Text {
        let defaultModifiers = defaultModifiers ?? {
            $0
        }
        
        let invalidModifiers = invalidModifiers ?? {
            $0.foregroundColor(Color.red)
        }
        
        let sepDays = defaultModifiers(Text(" "))
        let sepMain = format.filenameCompatible
            ? defaultModifiers(Text("-"))
            : defaultModifiers(Text(":"))
        let sepFrames = format.filenameCompatible
            ? defaultModifiers(Text("-"))
            : defaultModifiers(Text(frameRate.isDrop ? ";" : ":"))
        let sepSubFrames = defaultModifiers(Text("."))
        
        let invalids = invalidComponents
        
        // early return logic
        if invalids.isEmpty {
            return defaultModifiers(Text(stringValue(format: format)))
        }
        
        var output = defaultModifiers(Text(""))
        
        // days
        if days != 0 {
            let daysText = Text("\(days)")
            if invalids.contains(.days) {
                output = output + invalidModifiers(daysText)
            } else {
                output = output + defaultModifiers(daysText)
            }
            
            output = output + sepDays
        }
        
        // hours
        
        let hoursText = Text(String(format: "%02ld", hours))
        if invalids.contains(.hours) {
            output = output + invalidModifiers(hoursText)
        } else {
            output = output + defaultModifiers(hoursText)
        }
        
        output = output + sepMain
        
        // minutes
        
        let minutesText = Text(String(format: "%02ld", minutes))
        if invalids.contains(.minutes) {
            output = output + invalidModifiers(minutesText)
        } else {
            output = output + defaultModifiers(minutesText)
        }
        
        output = output + sepMain
        
        // seconds
        
        let secondsText = Text(String(format: "%02ld", seconds))
        if invalids.contains(.seconds) {
            output = output + invalidModifiers(secondsText)
        } else {
            output = output + defaultModifiers(secondsText)
        }
        
        output = output + sepFrames
        
        // frames
        
        let framesText = Text(String(format: "%0\(frameRate.numberOfDigits)ld", frames))
        if invalids.contains(.frames) {
            output = output + invalidModifiers(framesText)
        } else {
            output = output + defaultModifiers(framesText)
        }
        
        // subframes
        
        if format.showSubFrames {
            let numberOfSubFramesDigits = validRange(of: .subFrames).upperBound.numberOfDigits
            
            output = output + sepSubFrames
            
            let subframesText = Text(String(format: "%0\(numberOfSubFramesDigits)ld", subFrames))
            if invalids.contains(.subFrames) {
                output = output + invalidModifiers(subframesText)
            } else {
                output = output + defaultModifiers(subframesText)
            }
        }
        
        return output
    }
}

#endif
