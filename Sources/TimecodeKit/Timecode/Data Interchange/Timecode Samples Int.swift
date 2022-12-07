//
//  Timecode Samples Int.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// MARK: - Init

extension Timecode {
    /// Instance from total elapsed audio samples at a given sample rate.
    ///
    /// - Note: This may be lossy.
    ///
    /// - Throws: ``ValidationError``
    public init(
        samples exactly: Int,
        sampleRate: Int,
        at rate: FrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        frameRate = rate
        upperLimit = limit
        subFramesBase = base
        stringFormat = format
        
        try setTimecode(
            exactlySamplesValue: exactly,
            sampleRate: sampleRate
        )
    }
}

// MARK: - Get and Set

extension Timecode {
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
    /// - Throws: ``ValidationError``
    public mutating func setTimecode(
        exactlySamplesValue: Int,
        sampleRate: Int
    ) throws {
        try setTimecode(exactlySamplesValue: Double(exactlySamplesValue),
                        sampleRate: sampleRate)
    }
}
