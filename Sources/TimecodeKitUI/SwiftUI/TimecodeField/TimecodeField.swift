//
//  TimecodeField.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && (os(macOS) || os(iOS))

import SwiftUI
import TimecodeKit

@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
public struct TimecodeField: View {
    // MARK: - Properties settable through view initializers
    
    @Binding private var components: Timecode.Components
    private var frameRate: TimecodeFrameRate
    private var subFramesBase: Timecode.SubFramesBase
    private var upperLimit: Timecode.UpperLimit
    private var showSubFrames: Bool
    
    // MARK: - Properties settable through custom view modifiers
    
    var highlightColor: Color = .accentColor
    var separatorColor: Color?
    var invalidComponentColor: Color?
    
    // MARK: - Internal properties
    
    @FocusState private var componentEditing: Timecode.Component?
    
    // MARK: - Init
    
    public init(
        components: Binding<Timecode.Components>,
        showSubFrames: Bool = false
    ) {
        _components = components
        
        let defaultTimecode = Timecode(.zero, at: .fps24)
        frameRate = defaultTimecode.frameRate
        subFramesBase = defaultTimecode.subFramesBase
        upperLimit = defaultTimecode.upperLimit
        self.showSubFrames = showSubFrames
    }
    
    public init(
        components: Binding<Timecode.Components>,
        frameRate: TimecodeFrameRate,
        subFramesBase: Timecode.SubFramesBase,
        upperLimit: Timecode.UpperLimit,
        showSubFrames: Bool = false
    ) {
        _components = components
        self.frameRate = frameRate
        self.subFramesBase = subFramesBase
        self.upperLimit = upperLimit
        self.showSubFrames = showSubFrames
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(alignment: .trailing) {
            HStack(spacing: 0) {
                if upperLimit == .max100Days {
                    TimecodeField.ComponentView(
                        component: .days,
                        frameRate: frameRate,
                        subFramesBase: subFramesBase,
                        upperLimit: upperLimit,
                        showSubFrames: showSubFrames,
                        highlightColor: highlightColor,
                        invalidComponentColor: invalidComponentColor,
                        componentEditing: _componentEditing,
                        value: $components.days
                    )
                    Text(daysSeparator)
                        .conditionalForegroundStyle(separatorColor)
                }
                
                TimecodeField.ComponentView(
                    component: .hours,
                    frameRate: frameRate,
                    subFramesBase: subFramesBase,
                    upperLimit: upperLimit,
                    showSubFrames: showSubFrames,
                    highlightColor: highlightColor,
                    invalidComponentColor: invalidComponentColor,
                    componentEditing: _componentEditing,
                    value: $components.hours
                )
                
                Text(mainSeparator)
                    .conditionalForegroundStyle(separatorColor)
                
                TimecodeField.ComponentView(
                    component: .minutes,
                    frameRate: frameRate,
                    subFramesBase: subFramesBase,
                    upperLimit: upperLimit,
                    showSubFrames: showSubFrames,
                    highlightColor: highlightColor,
                    invalidComponentColor: invalidComponentColor,
                    componentEditing: _componentEditing,
                    value: $components.minutes
                )
                
                Text(mainSeparator)
                    .conditionalForegroundStyle(separatorColor)
                
                TimecodeField.ComponentView(
                    component: .seconds,
                    frameRate: frameRate,
                    subFramesBase: subFramesBase,
                    upperLimit: upperLimit,
                    showSubFrames: showSubFrames,
                    highlightColor: highlightColor,
                    invalidComponentColor: invalidComponentColor,
                    componentEditing: _componentEditing,
                    value: $components.seconds
                )
                
                Text(framesSeparator)
                    .conditionalForegroundStyle(separatorColor)
                
                TimecodeField.ComponentView(
                    component: .frames,
                    frameRate: frameRate,
                    subFramesBase: subFramesBase,
                    upperLimit: upperLimit,
                    showSubFrames: showSubFrames,
                    highlightColor: highlightColor,
                    invalidComponentColor: invalidComponentColor,
                    componentEditing: _componentEditing,
                    value: $components.frames
                )
                
                if showSubFrames {
                    Text(subFramesSeparator)
                        .conditionalForegroundStyle(separatorColor)
                    
                    TimecodeField.ComponentView(
                        component: .subFrames,
                        frameRate: frameRate,
                        subFramesBase: subFramesBase,
                        upperLimit: upperLimit,
                        showSubFrames: showSubFrames,
                        highlightColor: highlightColor,
                        invalidComponentColor: invalidComponentColor,
                        componentEditing: _componentEditing,
                        value: $components.subFrames
                    )
                }
            }
        }
        .monospacedDigit()
        .fixedSize()
        .animation(nil)
    }
    
    // MARK: - Timecode Separators
    
    private var daysSeparator: String { " " }
    private var mainSeparator: String { ":" }
    private var framesSeparator: String { frameRate.isDrop ? ";" : ":" }
    private var subFramesSeparator: String { "." }
}

// MARK: - Previews

#if DEBUG

@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
#Preview("HH:MM:SS:FF") {
    @Previewable let properties = Timecode.Properties(rate: .fps24)
    @Previewable @State var components: Timecode.Components = .zero
    
    VStack(alignment: .trailing) {
        TimecodeField(components: $components, showSubFrames: false)
        TimecodeField(
            components: $components,
            frameRate: properties.frameRate,
            subFramesBase: properties.subFramesBase,
            upperLimit: properties.upperLimit,
            showSubFrames: false
        )
    }
    .padding()
    .font(.largeTitle)
    .frame(width: 400)
    .onAppear {
        components = Timecode(.random, using: properties).components
    }
}

@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
#Preview("HH:MM:SS:FF:SF") {
    @Previewable let properties = Timecode.Properties(rate: .fps24, limit: .max24Hours)
    @Previewable @State var components: Timecode.Components = .zero
    
    VStack(alignment: .trailing) {
        TimecodeField(components: $components, showSubFrames: true)
        TimecodeField(
            components: $components,
            frameRate: properties.frameRate,
            subFramesBase: properties.subFramesBase,
            upperLimit: properties.upperLimit,
            showSubFrames: true
        )
    }
    .padding()
    .font(.largeTitle)
    .frame(width: 400)
    .onAppear {
        components = Timecode(.random, using: properties).components
    }
}

@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
#Preview("DD HH:MM:SS:FF") {
    @Previewable let properties = Timecode.Properties(rate: .fps24, limit: .max100Days)
    @Previewable @State var components: Timecode.Components = .zero
    
    VStack(alignment: .trailing) {
        TimecodeField(components: $components, showSubFrames: false)
        TimecodeField(
            components: $components,
            frameRate: properties.frameRate,
            subFramesBase: properties.subFramesBase,
            upperLimit: properties.upperLimit,
            showSubFrames: false
        )
    }
    .padding()
    .font(.largeTitle)
    .frame(width: 400)
    .onAppear {
        components = Timecode(.random, using: properties).components
    }
}

@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
#Preview("DD HH:MM:SS:FF:SF") {
    @Previewable let properties = Timecode.Properties(rate: .fps24, limit: .max100Days)
    @Previewable @State var components: Timecode.Components = .zero
    
    VStack(alignment: .trailing) {
        TimecodeField(components: $components, showSubFrames: true)
        TimecodeField(
            components: $components,
            frameRate: properties.frameRate,
            subFramesBase: properties.subFramesBase,
            upperLimit: properties.upperLimit,
            showSubFrames: true
        )
    }
    .padding()
    .font(.largeTitle)
    .frame(width: 400)
    .onAppear {
        components = Timecode(.random, using: properties).components
    }
}

@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
#Preview("Disabled") {
    @Previewable let properties = Timecode.Properties(rate: .fps24, limit: .max100Days)
    @Previewable @State var components: Timecode.Components = .zero
    
    VStack(alignment: .trailing) {
        TimecodeField(components: $components, showSubFrames: true)
        TimecodeField(
            components: $components,
            frameRate: properties.frameRate,
            subFramesBase: properties.subFramesBase,
            upperLimit: properties.upperLimit,
            showSubFrames: true
        )
    }
    .disabled(true)
    .padding()
    .font(.largeTitle)
    .frame(width: 400)
    .onAppear {
        components = Timecode(.random, using: properties).components
    }
}

@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
#Preview("Custom Styling") {
    @Previewable let properties = Timecode.Properties(rate: .fps24, limit: .max100Days)
    @Previewable @State var components: Timecode.Components = .zero
    
    VStack(alignment: .trailing) {
        TimecodeField(components: $components, showSubFrames: true)
            .timecodeFieldSeparatorStyle(.green)
            .timecodeFieldValidationStyle(.red)
            .timecodeFieldHighlightStyle(.purple)
            .foregroundStyle(.orange)
        TimecodeField(
            components: $components,
            frameRate: properties.frameRate,
            subFramesBase: properties.subFramesBase,
            upperLimit: properties.upperLimit,
            showSubFrames: true
        )
        .timecodeFieldSeparatorStyle(.gray)
        .timecodeFieldValidationStyle(.purple)
        .timecodeFieldHighlightStyle(.white)
        .foregroundStyle(.blue)
    }
    .padding()
    .font(.largeTitle)
    .frame(width: 400)
    .onAppear {
        components = Timecode(.random, using: properties).components
    }
}

@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
#Preview("Custom Styling Disabled") {
    @Previewable let properties = Timecode.Properties(rate: .fps24, limit: .max100Days)
    @Previewable @State var components: Timecode.Components = .zero
    
    VStack(alignment: .trailing) {
        TimecodeField(components: $components, showSubFrames: true)
            .timecodeFieldSeparatorStyle(.green)
            .timecodeFieldValidationStyle(.red)
            .timecodeFieldHighlightStyle(.purple)
            .foregroundStyle(.orange)
        TimecodeField(
            components: $components,
            frameRate: properties.frameRate,
            subFramesBase: properties.subFramesBase,
            upperLimit: properties.upperLimit,
            showSubFrames: true
        )
        .timecodeFieldSeparatorStyle(.gray)
        .timecodeFieldValidationStyle(.purple)
        .timecodeFieldHighlightStyle(.white)
        .foregroundStyle(.blue)
    }
    .disabled(true)
    .padding()
    .font(.largeTitle)
    .frame(width: 400)
    .onAppear {
        components = Timecode(.random, using: properties).components
    }
}

@available(macOS 14, iOS 17, watchOS 10.0, *)
#Preview("No Validation") {
    @Previewable let properties = Timecode.Properties(rate: .fps24, limit: .max100Days)
    @Previewable @State var components: Timecode.Components = .zero
    
    VStack(alignment: .trailing) {
        TimecodeField(components: $components, showSubFrames: true)
            .timecodeFieldValidationStyle(nil)
        TimecodeField(
            components: $components,
            frameRate: properties.frameRate,
            subFramesBase: properties.subFramesBase,
            upperLimit: properties.upperLimit,
            showSubFrames: true
        )
        .timecodeFieldValidationStyle(nil)
        .foregroundStyle(.blue)
    }
    .padding()
    .font(.largeTitle)
    .frame(width: 400)
    .onAppear {
        components = Timecode(.random, using: properties).components
    }
}

#endif

#endif
