//
//  TimecodeField ComponentView ComponentState.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(watchOS)

import SwiftUI
import TimecodeKitCore

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension TimecodeField.ComponentView {
    @Observable class ComponentState: _TimecodeComponentStateProtocol {
        // injected properties
        let component: Timecode.Component
        let frameRate: TimecodeFrameRate
        let subFramesBase: Timecode.SubFramesBase
        let upperLimit: Timecode.UpperLimit
        
        // state
        var value: Int
        
        // internal state
        @ObservationIgnored var textInput: String = ""
        var isVirgin: Bool = true
        
        init(
            component: Timecode.Component,
            frameRate: TimecodeFrameRate,
            subFramesBase: Timecode.SubFramesBase,
            upperLimit: Timecode.UpperLimit,
            initialValue value: Int
        ) {
            self.component = component
            self.frameRate = frameRate
            self.subFramesBase = subFramesBase
            self.upperLimit = upperLimit
            self.value = value
        }
    }
}

#endif
