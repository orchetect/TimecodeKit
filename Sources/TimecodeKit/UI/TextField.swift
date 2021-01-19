//
//  TextField.swift
//  TimecodeKit
//
//  Created by Steffan Andrews on 2020-07-11.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

#if os(macOS)

import AppKit

extension Timecode {
	
	/// NSTextField subclass with timecode formatting
	///
	/// Formatter is in effect bypassed until all its properties are set (`frameRate`, `upperLimit`, `displaySubFrames`, `subFramesDivisor`). These can be set after the class has initialized.
	///
	/// See `.formatter` property to access these.
	@objc(TimecodeTextField)
	public class TextField: NSTextField {
		
		public required init?(coder: NSCoder) {
			
			super.init(coder: coder)
			
			self.formatter = TextFormatter()
			
			self.allowsEditingTextAttributes = false
			self.cell?.allowsEditingTextAttributes = false
			
		}
		
		// responder chain: triggered when user presses Esc key
		public override func cancelOperation(_ sender: Any?) {
			
			//super.cancelOperation(sender)
			
			// cancel changes to text
			abortEditing()
			
			// give focus back to self
			window?.makeFirstResponder(self)
			
		}
		
	}
	
}

extension Timecode {
	
	/// NSTextFieldCell subclass with timecode formatting
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
