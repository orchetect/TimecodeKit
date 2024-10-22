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
    var timecodeFieldRejectedInputFeedback: TimecodeField.RejectedInputFeedback? { get }
    func shake()
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
@available(watchOS, unavailable)
extension RejectedInputFeedbackable {
    func rejectedInputFeedback(
        _ rejectedUserAction: TimecodeField.RejectedInputFeedback.UserAction
    ) {
        guard let timecodeFieldRejectedInputFeedback else { return }
        
        var shouldAnimate = false
        
        switch timecodeFieldRejectedInputFeedback {
        case let .validationBased(animation: isAnimated):
            shouldAnimate = isAnimated
        case let .validationBasedAndUndefinedKeys(animation: isAnimated):
            shouldAnimate = isAnimated
        case let .custom(action: closure):
            closure(rejectedUserAction)
            return
        }
        
        performErrorFeedback(shouldAnimate: shouldAnimate)
    }
    
    private func performErrorFeedback(shouldAnimate: Bool? = nil) {
        beep()
        
        guard shouldAnimate ?? (timecodeFieldRejectedInputFeedback?.isAnimated ?? false)
        else { return }
        
        shake()
    }
}
#endif
