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
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        frameRate = rate
        upperLimit = limit
        subFramesBase = base
        stringFormat = format
        
        try setTimecode(
            samples: exactly,
            sampleRate: sampleRate
        )
    }
    
    /// Instance from total elapsed audio samples at a given sample rate, clamping to valid timecode
    /// if necessary.
    ///
    /// Clamping is based on the `upperLimit` and `subFramesBase` properties.
    ///
    /// - Note: This may be lossy.
    public init(
        clampingSamples source: Int,
        sampleRate: Int,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        frameRate = rate
        upperLimit = limit
        subFramesBase = base
        stringFormat = format
        
        setTimecode(
            clampingSamples: source,
            sampleRate: sampleRate
        )
    }
    
    /// Instance from total elapsed audio samples at a given sample rate, clamping to valid timecode
    /// if necessary.
    ///
    /// Timecode will be wrapped around the timecode clock if out-of-bounds.
    ///
    /// - Note: This may be lossy.
    public init(
        wrappingSamples source: Int,
        sampleRate: Int,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        frameRate = rate
        upperLimit = limit
        subFramesBase = base
        stringFormat = format
        
        setTimecode(
            wrappingSamples: source,
            sampleRate: sampleRate
        )
    }
    
    /// Instance from total elapsed audio samples at a given sample rate, clamping to valid timecode
    /// if necessary.
    ///
    /// Allows for invalid raw values (in this case, unbounded Days component).
    ///
    /// - Note: This may be lossy.
    public init(
        rawValuesSamples source: Int,
        sampleRate: Int,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        frameRate = rate
        upperLimit = limit
        subFramesBase = base
        stringFormat = format
        
        setTimecode(
            rawValuesSamples: source,
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
    /// Throws an error if it underflows or overflows valid timecode range.
    /// Sample rate must be expressed as an Integer of Hz (ie: 48KHz would be passed as 48000)
    ///
    /// - Throws: ``ValidationError``
    public mutating func setTimecode(
        samples: Int,
        sampleRate: Int
    ) throws {
        try setTimecode(samples: Double(samples),
                        sampleRate: sampleRate)
    }
    
    /// (Lossy)
    /// Sets the timecode to the nearest elapsed frame at the current frame rate
    /// from elapsed audio samples.
    /// Clamps to valid timecode.
    /// Sample rate must be expressed as an Integer of Hz (ie: 48KHz would be passed as 48000)
    ///
    /// - Throws: ``ValidationError``
    public mutating func setTimecode(
        clampingSamples: Int,
        sampleRate: Int
    ) {
        setTimecode(clampingSamples: Double(clampingSamples),
                    sampleRate: sampleRate)
    }
    
    /// (Lossy)
    /// Sets the timecode to the nearest elapsed frame at the current frame rate
    /// from elapsed audio samples.
    /// Wraps timecode if necessary.
    /// Sample rate must be expressed as an Integer of Hz (ie: 48KHz would be passed as 48000)
    ///
    /// - Throws: ``ValidationError``
    public mutating func setTimecode(
        wrappingSamples: Int,
        sampleRate: Int
    ) {
        setTimecode(wrappingSamples: Double(wrappingSamples),
                    sampleRate: sampleRate)
    }
    
    /// (Lossy)
    /// Sets the timecode to the nearest elapsed frame at the current frame rate
    /// from elapsed audio samples.
    /// Allows for invalid raw values (in this case, unbounded Days component).
    /// Sample rate must be expressed as an Integer of Hz (ie: 48KHz would be passed as 48000)
    ///
    /// - Throws: ``ValidationError``
    public mutating func setTimecode(
        rawValuesSamples: Int,
        sampleRate: Int
    ) {
        setTimecode(rawValuesSamples: Double(rawValuesSamples),
                    sampleRate: sampleRate)
    }
}
