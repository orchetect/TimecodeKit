//
//  NSAttributedString.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(AppKit)
import AppKit

extension NSAttributedString {
    /// Initializes a new `NSAttributedString` instance using the specified format and style,
    /// including the ability to colorize invalid timecode components.
    ///
    /// For example, to colorize invalid timecode components values using red:
    ///
    /// ```swift
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
    ///   - defaultAttributes: The base attributes applied to the entire string before ``invalidAttributes`` are
    ///     applied.
    ///   - invalidAttributes: The attributes applied to invalid values. This attribute overrides any
    ///     ``defaultAttributes``.
    public convenience init(
        _ timecode: Timecode,
        format: Timecode.StringFormat = .default(),
        defaultAttributes: [NSAttributedString.Key: Any]? = nil,
        invalidAttributes: [NSAttributedString.Key: Any]? = nil
    ) {
        let attrString = timecode.nsAttributedString(
            format: format,
            defaultAttributes: defaultAttributes,
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
    ///   - timecode: Timecode instance.
    ///   - format: String format options.
    ///   - defaultAttributes: The base attributes applied to the entire string before ``invalidAttributes`` are
    ///     applied.
    ///   - invalidAttributes: The attributes applied to invalid values. This attribute overrides any
    ///     ``defaultAttributes``.
    public func nsAttributedString(
        format: StringFormat = .default(),
        defaultAttributes: [NSAttributedString.Key: Any]?,
        invalidAttributes: [NSAttributedString.Key: Any]?
    ) -> NSAttributedString {
        let sepDays = NSAttributedString(string: " ", attributes: defaultAttributes)
        let sepMain = NSAttributedString(string: ":", attributes: defaultAttributes)
        let sepFrames = NSAttributedString(string: frameRate.isDrop ? ";" : ":", attributes: defaultAttributes)
        let sepSubFrames = NSAttributedString(string: ".", attributes: defaultAttributes)
        
        let invalids = invalidComponents
        
        let output = NSMutableAttributedString(string: "", attributes: defaultAttributes)
        
        var piece: NSMutableAttributedString
        
        // days
        if days != 0 {
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
        
        if format.showSubFrames {
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
            }
            
            output.append(piece)
        }
        
        return output
    }
}

#endif
