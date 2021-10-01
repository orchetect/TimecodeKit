//
//  Timecode Conversion.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit

extension Timecode {
    
    /// Return a new `Timecode` object converted to a new frame rate.
    ///
    /// - If `preservingValues` is `false` (default): entire timecode is converted based on the equivalent real time value.
    ///
    /// - If `preservingValues` is `true`: Return a new `Timecode` object at the new frame rate preserving literal timecode values if possible.
    ///   If any value is not expressible at the new frame rate, the entire timecode will be converted.
    ///
    /// - Note: this process may be lossy.
    public func converted(to newFrameRate: FrameRate,
                          preservingValues: Bool = false) throws -> Timecode {
        
        // just return self if frameRate is equal
        guard frameRate != newFrameRate else {
            return self
        }
        
        if preservingValues,
           let newTC = try? Timecode(components,
                                     at: newFrameRate,
                                     limit: upperLimit,
                                     base: subFramesBase,
                                     format: stringFormat) {
            return newTC
        }
        
        // convert to new frame rate, retaining all ancillary property values
        
        return try Timecode(realTimeValue: realTimeValue,
                            at: newFrameRate,
                            limit: upperLimit,
                            base: subFramesBase,
                            format: stringFormat)
        
    }
    
}
