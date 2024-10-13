//
//  TimecodeField.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && (os(macOS) || os(iOS) || os(visionOS))

import SwiftUI
import TimecodeKit

/// A hybrid text field designed for timecode entry, allowing specialized format and style view modifiers
/// including the ability to colorize invalid timecode components.
///
/// ## Initializers
///
/// The view may be initialized to a `Timecode` instance directly. In this case, it is required to store the
/// `Timecode` instance in the view using the custom ``TimecodeState`` wrapper in place of the typical SwiftUI
/// `@State` wrapper.
///
/// It may then be passed into subviews using normal SwiftUI Bindings.
///
/// ```swift
/// struct ContentView: View {
///     @TimecodeState private var timecode: Timecode = // ...
///
///     var body: some View {
///         TimecodeField(timecode: $timecode)
///         MySubView(timecode: $timecode)
///     }
/// }
///
/// struct MySubView: View {
///     @Binding var timecode: Timecode
/// }
/// ```
///
/// For more granular flexibility, timecode components and properties may be bound as individual properties.
///
/// ```swift
/// @State private var components: Timecode.Components = .zero
/// @State private var frameRate: TimecodeFrameRate = .fps24
///
/// var body: some View {
///     TimecodeField(components: $components, at: frameRate)
/// }
/// ```
///
/// ## Style and Format Modifiers
///
/// You can supply format and style options by using the available view modifiers.
///
/// ```swift
/// TimecodeField(timecode: $timecode)
///     .foregroundColor(.primary)
///     .timecodeFormat([.showSubFrames])
///     .timecodeHighlightStyle(.accentColor)
///     .timecodeSeparatorStyle(.secondary)
///     .timecodeValidationStyle(.red)
/// ```
///
/// ## Focus
///
/// Each timecode component individually receives focus one at a time.
///
/// - On macOS and iOS, the user can click or tap on specific timecode components to move the focus.
/// - On macOS and iOS, a hardware keyboard accepts:
///   - left and right arrow keys to move the focus between timecode components
///   - tab key to advance to the next timecode component
///   - inputting a timecode separator (`.`, `:`) will advance the focus to the next timecode component
/// - On iOS, in the absence of a hardware keyboard, the standard decimal pad keyboard will appear on-screen.
///
/// ## Hardware Keyboard Input
///
/// The view is capable of receiving hardware keyboard input on macOS and iOS, as well as iOS on-screen keyboard input.
///
/// | Key | Description |
/// | --- | --- |
/// | Numeric digit keys | Enters digits for the currently focused timecode component. |
/// | `Return` or `Escape` | Can be used to remove focus from the field. |
/// | `Backspace` | Resets the timecode component to zero if it has freshly received focus. Once the user begins to enter digits into the component, the Backspace key will function as single digit delete akin to a text-entry field.
/// | `Delete` (`Del` key, or `forwardDelete`) | Resets the component to zero. |
///
/// For keys that navigate timecode component focus, see the Focus section above.
@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
public struct TimecodeField: View {
    // MARK: - Standard Environment
    
    @Environment(\.isEnabled) private var isEnabled
    
    // MARK: - Properties settable through view initializers
    
    @Binding private var components: Timecode.Components
    @Binding private var frameRate: TimecodeFrameRate
    @Binding private var subFramesBase: Timecode.SubFramesBase
    @Binding private var upperLimit: Timecode.UpperLimit
    @Binding private var timecode: Timecode
    
    // MARK: - Properties settable through custom view modifiers
    
    @Environment(\.timecodeFormat) private var timecodeFormat: Timecode.StringFormat
    @Environment(\.timecodeFieldHighlightStyle) private var timecodeHighlightStyle: Color?
    @Environment(\.timecodeSeparatorStyle) private var timecodeSeparatorStyle: Color?
    @Environment(\.timecodeValidationStyle) private var timecodeValidationStyle: Color?
    
    // MARK: - Internal State
    
    @FocusState private var componentEditing: Timecode.Component?
    
    // MARK: - Init from Components and Properties
    
    public init(
        components: Binding<Timecode.Components>
    ) {
        self.init(
            components: components,
            using: Timecode.Properties(rate: .fps24) // TODO: use a different default frame rate?
        )
    }
    
    public init(
        components: Binding<Timecode.Components>,
        at frameRate: TimecodeFrameRate,
        base: Timecode.SubFramesBase = .default(),
        limit: Timecode.UpperLimit = .max24Hours
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
            #if os(macOS)
            timecodeBody
            #else
            timecodeBody
                .keyboardType(.decimalPad)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            #endif
        }
        .monospacedDigit()
        .fixedSize()
        .compositingGroup()
        
        // update focus if view is disabled
        .onChange(of: isEnabled, initial: false) { oldValue, newValue in
            if !isEnabled {
                componentEditing = nil
            }
        }
        
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
    public var timecodeBody: some View {
        HStack(spacing: 0) {
            if upperLimit == .max100Days {
                TimecodeField.ComponentView(
                    component: .days,
                    frameRate: frameRate,
                    subFramesBase: subFramesBase,
                    upperLimit: upperLimit,
                    componentEditing: $componentEditing,
                    value: $components.days
                )
                Text(daysSeparator)
                    .conditionalForegroundStyle(timecodeSeparatorStyle)
            }
            
            TimecodeField.ComponentView(
                component: .hours,
                frameRate: frameRate,
                subFramesBase: subFramesBase,
                upperLimit: upperLimit,
                componentEditing: $componentEditing,
                value: $components.hours
            )
            
            Text(mainSeparator)
                .conditionalForegroundStyle(timecodeSeparatorStyle)
            
            TimecodeField.ComponentView(
                component: .minutes,
                frameRate: frameRate,
                subFramesBase: subFramesBase,
                upperLimit: upperLimit,
                componentEditing: $componentEditing,
                value: $components.minutes
            )
            
            Text(mainSeparator)
                .conditionalForegroundStyle(timecodeSeparatorStyle)
            
            TimecodeField.ComponentView(
                component: .seconds,
                frameRate: frameRate,
                subFramesBase: subFramesBase,
                upperLimit: upperLimit,
                componentEditing: $componentEditing,
                value: $components.seconds
            )
            
            Text(framesSeparator)
                .conditionalForegroundStyle(timecodeSeparatorStyle)
            
            TimecodeField.ComponentView(
                component: .frames,
                frameRate: frameRate,
                subFramesBase: subFramesBase,
                upperLimit: upperLimit,
                componentEditing: $componentEditing,
                value: $components.frames
            )
            
            if timecodeFormat.contains(.showSubFrames) {
                Text(subFramesSeparator)
                    .conditionalForegroundStyle(timecodeSeparatorStyle)
                
                TimecodeField.ComponentView(
                    component: .subFrames,
                    frameRate: frameRate,
                    subFramesBase: subFramesBase,
                    upperLimit: upperLimit,
                    componentEditing: $componentEditing,
                    value: $components.subFrames
                )
            }
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
                rate: frameRate,
                base: subFramesBase,
                limit: upperLimit
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
            .timecodeFieldHighlightStyle(.purple)
            .foregroundStyle(.orange)
        TimecodeField(
            components: $components,
            at: properties.frameRate,
            base: properties.subFramesBase,
            limit: properties.upperLimit
        )
        .timecodeSeparatorStyle(.gray)
        .timecodeValidationStyle(.purple)
        .timecodeFieldHighlightStyle(.white)
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
            .timecodeFieldHighlightStyle(.purple)
            .foregroundStyle(.orange)
        TimecodeField(
            components: $components,
            at: properties.frameRate,
            base: properties.subFramesBase,
            limit: properties.upperLimit
        )
        .timecodeSeparatorStyle(.gray)
        .timecodeValidationStyle(.purple)
        .timecodeFieldHighlightStyle(.white)
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
    @Previewable @TimecodeState var timecode = Timecode(
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
            TimecodeText(timecode)
        }
        .font(.largeTitle)
        .timecodeFormat(tcFormat)
        .timecodeValidationStyle(.red)
        
        Form {
            LabeledContent("Frame Rate") {
                Button("24") { timecode.frameRate = .fps24 }
                Button("30") { timecode.frameRate = .fps30 }
            }
            LabeledContent("SubFrames Base") {
                Button("80") { timecode.subFramesBase = .max80SubFrames }
                Button("100") { timecode.subFramesBase = .max100SubFrames }
            }
            LabeledContent("Upper Limit") {
                Button("24 Hours") { timecode.upperLimit = .max24Hours }
                Button("100 Days") { timecode.upperLimit = .max100Days }
            }
            LabeledContent("Components") {
                Button("Randomize") { timecode.components = .random(in: .unsafeRandomRanges) }
            }
            Toggle("Show SubFrames", isOn: $tcFormat.option(.showSubFrames))
        }
        .formStyle(.grouped)
    }
    .padding()
    .frame(width: 400)
}

#endif

#endif
