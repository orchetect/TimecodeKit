/// ----------------------------------------------
/// ----------------------------------------------
/// OTCore/Extensions/Foundation/NSAttributedString.swift
///
/// Borrowed from OTCore 1.4.2 under MIT license.
/// https://github.com/orchetect/OTCore
/// Methods herein are unit tested at their source
/// so no unit tests are necessary.
/// ----------------------------------------------
/// ----------------------------------------------

#if canImport(Foundation)

#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension NSAttributedString {
    /// Convenience. Returns a new `NSAttributedString` with the attribute applied to the entire string.
    @_disfavoredOverload
    func addingAttribute(alignment: NSTextAlignment) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = alignment
        
        guard let copy = mutableCopy() as? NSMutableAttributedString
        else {
            print("Could not create mutable NSAttributedString copy.")
            return self
        }
        
        copy.addAttributes(
            [.paragraphStyle: paragraph],
            range: NSRange(location: 0, length: length)
        )
        
        return copy
    }
}

extension NSMutableAttributedString {
    /// Convenience. Adds the attribute applied to the entire string.
    @_disfavoredOverload
    func addAttribute(alignment: NSTextAlignment) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = alignment
        
        addAttributes(
            [.paragraphStyle: paragraph],
            range: NSRange(location: 0, length: length)
        )
    }
}
#endif
