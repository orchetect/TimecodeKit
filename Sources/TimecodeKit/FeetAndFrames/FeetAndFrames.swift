//
//  FeetAndFrames.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Feet+Frames value.
///
/// Feet+Frames is a time domain that is seldomly used in video editing.
///
/// Initializers and properties on ``Timecode`` are available to convert to or from Feet+Frames.
///
/// When used as a counter in the audio-world the footage count refers to 35mm 4-perf. Detailed
/// discussion can be found [in this thread.](
/// https://gearspace.com/board/post-production-forum/898755-timecode-feet-frames.html
/// )
public struct FeetAndFrames: Equatable, Hashable {
    public var feet: Int
    public var frames: Int
    public var subFrames: Int
    public var subFramesBase: Timecode.SubFramesBase
    
    public init(
        feet: Int,
        frames: Int,
        subFrames: Int = 0,
        subFramesBase: Timecode.SubFramesBase = .default()
    ) {
        self.feet = feet
        self.frames = frames
        self.subFrames = subFrames
        self.subFramesBase = subFramesBase
    }
}

extension FeetAndFrames: CustomStringConvertible {
    public var description: String {
        stringValue
    }
}

extension FeetAndFrames {
    /// Returns string value, suitable for display in UI.
    public var stringValue: String {
        "\(feet)+\(String(format: "%02d", frames))"
    }

    /// Returns string value including subframes, suitable for display in UI.
    public var stringValueVerbose: String {
        "\(stringValue).\(String(format: "%02d", subFrames))"
    }
}

extension FeetAndFrames {
    /// Returns the total number of frames elapsed.
    public var frameCount: Timecode.FrameCount {
        let fc = frames + (feet * 16)
        
        switch subFrames != 0 {
        case true:
            return .init(.split(frames: fc, subFrames: subFrames), base: subFramesBase)
        case false:
            return .init(.frames(fc), base: subFramesBase)
        }
    }
}
