//
//  NSAttributedString.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

extension NSAttributedString {
    /// Initializes a new `NSAttributedString` instance using the specified format and style,
    /// including the ability to colorize invalid timecode components.
    ///
    /// For example, to colorize invalid timecode components values using red:
    ///
    /// ```swift
    /// let timecode = try Timecode(.string("01:20:10:15"), at: .fps24)
    ///
    /// // macOS (AppKit)
    /// NSAttributedString(
    ///     timecode,
    ///     invalidAttributes: [.foregroundColor: NSColor.red]
    /// )
    ///
    /// // iOS / tvOS / watchOS / visionOS (UIKit)
    /// NSAttributedString(
    ///     timecode,
    ///     invalidAttributes: [.foregroundColor: UIColor.red]
    /// )
    /// ```
    ///
    /// - Parameters:
    ///   - timecode: Timecode instance.
    ///   - format: String format options.
    ///   - defaultAttributes: The base attributes applied to the entire string before `invalidAttributes` are
    ///     applied.
    ///   - separatorAttributes: The attributes applied to separator characters.
    ///   - subFramesAttributes: The attributes applied to valid subframes.
    ///   - invalidAttributes: The attributes applied to invalid values. This attribute overrides any
    ///     `defaultAttributes` and `subFramesAttributes`.
    public convenience init(
        _ timecode: Timecode,
        format: Timecode.StringFormat = .default(),
        defaultAttributes: [NSAttributedString.Key: Any]? = nil,
        separatorAttributes: [NSAttributedString.Key: Any]? = nil,
        subFramesAttributes: [NSAttributedString.Key: Any]? = nil,
        invalidAttributes: [NSAttributedString.Key: Any]? = nil
    ) {
        let attrString = timecode.nsAttributedString(
            format: format,
            defaultAttributes: defaultAttributes,
            separatorAttributes: separatorAttributes,
            subFramesAttributes: subFramesAttributes,
            invalidAttributes: invalidAttributes
        )
        self.init(attributedString: attrString)
    }
}

extension Timecode {
    /// Returns a new `NSAttributedString` instance using the specified format and style,
    /// including the ability to colorize invalid timecode components.
    ///
    /// For example, to colorize invalid timecode components values using red:
    ///
    /// ```swift
    /// let timecode = try Timecode(.string("01:20:10:15"), at: .fps24)
    ///
    /// // macOS (AppKit)
    /// timecode.nsAttributedString(
    ///     invalidAttributes: [.foregroundColor: NSColor.red]
    /// )
    ///
    /// // iOS / tvOS / watchOS / visionOS (UIKit)
    /// timecode.nsAttributedString(
    ///     invalidAttributes: [.foregroundColor: UIColor.red]
    /// )
    /// ```
    ///
    /// - Parameters:
    ///   - format: String format options.
    ///   - defaultAttributes: The base attributes applied to the entire string before `invalidAttributes` are
    ///     applied.
    ///   - separatorAttributes: The attributes applied to separator characters.
    ///   - subFramesAttributes: The attributes applied to valid subframes.
    ///   - invalidAttributes: The attributes applied to invalid values. This attribute overrides any
    ///     `defaultAttributes` and `subFramesAttributes`.
    public func nsAttributedString(
        format: StringFormat = .default(),
        defaultAttributes: [NSAttributedString.Key: Any]?,
        separatorAttributes: [NSAttributedString.Key: Any]? = nil,
        subFramesAttributes: [NSAttributedString.Key: Any]? = nil,
        invalidAttributes: [NSAttributedString.Key: Any]?
    ) -> NSAttributedString {
        let sepDays = NSAttributedString(string: " ", attributes: separatorAttributes ?? defaultAttributes)
        let sepMain = NSAttributedString(string: ":", attributes: separatorAttributes ?? defaultAttributes)
        let sepFrames = NSAttributedString(string: frameRate.isDrop ? ";" : ":", attributes: separatorAttributes ?? defaultAttributes)
        let sepSubFrames = NSAttributedString(string: ".", attributes: separatorAttributes ?? defaultAttributes)
        
        let invalids = invalidComponents
        
        let output = NSMutableAttributedString(string: "", attributes: defaultAttributes)
        
        var piece: NSMutableAttributedString
        
        // days
        if days != 0 || format.contains(.alwaysShowDays) {
            piece = NSMutableAttributedString(string: "\(days)", attributes: defaultAttributes)
            if let invalidAttributes, invalids.contains(.days) {
                piece.addAttributes(
                    invalidAttributes,
                    range: NSRange(location: 0, length: piece.string.count)
                )
            }
            
            output.append(piece)
            
            output.append(sepDays)
        }
        
        // hours
        
        piece = NSMutableAttributedString(
            string: String(format: "%02ld", hours),
            attributes: defaultAttributes
        )
        if let invalidAttributes, invalids.contains(.hours) {
            piece.addAttributes(
                invalidAttributes,
                range: NSRange(location: 0, length: piece.string.count)
            )
        }
        
        output.append(piece)
        
        output.append(sepMain)
        
        // minutes
        
        piece = NSMutableAttributedString(
            string: String(format: "%02ld", minutes),
            attributes: defaultAttributes
        )
        if let invalidAttributes, invalids.contains(.minutes) {
            piece.addAttributes(
                invalidAttributes,
                range: NSRange(location: 0, length: piece.string.count)
            )
        }
        
        output.append(piece)
        
        output.append(sepMain)
        
        // seconds
        
        piece = NSMutableAttributedString(
            string: String(format: "%02ld", seconds),
            attributes: defaultAttributes
        )
        if let invalidAttributes, invalids.contains(.seconds) {
            piece.addAttributes(
                invalidAttributes,
                range: NSRange(location: 0, length: piece.string.count)
            )
        }
        
        output.append(piece)
        
        output.append(sepFrames)
        
        // frames
        
        piece = NSMutableAttributedString(
            string:
                String(
                    format: "%0\(frameRate.numberOfDigits)ld",
                    frames
                ),
            attributes: defaultAttributes
        )
        if let invalidAttributes, invalids.contains(.frames) {
            piece.addAttributes(
                invalidAttributes,
                range: NSRange(location: 0, length: piece.string.count)
            )
        }
        
        output.append(piece)
        
        // subframes
        
        if format.contains(.showSubFrames) {
            let numberOfSubFramesDigits = validRange(of: .subFrames).upperBound.numberOfDigits
            
            output.append(sepSubFrames)
            
            piece = NSMutableAttributedString(
                string:
                    String(
                        format: "%0\(numberOfSubFramesDigits)ld",
                        subFrames
                    ),
                attributes: defaultAttributes
            )
            if let invalidAttributes, invalids.contains(.subFrames) {
                piece.addAttributes(
                    invalidAttributes,
                    range: NSRange(location: 0, length: piece.string.count)
                )
            } else if let subFramesAttributes {
                piece.addAttributes(
                    subFramesAttributes,
                    range: NSRange(location: 0, length: piece.string.count)
                )
            }
            
            output.append(piece)
        }
        
        return output
    }
}
