//
//  Timecode String.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

#if os(macOS)
import AppKit
#elseif os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
import UIKit
#endif

// MARK: - FormattedTimecodeSource

extension String: _FormattedTimecodeSource {
    package func set(timecode: inout Timecode) throws {
        try timecode._setTimecode(exactly: self)
    }
    
    package func set(timecode: inout Timecode, by validation: Timecode.ValidationRule) throws {
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
    ///
    /// Valid formats for 24-hour:
    ///
    /// ```
    /// "00:00:00:00"     "00:00:00;00"
    /// "00:00:00:00.00"  "00:00:00;00.00"
    /// "00;00;00;00"     "00;00;00;00"
    /// "00;00;00;00.00"  "00;00;00;00.00"
    /// ```
    ///
    /// Valid formats for 100-day: All of the above, as well as:
    ///
    /// ```
    /// "0 00:00:00:00"     "0 00:00:00;00"
    /// "0:00:00:00:00"     "0:00:00:00;00"
    /// "0 00:00:00:00.00"  "0 00:00:00;00.00"
    /// "0:00:00:00:00.00"  "0:00:00:00;00.00"
    /// "0 00;00;00;00"     "0 00;00;00;00"
    /// "0;00;00;00;00"     "0;00;00;00;00"
    /// "0 00;00;00;00.00"  "0 00;00;00;00.00"
    /// "0;00;00;00;00.00"  "0;00;00;00;00.00"
    /// ```
    public static func string(_ timecodeString: String) -> Self {
        .init(value: timecodeString)
    }
    
    /// Timecode string.
    ///
    /// Valid formats for 24-hour:
    ///
    /// ```
    /// "00:00:00:00"     "00:00:00;00"
    /// "00:00:00:00.00"  "00:00:00;00.00"
    /// "00;00;00;00"     "00;00;00;00"
    /// "00;00;00;00.00"  "00;00;00;00.00"
    /// ```
    ///
    /// Valid formats for 100-day: All of the above, as well as:
    ///
    /// ```
    /// "0 00:00:00:00"     "0 00:00:00;00"
    /// "0:00:00:00:00"     "0:00:00:00;00"
    /// "0 00:00:00:00.00"  "0 00:00:00;00.00"
    /// "0:00:00:00:00.00"  "0:00:00:00;00.00"
    /// "0 00;00;00;00"     "0 00;00;00;00"
    /// "0;00;00;00;00"     "0;00;00;00;00"
    /// "0 00;00;00;00.00"  "0 00;00;00;00.00"
    /// "0;00;00;00;00.00"  "0;00;00;00;00.00"
    /// ```
    @_disfavoredOverload
    public static func string(_ timecodeString: some StringProtocol) -> Self {
        .init(value: String(timecodeString))
    }
}

// MARK: - Get

extension Timecode {
    // MARK: stringValue
    
    /// Returns the timecode's string representation.
    public func stringValue(
        format: StringFormat = .default()
    ) -> String {
        let sepDays = " "
        let sepMain = ":"
        let sepFrames = frameRate.isDrop ? ";" : ":"
        let sepSubFrames = "."
        
        var output = ""
        
        let showDays = format.contains(.alwaysShowDays) || days != 0
        output += "\(showDays ? "\(days)\(sepDays)" : "")"
        output += "\(String(format: "%02ld", hours))\(sepMain)"
        output += "\(String(format: "%02ld", minutes))\(sepMain)"
        output += "\(String(format: "%02ld", seconds))\(sepFrames)"
        output += "\(String(format: "%0\(frameRate.numberOfDigits)ld", frames))"
        
        if format.showSubFrames {
            let numberOfSubFramesDigits = validRange(of: .subFrames).upperBound.numberOfDigits
            
            output += "\(sepSubFrames)\(String(format: "%0\(numberOfSubFramesDigits)ld", subFrames))"
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
    
    /// Returns a more verbose output of the timecode's string representation including frame rate information.
    /// ie: "`01:00:00:00.00 @ 24 fps`"
    public var verboseStringValue: String {
        "\(stringValue(format: [.showSubFrames])) @ \(frameRate.stringValueVerbose)"
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
    /// Utility to decode a Timecode string into its component values, without validating component values.
    ///
    /// An error is thrown if the string is malformed and cannot be reasonably parsed. Raw values themselves will be passed as-is and not
    /// validated based on a frame rate or upper limit.
    ///
    /// Valid formats for 24-hour:
    ///
    /// ```
    /// "00:00:00:00"     "00:00:00;00"
    /// "00:00:00:00.00"  "00:00:00;00.00"
    /// "00;00;00;00"     "00;00;00;00"
    /// "00;00;00;00.00"  "00;00;00;00.00"
    /// ```
    ///
    /// Valid formats for 100-day: All of the above, as well as:
    ///
    /// ```
    /// "0 00:00:00:00"     "0 00:00:00;00"
    /// "0:00:00:00:00"     "0:00:00:00;00"
    /// "0 00:00:00:00.00"  "0 00:00:00;00.00"
    /// "0:00:00:00:00.00"  "0:00:00:00;00.00"
    /// "0 00;00;00;00"     "0 00;00;00;00"
    /// "0;00;00;00;00"     "0;00;00;00;00"
    /// "0 00;00;00;00.00"  "0 00;00;00;00.00"
    /// "0;00;00;00;00.00"  "0;00;00;00;00.00"
    /// ```
    ///
    /// - Throws: ``StringParseError``
    package static func decode(timecode string: some StringProtocol) throws -> Components {
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
