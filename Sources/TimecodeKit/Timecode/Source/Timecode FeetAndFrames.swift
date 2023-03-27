//
//  Timecode Feet+Frames.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - TimecodeSource

extension FeetAndFrames: TimecodeSource {
    public func set(timecode: inout Timecode) throws {
        try timecode.setTimecode(exactly: self)
    }
    
    public func set(timecode: inout Timecode, by validation: Timecode.ValidationRule) {
        switch validation {
        case .clamping, .clampingEach:
            timecode.setTimecode(clamping: self)
        case .wrapping:
            timecode.setTimecode(wrapping: self)
        case .allowingInvalidComponents:
            timecode.setTimecode(rawValues: self)
        }
    }
}

extension TimecodeSource where Self == FeetAndFrames {
    /// Feet and Frames time value.
    public static func feetAndFrames(_ source: FeetAndFrames) -> Self {
        source
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
            subFrames: components.subFrames,
            subFramesBase: properties.subFramesBase
        )
    }
}

// MARK: - Set

extension Timecode {
    internal mutating func setTimecode(exactly feetAndFrames: FeetAndFrames) throws {
        try setTimecode(exactly: feetAndFrames.frameCount)
    }
    
    internal mutating func setTimecode(clamping feetAndFrames: FeetAndFrames) {
        setTimecode(clamping: feetAndFrames.frameCount)
    }
    
    internal mutating func setTimecode(wrapping feetAndFrames: FeetAndFrames) {
        setTimecode(wrapping: feetAndFrames.frameCount)
    }
    
    internal mutating func setTimecode(rawValues feetAndFrames: FeetAndFrames) {
        setTimecode(rawValues: feetAndFrames.frameCount)
    }
}
