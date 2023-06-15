//
//  Timecode Feet+Frames.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - TimecodeSource

extension FeetAndFrames: TimecodeSource {
    public func set(timecode: inout Timecode) throws {
        try timecode._setTimecode(exactly: self)
    }
    
    public func set(timecode: inout Timecode, by validation: Timecode.ValidationRule) {
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
    internal mutating func _setTimecode(exactly feetAndFrames: FeetAndFrames) throws {
        try _setTimecode(exactly: feetAndFrames.frameCount)
    }
    
    internal mutating func _setTimecode(clamping feetAndFrames: FeetAndFrames) {
        _setTimecode(clamping: feetAndFrames.frameCount)
    }
    
    internal mutating func _setTimecode(wrapping feetAndFrames: FeetAndFrames) {
        _setTimecode(wrapping: feetAndFrames.frameCount)
    }
    
    internal mutating func _setTimecode(rawValues feetAndFrames: FeetAndFrames) {
        _setTimecode(rawValues: feetAndFrames.frameCount)
    }
}
