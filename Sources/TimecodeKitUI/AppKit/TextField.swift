//
//  TextField.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import AppKit
import TimecodeKit

extension Timecode {
    /// `NSTextField` subclass with timecode formatting.
    ///
    /// Formatter is in effect bypassed until all its properties are set (`frameRate`, `upperLimit`, `displaySubFrames`, `subFramesBase`).
    /// These can also be set after the class has initialized.
    ///
    /// See `.formatter` property to access these.
    @objc(TimecodeTextField)
    public class TextField: NSTextField {
        public required init?(coder: NSCoder) {
            super.init(coder: coder)
            
            formatter = TextFormatter()
            
            allowsEditingTextAttributes = false
            cell?.allowsEditingTextAttributes = false
        }
        
        // responder chain: triggered when user presses Esc key
        override public func cancelOperation(_ sender: Any?) {
            // super.cancelOperation(sender)
            
            // cancel changes to text
            abortEditing()
            
            // give focus back to self
            window?.makeFirstResponder(self)
        }
    }
}

extension Timecode {
    /// `NSTextFieldCell` subclass with timecode formatting.
    @objc(TimecodeTextFieldCell)
    public class TextFieldCell: NSTextFieldCell {
        public required init(coder: NSCoder) {
            super.init(coder: coder)
            
            formatter = TextFormatter()
            
            allowsEditingTextAttributes = false
        }
    }
}

#endif
