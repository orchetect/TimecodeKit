//
//  Timecode init.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension Timecode {
    // MARK: - Basic
    
    /// Instance with default timecode (00:00:00:00) at a given frame rate.
    public init(
        at rate: FrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        frameRate = rate
        upperLimit = limit
        subFramesBase = base
        stringFormat = format
    }
    
    // MARK: - Total Elapsed Frames (FrameCount)
    
    /// Instance exactly from total elapsed frames ("frame number") at a given frame rate.
    ///
    /// Validation is based on the `upperLimit` and `subFramesBase` properties.
    public init(
        _ exactly: FrameCount.Value,
        at rate: FrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        frameRate = rate
        upperLimit = limit
        subFramesBase = base
        stringFormat = format
        
        try setTimecode(exactly: exactly)
    }
    
    /// Instance exactly from total elapsed frames ("frame number") at a given frame rate.
    ///
    /// Validation is based on the `upperLimit` and `subFramesBase` properties.
    public init(
        _ exactly: FrameCount,
        at rate: FrameRate,
        limit: UpperLimit = ._24hours,
        format: StringFormat = .default()
    ) throws {
        frameRate = rate
        upperLimit = limit
        subFramesBase = exactly.subFramesBase
        stringFormat = format
        
        try setTimecode(exactly: exactly.value)
    }
    
    // MARK: - Components
    
    /// Instance exactly from timecode values and frame rate.
    ///
    /// If any values are out-of-bounds `nil` will be returned, indicating an invalid timecode.
    ///
    /// Validation is based on the `upperLimit` and `subFramesBase` properties.
    public init(
        _ exactly: Components,
        at rate: FrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        frameRate = rate
        upperLimit = limit
        subFramesBase = base
        stringFormat = format
        
        try setTimecode(exactly: exactly)
    }
    
    /// Instance from timecode values and frame rate, clamping to valid timecode if necessary.
    ///
    /// Clamping is based on the `upperLimit` and `subFramesBase` properties.
    public init(
        clamping source: Components,
        at rate: FrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        frameRate = rate
        upperLimit = limit
        subFramesBase = base
        stringFormat = format
        
        setTimecode(clamping: source)
    }
    
    /// Instance from timecode values and frame rate, clamping individual values if necessary.
    ///
    /// Values which are out-of-bounds will be clamped to minimum or maximum possible values.
    ///
    /// Clamping is based on the `upperLimit` and `subFramesBase` properties.
    public init(
        clampingEach values: Components,
        at rate: FrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        frameRate = rate
        upperLimit = limit
        subFramesBase = base
        stringFormat = format
        
        setTimecode(clampingEach: values)
    }
    
    /// Instance from timecode values and frame rate, wrapping timecode if necessary.
    ///
    /// Timecode will be wrapped around the timecode clock if out-of-bounds.
    ///
    /// Wrapping is based on the `upperLimit` and `subFramesBase` properties.
    public init(
        wrapping rawValues: Components,
        at rate: FrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        frameRate = rate
        upperLimit = limit
        subFramesBase = base
        stringFormat = format
        
        setTimecode(wrapping: rawValues)
    }
    
    /// Instance from raw timecode values and frame rate.
    ///
    /// Timecode values will not be validated or rejected if they overflow.
    ///
    /// This is useful, for example, when intending on running timecode validation methods against timecode values that are unknown to be valid or not at the time of initializing.
    public init(
        rawValues values: Components,
        at rate: FrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        frameRate = rate
        upperLimit = limit
        subFramesBase = base
        stringFormat = format
        
        setTimecode(rawValues: values)
    }
    
    // MARK: - TimecodeInterval
    
    /// Instance by flattening a `TimecodeInterval`, wrapping as necessary based on the ``upperLimit-swift.property`` and ``frameRate-swift.property`` of the interval.
    public init(
        flattening interval: TimecodeInterval
    ) {
        self = interval.flattened()
    }
    
    // MARK: - String
    
    /// Instance exactly from timecode string and frame rate.
    ///
    /// An improperly formatted timecode string or one with out-of-bounds values will return `nil`.
    ///
    /// Validation is based on the `upperLimit` and `subFramesBase` properties.
    public init(
        _ exactly: String,
        at rate: FrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        frameRate = rate
        upperLimit = limit
        subFramesBase = base
        stringFormat = format
        
        try setTimecode(exactly: exactly)
    }
    
    /// Instance from timecode string and frame rate, clamping to valid timecode if necessary.
    ///
    /// Clamping is based on the `upperLimit` and `subFramesBase` properties.
    public init(
        clamping timecodeString: String,
        at rate: FrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        frameRate = rate
        upperLimit = limit
        subFramesBase = base
        stringFormat = format
        
        try setTimecode(clamping: timecodeString)
    }
    
    /// Instance from timecode string and frame rate, clamping if values necessary.
    ///
    /// Individual values which are out-of-bounds will be clamped to minimum or maximum possible values.
    ///
    /// Clamping is based on the `upperLimit` and `subFramesBase` properties.
    public init(
        clampingEach timecodeString: String,
        at rate: FrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        frameRate = rate
        upperLimit = limit
        subFramesBase = base
        stringFormat = format
        
        try setTimecode(clampingEach: timecodeString)
    }
    
    /// Instance from timecode string and frame rate, wrapping timecode if necessary.
    ///
    /// An improperly formatted timecode string or one with invalid values will return `nil`.
    ///
    /// Wrapping is based on the `upperLimit` and `subFramesBase` properties.
    public init(
        wrapping timecodeString: String,
        at rate: FrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        frameRate = rate
        upperLimit = limit
        subFramesBase = base
        stringFormat = format
        
        try setTimecode(wrapping: timecodeString)
    }
    
    /// Instance from raw timecode values formatted as a timecode string and frame rate.
    ///
    /// Timecode values will not be validated or rejected if they overflow.
    ///
    /// This is useful, for example, when intending on running timecode validation methods against timecode values that are unknown to be valid or not at the time of initializing.
    public init(
        rawValues timecodeString: String,
        at rate: FrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        frameRate = rate
        upperLimit = limit
        subFramesBase = base
        stringFormat = format
        
        try setTimecode(rawValues: timecodeString)
    }
    
    // MARK: - Real time
    
    /// Instance from real time and frame rate.
    ///
    /// - Note: This may be lossy.
    public init(
        realTimeValue source: TimeInterval,
        at rate: FrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        frameRate = rate
        upperLimit = limit
        subFramesBase = base
        stringFormat = format
        
        try setTimecode(fromRealTimeValue: source)
    }
    
    // MARK: - Audio samples
    
    /// Instance from audio samples and sample rate.
    ///
    /// - Note: This may be lossy.
    public init(
        samples source: Double,
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
            fromSamplesValue: source,
            atSampleRate: sampleRate
        )
    }
}
