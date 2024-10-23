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
    // MARK: - Internal Method (Called internally by TimecodeField)
    
    /// Determines whether timecode pasted from the pasteboard by the user is appropriate to accept in the current
    /// field context.
    ///
    /// Policy is evaluated in cascading order of `pastePolicy` first, then `validationPolicy`, then `inputStyle`.
    ///
    /// - Parameters:
    ///   - pasteResult: The result passed in from `TimecodePasteAction.Action`.
    ///   - currentTimecodeProperties: Local timecode properties on the timecode field.
    ///   - pastePolicy: Paste policy injected from the SwiftUI environment.
    ///   - validationPolicy: Validation policy injected from the SwiftUI environment.
    ///   - inputStyle: Input style injected from the SwiftUI environment.
    ///
    /// - Returns: Paste result determining whether the input timecode passes all of the validation conditions and the
    ///   receiver should accept the new timecode.
    ///   Note that the timecode returned in this result may have properties that are different from the input timecode.
    ///   For this reason, when accepting the pasted timecode after this method returns an
    ///   ``PasteValidationResult/allowed(_:)`` case, you should accept the timecode contained in this case and not the
    ///   timecode input into this method.
    static func validate(
        pasteResult: Result<Timecode, any Error>,
        currentTimecodeProperties: Timecode.Properties,
        pastePolicy: PastePolicy,
        validationPolicy: ValidationPolicy,
        inputStyle: InputStyle
    ) -> PasteValidationResult {
        guard let pastedTimecode = try? pasteResult.get() else {
            return .inputRejectionFeedback(.fieldPasteRejected)
        }
        
        return validate(
            pastedTimecode: pastedTimecode,
            currentTimecodeProperties: currentTimecodeProperties,
            pastePolicy: pastePolicy,
            validationPolicy: validationPolicy,
            inputStyle: inputStyle
        )
    }
    
    // MARK: - Public Utility Method
    
    /// Determines whether timecode pasted from the pasteboard by the user is appropriate to accept in the current
    /// field context.
    ///
    /// Policy is evaluated in cascading order of `pastePolicy` first, then `validationPolicy`, then `inputStyle`.
    ///
    /// - Parameters:
    ///   - pastedTimecode: The timecode instance received from the pasteboard after decoding its contents.
    ///
    ///     Typically this will be the timecode returned in SwiftUI from:
    ///     - `pasteDestination()` view modifier, or
    ///     - `onPasteCommand()` view modifier after parsing the `NSItemProvider`s using
    ///       `Timecode(from:propertiesForString:)`.
    ///
    ///   - currentTimecodeProperties: Local timecode properties on the timecode field.
    ///   - pastePolicy: Paste policy. The default is the safest and most common option.
    ///   - validationPolicy: Validation policy. The default is the safest and most common option.
    ///   - inputStyle: Input style, if applicable. The default is the safest and most common option.
    ///
    /// - Returns: Paste result determining whether the input timecode passes all of the validation conditions and the
    ///   receiver should accept the new timecode.
    ///   Note that the timecode returned in this result may have properties that are different from the input timecode.
    ///   For this reason, when accepting the pasted timecode after this method returns an
    ///   ``PasteValidationResult/allowed(_:)`` case, you should accept the timecode contained in this case and not the
    ///   timecode input into this method.
    public static func validate(
        pastedTimecode: Timecode,
        currentTimecodeProperties: Timecode.Properties,
        pastePolicy: PastePolicy = .preserveLocalProperties,
        validationPolicy: ValidationPolicy = .enforceValid,
        inputStyle: InputStyle = .autoAdvance
    ) -> PasteValidationResult {
        var pastedTimecode = pastedTimecode
        
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
            currentTimecodeProperties: currentTimecodeProperties,
            pastePolicy: pastePolicy,
            validationPolicy: validationPolicy,
            inputStyle: inputStyle
        )
    }
    
    // MARK: - Private Chaining Handler
    
    private static func _validate(
        pastedTimecode: Timecode,
        currentTimecodeProperties: Timecode.Properties,
        pastePolicy: PastePolicy,
        validationPolicy: ValidationPolicy,
        inputStyle: InputStyle
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
