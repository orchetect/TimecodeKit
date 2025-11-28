//
//  TimecodeField Paste Policy.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(watchOS)

import SwiftUI
import SwiftTimecodeCore

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
    ///   - localTimecodeProperties: Local timecode properties on the timecode field.
    ///   - pastePolicy: Paste policy injected from the SwiftUI environment.
    ///   - validationPolicy: Validation policy injected from the SwiftUI environment.
    ///   - inputStyle: Input style injected from the SwiftUI environment.
    ///
    /// - Returns: New timecode instance if the input timecode passes all of the validation conditions and the
    ///   receiver should accept the new timecode.
    ///   Note that the timecode returned in this result may have properties that are different from the input timecode.
    ///   For this reason, you should accept the timecode returned from this method and not the timecode input into this
    ///   method.
    nonisolated static func validate(
        pasteResult: Result<Timecode, any Error>,
        localTimecodeProperties: Timecode.Properties,
        pastePolicy: PastePolicy,
        validationPolicy: ValidationPolicy,
        inputStyle: InputStyle
    ) -> Timecode? {
        guard let pastedTimecode = try? pasteResult.get() else {
            return nil
        }
        
        return validate(
            pastedTimecode: pastedTimecode,
            localTimecodeProperties: localTimecodeProperties,
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
    ///   - localTimecodeProperties: Local timecode properties on the timecode field.
    ///   - pastePolicy: Paste policy. The default is the safest and most common option.
    ///   - validationPolicy: Validation policy. The default is the safest and most common option.
    ///   - inputStyle: Input style, if applicable. The default is the safest and most common option.
    ///
    /// - Returns: New timecode instance if the input timecode passes all of the validation conditions and the
    ///   receiver should accept the new timecode.
    ///   Note that the timecode returned in this result may have properties that are different from the input timecode.
    ///   For this reason, you should accept the timecode returned from this method and not the timecode input into this
    ///   method.
    nonisolated public static func validate(
        pastedTimecode: Timecode,
        localTimecodeProperties: Timecode.Properties,
        pastePolicy: PastePolicy = .preserveLocalProperties,
        validationPolicy: ValidationPolicy = .enforceValid,
        inputStyle: InputStyle = .autoAdvance
    ) -> Timecode? {
        var pastedTimecode = pastedTimecode
        
        switch pastePolicy {
        case .preserveLocalProperties:
            // ensure that the newly pasted timecode is compatible with local properties.
            guard pastedTimecode.frameRate == localTimecodeProperties.frameRate
            else {
                return nil
            }
            
            switch validationPolicy {
            case .allowInvalid:
                // other properties (subframes base, upper limit) can be ignored at this stage.
                // just ensure Timecode instance has identical local properties.
                pastedTimecode.properties = localTimecodeProperties
            case .enforceValid:
                // ensure other properties (subframes base, upper limit) are compatible
                guard let transplantedTimecode = try? pastedTimecode.setting(.components(pastedTimecode.components))
                else {
                    return nil
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
            pastedTimecode.properties = localTimecodeProperties
        }
        
        return _validate(
            pastedTimecode: pastedTimecode,
            localTimecodeProperties: localTimecodeProperties,
            pastePolicy: pastePolicy,
            validationPolicy: validationPolicy,
            inputStyle: inputStyle
        )
    }
    
    // MARK: - Private Chaining Handler
    
    nonisolated private static func _validate(
        pastedTimecode: Timecode,
        localTimecodeProperties: Timecode.Properties,
        pastePolicy: PastePolicy,
        validationPolicy: ValidationPolicy,
        inputStyle: InputStyle
    ) -> Timecode? {
        // validate against validation policy
        switch validationPolicy {
        case .allowInvalid:
            break
        case .enforceValid:
            guard pastedTimecode.isValid else {
                return nil
            }
        }
        
        var timecodeProperties = localTimecodeProperties
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
                return nil
            }
        case .unbounded:
            break
        }
        
        return pastedTimecode
    }
    
    public enum PasteValidationResult: Equatable, Hashable, Sendable {
        /// The input timecode passed validation and is allowed to be pasted.
        ///
        /// > Note:
        /// >
        /// > The timecode may have mutated properties depending on which policies were applied, so when accepting the
        /// > pasted timecode, use the timecode instance contained within this enum case and not the input timecode
        /// > supplied to the ``TimecodeField/validate(pastedTimecode:localTimecodeProperties:pastePolicy:validationPolicy:inputStyle:)``
        /// > method.
        case allowed(_ newTimecode: Timecode)
        
        /// The pasted timecode failed validation based on the supplied policies.
        case rejected(
            _ rejectedUserAction: InputRejectionFeedback.UserAction
        )
    }
}
    
#endif
