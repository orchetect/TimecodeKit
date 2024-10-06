//
//  KeyboardInputView.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && os(iOS)

import SwiftUI

/// An invisible view providing a native SwiftUI on-screen keyboard input experience.
/// Limited in functionality. Provided as-is.
@available(iOS 14, *)
struct KeyboardInputView: UIViewRepresentable {
    typealias UIViewType = KeyboardInputTextField
    
    private var keyboardType: UIKeyboardType
    private var keyPressed: (KeyEquivalent) -> Void
    private var isFocused: Bool
    
    init(
        keyboardType: UIKeyboardType = .default,
        isFocused: Bool,
        keyPressed: @escaping (KeyEquivalent) -> Void
    ) {
        self.keyboardType = keyboardType
        self.isFocused = isFocused
        self.keyPressed = keyPressed
    }
    
    func makeUIView(context: Context) -> KeyboardInputTextField {
        KeyboardInputTextField(
            keyboardType: keyboardType,
            keyPressed: keyPressed
        )
    }
    
    func updateUIView(_ uiView: KeyboardInputTextField, context: Context) {
        Task { @MainActor in
            if isFocused {
                if !uiView.isFirstResponder {
                    uiView.becomeFirstResponder()
                }
            } else {
                if uiView.isFirstResponder {
                    uiView.resignFirstResponder()
                }
            }
        }
    }
    
    // func makeCoordinator() -> Coordinator {
    //     Coordinator(self)
    // }
    //
    // class Coordinator: NSObject {
    //     var parent: KeyboardInputView
    //
    //     init(_ parent: KeyboardInputView) {
    //         self.parent = parent
    //     }
    // }
    
    class KeyboardInputTextField: UITextField, UITextFieldDelegate {
        private var keyPressed: (KeyEquivalent) -> Void
        
        init(
            keyboardType: UIKeyboardType,
            keyPressed: @escaping (KeyEquivalent) -> Void
        ) {
            self.keyPressed = keyPressed
            super.init(frame: CGRect(origin: .zero, size: CGSize(width: 10, height: 10)))
            delegate = self
            text = ""
            self.keyboardType = keyboardType
        }
        
        required init?(coder: NSCoder) {
            assertionFailure("init(coder:) has not been implemented")
            keyPressed = { _ in }
            super.init(coder: coder)
        }
        
        // MARK: UIResponder
        
        override var canBecomeFirstResponder: Bool { true }
        override var canResignFirstResponder: Bool { true }
        
        override var canBecomeFocused: Bool { true }
        override var isTransparentFocusItem: Bool { true }
        
        // MARK: UITextField
        
        // hide insertion caret
        override func caretRect(for position: UITextPosition) -> CGRect {
            .zero
        }
        
        // MARK: UITextFieldDelegate
        
        func textField(
            _ textField: UITextField,
            shouldChangeCharactersIn range: NSRange,
            replacementString string: String
        ) -> Bool {
            guard let firstChar = string.first else {
                keyPressed(.delete)
                return false
            }
            let key = KeyEquivalent(firstChar)
            keyPressed(key)
            return false
        }
        
        // disable popup context menu
        func textField(
            _ textField: UITextField,
            editMenuForCharactersIn range: NSRange,
            suggestedActions: [UIMenuElement]
        ) -> UIMenu? {
            nil
        }
        
        // MARK: UIKeyInput
        
        // this seems to never be called. perhaps UITextField is bypassing it.
        override func insertText(_ text: String) {
            guard let firstChar = text.first else {
                return
            }
            let key = KeyEquivalent(firstChar)
            keyPressed(key)
        }
        
        // this only seems to be called when the field text is empty or the
        // insertion caret is at the start
        override func deleteBackward() {
            keyPressed(.delete)
        }
        
        override var hasText: Bool { true }
    }
}

#endif
