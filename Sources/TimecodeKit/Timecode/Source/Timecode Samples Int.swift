//
//  Timecode Samples Int.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// MARK: - Payload

public struct SamplesPayload {
    public var samples: Double
    public var sampleRate: Int
}

// MARK: - TimecodeSource

extension SamplesPayload: TimecodeSource {
    public func set(timecode: inout Timecode) throws {
        try timecode.setTimecode(samples: samples, sampleRate: sampleRate)
    }
    
    public func set(timecode: inout Timecode, by validation: Timecode.Validation) {
        switch validation {
        case .clamping, .clampingEach:
            timecode.setTimecode(clampingSamples: samples, sampleRate: sampleRate)
        case .wrapping:
            timecode.setTimecode(wrappingSamples: samples, sampleRate: sampleRate)
        case .allowingInvalidComponents:
            timecode.setTimecode(rawValuesSamples: samples, sampleRate: sampleRate)
        }
    }
}

extension TimecodeSource where Self == SamplesPayload {
    public static func samples(_ samples: Int, sampleRate: Int) -> Self {
        SamplesPayload(samples: Double(samples), sampleRate: sampleRate)
    }
    
    public static func samples(_ samples: Double, sampleRate: Int) -> Self {
        SamplesPayload(samples: samples, sampleRate: sampleRate)
    }
}

// MARK: - Get

extension Timecode {
    /// (Lossy)
    /// Returns the current timecode converted to a duration in audio samples
    /// at the given sample rate, rounded to the nearest sample.
    /// Sample rate is expressed in Hz. (ie: 48KHz would be passed as 48000)
    public func samplesValue(sampleRate: Int) -> Int {
        Int(samplesDoubleValue(sampleRate: sampleRate).rounded())
    }
    
    /// (Lossy)
    /// Returns the current timecode converted to a duration in audio samples
    /// at the given sample rate, with floating-point sub-sample duration.
    /// Sample rate is expressed in Hz. (ie: 48KHz would be passed as 48000)
    public func samplesDoubleValue(sampleRate: Int) -> Double {
        realTimeValue * Double(sampleRate)
    }
}

// MARK: - Set

extension Timecode {
    // MARK: - Int
    
    /// (Lossy)
    /// Sets the timecode to the nearest elapsed frame at the current frame rate
    /// from elapsed audio samples.
    /// Throws an error if it underflows or overflows valid timecode range.
    /// Sample rate must be expressed as an Integer of Hz (ie: 48KHz would be passed as 48000)
    ///
    /// - Throws: ``ValidationError``
    internal mutating func setTimecode(
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
    internal mutating func setTimecode(
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
    internal mutating func setTimecode(
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
    internal mutating func setTimecode(
        rawValuesSamples: Int,
        sampleRate: Int
    ) {
        setTimecode(rawValuesSamples: Double(rawValuesSamples),
                    sampleRate: sampleRate)
    }
    
    // MARK: - Double
    
    /// (Lossy)
    /// Sets the timecode to the nearest elapsed frame at the current frame rate
    /// from elapsed audio samples, with floating-point sub-sample duration.
    /// Throws an error if it underflows or overflows valid timecode range.
    /// Sample rate is expressed in Hz. (ie: 48KHz would be passed as 48000)
    ///
    /// - Throws: ``ValidationError``
    internal mutating func setTimecode(
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
    internal mutating func setTimecode(
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
    internal mutating func setTimecode(
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
    internal mutating func setTimecode(
        rawValuesSamples: Double,
        sampleRate: Int
    ) {
        let convertedComponents = components(
            fromSamples: rawValuesSamples,
            sampleRate: sampleRate
        )
        setTimecode(rawValues: convertedComponents)
    }
    
    // MARK: Helper Methods
    
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
        
        let magicNumber = 0.0001
        
        if rtv < 0 {
            base -= magicNumber
        } else {
            base += magicNumber
        }
        
        // then derive components
        return Self.components(
            of: .init(.combined(frames: base), base: properties.subFramesBase),
            at: properties.frameRate
        )
    }
}
