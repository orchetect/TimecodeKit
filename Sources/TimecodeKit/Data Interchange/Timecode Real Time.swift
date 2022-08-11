//
//  Timecode Real Time.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//

import Foundation

extension Timecode {
    /// (Lossy) Returns the current timecode converted to a duration in real-time (wall-clock time), based on the frame rate.
    ///
    /// Generally, `.realTimeValue` -> `.setTimecode(fromRealTimeValue:)` will produce equivalent timecodes.
    public var realTimeValue: TimeInterval {
        frameCount.doubleValue * (1.0 / frameRate.frameRateForRealTimeCalculation)
    }
    
    /// Sets the timecode to the nearest frame at the current frame rate from real-time (wall-clock time).
    ///
    /// Returns false if it underflows or overflows valid timecode range.
    /// (Validation is based on the frame rate and `upperLimit` property.)
    ///
    /// - Throws: `Timecode.ValidationError`
    public mutating func setTimecode(fromRealTimeValue: TimeInterval) throws {
        // the basic calculation
        var calc = fromRealTimeValue / (1.0 / frameRate.frameRateForRealTimeCalculation)
        
        // over-estimate so real time is just past the equivalent timecode
        // since raw time values in practise can be a hair under the actual elapsed real time that would trigger the equivalent timecode (due to precision and rounding behaviors that may not be in our control, depending on where the passed real time value originated)
        
        calc += 0.000_010 // 10 microseconds
        
        // final calculation
        
        let elapsedFrames = calc
        
        let convertedComponents = Self.components(
            from: .init(.combined(frames: elapsedFrames), base: subFramesBase),
            at: frameRate
        )
        
        try setTimecode(exactly: convertedComponents)
    }
}

// a.k.a: extension Double
extension TimeInterval {
    /// Convenience method to create an `Timecode` struct using the default `(_ exactly:)` initializer.
    @inlinable
    public func toTimecode(
        at rate: Timecode.FrameRate,
        limit: Timecode.UpperLimit = ._24hours,
        base: Timecode.SubFramesBase = .default(),
        format: Timecode.StringFormat = .default()
    ) throws -> Timecode {
        try Timecode(
            realTimeValue: self,
            at: rate,
            limit: limit,
            base: base,
            format: format
        )
    }
}
