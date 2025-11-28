//
//  TimecodeField StateModelProtocol.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(watchOS)

import SwiftUI
import SwiftTimecodeCore

@available(macOS 14.0, iOS 17.0, tvOS 17.0, *)
extension TimecodeField {
    protocol StateModelProtocol where Self: AnyObject, Self: Observable {
        // injected properties
        var component: Timecode.Component { get }
        var frameRate: TimecodeFrameRate { get }
        var subFramesBase: Timecode.SubFramesBase { get }
        var upperLimit: Timecode.UpperLimit { get }
        
        // local state
        var value: Int { get set }
        var isVirgin: Bool { get set }
        
        // local methods
        @discardableResult func handleKeyPress(
            key: KeyEquivalent,
            inputStyle: TimecodeField.InputStyle,
            validationPolicy: TimecodeField.ValidationPolicy
        ) -> TimecodeField.KeyResult
        
        func setIsVirgin(_ isVirgin: Bool)
        func resetToZero()
        
        // local computed properties
        var validRange: ClosedRange<Int> { get }
    }
    
    protocol _StateModelProtocol: StateModelProtocol {
        // private local properties
        var textInput: String { get set }
    }
}

// MARK: - Key Input Processor

@available(macOS 14.0, iOS 17.0, tvOS 17.0, *)
extension TimecodeField._StateModelProtocol {
    @discardableResult
    public func handleKeyPress(
        key: KeyEquivalent,
        inputStyle: TimecodeField.InputStyle,
        validationPolicy: TimecodeField.ValidationPolicy
    ) -> TimecodeField.KeyResult {
        typealias KeyResult = TimecodeField.KeyResult
        
        //   KEY                                          ASCII/Scalar           KeyEquivalent
        // ---------------------------------------------- ---------------------- ------------------------
        // MacBook Pro (2021 16") Built-in Keyboard:
        // - Return key                                   == ASCII 13            .return
        // - Delete key (traditionally Backspace)         == ASCII 127           .asciiDEL (custom)
        //
        // Apple Keyboard with Keypad (Wired USB, model A1243):
        // - Return key                                   == ASCII 13            .return
        // - Delete key (traditionally Backspace)         == ASCII 127           .asciiDEL (custom)
        // - DEL key ("forward Delete")                   == Scalar 63272 (F728) .deleteForward
        // - Numpad Enter key                             == ASCII 3             .asciiEndOfText (custom)
        //
        // Apple Magic Keyboard with Keypad (Bluetooth, model A1843):
        // - Return key                                   == ASCII 13            .return
        // - Delete key (traditionally Backspace)         == ASCII 127           .asciiDEL (custom)
        // - DEL key ("forward Delete")                   == Scalar 63272 (F728) .deleteForward
        // - Numpad Enter key                             == ASCII 3             .asciiEndOfText (custom)
        //
        
        // #if DEBUG
        // print("KEY: '\(key.character)' (ASCII: \(key.character.asciiValue?.description ?? "<nil>"), Scalars: \(key.character.unicodeScalars.map(\.value))")
        // print("  .delete", key == .delete)
        // print("  .deleteForward", key == .deleteForward)
        // print("  .return", key == .return)
        // print("  .asciiDEL", key == .asciiDEL)
        // print("  .asciiEndOfText", key == .asciiEndOfText)
        // print()
        // #endif
        
        switch key {
        case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
            let proposedValue: Int?
            
            defer { setIsVirgin(false) }
            if isVirgin {
                proposedValue = Int("\(key.character)")
            } else {
                proposedValue = Int("\(value)\(key.character)")
            }
            
            guard var proposedValue else { return KeyResult(.ignored) }
            var proposedTextInput = "\(textInput)\(key.character)"
            
            func checkForValidation() -> KeyResult? {
                switch validationPolicy {
                case .allowInvalid:
                    break
                case .enforceValid:
                    guard validRange.contains(proposedValue) else {
                        return KeyResult(.handled, rejection: .invalid)
                    }
                }
                
                return nil
            }
            
            switch inputStyle {
            case .autoAdvance:
                if let result = checkForValidation() { return result }
                
                let postDigitCount = proposedTextInput.count
                let maxDigits = component.numberOfDigits(at: frameRate, base: subFramesBase)
                if postDigitCount > maxDigits {
                    return KeyResult(.handled, .focusNextComponent)
                }
                value = proposedValue
                textInput = proposedTextInput
                if postDigitCount == maxDigits {
                    return KeyResult(.handled, .focusNextComponent)
                }
                
                return KeyResult(.handled)
            case .continuousWithinComponent:
                let postDigitCount = proposedValue.numberOfDigits
                let maxDigits = component.numberOfDigits(at: frameRate, base: subFramesBase)
                if postDigitCount > maxDigits {
                    guard let int = Int("\(proposedValue)".suffix(maxDigits)) else {
                        return KeyResult(.handled)
                    }
                    proposedValue = int
                }
                proposedTextInput = String(proposedTextInput.suffix(maxDigits))
                
                if let result = checkForValidation() { return result }
                
                value = proposedValue
                textInput = proposedTextInput
                return KeyResult(.handled)
            case .unbounded:
                if let result = checkForValidation() { return result }
                
                value = proposedValue
                textInput = proposedTextInput
                return KeyResult(.handled)
            }
            
        case "+", .upArrow: // increment
            let newValue = value + 1
            if validRange.contains(newValue) {
                value = newValue
            } else {
                value = validRange.lowerBound
            }
            setIsVirgin(true)
            return KeyResult(.handled)
            
        case "-", .downArrow: // decrement
            let newValue = value - 1
            if validRange.contains(newValue) {
                value = newValue
            } else {
                value = validRange.upperBound
            }
            setIsVirgin(true)
            return KeyResult(.handled)
            
        case .delete, // weirdly this case is never called, on all the physical keyboard I've tried
             .asciiDEL: // "Delete" key at the end of the number line, traditionally the Backspace key
            let shouldFocusPreviousComponent = value == 0
            if isVirgin {
                resetToZero()
                setIsVirgin(false)
            } else {
                textInput = String(textInput.dropLast())
                value = Int("\(textInput)") ?? 0
            }
            return KeyResult(
                .handled,
                shouldFocusPreviousComponent ? .focusPreviousComponent : nil
            )
            
        case .deleteForward, // on full-size keyboard with numpad, this is the DEL key above the arrow keys. it can also be triggered by `Control+D` or `fn+Delete` key commands.
             .clear: // Clear key on full-size keyboard with numpad, in the numpad area
            resetToZero()
            setIsVirgin(false)
            return KeyResult(.handled)
            
        case .leftArrow:
            return KeyResult(.handled, .focusPreviousComponent)
            
        case ".", ":", ";", ",", /* .tab, */ .rightArrow:
            return KeyResult(.handled, .focusNextComponent)
            
        case .escape:
            // pass through to any receivers that accept cancel action
            return KeyResult(.performEscapeAction)
            
        case .return, // Return key on main keyboard area
             .asciiEndOfText: // Enter key on full-size keyboard in the numpad area
            // pass through to any receivers that accept default action
            return KeyResult(.performReturnAction)
            
        default:
            // don't send error feedback, because we can't know for sure what undefined keys should be
            // considered unhandled by the entire parent view stack outside of our control.
            // so we should only provide error feedback for keys that we actually define in our handler.
            return KeyResult(.ignored, rejection: .undefinedKey)
        }
    }
}

// MARK: - View Model

@available(macOS 14.0, iOS 17.0, tvOS 17.0, *)
extension TimecodeField.StateModelProtocol {
    public var validRange: ClosedRange<Int> {
        Timecode(.zero, at: frameRate, base: subFramesBase, limit: upperLimit)
            .validRange(of: component)
    }
    
    public var valuePadded: String {
        var string = "\(value)"
        if string.count < numberOfDigits {
            string.insert(
                contentsOf: String(repeating: "0", count: numberOfDigits - string.count),
                at: string.startIndex
            )
        }
        
        return string
    }
    
    public var isValueValid: Bool {
        validRange.contains(value)
    }
    
    public var numberOfDigits: Int {
        component.numberOfDigits(at: frameRate, base: subFramesBase)
    }
}

// MARK: - Methods

@available(macOS 14.0, iOS 17.0, tvOS 17.0, *)
extension TimecodeField._StateModelProtocol {
    public func setIsVirgin(_ state: Bool) {
        isVirgin = state
        if isVirgin { textInput = "" }
    }
    
    public func resetToZero() {
        value = 0
        textInput = ""
    }
}

#endif
