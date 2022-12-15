//
//  Timecode Samples Double.swift
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
        samples exactly: Double,
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
        clampingSamples source: Double,
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
        wrappingSamples source: Double,
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
        rawValuesSamples source: Double,
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
}

// MARK: - Get and Set

extension Timecode {
    /// (Lossy)
    /// Returns the current timecode converted to a duration in audio samples
    /// at the given sample rate, with floating-point sub-sample duration.
    /// Sample rate is expressed in Hz. (ie: 48KHz would be passed as 48000)
    public func samplesDoubleValue(sampleRate: Int) -> Double {
        realTimeValue * Double(sampleRate)
    }
    
    /// (Lossy)
    /// Sets the timecode to the nearest elapsed frame at the current frame rate
    /// from elapsed audio samples, with floating-point sub-sample duration.
    /// Throws an error if it underflows or overflows valid timecode range.
    /// Sample rate is expressed in Hz. (ie: 48KHz would be passed as 48000)
    ///
    /// - Throws: ``ValidationError``
    public mutating func setTimecode(
        samples: Double,
        sampleRate: Int
    ) throws {
        let convertedComponents = components(
            fromSamples: samples,
            sampleRate: sampleRate
        )
        try setTimecode(exactly: convertedComponents)
    }
    
    /// (Lossy)
    /// Sets the timecode to the nearest elapsed frame at the current frame rate
    /// from elapsed audio samples, with floating-point sub-sample duration.
    /// Clamps to valid timecode.
    /// Sample rate is expressed in Hz. (ie: 48KHz would be passed as 48000)
    ///
    /// - Throws: ``ValidationError``
    public mutating func setTimecode(
        clampingSamples: Double,
        sampleRate: Int
    ) {
        let convertedComponents = components(
            fromSamples: clampingSamples,
            sampleRate: sampleRate
        )
        setTimecode(clamping: convertedComponents)
    }
    
    /// (Lossy)
    /// Sets the timecode to the nearest elapsed frame at the current frame rate
    /// from elapsed audio samples, with floating-point sub-sample duration.
    /// Wraps timecode if necessary.
    /// Sample rate is expressed in Hz. (ie: 48KHz would be passed as 48000)
    ///
    /// - Throws: ``ValidationError``
    public mutating func setTimecode(
        wrappingSamples: Double,
        sampleRate: Int
    ) {
        let convertedComponents = components(
            fromSamples: wrappingSamples,
            sampleRate: sampleRate
        )
        setTimecode(wrapping: convertedComponents)
    }
    
    /// (Lossy)
    /// Sets the timecode to the nearest elapsed frame at the current frame rate
    /// from elapsed audio samples, with floating-point sub-sample duration.
    /// Allows for invalid raw values (in this case, unbounded Days component).
    /// Sample rate is expressed in Hz. (ie: 48KHz would be passed as 48000)
    ///
    /// - Throws: ``ValidationError``
    public mutating func setTimecode(
        rawValuesSamples: Double,
        sampleRate: Int
    ) {
        let convertedComponents = components(
            fromSamples: rawValuesSamples,
            sampleRate: sampleRate
        )
        setTimecode(rawValues: convertedComponents)
    }
    
    // MARK: Internal Methods
    
    internal func components(
        fromSamples: Double,
        sampleRate: Int
    ) -> Components {
        let rtv = fromSamples / Double(sampleRate)
        var base = elapsedFrames(realTime: rtv)
        
        // over-estimate so samples are just past the equivalent timecode
        // so calculations of samples back into timecode work reliably
        // otherwise, this math produces a samples value that can be a hair under
        // the actual elapsed samples that would convert back to equivalent timecode
        
        base += 0.0001
        
        // then derive components
        return Self.components(
            of: .init(.combined(frames: base), base: subFramesBase),
            at: frameRate
        )
    }
}
