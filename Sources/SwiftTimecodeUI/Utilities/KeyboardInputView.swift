//
//  KeyboardInputView.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && (os(iOS) || os(tvOS) || os(visionOS))

import SwiftUI

/// An invisible view providing a native SwiftUI on-screen keyboard input experience.
/// Note that `return` key is not passed to the `onKeyPress` closure. Instead, handle that with an `onSubmit { }` view modifier.
@available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, *)
struct KeyboardInputView: View {
    var onKeyPress: (_ keyEquivalent: KeyEquivalent) -> Void
    
    @State private var text = neutralText
    
    private static let neutralText = " "
    
    var body: some View {
        TextField("", text: $text)
            .textFieldStyle(.plain)
            #if !os(tvOS)
            .textSelection(.disabled)
            #endif
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .keyboardType(.decimalPad)
            .labelsHidden()
            .foregroundStyle(.clear)
            .tint(.clear) // hide text input caret
            .onChange(of: text) { oldValue, newValue in
                // backspace
                if text.isEmpty {
                    onKeyPress(.delete)
                    reset()
                    return
                }
                
                // avoid catching the default string
                guard text != Self.neutralText else { return }
                
                // otherwise new printable character will be added at end of string
                guard let char = text.last else { return }
                
                // reset to neutral string
                Task { reset() }
                
                // not a universal solution, but it works for the keys we care about
                let keyEquivalent = KeyEquivalent(char)
                onKeyPress(keyEquivalent)
            }
    }
    
    private func reset() {
        text = Self.neutralText
    }
}

// TODO: Previous solution that worked, except had issues with Return key. Could delete.

// /// An invisible view providing a native SwiftUI on-screen keyboard input experience.
// @available(iOS 14, tvOS 17.0, *)
// struct KeyboardInputView: UIViewRepresentable {
//     typealias UIViewType = KeyboardInputTextField
//
//     private var keyboardType: UIKeyboardType
//     private var keyPressed: @MainActor (KeyEquivalent) -> Void
//
//     init(
//         keyboardType: UIKeyboardType = .default,
//         keyPressed: @MainActor @escaping (KeyEquivalent) -> Void
//     ) {
//         self.keyboardType = keyboardType
//         self.keyPressed = keyPressed
//     }
//
//     func makeUIView(context: Context) -> UIViewType {
//         KeyboardInputTextField(
//             keyboardType: keyboardType,
//             keyPressed: keyPressed
//         )
//     }
//
//     func updateUIView(_ uiView: UIViewType, context: Context) {
//         uiView.keyboardType = keyboardType
//
//         // we have to update the stored closure to reflect changes to the view's environment variables
//         uiView.keyPressed = keyPressed
//     }
//
//     class KeyboardInputTextField: UITextField, UITextFieldDelegate {
//         var keyPressed: @MainActor (KeyEquivalent) -> Void
//
//         init(
//             keyboardType: UIKeyboardType,
//             keyPressed: @MainActor @escaping (KeyEquivalent) -> Void
//         ) {
//             self.keyPressed = keyPressed
//             super.init(frame: CGRect(origin: .zero, size: CGSize(width: 10, height: 10)))
//             delegate = self
//             text = ""
//             self.keyboardType = keyboardType
//         }
//
//         required init?(coder: NSCoder) {
//             assertionFailure("init(coder:) has not been implemented")
//             keyPressed = { _ in }
//             super.init(coder: coder)
//         }
//
//         // MARK: UIResponder
//
//         override var canBecomeFirstResponder: Bool { true }
//         override var canResignFirstResponder: Bool { true }
//
//         override var canBecomeFocused: Bool { true }
//         override var isTransparentFocusItem: Bool { true }
//
//         // MARK: UITextField
//
//         // hide insertion caret
//         override func caretRect(for position: UITextPosition) -> CGRect {
//             .zero
//         }
//
//         // MARK: UITextFieldDelegate
//
//         func textField(
//             _ textField: UITextField,
//             shouldChangeCharactersIn range: NSRange,
//             replacementString string: String
//         ) -> Bool {
//             guard let firstChar = string.first else {
//                 keyPressed(.delete)
//                 return false
//             }
//             let key = KeyEquivalent(firstChar)
//             keyPressed(key)
//             return false
//         }
//
//         // disable popup context menu
//         func textField(
//             _ textField: UITextField,
//             editMenuForCharactersIn range: NSRange,
//             suggestedActions: [UIMenuElement]
//         ) -> UIMenu? {
//             nil
//         }
//
//         // MARK: UIKeyInput
//
//         // this seems to never be called. perhaps UITextField is bypassing it.
//         override func insertText(_ text: String) {
//             guard let firstChar = text.first else {
//                 return
//             }
//             let key = KeyEquivalent(firstChar)
//             keyPressed(key)
//         }
//
//         // this only seems to be called when the field text is empty or the
//         // insertion caret is at the start
//         override func deleteBackward() {
//             keyPressed(.delete)
//         }
//
//         // forward return key
//         func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//             keyPressed(.return)
//             return false
//         }
//
//         // TODO: could forward this in the future as well
//         // func textFieldShouldClear(_ textField: UITextField) -> Bool { }
//
//         override var hasText: Bool { true }
//     }
// }

#endif
