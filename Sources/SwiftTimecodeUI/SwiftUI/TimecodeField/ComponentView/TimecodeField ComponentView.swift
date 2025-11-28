//
//  TimecodeField ComponentView.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(watchOS)

import SwiftUI
import SwiftTimecodeCore

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension TimecodeField {
    /// Individual timecode component view.
    struct ComponentView: View {
        // MARK: - Properties settable through view initializers
        
        @Binding var timecodeProperties: Timecode.Properties
        @Binding var value: Int
        @FocusState.Binding var focusedComponent: Timecode.Component?
        
        // MARK: - Public view modifiers
        
        @Environment(\.timecodeFormat) private var timecodeFormat
        @Environment(\.timecodeFieldHighlightStyle) private var timecodeHighlightStyle
        @Environment(\.timecodeSeparatorStyle) private var timecodeSeparatorStyle
        @Environment(\.timecodeValidationStyle) private var timecodeValidationStyle
        @Environment(\.timecodeFieldReturnAction) private var timecodeFieldReturnAction
        @Environment(\.timecodeFieldEscapeAction) private var timecodeFieldEscapeAction
        @Environment(\.timecodeFieldInputStyle) private var timecodeFieldInputStyle
        @Environment(\.timecodeFieldInputWrapping) private var timecodeFieldInputWrapping
        @Environment(\.timecodeFieldInputRejectionFeedback) var timecodeFieldInputRejectionFeedback
        @Environment(\.timecodeFieldValidationPolicy) private var timecodeFieldValidationPolicy
        
        // MARK: - Internal view modifiers
        
        @Environment(\.timecodePasted) private var timecodePasted
        
        // MARK: - Internal State
        
        @State private var stateModel: StateModel
        @State var viewModel: ViewModel
        
        @State private var isHovering: Bool = false
        @State private var shakeTrigger: Bool = false
        @State private var pulseTrigger: Bool = false
        
        private let shakeIntensity: CGFloat = 5
        private let pulseIntensity: Double = 0.7 // 0.0 ... 1.0
        
        // MARK: - Init
        
        init(
            component: Timecode.Component,
            timecodeProperties: Binding<Timecode.Properties>,
            value: Binding<Int>,
            focusedComponent: FocusState<Timecode.Component?>.Binding
        ) {
            self._timecodeProperties = timecodeProperties
            self._focusedComponent = focusedComponent
            self._value = value
            
            stateModel = StateModel(
                component: component,
                initialTimecodeProperties: timecodeProperties.wrappedValue,
                initialValue: value.wrappedValue
            )
            viewModel = ViewModel(
                component: component,
                initialTimecodeProperties: timecodeProperties.wrappedValue
            )
        }
        
        // MARK: - Body
        
        var body: some View {
            baseBodyForPlatform
                // multiplatform UI modifiers
                .background { background }
                .offset(x: shakeTrigger ? shakeIntensity : 0)
                .brightness(pulseTrigger ? pulseIntensity : 0)
            
                // multiplatform focus logic
                // (`focusable()` and `focused()` are implemented in platform-specific body
                .onChange(of: focusedComponent) { oldValue, newValue in
                    stateModel.setIsVirgin(true)
                }
            
                // properties binding synchronization
                // only need binding -> models sync.
                // no need for models -> binding sync because the models only read the values.
                .onChange(of: timecodeProperties) { oldValue, newValue in
                    updateModelsTimecodeProperties()
                }
            
                // value binding synchronization
                .onChange(of: value) { oldValue, newValue in
                    stateModel.value = value
                }
                .onChange(of: stateModel.value) { oldValue, newValue in
                    value = stateModel.value
                }
            
                // multiplatform user interaction
                .onTapGesture {
                    startEditing()
                }
            
                // multiplatform lifecycle
                .onDisappear {
                    endEditing()
                }
        }
        
        var baseBodyForPlatform: some View {
            #if os(macOS)
            // Note: The ZStack is necessary to persist focus state.
            // The `conditionalForegroundStyle` modifier causes the view to be recreated
            // when `isValueValid` changes which in turn would cause focus to be lost.
            ZStack {
                Text(stateModel.valuePadded)
                    .conditionalForegroundStyle(stateModel.isValueValid ? nil : timecodeValidationStyle)
                    .lineLimit(1)
                    .fixedSize()
                    .allowsTightening(false)
            }
            .background { background }
            
            // focus
            .focusable(interactions: [.edit])
            .focused($focusedComponent, equals: viewModel.component)
            
            // pasteboard
            .onPasteCommandOfTimecode(
                propertiesForString: viewModel.timecodeProperties,
                forwardTo: timecodePasted
            )
            
            // user interaction
            .onHover { state in
                isHovering = state
            }
            
            .onKeyPress(phases: [.down, .repeat]) { keyPress in
                handleKeyPress(key: keyPress.key)
            }
            
            #elseif os(iOS) || os(tvOS) || os(visionOS)
            
            ZStack {
                // KeyboardInputView(
                //     keyboardType: .decimalPad // note that on iPadOS this also contains extended chars
                // ) { keyEquivalent in
                //     handleKeyPress(key: keyEquivalent)
                // }
                KeyboardInputView { keyEquivalent in
                    handleKeyPress(key: keyEquivalent)
                }
                .focused($focusedComponent, equals: viewModel.component)
                .onKeyPress(phases: [.down, .repeat]) { keyPress in
                    // only handle hardware keyboard keys that aren't already handled by KeyboardInputView.
                    // basically, anything that isn't a numeric digit or a period.
                    
                    guard !keyPress.key.character.isNumber,
                          keyPress.key.character != "."
                    else {
                        return .ignored
                    }
                    return handleKeyPress(key: keyPress.key)
                }
                
                Text(stateModel.valuePadded)
                    .conditionalForegroundStyle(stateModel.isValueValid ? nil : timecodeValidationStyle)
                    .lineLimit(1)
                    .fixedSize()
                    .allowsTightening(false)
                    .allowsHitTesting(false)
            }
            
            #endif
        }
        
        // MARK: - Styling
        
        private var background: some View {
            RoundedRectangle(cornerSize: CGSize(width: 2, height: 2))
                .fill(backgroundStyle)
        }
        
        private var backgroundStyle: AnyShapeStyle {
            if isEditing, let timecodeHighlightStyle {
                timecodeHighlightStyle
            } else if isHovering {
                AnyShapeStyle(Color.secondary)
            } else {
                AnyShapeStyle(Color.clear)
            }
        }
        
        // MARK: - Editing
        
        private var isEditing: Bool {
            focusedComponent == viewModel.component
        }
        
        private func startEditing() {
            focus(component: viewModel.component)
        }
        
        private func endEditing() {
            focus(component: nil)
        }
        
        // MARK: - Models
        
        private func updateModelsTimecodeProperties() {
            stateModel.timecodeProperties = timecodeProperties
            viewModel.timecodeProperties = timecodeProperties
        }
        
        // MARK: - UI
        
        private func focus(component: Timecode.Component?) {
            Task { // task avoids animation quirk
                focusedComponent = component
            }
        }
        
        /// Perform UI updates in response to a keyboard key event.
        @discardableResult
        private func handleKeyPress(key: KeyEquivalent) -> KeyPress.Result {
            let handlerResult = stateModel.handleKeyPress(
                key: key,
                inputStyle: timecodeFieldInputStyle,
                validationPolicy: timecodeFieldValidationPolicy
            )
            
            // defer UI feedback until after updating state or performing actions
            defer {
                if let newFocus = handlerResult.updateFocus {
                    switch newFocus {
                    case .focusPreviousComponent:
                        focusPreviousComponent(wrap: timecodeFieldInputWrapping)
                    case .focusNextComponent:
                        focusNextComponent(wrap: timecodeFieldInputWrapping)
                    }
                }
                
                if let reason = handlerResult.rejection {
                    inputRejectionFeedback(
                        .keyRejected(component: viewModel.component, key: key, reason: reason)
                    )
                }
            }
            
            switch handlerResult.result {
            case .handled:
                return .handled
            case .ignored:
                return .ignored
            case .performEscapeAction:
                return perform(fieldAction: timecodeFieldEscapeAction)
            case .performReturnAction:
                return perform(fieldAction: timecodeFieldReturnAction)
            }
        }
        
        private func focusPreviousComponent(wrap: TimecodeField.InputWrapping){
            let newComponent = viewModel.previousComponent(timecodeFormat: timecodeFormat, wrap: wrap)
            Task { // task avoids animation quirk
                focusedComponent = newComponent
            }
        }
        
        private func focusNextComponent(wrap: TimecodeField.InputWrapping) {
            let newComponent = viewModel.nextComponent(timecodeFormat: timecodeFormat, wrap: wrap)
            Task { // task avoids animation quirk
                focusedComponent = newComponent
            }
        }
        
        private func perform(fieldAction: TimecodeField.FieldAction?) -> KeyPress.Result {
            // a `nil` action does nothing.
            guard let fieldAction else { return .ignored }
            
            switch fieldAction {
            case .endEditing:
                endEditing()
                return .ignored
                
            case let .resetComponentFocus(component):
                let targetComponent = component
                    ?? viewModel.firstVisibleComponent(timecodeFormat: timecodeFormat)
                focus(component: targetComponent)
                
                // pass through to any receivers
                return .ignored
                
            case .focusNextComponent:
                focusNextComponent(wrap: timecodeFieldInputWrapping)
                return .handled
            }
        }
    }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension TimecodeField.ComponentView: RejectedInputFeedbackable {
    func perform(rejectionAnimation: TimecodeField.InputRejectionFeedback.RejectionAnimation) {
        switch rejectionAnimation {
        case .shake:
            shakeTrigger = true
            withAnimation(Self.shakeAnimation) {
                shakeTrigger = false
            }
        case .pulse:
            pulseTrigger = true
            withAnimation(Self.pulseAnimation) {
                pulseTrigger = false
            }
        }
    }
}

#endif
