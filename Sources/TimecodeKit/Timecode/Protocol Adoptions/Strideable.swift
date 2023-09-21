//
//  Strideable.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import Darwin

extension Timecode: Strideable {
    public typealias Stride = Int
    
    /// Returns a new instance advanced by specified time components.
    /// Same as calling `.adding(clamping: Timecode.Components(f: n))` but implemented in order to allow Timecode to conform to
    /// `Strideable`.
    /// Will clamp to valid timecode range.
    public func advanced(by n: Stride) -> Self {
        adding(Components(f: n), by: .clamping)
    }
    
    /// Distance between two timecode expressed as number of frames.
    /// Implemented in order to allow Timecode to conform to `Strideable`.
    public func distance(to other: Self) -> Stride {
        other.frameCount.wholeFrames - frameCount.wholeFrames
    }
}
