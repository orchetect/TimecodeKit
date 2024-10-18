//
//  KeyboardInputView.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && (os(iOS) || os(tvOS) || os(visionOS))

import SwiftUI

/// An invisible view providing a native SwiftUI on-screen keyboard input experience.
@available(iOS 14, tvOS 17.0, *)
struct KeyboardInputView: UIViewRepresentable {
    typealias UIViewType = KeyboardInputTextField
    
    private var keyboardType: UIKeyboardType
    private var keyPressed: @MainActor (KeyEquivalent) -> Void
    
    init(
        keyboardType: UIKeyboardType = .default,
        keyPressed: @MainActor @escaping (KeyEquivalent) -> Void
    ) {
        self.keyboardType = keyboardType
        self.keyPressed = keyPressed
    }
    
    func makeUIView(context: Context) -> KeyboardInputTextField {
        KeyboardInputTextField(
            keyboardType: keyboardType,
            keyPressed: keyPressed
        )
    }
    
    func updateUIView(_ uiView: KeyboardInputTextField, context: Context) {
        uiView.keyboardType = keyboardType
        
        // we have to update the stored closure to reflect changes to the view's environment variables
        uiView.keyPressed = keyPressed
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
        var keyPressed: @MainActor (KeyEquivalent) -> Void
        
        init(
            keyboardType: UIKeyboardType,
            keyPressed: @MainActor @escaping (KeyEquivalent) -> Void
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
        
        // forward return key
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            keyPressed(.return)
            return false
        }
        
        // TODO: could forward this in the future as well
        // func textFieldShouldClear(_ textField: UITextField) -> Bool { }
        
        override var hasText: Bool { true }
    }
}

#endif
