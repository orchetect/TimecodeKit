//
//  TimecodeField ComponentView.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(watchOS)

import SwiftUI
import TimecodeKitCore

@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
extension TimecodeField {
    /// Individual timecode component view.
    struct ComponentView: View {
        // MARK: - Properties settable through view initializers
        
        let component: Timecode.Component
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
        @Environment(\.timecodeFieldValidationAnimation) private var timecodeFieldValidationAnimation
        @Environment(\.timecodeFieldValidationPolicy) private var timecodeFieldValidationPolicy
        
        // MARK: - Internal view modifiers
        
        @Environment(\.timecodePasted) private var timecodePasted
        
        // MARK: - Internal State
        
        @State private var state: ComponentState
        
        @State var isHovering: Bool = false
        @State var shakeTrigger: Bool = false
        
        private let shakeIntensity: CGFloat = 5
        
        // MARK: - Init
        
        init(
            component: Timecode.Component,
            frameRate: TimecodeFrameRate,
            subFramesBase: Timecode.SubFramesBase,
            upperLimit: Timecode.UpperLimit,
            value: Binding<Int>,
            focusedComponent: FocusState<Timecode.Component?>.Binding
        ) {
            self.component = component
            self._value = value
            self._focusedComponent = focusedComponent
            self._value = value
            
            self.state = ComponentState(
                component: component,
                frameRate: frameRate,
                subFramesBase: subFramesBase,
                upperLimit: upperLimit,
                initialValue: value.wrappedValue
            )
        }
        
        // MARK: - Body
        
        var body: some View {
            baseBodyForPlatform
                // multiplatform UI modifiers
                .background { background }
                .offset(x: shakeTrigger ? shakeIntensity : 0)
            
                // multiplatform focus logic
                // (`focusable()` and `focused()` are implemented in platform-specific body
                .onChange(of: focusedComponent) { oldValue, newValue in
                    state.setIsVirgin(true)
                }
            
                // value binding synchronization
                .onChange(of: value) { oldValue, newValue in
                    state.value = value
                }
                .onChange(of: state.value) { oldValue, newValue in
                    value = state.value
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
                Text(state.valuePadded)
                    .conditionalForegroundStyle(state.isValueValid ? nil : timecodeValidationStyle)
                    .lineLimit(1)
                    .fixedSize()
                    .allowsTightening(false)
            }
            .background { background }
            
            // focus
            .focusable(interactions: [.edit])
            .focused($focusedComponent, equals: component)
            
            // pasteboard
            .onPasteCommandOfTimecode(
                propertiesForString: state.timecodeProperties,
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
                .focused($focusedComponent, equals: component)
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
                
                Text(state.valuePadded)
                    .conditionalForegroundStyle(state.isValueValid ? nil : timecodeValidationStyle)
                    .lineLimit(1)
                    .fixedSize()
                    .allowsTightening(false)
                    .allowsHitTesting(false)
            }
            
            #endif
        }
        
        // MARK: - Styling
        
        private var background: some View {
            // backgroundColor.mask(alignment: .center) { backgroundMask }
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
        
        // private var backgroundMask: some View {
        //     RoundedRectangle(cornerSize: CGSize(width: 2, height: 2))
        // }
        
        // MARK: - Editing
        
        private var isEditing: Bool {
            focusedComponent == component
        }
        
        private func startEditing() {
            focus(component: component)
        }
        
        private func endEditing() {
            focus(component: nil)
        }
        
        // MARK: - UI
        
        private var firstVisibleComponent: Timecode.Component {
            Timecode.Component.first(excluding: state.invisibleComponents(using: timecodeFormat))
        }
        
        private func focus(component: Timecode.Component?) {
            Task { // task avoids animation quirk
                focusedComponent = component
            }
        }
        
        /// Perform UI updates in response to a keyboard key event.
        @discardableResult
        private func handleKeyPress(key: KeyEquivalent) -> KeyPress.Result {
            let handlerResult = state.handleKeyPress(
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
                
                if handlerResult.errorFeedback {
                    errorFeedback()
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
        
        /// Returns true if component focus changed.
        @discardableResult
        private func focusPreviousComponent(wrap: TimecodeField.InputWrapping) -> Bool {
            let bool = wrap == .wrap
            let newComponent = component.previous(
                excluding: state.invisibleComponents(using: timecodeFormat),
                wrap: bool
            )
            let didChange = focusedComponent != newComponent
            Task { // task avoids animation quirk
                focusedComponent = newComponent
            }
            return didChange
        }
        
        /// Returns true if component focus changed.
        @discardableResult
        private func focusNextComponent(wrap: TimecodeField.InputWrapping) -> Bool {
            let bool = wrap == .wrap
            let newComponent = component.next(
                excluding: state.invisibleComponents(using: timecodeFormat),
                wrap: bool
            )
            let didChange = focusedComponent != newComponent
            Task { // task avoids animation quirk
                focusedComponent = newComponent
            }
            return didChange
        }
        
        private func perform(fieldAction: TimecodeField.FieldAction?) -> KeyPress.Result {
            // a `nil` action does nothing.
            guard let fieldAction else { return .ignored }
            
            switch fieldAction {
            case .endEditing:
                endEditing()
                return .ignored
                
            case let .resetComponentFocus(component):
                focus(component: component ?? firstVisibleComponent)
                // pass through to any receivers
                return .ignored
                
            case .focusNextComponent:
                focusNextComponent(wrap: timecodeFieldInputWrapping)
                return .handled
            }
        }
        
        private func errorFeedback() {
            beep()
            
            if timecodeFieldValidationAnimation {
                shakeTrigger = true
                withAnimation(
                    Animation.spring(response: 0.2, dampingFraction: 0.2, blendDuration: 0.2)
                ) {
                    shakeTrigger = false
                }
            }
        }
    }
}

#endif
