//
//  Timecode Conversion.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit

extension Timecode {
    
    /// Return a new `Timecode` object converted to a new frame rate, based on real time.
    /// Note: this process may be lossy.
    public func converted(to newFrameRate: FrameRate) -> Timecode? {
        
        // just return self if frameRate is equal
        guard frameRate != newFrameRate else {
            return self
        }
        
        // convert to new frame rate, retaining all ancillary property values
        
        return Timecode(realTimeValue: realTimeValue,
                        at: newFrameRate,
                        limit: upperLimit,
                        subFramesDivisor: subFramesDivisor,
                        displaySubFrames: displaySubFrames)
        
    }
    
}
