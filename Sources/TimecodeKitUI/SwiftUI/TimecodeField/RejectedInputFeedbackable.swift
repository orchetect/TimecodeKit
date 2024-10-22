//
//  RejectedInputFeedbackable.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(watchOS)

import SwiftUI
import TimecodeKitCore

@available(macOS 14.0, iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
protocol RejectedInputFeedbackable where Self: View {
    var timecodeFieldInputRejectionFeedback: TimecodeField.InputRejectionFeedback? { get }
    func perform(rejectionAnimation: TimecodeField.InputRejectionFeedback.RejectionAnimation)
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
@available(watchOS, unavailable)
extension RejectedInputFeedbackable {
    static var shakeAnimation: Animation {
        .spring(response: 0.2, dampingFraction: 0.2, blendDuration: 0.15)
    }
    
    static var pulseAnimation: Animation {
        .linear(duration: 0.08)
    }
    
    func inputRejectionFeedback(
        _ rejectedUserAction: TimecodeField.InputRejectionFeedback.UserAction
    ) {
        guard let timecodeFieldInputRejectionFeedback else { return }
        
        var rejectionAnimation: TimecodeField.InputRejectionFeedback.RejectionAnimation? = nil
        
        switch timecodeFieldInputRejectionFeedback {
        case let .validationBased(animation):
            rejectionAnimation = animation
        case let .validationBasedAndUndefinedKeys(animation):
            rejectionAnimation = animation
        case let .custom(action: closure):
            closure(rejectedUserAction)
            return
        }
        
        inputRejectionFeedback(rejectionAnimation: rejectionAnimation)
    }
    
    private func inputRejectionFeedback(
        rejectionAnimation: TimecodeField.InputRejectionFeedback.RejectionAnimation? = nil
    ) {
        beep()
        
        guard let rejectionAnimation else { return }
        
        perform(rejectionAnimation: rejectionAnimation)
    }
}
#endif
