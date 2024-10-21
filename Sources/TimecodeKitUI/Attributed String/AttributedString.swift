//
//  AttributedString.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI)

import Foundation
import SwiftUI
import TimecodeKitCore

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension AttributedString {
    /// Initializes a new `AttributedString` instance using the specified format and style,
    /// including the ability to colorize invalid timecode components.
    ///
    /// The format and style parameters are necessary to be provided imperatively here, as it's not possible to derive
    /// them from the SwiftUI environment.
    ///
    /// It's recommended to use ``TimecodeText`` instead if formatted timecode is being used in a SwiftUI view, where
    /// the custom declarative timecode view modifiers can be used.
    public init(
        _ timecode: Timecode,
        format: Timecode.StringFormat = .default(),
        separatorStyle: Color? = nil,
        validationStyle: Color? = .red
    ) {
        self = timecode.attributedString(
            format: format,
            separatorStyle: separatorStyle,
            validationStyle: validationStyle
        )
    }
}

extension Timecode {
    /// Returns a new `AttributedString` instance using the specified format and style,
    /// including the ability to colorize invalid timecode components.
    ///
    /// This method is not meant to be used directly, and is thus not exposed as public.
    /// Instead, use the custom `AttributedString(timecode:)` init.
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    func attributedString(
        format: Timecode.StringFormat = .default(),
        separatorStyle: Color? = nil,
        validationStyle: Color? = .red
    ) -> AttributedString {
        // proxy variables which makes it easier to copy/paste or refactor this code block
        let timecode = self
        let timecodeFormat = format
        let timecodeSeparatorStyle = separatorStyle
        let timecodeValidationStyle = validationStyle
        
        let invalidModifiers: (String) -> AttributedString = {
            var str = AttributedString($0)
            if let timecodeValidationStyle {
                str.foregroundColor = timecodeValidationStyle
            }
            return str
        }
        
        let separatorModifiers: (String) -> AttributedString = {
            var str = AttributedString($0)
            if let timecodeSeparatorStyle {
                str.foregroundColor = timecodeSeparatorStyle
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
        
        var output = AttributedString("")
        
        // days
        if timecode.days != 0 {
            let daysText = "\(timecode.days)"
            if invalids.contains(.days) {
                output.append(invalidModifiers(daysText))
            } else {
                output.append(AttributedString(daysText))
            }
            
            output.append(sepDays)
        }
        
        // hours
        
        let hoursText = String(format: "%02ld", timecode.hours)
        if invalids.contains(.hours) {
            output.append(invalidModifiers(hoursText))
        } else {
            output.append(AttributedString(hoursText))
        }
        
        output.append(sepMain)
        
        // minutes
        
        let minutesText = String(format: "%02ld", timecode.minutes)
        if invalids.contains(.minutes) {
            output.append(invalidModifiers(minutesText))
        } else {
            output.append(AttributedString(minutesText))
        }
        
        output.append(sepMain)
        
        // seconds
        
        let secondsText = String(format: "%02ld", timecode.seconds)
        if invalids.contains(.seconds) {
            output.append(invalidModifiers(secondsText))
        } else {
            output.append(AttributedString(secondsText))
        }
        
        output.append(sepFrames)
        
        // frames
        
        let framesText = String(format: "%0\(timecode.frameRate.numberOfDigits)ld", timecode.frames)
        if invalids.contains(.frames) {
            output.append(invalidModifiers(framesText))
        } else {
            output.append(AttributedString(framesText))
        }
        
        // subframes
        
        if timecodeFormat.showSubFrames {
            let numberOfSubFramesDigits = timecode.validRange(of: .subFrames).upperBound.numberOfDigits
            
            output.append(sepSubFrames)
            
            let subframesText = String(format: "%0\(numberOfSubFramesDigits)ld", timecode.subFrames)
            if invalids.contains(.subFrames) {
                output.append(invalidModifiers(subframesText))
            } else {
                output.append(AttributedString(subframesText))
            }
        }
        
        return output
    }
}

#endif
