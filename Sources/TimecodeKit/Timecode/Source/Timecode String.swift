//
//  Timecode String.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation

#if os(macOS)
import AppKit
#elseif os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
import UIKit
#endif

// MARK: - FormattedTimecodeSource

extension String: FormattedTimecodeSource {
    public func set(timecode: inout Timecode) throws {
        try timecode._setTimecode(exactly: self)
    }
    
    public func set(timecode: inout Timecode, by validation: Timecode.ValidationRule) throws {
        switch validation {
        case .clamping:
            try timecode._setTimecode(clamping: self)
        case .clampingComponents:
            try timecode._setTimecode(clampingComponents: self)
        case .wrapping:
            try timecode._setTimecode(wrapping: self)
        case .allowingInvalid:
            try timecode._setTimecode(rawValues: self)
        }
    }
}

// MARK: - Static Constructors

extension FormattedTimecodeSourceValue {
    /// Timecode string.
    public static func string(_ timecodeString: String) -> Self {
        .init(value: timecodeString)
    }
    
    /// Timecode string.
    @_disfavoredOverload
    public static func string<S: StringProtocol>(_ timecodeString: S) -> Self {
        .init(value: String(timecodeString))
    }
}

// MARK: - Get

extension Timecode {
    // MARK: stringValue
    
    /// Timecode string representation.
    ///
    /// Valid formats for 24-hour:
    ///
    ///     "00:00:00:00" "00:00:00;00"
    ///     "0:00:00:00" "0:00:00;00"
    ///     "00000000"
    ///
    /// Valid formats for 100-day: All of the above, as well as:
    ///
    ///     "0 00:00:00:00" "0 00:00:00;00"
    ///     "0:00:00:00:00" "0:00:00:00;00"
    ///
    /// (Validation is based on the frame rate and `upperLimit` property.)
    public func stringValue(
        format: StringFormat = .default()
    ) -> String {
        let sepDays = " "
        let sepMain = ":"
        let sepFrames = frameRate.isDrop ? ";" : ":"
        let sepSubFrames = "."
        
        var output = ""
        
        output += "\(days != 0 ? "\(days)\(sepDays)" : "")"
        output += "\(String(format: "%02d", hours))\(sepMain)"
        output += "\(String(format: "%02d", minutes))\(sepMain)"
        output += "\(String(format: "%02d", seconds))\(sepFrames)"
        output += "\(String(format: "%0\(frameRate.numberOfDigits)d", frames))"
        
        if format.showSubFrames {
            let numberOfSubFramesDigits = validRange(of: .subFrames).upperBound.numberOfDigits
            
            output += "\(sepSubFrames)\(String(format: "%0\(numberOfSubFramesDigits)d", subFrames))"
        }
        
        if format.contains(.filenameCompatible) {
            return output
                .replacingOccurrences(of: ":", with: "-")
                .replacingOccurrences(of: ";", with: "-")
                .replacingOccurrences(of: " ", with: "-")
        } else {
            return output
        }
    }
    
    // MARK: stringValueValidated
    
    /// Returns ``stringValue(format:)`` as `NSAttributedString`, highlighting
    /// invalid values.
    ///
    /// `invalidAttributes` are the `NSAttributedString` attributes applied to invalid values.
    /// If `invalidAttributes` are not passed, the default of red foreground color is used.
    public func stringValueValidated(
        format: StringFormat = .default(),
        invalidAttributes: [NSAttributedString.Key: Any]? = nil,
        withDefaultAttributes attrs: [NSAttributedString.Key: Any]? = nil
    ) -> NSAttributedString {
        let sepDays = NSAttributedString(string: " ", attributes: attrs)
        let sepMain = NSAttributedString(string: ":", attributes: attrs)
        let sepFrames = NSAttributedString(string: frameRate.isDrop ? ";" : ":", attributes: attrs)
        let sepSubFrames = NSAttributedString(string: ".", attributes: attrs)
        
        #if os(macOS)
        let invalidColor = invalidAttributes
            ?? [.foregroundColor: NSColor.red]
        #elseif os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
        let invalidColor = invalidAttributes
            ?? [.foregroundColor: UIColor.red]
        #else
        let invalidColor = invalidAttributes
            ?? [:]
        #endif
        
        let invalids = invalidComponents
        
        let output = NSMutableAttributedString(string: "", attributes: attrs)
        
        var piece: NSMutableAttributedString
        
        // days
        if days != 0 {
            piece = NSMutableAttributedString(string: "\(days)", attributes: attrs)
            if invalids.contains(.days) {
                piece.addAttributes(
                    invalidColor,
                    range: NSRange(location: 0, length: piece.string.count)
                )
            }
            
            output.append(piece)
            
            output.append(sepDays)
        }
        
        // hours
        
        piece = NSMutableAttributedString(
            string: String(format: "%02d", hours),
            attributes: attrs
        )
        if invalids.contains(.hours) {
            piece.addAttributes(
                invalidColor,
                range: NSRange(location: 0, length: piece.string.count)
            )
        }
        
        output.append(piece)
        
        output.append(sepMain)
        
        // minutes
        
        piece = NSMutableAttributedString(
            string: String(format: "%02d", minutes),
            attributes: attrs
        )
        if invalids.contains(.minutes) {
            piece.addAttributes(
                invalidColor,
                range: NSRange(location: 0, length: piece.string.count)
            )
        }
        
        output.append(piece)
        
        output.append(sepMain)
        
        // seconds
        
        piece = NSMutableAttributedString(
            string: String(format: "%02d", seconds),
            attributes: attrs
        )
        if invalids.contains(.seconds) {
            piece.addAttributes(
                invalidColor,
                range: NSRange(location: 0, length: piece.string.count)
            )
        }
        
        output.append(piece)
        
        output.append(sepFrames)
        
        // frames
        
        piece = NSMutableAttributedString(
            string:
            String(
                format: "%0\(frameRate.numberOfDigits)d",
                frames
            ),
            attributes: attrs
        )
        if invalids.contains(.frames) {
            piece.addAttributes(
                invalidColor,
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
                    format: "%0\(numberOfSubFramesDigits)d",
                    subFrames
                ),
                attributes: attrs
            )
            if invalids.contains(.subFrames) {
                piece.addAttributes(
                    invalidColor,
                    range: NSRange(location: 0, length: piece.string.count)
                )
            }
            
            output.append(piece)
        }
        
        return output
    }
}

// MARK: - Set

extension Timecode {
    /// Set timecode from a timecode string. Values which are out-of-bounds will also cause the setter to fail, and return false. An error
    /// is thrown if the string is malformed and cannot be reasonably parsed.
    ///
    /// Validation is based on the `upperLimit` and `subFramesBase` properties.
    ///
    /// - Throws: ``StringParseError`` or ``ValidationError``
    mutating func _setTimecode(exactly string: String) throws {
        let decoded = try Timecode.decode(timecode: string)
        try _setTimecode(exactly: decoded)
    }
    
    /// Set timecode from a timecode string, clamping to valid timecode if necessary. An error is thrown if the string is malformed and
    /// cannot be reasonably parsed.
    ///
    /// Clamping is based on the `upperLimit` and `subFramesBase` properties.
    ///
    /// - Throws: ``StringParseError``
    mutating func _setTimecode(clamping string: String) throws {
        let tcVals = try Timecode.decode(timecode: string)
        _setTimecode(clamping: tcVals)
    }
    
    /// Set timecode from a timecode string, clamping individual values if necessary. Individual values which are out-of-bounds will be
    /// clamped to minimum or maximum possible values. An error is thrown if the string is malformed and cannot be reasonably parsed.
    ///
    /// Returns true/false depending on whether the string is formatted correctly or not.
    ///
    /// Clamping is based on the `upperLimit` and `subFramesBase` properties.
    ///
    /// - Throws: ``StringParseError``
    mutating func _setTimecode(clampingComponents string: String) throws {
        let tcVals = try Timecode.decode(timecode: string)
        _setTimecode(clampingComponents: tcVals)
    }
    
    /// Set timecode from a string. Values which are out-of-bounds will be clamped to minimum or maximum possible values. An error is thrown
    /// if the string is malformed and cannot be reasonably parsed.
    ///
    /// Clamping is based on the `upperLimit` and `subFramesBase` properties.
    ///
    /// - Throws: ``StringParseError``
    mutating func _setTimecode(wrapping string: String) throws {
        let tcVals = try Timecode.decode(timecode: string)
        _setTimecode(wrapping: tcVals)
    }
    
    /// Set timecode from a string, treating components as raw values. Timecode values will not be validated or rejected if they overflow.
    /// An error is thrown if the string is malformed and cannot be reasonably parsed.
    ///
    /// This is useful, for example, when intending on running timecode validation methods against timecode values that are unknown to be
    /// valid or not at the time of initializing.
    ///
    /// - Throws: ``StringParseError``
    mutating func _setTimecode(rawValues string: String) throws {
        let tcVals = try Timecode.decode(timecode: string)
        _setTimecode(rawValues: tcVals)
    }
}

extension Timecode {
    /// Decodes a Timecode string into its component values, without validating.
    ///
    /// An error is thrown if the string is malformed and cannot be reasonably parsed. Raw values themselves will be passed as-is and not
    /// validated based on a frame rate or upper limit.
    ///
    /// Valid formats for 24-hour:
    ///
    ///     "00:00:00:00"    "00:00:00;00"
    ///     "00:00:00:00.00" "00:00:00;00.00"
    ///     "00;00;00;00"    "00;00;00;00"
    ///     "00;00;00;00.00" "00;00;00;00.00"
    ///
    /// Valid formats for 100-day: All of the above, as well as:
    ///
    ///     "0 00:00:00:00" "0 00:00:00;00"
    ///     "0:00:00:00:00" "0:00:00:00;00"
    ///     "0 00:00:00:00.00" "0 00:00:00;00.00"
    ///     "0:00:00:00:00.00" "0:00:00:00;00.00"
    ///     "0 00;00;00;00" "0 00;00;00;00"
    ///     "0;00;00;00;00" "0;00;00;00;00"
    ///     "0 00;00;00;00.00" "0 00;00;00;00.00"
    ///     "0;00;00;00;00.00" "0;00;00;00;00.00"
    ///
    /// - Throws: ``StringParseError``
    public static func decode(timecode string: String) throws -> Components {
        let pattern = #"^(\d+)??[\:;\s]??(\d+)[\:;](\d+)[\:;](\d+)[\:\;](\d+)[\.]??(\d+)??$"#
        
        let matches = string
            .regexMatches(captureGroupsFromPattern: pattern)
            .dropFirst()
        
        // attempt to convert strings to integers, preserving indexes and preserving nils
        // essentially converting [String?] to [Int?]
        // note: don't use compactMap here
        
        let ints = matches.map { $0 == nil ? nil : Int($0!) }
        
        // basic check - ensure there's at least 4 values but no more than 6
        
        let nonNilCount = ints.reduce(0) { $1 != nil ? $0 + 1 : $0 }
        
        guard (4 ... 6).contains(nonNilCount)
        else { throw StringParseError.malformed }
        
        // return components
        
        return Components(
            d:  ints[0] ?? 0,
            h:  ints[1] ?? 0,
            m:  ints[2] ?? 0,
            s:  ints[3] ?? 0,
            f:  ints[4] ?? 0,
            sf: ints[5] ?? 0
        )
    }
}
