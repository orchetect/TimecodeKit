//
//  TimecodeField.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(watchOS)

import SwiftUI
import TimecodeKitCore

/// A hybrid text field designed for timecode entry, allowing specialized format and style view modifiers
/// including the ability to colorize invalid timecode components.
///
/// ## Initializers
///
/// The view may be initialized with a `Timecode` binding. In this case, it is required to store the
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
///     // appearance
///     .foregroundColor(.primary) // default text color
///     .timecodeFormat([.showSubFrames]) // enable subframes component
///     .timecodeSeparatorStyle(.secondary) // colorize separators
///     .timecodeSubFramesStyle(.secondary, scale: .secondary) // colorize and/or set text size
///     .timecodeValidationStyle(.red) // colorize invalid components
///     .timecodeFieldHighlightStyle(.accentColor) // component selection color
///     // behavior
///     .timecodeFieldInputStyle(.autoAdvance)
///     .timecodeFieldInputWrapping(.noWrap)
///     .timecodeFieldInputRejectionFeedback(.validationBased())
///     .timecodeFieldValidationPolicy(.enforceValid)
///     .timecodeFieldEscapeAction(.endEditing)
///     .timecodeFieldReturnAction(.endEditing)
/// ```
///
/// For a demonstration, see the **Timecode UI** example project in this repo.
///
/// ## Submitting the Field
///
/// ### macOS
///
/// On macOS, to perform an action when the user submits the timecode (typically by pressing the Return key), use a
/// button in the view or in a parent view with the default action key command.
///
/// ```swift
/// TimecodeField(timecode: $timecode)
///
/// Button("Submit") {
///     // ...
/// }
/// .keyboardShortcut(.defaultAction)
/// ```
///
/// Note that the `onSubmit { }` view modifier will not be called on macOS.
///
/// ### iOS
///
/// On iOS, to perform an action when the user submits the timecode (typically by pressing the Return key on a hardware
/// keyboard), use the `onSubmit { }` view modifier in the view or in a parent view.
///
/// ```swift
/// TimecodeField(timecode: $timecode)
///     .onSubmit {
///         // ...
///     }
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
/// | `Backspace` | Resets the timecode component to zero if it has freshly received focus. Once the user begins to enter digits into the component, the Backspace key will function as single digit delete akin to a typical text-entry field.
/// | `Delete` (`Del` key, or `forwardDelete`) | Resets the component to zero. |
///
/// For keys that navigate timecode component focus, see the <doc:#Focus> section above.
@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
public struct TimecodeField: View, RejectedInputFeedbackable {
    // MARK: - Standard Environment
    
    @Environment(\.isEnabled) private var isEnabled
    
    // MARK: - Properties settable through view initializers
    
    // bindings for individual timecode constituents
    @Binding private var components: Timecode.Components
    @Binding private var frameRate: TimecodeFrameRate
    @Binding private var subFramesBase: Timecode.SubFramesBase
    @Binding private var upperLimit: Timecode.UpperLimit
    
    // binding for unified timecode instance
    @Binding private var timecode: Timecode
    
    // MARK: - Public view modifiers
    
    @Environment(\.timecodeFormat) private var timecodeFormat
    @Environment(\.timecodeFieldHighlightStyle) private var timecodeHighlightStyle
    @Environment(\.timecodeSubFramesStyle) private var timecodeSubFramesStyle
    @Environment(\.timecodeFieldInputStyle) private var timecodeFieldInputStyle
    @Environment(\.timecodeValidationStyle) private var timecodeValidationStyle
    @Environment(\.timecodeFieldInputRejectionFeedback) var timecodeFieldInputRejectionFeedback
    @Environment(\.timecodeFieldValidationPolicy) private var timecodeFieldValidationPolicy
    
    // MARK: - Internal view modifiers
    
    @Environment(\.timecodePasted) private var timecodePasted
    
    // MARK: - Internal State
    
    @FocusState private var focusedComponent: Timecode.Component?
    @State private var shakeTrigger: Bool = false
    
    private let shakeIntensity: CGFloat = 5
    
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
                .textSelection(.disabled)
            #elseif os(iOS) || os(visionOS)
            timecodeBody
                .keyboardType(.decimalPad)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            #elseif os(watchOS) || os(tvOS)
            timecodeBody
            #endif
        }
        .monospacedDigit()
        .fixedSize()
        .compositingGroup()
        .offset(x: shakeTrigger ? shakeIntensity : 0)
        
        #if os(macOS)
        // catch user-initiated paste event locally, forward to environment method
        .onPasteCommandOfTimecode(
            propertiesForString: timecodeProperties,
            forwardTo: timecodePasted
        )
        // handle user-initiated paste event locally or propagated up from a child view
        .onPastedTimecode(handle(pasteResult:))
        #endif
        
        // update focus if view is disabled
        .onChange(of: isEnabled, initial: false) { oldValue, newValue in
            if !isEnabled {
                focusedComponent = nil
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
    
    private var timecodeBody: some View {
        HStack(spacing: 0) {
            if upperLimit == .max100Days {
                TimecodeField.ComponentView(
                    component: .days,
                    timecodeProperties: $timecode.properties,
                    value: $components.days,
                    focusedComponent: $focusedComponent
                )
                
                SeparatorView(text: daysSeparator)
            }
            
            TimecodeField.ComponentView(
                component: .hours,
                timecodeProperties: $timecode.properties,
                value: $components.hours,
                focusedComponent: $focusedComponent
            )
            
            SeparatorView(text: mainSeparator)
            
            TimecodeField.ComponentView(
                component: .minutes,
                timecodeProperties: $timecode.properties,
                value: $components.minutes,
                focusedComponent: $focusedComponent
            )
            
            SeparatorView(text: mainSeparator)
            
            TimecodeField.ComponentView(
                component: .seconds,
                timecodeProperties: $timecode.properties,
                value: $components.seconds,
                focusedComponent: $focusedComponent
            )
            
            SeparatorView(text: framesSeparator)
            
            TimecodeField.ComponentView(
                component: .frames,
                timecodeProperties: $timecode.properties,
                value: $components.frames,
                focusedComponent: $focusedComponent
            )
            
            if timecodeFormat.contains(.showSubFrames) {
                SeparatorView(text: subFramesSeparator)
                
                TimecodeField.ComponentView(
                    component: .subFrames,
                    timecodeProperties: $timecode.properties,
                    value: $components.subFrames,
                    focusedComponent: $focusedComponent
                )
                .textScale(timecodeSubFramesStyle.scale)
                .conditionalForegroundStyle(timecodeSubFramesStyle.style)
            }
        }
    }
    
    // MARK: - Timecode Separators
    
    private var daysSeparator: String { " " }
    private var mainSeparator: String { ":" }
    private var framesSeparator: String { frameRate.isDrop ? ";" : ":" }
    private var subFramesSeparator: String { "." }
    
    // MARK: - View Model
    
    private var timecodeProperties: Timecode.Properties {
        Timecode.Properties(rate: frameRate, base: subFramesBase, limit: upperLimit)
    }
    
    private func handle(pasteResult: Result<Timecode, any Error>) {
        do {
            let pastedTimecode = try pasteResult.get()
            
            // validate against validation policy
            switch timecodeFieldValidationPolicy {
            case .allowInvalid:
                break
            case .enforceValid:
                guard timecode.isValid else {
                    inputRejectionFeedback(.fieldPasteRejected)
                    return
                }
            }
            
            // validate against input style
            switch timecodeFieldInputStyle {
            case .autoAdvance, .continuousWithinComponent:
                // ensure all timecode components as-is respect the max number of digits allowed for each
                guard pastedTimecode.components.isWithinValidDigitCount(at: frameRate, base: subFramesBase)
                else {
                    inputRejectionFeedback(.fieldPasteRejected)
                    return
                }
            case .unbounded:
                break
            }
            
            // TODO: handle additional case when configured to only paste values and not mutate timecode properties
            timecode = pastedTimecode
        } catch {
            inputRejectionFeedback(.fieldPasteRejected)
        }
    }
    
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

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension TimecodeField: RejectedInputFeedbackable {
    func shake() {
        shakeTrigger = true
        withAnimation(
            Animation.spring(response: 0.2, dampingFraction: 0.2, blendDuration: 0.2)
        ) {
            shakeTrigger = false
        }
    }
}

#endif
