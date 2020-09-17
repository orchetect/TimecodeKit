//
//  File.swift
//  SwiftTimecode
//
//  Created by Steffan Andrews on 2020-09-17.
//

#if os(macOS)
import Cocoa
#elseif os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#endif

extension NSAttributedString {
	
	/// CUSTOM SHARED:
	/// Convenience. Returns a new `NSAttributedString` with the attribute applied to the entire string.
	internal func addingAttribute(alignment: NSTextAlignment) -> NSAttributedString {
		
		let paragraph = NSMutableParagraphStyle()
		paragraph.alignment = alignment
		
		guard let copy = self.mutableCopy() as? NSMutableAttributedString
			else { return self }
		
		copy.addAttributes([ .paragraphStyle : paragraph ],
						   range: NSRange(location: 0, length: self.length))
		
		return copy
		
	}
	
}

extension NSMutableAttributedString {
	
	/// CUSTOM SHARED:
	/// Convenience. Adds the attribute applied to the entire string.
	internal func addAttribute(alignment: NSTextAlignment) {
		
		let paragraph = NSMutableParagraphStyle()
		paragraph.alignment = alignment
		
		self.addAttributes([ .paragraphStyle : paragraph ],
						   range: NSRange(location: 0, length: self.length))
		
	}
	
}
