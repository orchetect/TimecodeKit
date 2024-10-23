//
//  TimecodeField Paste Policy.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(watchOS)

import SwiftUI
import TimecodeKitCore

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension TimecodeField {
    /// Determines whether timecode pasted from the pasteboard by the user is appropriate to accept in the current
    /// field context.
    public static func validate(
        pasteResult: Result<Timecode, any Error>,
        inputStyle: InputStyle,
        validationPolicy: ValidationPolicy,
        currentTimecodeProperties: Timecode.Properties,
        pastePolicy: PastePolicy
    ) -> PasteValidationResult {
        guard var pastedTimecode = try? pasteResult.get() else {
            return .inputRejectionFeedback(.fieldPasteRejected)
        }
        
        switch pastePolicy {
        case .preserveLocalProperties:
            // ensure that the newly pasted timecode is compatible with local properties.
            guard pastedTimecode.frameRate == currentTimecodeProperties.frameRate
            else {
                return .inputRejectionFeedback(.fieldPasteRejected)
            }
            
            switch validationPolicy {
            case .allowInvalid:
                // other properties (subframes base, upper limit) can be ignored at this stage.
                // just ensure Timecode instance has identical local properties.
                pastedTimecode.properties = currentTimecodeProperties
            case .enforceValid:
                // ensure other properties (subframes base, upper limit) are compatible
                guard let transplantedTimecode = try? pastedTimecode.setting(.components(pastedTimecode.components))
                else {
                    return .inputRejectionFeedback(.fieldPasteRejected)
                }
                pastedTimecode = transplantedTimecode
            }
            
        case .allowNewProperties:
            // indiscriminately accept new timecode's properties.
            // at this stage we don't care if the timecode is valid or not.
            break
        case .discardProperties:
            // ensure Timecode instance has identical local properties.
            // at this stage we don't care if the timecode is valid or not.
            pastedTimecode.properties = currentTimecodeProperties
        }
        
        return _validate(
            pastedTimecode: pastedTimecode,
            inputStyle: inputStyle,
            validationPolicy: validationPolicy,
            currentTimecodeProperties: currentTimecodeProperties,
            pastePolicy: pastePolicy
        )
    }
    
    private static func _validate(
        pastedTimecode: Timecode,
        inputStyle: InputStyle,
        validationPolicy: ValidationPolicy,
        currentTimecodeProperties: Timecode.Properties,
        pastePolicy: PastePolicy
    ) -> PasteValidationResult {
        // validate against validation policy
        switch validationPolicy {
        case .allowInvalid:
            break
        case .enforceValid:
            guard pastedTimecode.isValid else {
                return .inputRejectionFeedback(.fieldPasteRejected)
            }
        }
        
        var timecodeProperties = currentTimecodeProperties
        switch pastePolicy {
        case .allowNewProperties:
            timecodeProperties = pastedTimecode.properties
        case .discardProperties:
            break
        case .preserveLocalProperties:
            break
        }
        
        // validate against input style
        switch inputStyle {
        case .autoAdvance, .continuousWithinComponent:
            // ensure all timecode components as-is respect the max number of digits allowed for each
            guard pastedTimecode.components.isWithinValidDigitCounts(
                at: timecodeProperties.frameRate,
                base: timecodeProperties.subFramesBase
            )
            else {
                return .inputRejectionFeedback(.fieldPasteRejected)
            }
        case .unbounded:
            break
        }
        
        return .allowed(pastedTimecode)
    }
    
    public enum PasteValidationResult: Equatable, Hashable, Sendable {
        case allowed(_ newTimecode: Timecode)
        case inputRejectionFeedback(
            _ rejectedUserAction: InputRejectionFeedback.UserAction
        )
    }
}
    
#endif
