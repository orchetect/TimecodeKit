//
//  TextFormatter.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)
import AppKit
#elseif os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#else
import Foundation
#endif

// MARK: - TextFormatter

extension Timecode {
    /// `Formatter` subclass. (`@objC` name `TimecodeTextFormatter`)
    /// `Timecode` string formatter capable of displaying invalid timecode components with special formatting.
    @objc(TimecodeTextFormatter)
    public class TextFormatter: Formatter {
        // MARK: properties
        
        public var frameRate: TimecodeFrameRate?
        public var upperLimit: Timecode.UpperLimit?
        public var subFramesBase: SubFramesBase?
        public var stringFormat: Timecode.StringFormat = .default()
        
        /// The formatter's `attributedString(...) -> NSAttributedString` output will override a control's alignment (ie: `NSTextField`).
        /// Setting alignment here will add the appropriate paragraph alignment attribute to the output `NSAttributedString`.
        public var alignment: NSTextAlignment = .natural
        
        /// When set true, invalid timecode component values are individually attributed.
        public var showsValidation: Bool = false
        
        /// The `NSAttributedString` attributes applied to invalid values if `showsValidation` is set.
        ///
        /// Defaults to red foreground color.
        
        public var validationAttributes: [NSAttributedString.Key: Any] = {
            #if os(macOS)
            return [.foregroundColor: NSColor.red]
            #elseif os(iOS) || os(tvOS) || os(watchOS)
            return [.foregroundColor: UIColor.red]
            #else
            return []
            #endif
        }()
        
        // MARK: init
        
        public required init?(coder: NSCoder) {
            
            super.init(coder: coder)
        }
        
        public init(
            properties: Timecode.Properties? = nil,
            stringFormat: StringFormat? = nil,
            showsValidation: Bool = false,
            validationAttributes: [NSAttributedString.Key: Any]? = nil
        ) {
            super.init()
            
            frameRate = properties?.frameRate
            upperLimit = properties?.upperLimit
            subFramesBase = properties?.subFramesBase
            self.stringFormat = stringFormat ?? .default()
            
            self.showsValidation = showsValidation
            
            if let unwrappedValidationAttributes = validationAttributes {
                self.validationAttributes = unwrappedValidationAttributes
            }
        }
        
        /// Initializes with properties from an `Timecode` object.
        public convenience init(
            using timecode: Timecode,
            stringFormat: StringFormat? = nil,
            showsValidation: Bool = false,
            validationAttributes: [NSAttributedString.Key: Any]? = nil
        ) {
            self.init(
                properties: timecode.properties,
                stringFormat: stringFormat,
                showsValidation: showsValidation,
                validationAttributes: validationAttributes
            )
        }
        
        public func inheritProperties(from other: Timecode.TextFormatter) {
            frameRate = other.frameRate
            upperLimit = other.upperLimit
            subFramesBase = other.subFramesBase
            stringFormat = other.stringFormat
            
            alignment = other.alignment
            showsValidation = other.showsValidation
            validationAttributes = other.validationAttributes
        }
        
        // MARK: - Override methods
        
        // MARK: string
        
        override public func string(for obj: Any?) -> String? {
            guard let string = obj as? String
            else { return nil }
            
            guard var tc = timecodeTemplate
            else { return string }
            
            // form timecode components without validating
            guard let tcc = try? Timecode.decode(timecode: string)
            else { return string }
            
            // set values without validating
            tc.setTimecode(rawValues: tcc)
            
            return tc.stringValue(format: stringFormat)
        }
        
        // MARK: attributedString
        
        override public func attributedString(
            for obj: Any,
            withDefaultAttributes attrs: [NSAttributedString.Key: Any]? = nil
        ) -> NSAttributedString? {
            guard let stringForObj = string(for: obj)
            else { return nil }
            
            func entirelyInvalid() -> NSAttributedString {
                showsValidation
                    ? NSAttributedString(
                        string: stringForObj,
                        attributes: validationAttributes
                            .merging(
                                attrs ?? [:],
                                uniquingKeysWith: { current, _ in current }
                            )
                    )
                    .addingAttribute(alignment: alignment)
                    : NSAttributedString(string: stringForObj, attributes: attrs)
                        .addingAttribute(alignment: alignment)
            }
            
            // grab properties from the formatter
            guard var tc = timecodeTemplate else { return entirelyInvalid() }
            
            // form timecode components without validating
            guard let tcc = try? Timecode.decode(timecode: stringForObj)
            else { return entirelyInvalid() }
            
            // set values without validating
            tc.setTimecode(rawValues: tcc)
            
            return (
                showsValidation
                    ? tc.stringValueValidated(
                        invalidAttributes: validationAttributes,
                        withDefaultAttributes: attrs
                    )
                    : NSAttributedString(string: stringForObj, attributes: attrs)
            )
            .addingAttribute(alignment: alignment)
        }
        
        override public func getObjectValue(
            _ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
            for string: String,
            errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?
        ) -> Bool {
            obj?.pointee = string as NSString
            return true
        }
        
        // MARK: isPartialStringValid
        
        override public func isPartialStringValid(
            _ partialStringPtr: AutoreleasingUnsafeMutablePointer<NSString>,
            proposedSelectedRange proposedSelRangePtr: NSRangePointer?,
            originalString origString: String,
            originalSelectedRange origSelRange: NSRange,
            errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?
        ) -> Bool {
            guard let unwrappedFrameRate = frameRate,
                  let unwrappedUpperLimit = upperLimit
                  // let unwrappedSubFramesBase = subFramesBase,
            else { return true }
            
            let partialString = partialStringPtr.pointee as String
            
            // baseline checks
            
            if partialString.isEmpty { return true } // allow empty field
            // if partialString.count > 20 { return false } // don't allow too many chars
            
            // constants
            
            let numberChars = CharacterSet(charactersIn: "0123456789")
            // let coreSeparatorChars = CharacterSet(charactersIn: ":;")
            // let allSeparatorChars = CharacterSet(charactersIn: ":;. ")
            
            let allowedChars = CharacterSet(charactersIn: "0123456789:;. ")
            let disallowedChars = allowedChars.inverted
            
            // more baseline checks
            
            if let _ = partialString.rangeOfCharacter(
                from: disallowedChars,
                options: .caseInsensitive
            ) {
                error?.pointee = NSString("Invalid characters.")
                return false
            }
            
            // parse
            
            var string = ""
            var fixed = false
            var consecutiveIntCount = 0
            var intGrouping = 0
            var spaceCount = 0
            var colonCount = 0
            var periodCount = 0
            var lastChar: Character?
            
            for var char in partialString {
                // prep
                
                if numberChars.contains(char) {
                    consecutiveIntCount += 1
                }
                
                // separators
                
                switch char {
                case ".":
                    if colonCount < 3 {
                        char = unwrappedFrameRate.isDrop && (colonCount == 2)
                            ? ";"
                            : ":"
                        
                        fixed = true
                    } else if periodCount == 0 { break }
                    else { return false }
                    
                case ";":
                    if colonCount < 3 {
                        char = unwrappedFrameRate.isDrop && (colonCount == 2)
                            ? ";"
                            : ":"
                        
                        fixed = true
                    }
                    
                default: break
                }
                
                if char == " " {
                    if unwrappedUpperLimit == ._24hours
                    { return false }
                    
                    if !(
                        intGrouping == 1
                            && spaceCount == 0
                            && colonCount == 0
                            && periodCount == 0
                    )
                    { return false }
                    
                    spaceCount += 1
                }
                
                // separator validation
                
                if char == ":" || char == ";"
                { colonCount += 1; consecutiveIntCount = 0 }
                
                if (char == ":" || char == ";"), colonCount >= 4
                { return false }
                
                // period validation
                
                if char == "."
                { periodCount += 1 }
                
                if char == ".", periodCount > 1
                { return false }
                
                if char == ".", !stringFormat.showSubFrames
                { return false }
                
                // number validation (?)
                
                // cleanup
                
                if numberChars.contains(char) {
                    if let unwrappedLastChar = lastChar {
                        if !numberChars.contains(unwrappedLastChar)
                        { intGrouping += 1 }
                    } else {
                        intGrouping += 1
                    }
                }
                
                // cycle variables
                
                lastChar = char
                
                // append char
                
                string += "\(char)"
            }
            
            if fixed {
                partialStringPtr.pointee = NSString(string: string)
                return false
            } else {
                return true
            }
        }
    }
}

// MARK: timecodeTemplate

extension Timecode.TextFormatter {
    public var timecodeTemplate: Timecode? {
        guard let unwrappedFrameRate = frameRate,
              let unwrappedUpperLimit = upperLimit,
              let unwrappedSubFramesBase = subFramesBase
        else {
            return nil
        }
        
        return Timecode(
            at: unwrappedFrameRate,
            limit: unwrappedUpperLimit,
            base: unwrappedSubFramesBase
        )
    }
}
