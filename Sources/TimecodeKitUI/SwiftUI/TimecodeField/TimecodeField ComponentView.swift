//
//  TimecodeField ComponentView.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && (os(macOS) || os(iOS) || os(visionOS))

import SwiftUI
import TimecodeKit

@available(macOS 14, iOS 17, *)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
extension TimecodeField {
    struct ComponentView: View {
        // MARK: - Properties settable through view initializers
        
        let component: Timecode.Component
        let frameRate: TimecodeFrameRate
        let subFramesBase: Timecode.SubFramesBase
        let upperLimit: Timecode.UpperLimit
        @FocusState var componentEditing: Timecode.Component?
        @Binding var value: Int
        
        // MARK: - Properties settable through custom view modifiers
        
        @Environment(\.timecodeFormat) private var timecodeFormat: Timecode.StringFormat
        @Environment(\.timecodeHighlightStyle) private var timecodeHighlightStyle: Color?
        @Environment(\.timecodeSeparatorStyle) private var timecodeSeparatorStyle: Color?
        @Environment(\.timecodeValidationStyle) private var timecodeValidationStyle: Color?
        
        // MARK: - Internal State
        
        @State private var isVirgin: Bool = true
        @State private var isHovering: Bool = false
        
        // MARK: - Body
        
        var body: some View {
            VStack(spacing: 0) {
                ZStack {
                    Text(valuePadded)
                        .conditionalForegroundStyle(isValueValid ? nil : timecodeValidationStyle)
                        .background(
                            background,
                            alignment: .center
                        )
                    #if os(iOS)
                    // for iOS, add an invisible view overlay to allow on-screen keyboard input
                    KeyboardInputView(
                        keyboardType: .decimalPad,
                        isFocused: isEditing
                    ) { key in
                        handleKeyPress(key: key)
                    }
                    .keyboardType(.decimalPad) // note: only affects TextField
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    // .focusable(interactions: [.edit])
                    // .focused($componentEditing, equals: component)
                    #endif
                }
            }
            .focusable(interactions: [.edit])
            .focused($componentEditing, equals: component)
            .onHover { state in
                isHovering = state
            }
            .onTapGesture {
                startEditing()
            }
            .onChange(of: componentEditing) { oldValue, newValue in
                isVirgin = true
            }
            .onKeyPress(phases: [.down, .repeat]) { keyPress in
                handleKeyPress(key: keyPress.key)
            }
        }
        
        // MARK: - Styling
        
        @ViewBuilder
        private var background: some View {
            if isEditing {
                timecodeHighlightStyle.mask(backgroundMask)
            } else if isHovering {
                Color.secondary.mask(backgroundMask)
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
            componentEditing = component
        }
        
        private func endEditing() {
            componentEditing = nil
        }
        
        private func handleKeyPress(key: KeyEquivalent) -> KeyPress.Result {
            switch key {
            case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
                if isVirgin {
                    guard let newValue = Int("\(key.character)") else {
                        return .ignored
                    }
                    value = newValue
                    isVirgin = false
                    return .handled
                } else {
                    guard let newValue = Int("\(value)\(key.character)") else {
                        return .ignored
                    }
                    value = newValue
                    return .handled
                }
                
            case "+", "=", .upArrow: // increment
                let newValue = value + 1
                if validRange.contains(newValue) {
                    value = newValue
                } else {
                    value = validRange.lowerBound
                }
                isVirgin = true
                return .handled
                
            case "-", .downArrow: // decrement
                let newValue = value - 1
                if validRange.contains(newValue) {
                    value = newValue
                } else {
                    value = validRange.upperBound
                }
                isVirgin = true
                return .handled
                
            case .delete, .deleteScalar:
                if isVirgin {
                    value = 0
                    isVirgin = false
                } else {
                    value = Int("\(value)".dropLast()) ?? 0
                }
                return .handled
                
            case .deleteForward:
                value = 0
                return .handled
                
            case .leftArrow:
                componentEditing = component.previous(excluding: invisibleComponents)
                return .handled
                
            case ".", ":", ";", ",", /* .tab, */ .rightArrow:
                componentEditing = component.next(excluding: invisibleComponents)
                return .handled
                
            case .escape:
                endEditing()
                return .handled
                
            case .return:
                endEditing()
                return .handled
                
            default:
                return .ignored
            }
        }
    }
}

#endif
