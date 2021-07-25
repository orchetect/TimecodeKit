//
//  Strideable.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//

import Darwin

extension Timecode: Strideable {
    
    public typealias Stride = Int
    
    /// Returns a new instance advanced by specified time components.
    /// Same as calling `.adding(clamping: TCC(f: n))` but implemented in order to allow Timecode to conform to `Strideable`.
    /// Will clamp to valid timecode range.
    @inlinable public func advanced(by n: Int) -> Self {
        
        self.adding(clamping: Components(f: n))
        
    }
    
    /// Distance between two timecodes expressed as number of frames.
    /// Implemented in order to allow Timecode to conform to `Strideable`.
    @inlinable public func distance(to other: Self) -> Int {
        
        Int(trunc(other.totalElapsedFrames) - trunc(self.totalElapsedFrames))
        
    }
    
}
