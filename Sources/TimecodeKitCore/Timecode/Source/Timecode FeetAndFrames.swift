//
//  Timecode FeetAndFrames.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - TimecodeSource

extension FeetAndFrames: _TimecodeSource {
    func set(timecode: inout Timecode) throws {
        try timecode._setTimecode(exactly: self)
    }
    
    func set(timecode: inout Timecode, by validation: Timecode.ValidationRule) {
        switch validation {
        case .clamping, .clampingComponents:
            timecode._setTimecode(clamping: self)
        case .wrapping:
            timecode._setTimecode(wrapping: self)
        case .allowingInvalid:
            timecode._setTimecode(rawValues: self)
        }
    }
}

// MARK: - Static Constructors

extension TimecodeSourceValue {
    /// Feet and Frames time value.
    public static func feetAndFrames(_ source: FeetAndFrames) -> Self {
        .init(value: source)
    }
    
    /// Feet and Frames time value.
    public static func feetAndFrames(
        feet: Int,
        frames: Int,
        subFrames: Int = 0,
        subFramesBase: Timecode.SubFramesBase = .default()
    ) -> Self {
        .init(value: FeetAndFrames(
            feet: feet,
            frames: frames,
            subFrames: subFrames,
            subFramesBase: subFramesBase
        ))
    }
    
    /// Feet and Frames time value.
    public static func feetAndFrames(
        _ string: some StringProtocol,
        subFramesBase: Timecode.SubFramesBase = .default()
    ) throws -> Self {
        try .init(value: FeetAndFrames(
            string,
            subFramesBase: subFramesBase
        ))
    }
}

// MARK: - Get

extension Timecode {
    /// Returns the timecode expressed as Feet+Frames.
    ///
    /// When used as a counter in the audio-world the footage count refers to 35mm 4-perf. Detailed
    /// discussion can be found [in this thread.](
    /// https://gearspace.com/board/post-production-forum/898755-timecode-feet-frames.html
    /// )
    public var feetAndFramesValue: FeetAndFrames {
        let fc = frameCount.wholeFrames
        let feet = fc / 16
        let frames = fc % 16
        
        return FeetAndFrames(
            feet: feet,
            frames: frames,
            subFrames: subFrames,
            subFramesBase: subFramesBase
        )
    }
}

// MARK: - Set

extension Timecode {
    mutating func _setTimecode(exactly feetAndFrames: FeetAndFrames) throws {
        try _setTimecode(exactly: feetAndFrames.frameCount)
    }
    
    mutating func _setTimecode(clamping feetAndFrames: FeetAndFrames) {
        _setTimecode(clamping: feetAndFrames.frameCount)
    }
    
    mutating func _setTimecode(wrapping feetAndFrames: FeetAndFrames) {
        _setTimecode(wrapping: feetAndFrames.frameCount)
    }
    
    mutating func _setTimecode(rawValues feetAndFrames: FeetAndFrames) {
        _setTimecode(rawValues: feetAndFrames.frameCount)
    }
}

extension FeetAndFrames {
    /// Utility to decode a Feet+Frames string into its component values, without validating component values.
    ///
    /// An error is thrown if the string is malformed and cannot be reasonably parsed.
    /// Raw values themselves will be passed as-is and not validated.
    ///
    /// - Throws: ``Timecode/StringParseError``
    static func decode(feetAndFrames string: some StringProtocol) throws -> (feet: Int, frames: Int, subFrames: Int) {
        let pattern = #"^([\d]+)\+([\d]+)(?:\.([\d]+))?$"#
        
        let matches = string.regexMatches(captureGroupsFromPattern: pattern)
        
        guard matches.count == 4 else {
            throw Timecode.StringParseError.malformed
        }
        
        guard let ftString = matches[1],
              let ft = Int(ftString),
              let frString = matches[2],
              let fr = Int(frString)
        else {
            throw Timecode.StringParseError.malformed
        }
        
        let feet = ft
        let frames = fr
        
        // subframes are optional and may not be present
        let subFrames: Int
        if let sfrString = matches[3] {
            guard let sfr = Int(sfrString) else {
                throw Timecode.StringParseError.malformed
            }
            subFrames = sfr
        } else {
            subFrames = 0
        }
        
        return (feet: feet, frames: frames, subFrames: subFrames)
    }
}
