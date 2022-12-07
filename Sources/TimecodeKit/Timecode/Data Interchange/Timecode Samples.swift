//
//  Timecode Samples.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

extension Timecode {
    // MARK: - Int
    
    /// (Lossy)
    /// Returns the current timecode converted to a duration in audio samples
    /// at the given sample rate, rounded to the nearest sample.
    /// Sample rate is expressed in Hz. (ie: 48KHz would be passed as 48000)
    public func samplesValue(sampleRate: Int) -> Int {
        Int(samplesDoubleValue(sampleRate: sampleRate).rounded())
    }
    
    /// (Lossy)
    /// Sets the timecode to the nearest elapsed frame at the current frame rate
    /// from elapsed audio samples.
    /// Returns false if it underflows or overflows valid timecode range.
    /// Sample rate must be expressed as an Integer of Hz (ie: 48KHz would be passed as 48000)
    ///
    /// - Throws: `Timecode.ValidationError`
    public mutating func setTimecode(
        exactlySamplesValue: Int,
        sampleRate: Int
    ) throws {
        try setTimecode(exactlySamplesValue: Double(exactlySamplesValue),
                        sampleRate: sampleRate)
    }
    
    // MARK: - Double
    
    /// (Lossy)
    /// Returns the current timecode converted to a duration in audio samples
    /// at the given sample rate, with sub-sample duration as floating-point.
    /// Sample rate is expressed in Hz. (ie: 48KHz would be passed as 48000)
    public func samplesDoubleValue(sampleRate: Int) -> Double {
        realTimeValue * Double(sampleRate)
    }
    
    /// (Lossy)
    /// Sets the timecode to the nearest elapsed frame at the current frame rate
    /// from elapsed audio samples.
    /// Returns false if it underflows or overflows valid timecode range.
    /// Sample rate is expressed in Hz. (ie: 48KHz would be passed as 48000)
    ///
    /// - Throws: `Timecode.ValidationError`
    public mutating func setTimecode(
        exactlySamplesValue: Double,
        sampleRate: Int
    ) throws {
        let rtv = exactlySamplesValue / Double(sampleRate)
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
