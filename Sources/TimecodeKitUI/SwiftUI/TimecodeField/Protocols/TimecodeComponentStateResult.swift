//
//  TimecodeComponentStateResult.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(watchOS)

import SwiftUI
import TimecodeKitCore

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
struct TimecodeComponentStateResult: Equatable, Hashable, Sendable {
    let result: Result
    let updateFocus: FocusResult?
    let errorFeedback: Bool
    
    init(
        _ result: Result,
        _ updateFocus: FocusResult? = nil,
        errorFeedback: Bool = false
    ) {
        self.result = result
        self.errorFeedback = errorFeedback
        self.updateFocus = updateFocus
    }
    
    enum Result: String, Sendable, CaseIterable {
        case handled
        case ignored
        case performEscapeAction // defer to action handler's KeyPress.Result return value
        case performReturnAction // defer to action handler's KeyPress.Result return value
        
        init(_ keyPressResult: KeyPress.Result) {
            switch keyPressResult {
            case .handled:
                self = .handled
            case .ignored:
                self = .ignored
            @unknown default:
                assertionFailure("Unhandled KeyPress.Result: \(keyPressResult)")
                self = .handled
            }
        }
    }
    
    enum FocusResult: String, Equatable, Hashable, Sendable, CaseIterable {
        case focusPreviousComponent
        case focusNextComponent
    }
}

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension TimecodeComponentStateResult: CustomStringConvertible {
    var description: String {
        var str = "<\(result)"
        if let updateFocus {
            str += " \(updateFocus)"
        }
        if errorFeedback {
            str += " errorFeedback"
        }
        str += ">"
        return str
    }
}

#endif
