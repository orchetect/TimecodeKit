//
//  TextField.swift
//  SwiftTimecode
//
//  Created by Steffan Andrews on 2020-07-11.
//  Copyright © 2020 Steffan Andrews. All rights reserved.
//

#if os(macOS)

import Cocoa

extension OTTimecode {
	
	/// NSTextField subclass with timecode formatting
	///
	/// Formatter is in effect bypassed until all its properties are set (frameRate, upperLimit, displaySubFrames, subFramesDivisor). These can be set after the class has initialized.
	///
	/// See `.formatter` property to access these.
	@objc(OTTimecodeTextField)
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

extension OTTimecode {
	
	/// NSTextFieldCell subclass with timecode formatting
	@objc(OTTimecodeTextFieldCell)
	public class TextFieldCell: NSTextFieldCell {
		
		public required init(coder: NSCoder) {
			super.init(coder: coder)
			
			formatter = TextFormatter()
			
			self.allowsEditingTextAttributes = false
		}
		
	}
	
}

#endif
