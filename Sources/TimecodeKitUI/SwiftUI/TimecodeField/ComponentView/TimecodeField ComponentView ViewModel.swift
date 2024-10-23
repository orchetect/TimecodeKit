//
//  TimecodeField ComponentView ViewModel.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(watchOS)

import SwiftUI
import TimecodeKitCore

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension TimecodeField.ComponentView {
    @Observable class ViewModel {
        let component: Timecode.Component
        
        var timecodeProperties: Timecode.Properties
        var frameRate: TimecodeFrameRate { timecodeProperties.frameRate }
        var subFramesBase: Timecode.SubFramesBase { timecodeProperties.subFramesBase }
        var upperLimit: Timecode.UpperLimit { timecodeProperties.upperLimit }
        
        init(
            component: Timecode.Component,
            initialTimecodeProperties timecodeProperties: Timecode.Properties
        ) {
            self.component = component
            self.timecodeProperties = timecodeProperties
        }
        
        func invisibleComponents(
            timecodeFormat: Timecode.StringFormat
        ) -> Set<Timecode.Component> {
            var invisibles: Set<Timecode.Component> = []
            if !timecodeFormat.contains(.alwaysShowDays) {
                if upperLimit == .max24Hours { invisibles.insert(.days) }
            }
            if !timecodeFormat.contains(.showSubFrames) { invisibles.insert(.subFrames) }
            return invisibles
        }
        
        func firstVisibleComponent(
            timecodeFormat: Timecode.StringFormat
        ) -> Timecode.Component {
            let invisibleComponents = invisibleComponents(
                timecodeFormat: timecodeFormat
            )
            return Timecode.Component.first(excluding: invisibleComponents)
        }
        
        func previousComponent(
            timecodeFormat: Timecode.StringFormat,
            wrap: TimecodeField.InputWrapping
        ) -> Timecode.Component {
            let invisibleComponents = invisibleComponents(
                timecodeFormat: timecodeFormat
            )
            let bool = wrap == .wrap
            let newComponent = component.previous(
                excluding: invisibleComponents,
                wrap: bool
            )
            return newComponent
        }
        
        func nextComponent(
            timecodeFormat: Timecode.StringFormat,
            wrap: TimecodeField.InputWrapping
        ) -> Timecode.Component {
            let invisibleComponents = invisibleComponents(
                timecodeFormat: timecodeFormat
            )
            let bool = wrap == .wrap
            let newComponent = component.next(
                excluding: invisibleComponents,
                wrap: bool
            )
            return newComponent
        }
        
        // MARK: Static Methods
        
        static func isDaysVisible(
            format: Timecode.StringFormat,
            limit: Timecode.UpperLimit
        ) -> Bool {
            limit == .max100Days || format.contains(.alwaysShowDays)
        }
        
        static func isSubFramesVisible(format: Timecode.StringFormat) -> Bool {
            format.contains(.showSubFrames)
        }
    }
}

#endif
