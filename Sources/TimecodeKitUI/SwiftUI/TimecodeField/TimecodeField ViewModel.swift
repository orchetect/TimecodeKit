//
//  TimecodeField ViewModel.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(watchOS)

import SwiftUI
import TimecodeKitCore

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension TimecodeField {
    @Observable class ViewModel {
        /// Determines whether timecode pasted from the pasteboard by the user is appropriate to accept in the current
        /// field context.
        func validate(
            pasteResult: Result<Timecode, any Error>,
            inputStyle: TimecodeField.InputStyle,
            validationPolicy: TimecodeField.ValidationPolicy,
            currentTimecodeProperties: Timecode.Properties,
            pastePolicy: TimecodePastePolicy
        ) -> PasteValidationResult {
            do {
                let pastedTimecode = try pasteResult.get()
                
                // validate against validation policy
                switch validationPolicy {
                case .allowInvalid:
                    break
                case .enforceValid:
                    guard pastedTimecode.isValid else {
                        return .inputRejectionFeedback(.fieldPasteRejected)
                    }
                }
                
                // validate against input style
                switch inputStyle {
                case .autoAdvance, .continuousWithinComponent:
                    // ensure all timecode components as-is respect the max number of digits allowed for each
                    guard pastedTimecode.components.isWithinValidDigitCounts(
                        at: currentTimecodeProperties.frameRate,
                        base: currentTimecodeProperties.subFramesBase
                    )
                    else {
                        return .inputRejectionFeedback(.fieldPasteRejected)
                    }
                case .unbounded:
                    break
                }
                
                // TODO: handle additional case when configured to only paste values and not mutate timecode properties
                return .setTimecode(pastedTimecode)
            } catch {
                return .inputRejectionFeedback(.fieldPasteRejected)
            }
        }
        
        enum PasteValidationResult: Equatable, Hashable, Sendable {
            case setTimecode(_ newTimecode: Timecode)
            case inputRejectionFeedback(
                _ rejectedUserAction: TimecodeField.InputRejectionFeedback.UserAction
            )
        }
    }
}
    
#endif
