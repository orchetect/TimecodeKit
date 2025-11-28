//
//  TimecodeField ComponentView StateModel.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(watchOS)

import SwiftUI
import SwiftTimecodeCore

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension TimecodeField.ComponentView {
    @Observable class StateModel: TimecodeField._StateModelProtocol {
        // injected properties
        let component: Timecode.Component
        
        var timecodeProperties: Timecode.Properties
        var frameRate: TimecodeFrameRate { timecodeProperties.frameRate }
        var subFramesBase: Timecode.SubFramesBase { timecodeProperties.subFramesBase }
        var upperLimit: Timecode.UpperLimit { timecodeProperties.upperLimit }
        
        // state
        var value: Int
        
        // internal state
        @ObservationIgnored var textInput: String = ""
        var isVirgin: Bool = true
        
        init(
            component: Timecode.Component,
            initialRate rate: TimecodeFrameRate,
            initialBase base: Timecode.SubFramesBase,
            initialLimit limit: Timecode.UpperLimit,
            initialValue value: Int
        ) {
            self.component = component
            
            timecodeProperties = Timecode.Properties(
                rate: rate,
                base: base,
                limit: limit
            )
            
            self.value = value
        }
        
        init(
            component: Timecode.Component,
            initialTimecodeProperties timecodeProperties: Timecode.Properties,
            initialValue value: Int
        ) {
            self.component = component
            self.timecodeProperties = timecodeProperties
            self.value = value
        }
    }
}

#endif
