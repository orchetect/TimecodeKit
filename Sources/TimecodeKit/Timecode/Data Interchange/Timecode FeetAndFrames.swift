//
//  Timecode Feet+Frames.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - Init

extension Timecode {
    /// Instance exactly from Feet+Frames.
    ///
    /// If any values are out-of-bounds an error will be thrown, indicating an invalid timecode.
    ///
    /// Validation is based on the `upperLimit` and `subFramesBase` properties.
    ///
    /// When used as a counter in the audio-world the footage count refers to 35mm 4-perf. Detailed
    /// discussion can be found [in this thread.](
    /// https://gearspace.com/board/post-production-forum/898755-timecode-feet-frames.html
    /// )
    ///
    /// - Throws: ``ValidationError``
    public init(
        _ exactly: FeetAndFrames,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default()
    ) throws {
        properties = Properties(rate: rate, base: base, limit: limit)
        
        try setTimecode(exactly: exactly)
    }
}

// MARK: - Get and Set

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
    
    /// Set timecode from Feet+Frames.
    ///
    /// Returns true/false depending on whether the string values are valid or not.
    ///
    /// Values which are out-of-bounds will return false.
    ///
    /// (Validation is based on the frame rate and `upperLimit` property.)
    ///
    /// When used as a counter in the audio-world the footage count refers to 35mm 4-perf. Detailed
    /// discussion can be found [in this thread.](
    /// https://gearspace.com/board/post-production-forum/898755-timecode-feet-frames.html
    /// )
    ///
    /// - Throws: ``ValidationError``
    public mutating func setTimecode(exactly feetAndFrames: FeetAndFrames) throws {
        try setTimecode(exactly: feetAndFrames.frameCount)
    }
}
