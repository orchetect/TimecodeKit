//
//  TimecodeField.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && (os(macOS) || os(iOS) || os(visionOS))

import SwiftUI
import TimecodeKit

@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
public struct TimecodeField: View {
    // MARK: - Properties settable through view initializers
    
    @Binding private var components: Timecode.Components
    @Binding private var frameRate: TimecodeFrameRate
    @Binding private var subFramesBase: Timecode.SubFramesBase
    @Binding private var upperLimit: Timecode.UpperLimit
    @Binding private var timecode: Timecode
    
    // MARK: - Properties settable through custom view modifiers
    
    @Environment(\.timecodeFormat) private var timecodeFormat: Timecode.StringFormat
    @Environment(\.timecodeHighlightStyle) private var timecodeHighlightStyle: Color?
    @Environment(\.timecodeSeparatorStyle) private var timecodeSeparatorStyle: Color?
    @Environment(\.timecodeValidationStyle) private var timecodeValidationStyle: Color?
    
    // MARK: - Internal State
    
    @FocusState private var componentEditing: Timecode.Component?
    
    // MARK: - Init from Components and Properties
    
    public init(
        components: Binding<Timecode.Components>
    ) {
        let defaultTimecode = Timecode(.zero, at: .fps24) // TODO: use a different default frame rate?
        self.init(
            components: components,
            using: defaultTimecode.properties
        )
    }
    
    public init(
        components: Binding<Timecode.Components>,
        at frameRate: TimecodeFrameRate,
        base: Timecode.SubFramesBase,
        limit: Timecode.UpperLimit
    ) {
        let properties = Timecode.Properties(rate: frameRate, base: base, limit: limit)
        self.init(components: components, using: properties)
    }
    
    public init(
        components: Binding<Timecode.Components>,
        using properties: Timecode.Properties
    ) {
        _components = components
        _frameRate = .constant(properties.frameRate)
        _subFramesBase = .constant(properties.subFramesBase)
        _upperLimit = .constant(properties.upperLimit)
        
        // need to set this first or compiler complains about accessing self before initialization
        _timecode = .constant(Timecode(.zero, using: properties)) // unused
        _timecode = timecodeBinding() // unused
    }
    
    // MARK: - Init from Timecode struct
    
    public init(
        timecode: Binding<Timecode>
    ) {
        _timecode = timecode
        // need to set this first or compiler complains about accessing self before initialization
        _components = .constant(.zero) // will be changed to a binding
        _frameRate = .constant(.fps24) // will be changed to a binding
        _subFramesBase = .constant(.max100SubFrames) // will be changed to a binding
        _upperLimit = .constant(.max24Hours) // will be changed to a binding
        
        _components = componentsBinding()
        _frameRate = frameRateBinding()
        _subFramesBase = subFramesBaseBinding()
        _upperLimit = upperLimitBinding()
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
                        componentEditing: _componentEditing,
                        value: $components.days
                    )
                    Text(daysSeparator)
                        .conditionalForegroundStyle(timecodeValidationStyle)
                }
                
                TimecodeField.ComponentView(
                    component: .hours,
                    frameRate: frameRate,
                    subFramesBase: subFramesBase,
                    upperLimit: upperLimit,
                    componentEditing: _componentEditing,
                    value: $components.hours
                )
                
                Text(mainSeparator)
                    .conditionalForegroundStyle(timecodeValidationStyle)
                
                TimecodeField.ComponentView(
                    component: .minutes,
                    frameRate: frameRate,
                    subFramesBase: subFramesBase,
                    upperLimit: upperLimit,
                    componentEditing: _componentEditing,
                    value: $components.minutes
                )
                
                Text(mainSeparator)
                    .conditionalForegroundStyle(timecodeValidationStyle)
                
                TimecodeField.ComponentView(
                    component: .seconds,
                    frameRate: frameRate,
                    subFramesBase: subFramesBase,
                    upperLimit: upperLimit,
                    componentEditing: _componentEditing,
                    value: $components.seconds
                )
                
                Text(framesSeparator)
                    .conditionalForegroundStyle(timecodeValidationStyle)
                
                TimecodeField.ComponentView(
                    component: .frames,
                    frameRate: frameRate,
                    subFramesBase: subFramesBase,
                    upperLimit: upperLimit,
                    componentEditing: _componentEditing,
                    value: $components.frames
                )
                
                if timecodeFormat.contains(.showSubFrames) {
                    Text(subFramesSeparator)
                        .conditionalForegroundStyle(timecodeValidationStyle)
                    
                    TimecodeField.ComponentView(
                        component: .subFrames,
                        frameRate: frameRate,
                        subFramesBase: subFramesBase,
                        upperLimit: upperLimit,
                        componentEditing: _componentEditing,
                        value: $components.subFrames
                    )
                }
            }
        }
        .monospacedDigit()
        .fixedSize()
        .animation(nil)
        
        // sync components to/from `timecode` binding.
        .onChange(of: components) { oldValue, newValue in
            if timecode.components != components {
                timecode.components = components
            }
        }
        .onChange(of: timecode.components) { oldValue, newValue in
            if components != timecode.components {
                components = timecode.components
            }
        }
        // sync timecode properties
        .onChange(of: timecode.properties) { oldValue, newValue in
            if frameRate != timecode.properties.frameRate { frameRate = timecode.properties.frameRate }
            if subFramesBase != timecode.properties.subFramesBase { subFramesBase = timecode.properties.subFramesBase }
            if upperLimit != timecode.properties.upperLimit { upperLimit = timecode.properties.upperLimit }
        }
        .onChange(of: frameRate) { oldValue, newValue in
            if timecode.frameRate != frameRate { timecode.frameRate = frameRate }
        }
        .onChange(of: subFramesBase) { oldValue, newValue in
            if timecode.subFramesBase != subFramesBase { timecode.subFramesBase = subFramesBase }
        }
        .onChange(of: upperLimit) { oldValue, newValue in
            if timecode.upperLimit != upperLimit { timecode.upperLimit = upperLimit }
        }
    }
    
    // MARK: - Timecode Separators
    
    private var daysSeparator: String { " " }
    private var mainSeparator: String { ":" }
    private var framesSeparator: String { frameRate.isDrop ? ";" : ":" }
    private var subFramesSeparator: String { "." }
    
    // MARK: - Sync Bindings
    
    private func timecodeBinding() -> Binding<Timecode> {
        Binding {
            let properties = Timecode.Properties(
                rate: self.frameRate,
                base: self.subFramesBase,
                limit: self.upperLimit
            )
            return Timecode(.components(components), using: properties, by: .allowingInvalid)
        } set: { newValue in
            if components != newValue.components {
                components = newValue.components
            }
            if frameRate != newValue.frameRate { frameRate = newValue.frameRate }
            if subFramesBase != newValue.subFramesBase { subFramesBase = newValue.subFramesBase }
            if upperLimit != newValue.upperLimit { upperLimit = newValue.upperLimit }
        }
    }
    
    private func componentsBinding() -> Binding<Timecode.Components> {
        Binding {
            timecode.components
        } set: { newValue in
            timecode.components = newValue
        }
    }
    
    private func frameRateBinding() -> Binding<TimecodeFrameRate> {
        Binding {
            timecode.frameRate
        } set: { newValue in
            timecode.frameRate = newValue
        }
    }
    
    private func subFramesBaseBinding() -> Binding<Timecode.SubFramesBase> {
        Binding {
            timecode.subFramesBase
        } set: { newValue in
            timecode.subFramesBase = newValue
        }
    }
    
    private func upperLimitBinding() -> Binding<Timecode.UpperLimit> {
        Binding {
            timecode.upperLimit
        } set: { newValue in
            timecode.upperLimit = newValue
        }
    }
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
        TimecodeField(components: $components)
            .timecodeFormat([.showSubFrames])
        TimecodeField(
            components: $components,
            at: properties.frameRate,
            base: properties.subFramesBase,
            limit: properties.upperLimit
        )
        .timecodeFormat([])
    }
    .padding()
    .font(.largeTitle)
    .frame(width: 400)
    .onAppear {
        components = Timecode(.randomComponents, using: properties).components
    }
}

@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
#Preview("HH:MM:SS:FF:SF") {
    @Previewable let properties = Timecode.Properties(rate: .fps24, limit: .max24Hours)
    @Previewable @State var components: Timecode.Components = .zero
    
    VStack(alignment: .trailing) {
        TimecodeField(components: $components)
        TimecodeField(
            components: $components,
            at: properties.frameRate,
            base: properties.subFramesBase,
            limit: properties.upperLimit
        )
    }
    .padding()
    .font(.largeTitle)
    .timecodeFormat([.showSubFrames])
    .frame(width: 400)
    .onAppear {
        components = Timecode(.randomComponents, using: properties).components
    }
}

@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
#Preview("DD HH:MM:SS:FF") {
    @Previewable let properties = Timecode.Properties(rate: .fps24, limit: .max100Days)
    @Previewable @State var components: Timecode.Components = .zero
    
    VStack(alignment: .trailing) {
        TimecodeField(components: $components)
        TimecodeField(
            components: $components,
            at: properties.frameRate,
            base: properties.subFramesBase,
            limit: properties.upperLimit
        )
    }
    .padding()
    .font(.largeTitle)
    .timecodeFormat([])
    .frame(width: 400)
    .onAppear {
        components = Timecode(.randomComponents, using: properties).components
    }
}

@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
#Preview("DD HH:MM:SS:FF:SF") {
    @Previewable let properties = Timecode.Properties(rate: .fps24, limit: .max100Days)
    @Previewable @State var components: Timecode.Components = .zero
    
    VStack(alignment: .trailing) {
        TimecodeField(components: $components)
        TimecodeField(
            components: $components,
            at: properties.frameRate,
            base: properties.subFramesBase,
            limit: properties.upperLimit
        )
    }
    .padding()
    .font(.largeTitle)
    .timecodeFormat([.showSubFrames])
    .frame(width: 400)
    .onAppear {
        components = Timecode(.randomComponents, using: properties).components
    }
}

@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
#Preview("Disabled") {
    @Previewable let properties = Timecode.Properties(rate: .fps24, limit: .max100Days)
    @Previewable @State var components: Timecode.Components = .zero
    
    VStack(alignment: .trailing) {
        TimecodeField(components: $components)
        TimecodeField(
            components: $components,
            at: properties.frameRate,
            base: properties.subFramesBase,
            limit: properties.upperLimit
        )
    }
    .padding()
    .disabled(true)
    .font(.largeTitle)
    .timecodeFormat([.showSubFrames])
    .frame(width: 400)
    .onAppear {
        components = Timecode(.randomComponents, using: properties).components
    }
}

@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
#Preview("Custom Styling") {
    @Previewable let properties = Timecode.Properties(rate: .fps24, limit: .max100Days)
    @Previewable @State var components: Timecode.Components = .zero
    
    VStack(alignment: .trailing) {
        TimecodeField(components: $components)
            .timecodeSeparatorStyle(.green)
            .timecodeValidationStyle(.red)
            .timecodeHighlightStyle(.purple)
            .foregroundStyle(.orange)
        TimecodeField(
            components: $components,
            at: properties.frameRate,
            base: properties.subFramesBase,
            limit: properties.upperLimit
        )
        .timecodeSeparatorStyle(.gray)
        .timecodeValidationStyle(.purple)
        .timecodeHighlightStyle(.white)
        .foregroundStyle(.blue)
    }
    .padding()
    .font(.largeTitle)
    .timecodeFormat([.showSubFrames])
    .frame(width: 400)
    .onAppear {
        components = Timecode(.randomComponents, using: properties).components
    }
}

@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
#Preview("Custom Styling Disabled") {
    @Previewable let properties = Timecode.Properties(rate: .fps24, limit: .max100Days)
    @Previewable @State var components: Timecode.Components = .zero
    
    VStack(alignment: .trailing) {
        TimecodeField(components: $components)
            .timecodeSeparatorStyle(.green)
            .timecodeValidationStyle(.red)
            .timecodeHighlightStyle(.purple)
            .foregroundStyle(.orange)
        TimecodeField(
            components: $components,
            at: properties.frameRate,
            base: properties.subFramesBase,
            limit: properties.upperLimit
        )
        .timecodeSeparatorStyle(.gray)
        .timecodeValidationStyle(.purple)
        .timecodeHighlightStyle(.white)
        .foregroundStyle(.blue)
    }
    .padding()
    .disabled(true)
    .font(.largeTitle)
    .timecodeFormat([.showSubFrames])
    .frame(width: 400)
    .onAppear {
        components = Timecode(.randomComponents, using: properties).components
    }
}

@available(macOS 14, iOS 17, watchOS 10.0, *)
#Preview("No Validation") {
    @Previewable let properties = Timecode.Properties(rate: .fps24, limit: .max100Days)
    @Previewable @State var components: Timecode.Components = .zero
    
    VStack(alignment: .trailing) {
        TimecodeField(components: $components)
        TimecodeField(
            components: $components,
            at: properties.frameRate,
            base: properties.subFramesBase,
            limit: properties.upperLimit
        )
        .foregroundStyle(.blue)
    }
    .padding()
    .font(.largeTitle)
    .timecodeFormat([.showSubFrames])
    .timecodeValidationStyle(nil)
    .frame(width: 400)
    .onAppear {
        components = Timecode(.randomComponents, using: properties).components
    }
}

@available(macOS 14, iOS 17, watchOS 10.0, *)
#Preview("Timecode Binding") {
    @Previewable @TimecodeState var timecode: Timecode = Timecode(
        .components(d: 02, h: 04, m: 20, s: 30, f: 25, sf: 82),
        using: Timecode.Properties(
            rate: .fps24,
            base: .max100SubFrames,
            limit: .max100Days
        ),
        by: .allowingInvalid
    )
    @Previewable @State var tcFormat: Timecode.StringFormat = [.showSubFrames]
    
    VStack(alignment: .trailing) {
        Group {
            TimecodeField(timecode: $timecode)
            TimecodeField(
                components: $timecode.components,
                at: timecode.frameRate,
                base: timecode.subFramesBase,
                limit: timecode.upperLimit
            )
            Text(timecode: timecode, format: tcFormat)
        }
        .font(.largeTitle)
        .timecodeFormat(tcFormat)
        .timecodeValidationStyle(.red)
        
        Grid {
            GridRow {
                Text("Frame Rate").gridColumnAlignment(.trailing)
                Button("24") { timecode.frameRate = .fps24 }
                Button("30") { timecode.frameRate = .fps30 }
            }
            GridRow {
                Text("SubFrames Base")
                Button("80") { timecode.subFramesBase = .max80SubFrames }
                Button("100") { timecode.subFramesBase = .max100SubFrames }
            }
            GridRow {
                Text("Upper Limit")
                Button("24 Hours") { timecode.upperLimit = .max24Hours }
                Button("100 Days") { timecode.upperLimit = .max100Days }
            }
            GridRow {
                Text("Components")
                Button("Randomize") { timecode.components = .random(using: timecode.properties) }
            }
            GridRow {
                Text("Show SubFrames")
                Toggle("Show SubFrames", isOn: $tcFormat.option(.showSubFrames))
                .labelsHidden()
            }
        }
    }
    .padding()
    .frame(width: 400)
}

#endif

#endif
