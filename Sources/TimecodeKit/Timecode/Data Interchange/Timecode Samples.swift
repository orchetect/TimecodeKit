//
//  Timecode Samples.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

extension Timecode {
    /// (Lossy)
    /// Returns the current timecode converted to a duration in
    /// real-time audio samples at the given sample rate, rounded to the nearest sample.
    /// Sample rate must be expressed as an Integer in Hz (ie: 48KHz would be 48000)
    public func samplesValue(atSampleRate: Int) -> Double {
        realTimeValue * Double(atSampleRate)
    }
    
    /// (Lossy)
    /// Sets the timecode to the nearest frame at the current frame rate from elapsed audio samples.
    /// Returns false if it underflows or overflows valid timecode range.
    /// Sample rate must be expressed as an Integer of Hz (ie: 48KHz would be passed as 48000)
    ///
    /// - Throws: `Timecode.ValidationError`
    public mutating func setTimecode(
        fromSamplesValue: Double,
        atSampleRate: Int
    ) throws {
        let rtv = fromSamplesValue / Double(atSampleRate)
        var base = elapsedFrames(fromRealTimeValue: rtv)
        
        // over-estimate so samples are just past the equivalent timecode
        // so calculations of samples back into timecode work reliably
        // otherwise, this math produces a samples value that can be a hair under
        // the actual elapsed samples that would convert back to equivalent timecode
        
        base += 0.0001
        
        // then derive components
        let convertedComponents = Self.components(
            from: .init(.combined(frames: base), base: subFramesBase),
            at: frameRate
        )
        
        try setTimecode(exactly: convertedComponents)
    }
}
