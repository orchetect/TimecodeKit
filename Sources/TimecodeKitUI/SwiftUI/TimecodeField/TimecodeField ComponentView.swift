//
//  TimecodeField ComponentView.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI)

import SwiftUI
import TimecodeKitCore

@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
extension TimecodeField {
    /// Individual timecode component view.
    struct ComponentView: View {
        // MARK: - Properties settable through view initializers
        
        let component: Timecode.Component
        let frameRate: TimecodeFrameRate
        let subFramesBase: Timecode.SubFramesBase
        let upperLimit: Timecode.UpperLimit
        @FocusState.Binding var componentEditing: Timecode.Component?
        @Binding var value: Int
        
        // MARK: - Properties settable through custom view modifiers
        
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
        
        // MARK: - Internal State
        
        @State private var isVirgin: Bool = true
        @State private var isHovering: Bool = false
        @State private var textInput: String = ""
        @State private var shakeTrigger: Bool = false
        
        private let shakeIntensity: CGFloat = 5
        
        // MARK: - Body
        
        var body: some View {
            #if os(macOS)
            // Note: The ZStack is necessary to persist focus state.
            // The `conditionalForegroundStyle` modifier causes the view to be recreated
            // when `isValueValid` changes which in turn would cause focus to be lost.
            ZStack {
                Text(valuePadded)
                    .conditionalForegroundStyle(isValueValid ? nil : timecodeValidationStyle)
                    .lineLimit(1)
                    .fixedSize()
                    .allowsTightening(false)
            }
            .background { background }
            .offset(x: shakeTrigger ? shakeIntensity : 0)
            .focusable(interactions: [.edit])
            .focused($componentEditing, equals: component)
            .onHover { state in
                isHovering = state
            }
            .onTapGesture {
                startEditing()
            }
            .onChange(of: componentEditing) { oldValue, newValue in
                setIsVirgin(true)
            }
            .onKeyPress(phases: [.down, .repeat]) { keyPress in
                handleKeyPress(key: keyPress.key)
            }
            .onDisappear {
                endEditing()
            }
            #elseif os(iOS) || os(visionOS)
            ZStack {
                KeyboardInputView(
                    keyboardType: .decimalPad // note that on iPadOS this also contains extended chars
                ) { keyEquivalent in
                    _ = handleKeyPress(key: keyEquivalent)
                }
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
                .focused($componentEditing, equals: component)
                
                Text(valuePadded)
                    .conditionalForegroundStyle(isValueValid ? nil : timecodeValidationStyle)
                    .lineLimit(1)
                    .fixedSize()
                    .allowsTightening(false)
                    .allowsHitTesting(false)
            }
            .background { background }
            .offset(x: shakeTrigger ? shakeIntensity : 0)
            .onTapGesture {
                startEditing()
            }
            .onChange(of: componentEditing) { oldValue, newValue in
                setIsVirgin(true)
            }
            .onDisappear {
                endEditing()
            }
            #endif
        }
        
        // MARK: - Styling
        
        private var background: some View {
            backgroundColor.mask(alignment: .center) { backgroundMask }
        }
        
        private var backgroundColor: Color {
            if isEditing, let timecodeHighlightStyle {
                timecodeHighlightStyle
            } else if isHovering {
                Color.secondary
            } else {
                Color.clear
            }
        }
        
        private var backgroundMask: some View {
            RoundedRectangle(cornerSize: CGSize(width: 2, height: 2))
        }
        
        // MARK: - View Model
        
        private var valuePadded: String {
            var string = "\(value)"
            if string.count < numberOfDigits {
                string.insert(
                    contentsOf: String(repeating: "0", count: numberOfDigits - string.count),
                    at: string.startIndex
                )
            }
            
            return string
        }
        
        private var validRange: ClosedRange<Int> {
            Timecode(.zero, at: frameRate, base: subFramesBase, limit: upperLimit)
                .validRange(of: component)
        }
        
        private var isValueValid: Bool {
            validRange.contains(value)
        }
        
        private var numberOfDigits: Int {
            component.numberOfDigits(at: frameRate, base: subFramesBase)
        }
        
        private var invisibleComponents: Set<Timecode.Component> {
            var c: Set<Timecode.Component> = []
            if upperLimit == ._24hours { c.insert(.days) }
            if !timecodeFormat.contains(.showSubFrames) { c.insert(.subFrames) }
            return c
        }
        
        // MARK: - Editing
        
        private var isEditing: Bool {
            componentEditing == component
        }
        
        private func startEditing() {
            focus(component: component)
        }
        
        private func endEditing() {
            componentEditing = nil
        }
        
        private func setIsVirgin(_ state: Bool) {
            isVirgin = state
            if isVirgin { textInput = "" }
        }
        
        private func resetToZero() {
            value = 0
            textInput = ""
        }
        
        private func handleKeyPress(key: KeyEquivalent) -> KeyPress.Result {
            switch key {
            case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
                let proposedValue: Int?
                
                defer { setIsVirgin(false) }
                if isVirgin {
                    proposedValue = Int("\(key.character)")
                } else {
                    proposedValue = Int("\(value)\(key.character)")
                }
                
                guard var proposedValue else { return .ignored }
                var proposedTextInput = "\(textInput)\(key.character)"
                
                func checkForValidation() -> KeyPress.Result? {
                    switch timecodeFieldValidationPolicy {
                    case .allowInvalid:
                        break
                    case .enforceValid:
                        guard validRange.contains(proposedValue) else {
                            errorFeedback()
                            return .handled
                        }
                    }
                    
                    return nil
                }
                
                switch timecodeFieldInputStyle {
                case .autoAdvance:
                    if let result = checkForValidation() { return result }
                    
                    let postDigitCount = proposedTextInput.count
                    let maxDigits = component.numberOfDigits(at: frameRate, base: subFramesBase)
                    if postDigitCount > maxDigits {
                        focusNextComponent(wrap: timecodeFieldInputWrapping)
                        return .handled
                    }
                    value = proposedValue
                    textInput = proposedTextInput
                    if postDigitCount == maxDigits {
                        focusNextComponent(wrap: timecodeFieldInputWrapping)
                    }
                    
                    return .handled
                case .continuousWithinComponent:
                    let postDigitCount = proposedValue.numberOfDigits
                    let maxDigits = component.numberOfDigits(at: frameRate, base: subFramesBase)
                    if postDigitCount > maxDigits {
                        guard let int = Int("\(proposedValue)".suffix(maxDigits)) else {
                            return .handled
                        }
                        proposedValue = int
                    }
                    proposedTextInput = String(proposedTextInput.suffix(maxDigits))
                    
                    if let result = checkForValidation() { return result }
                    
                    value = proposedValue
                    textInput = proposedTextInput
                    return .handled
                case .unbounded:
                    if let result = checkForValidation() { return result }
                    
                    value = proposedValue
                    textInput = proposedTextInput
                    return .handled
                }
                
            case "+", "=", .upArrow: // increment
                let newValue = value + 1
                if validRange.contains(newValue) {
                    value = newValue
                } else {
                    value = validRange.lowerBound
                }
                setIsVirgin(true)
                return .handled
                
            case "-", .downArrow: // decrement
                let newValue = value - 1
                if validRange.contains(newValue) {
                    value = newValue
                } else {
                    value = validRange.upperBound
                }
                setIsVirgin(true)
                return .handled
                
            case .delete, .deleteScalar: // backspace
                if value == 0 {
                    focusPreviousComponent(wrap: timecodeFieldInputWrapping)
                }
                if isVirgin {
                    resetToZero()
                    setIsVirgin(false)
                } else {
                    textInput = String(textInput.dropLast())
                    value = Int("\(textInput)") ?? 0
                }
                return .handled
                
            case .deleteForward:
                resetToZero()
                setIsVirgin(false)
                return .handled
                
            case .leftArrow:
                focusPreviousComponent(wrap: timecodeFieldInputWrapping)
                return .handled
                
            case ".", ":", ";", ",", /* .tab, */ .rightArrow:
                focusNextComponent(wrap: timecodeFieldInputWrapping)
                return .handled
                
            case .escape:
                // pass through to any receivers that accept cancel action
                return perform(fieldAction: timecodeFieldEscapeAction)
                
            case .return:
                // pass through to any receivers that accept default action
                return perform(fieldAction: timecodeFieldReturnAction)
                
            default:
                return .ignored
            }
        }
        
        // MARK: - UI
        
        private var firstVisibleComponent: Timecode.Component {
            Timecode.Component.first(excluding: invisibleComponents)
        }
        
        private func focus(component: Timecode.Component) {
            Task { // task avoids animation quirk
                componentEditing = component
            }
        }
        
        /// Returns true if component focus changed.
        @discardableResult
        private func focusPreviousComponent(wrap: TimecodeField.InputWrapping) -> Bool {
            let bool = wrap == .wrap
            let newComponent = component.previous(excluding: invisibleComponents, wrap: bool)
            let didChange = componentEditing != newComponent
            Task { // task avoids animation quirk
                componentEditing = newComponent
            }
            return didChange
        }
        
        /// Returns true if component focus changed.
        @discardableResult
        private func focusNextComponent(wrap: TimecodeField.InputWrapping) -> Bool {
            let bool = wrap == .wrap
            let newComponent = component.next(excluding: invisibleComponents, wrap: bool)
            let didChange = componentEditing != newComponent
            Task { // task avoids animation quirk
                componentEditing = newComponent
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
