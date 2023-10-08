//
//  FeetAndFrames.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Feet+Frames is a time reference traditionally used when measuring and splicing physical film, but its use in modern day is uncommon.
/// Some digital video editors and DAWs support this time format.
///
/// Initializers and properties on ``Timecode`` are available to convert to or from Feet+Frames.
///
/// When used as a counter in the audio-world the footage count refers to 35mm 4-perf. Detailed
/// discussion can be found [in this thread.](
/// https://gearspace.com/board/post-production-forum/898755-timecode-feet-frames.html
/// )
///
/// For added precision, ``subFrames`` are an optional additional component.
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
    
    /// Initialize from a Feet+Frames string value.
    /// Throws an error if the string is not formatted correctly.
    ///
    /// - Throws: ``Timecode/StringParseError``
    public init<S: StringProtocol>(
        _ string: S,
        subFramesBase: Timecode.SubFramesBase = .default()
    ) throws {
        let decoded = try Self.decode(feetAndFrames: string)
        
        feet = decoded.feet
        frames = decoded.frames
        subFrames = decoded.subFrames
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
        "\(feet)+\(String(format: "%02ld", frames))"
    }

    /// Returns string value including subframes, suitable for display in UI.
    public var stringValueVerbose: String {
        "\(stringValue).\(String(format: "%02ld", subFrames))"
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
