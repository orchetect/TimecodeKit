//
//  Timecode Conversion.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

extension Timecode {
    // MARK: - FrameRate
    
    /// Return a new `Timecode` object converted to a new frame rate.
    ///
    /// - Warning: This conversion process may be lossy.
    ///
    /// - Parameters:
    ///   - newFrameRate: New frame rate.
    ///     If the new rate is identical to the current rate, the timecode will be returned unchanged.
    ///
    ///   - newSubFramesBase: New sub-frames base (optional).
    ///
    ///     If not specified, the current sub-frames base will be preserved.
    ///
    ///   - preservingValues: Preserve literal timecode component values. (Default: `false`)
    ///
    ///     When `true`, a new `Timecode` instance at the new frame rate is returned, preserving literal timecode values
    ///     if possible. If any values are invalid at the new frame rate, an error is thrown.
    ///     If any value is not expressible at the new frame rate, the entire timecode will be converted.
    ///     When `false`, the timecode is converted to the new frame rate based on the equivalent real time value.
    ///
    /// - Throws: ``ValidationError``
    ///
    /// - Returns: A new `Timecode` instance converted to the new frame rate and sub-frames base.
    public func converted(
        to newFrameRate: TimecodeFrameRate,
        base newSubFramesBase: Timecode.SubFramesBase? = nil,
        preservingValues: Bool = false
    ) throws -> Timecode {
        let newSubFramesBase = newSubFramesBase ?? subFramesBase
        
        // just return self if new parameters are equal to current parameters
        guard frameRate != newFrameRate ||
              subFramesBase != newSubFramesBase
        else {
            return self
        }
        
        if preservingValues,
           let newTC = try? Timecode(
               .components(components),
               at: newFrameRate,
               base: newSubFramesBase,
               limit: upperLimit
           )
        {
            return newTC
        }
        
        // convert to new frame rate, retaining all ancillary property values
        
        return try Timecode(
            .realTime(seconds: realTimeValue),
            at: newFrameRate,
            base: newSubFramesBase,
            limit: upperLimit
        )
    }
    
    // MARK: - TimecodeTransformer
    
    /// Returns the timecode transformed by the given transformer.
    public func transformed(using transformer: TimecodeTransformer) -> Timecode {
        transformer.transform(self)
    }
    
    /// Transforms the timecode in-place using the given transformer.
    public mutating func transform(using transformer: TimecodeTransformer) {
        self = transformer.transform(self)
    }
}
