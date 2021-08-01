//
//  Timecode init.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//

import Foundation

extension Timecode {
    
    // MARK: - Basic
    
    /// Instance with default timecode (00:00:00:00) at a given frame rate.
    @inlinable public init(at rate: FrameRate,
                           limit: UpperLimit = ._24hours,
                           base: SubFramesBase = .default(),
                           format: StringFormat = .default()) {
        
        self.frameRate = rate
        self.upperLimit = limit
        self.subFramesBase = base
        self.stringFormat = format
        
    }
    
    
    // MARK: - Total Elapsed Frames (FrameCount)
    
    /// Instance exactly from total elapsed frames ("frame number") at a given frame rate.
    ///
    /// Validation is based on the `upperLimit` and `subFramesBase` properties.
    @inlinable public init?(_ exactly: FrameCount.Value,
                            at rate: FrameRate,
                            limit: UpperLimit = ._24hours,
                            base: SubFramesBase = .default(),
                            format: StringFormat = .default()) {
        
        self.frameRate = rate
        self.upperLimit = limit
        self.subFramesBase = base
        self.stringFormat = format
        
        if !setTimecode(exactly: exactly) { return nil }
        
    }
    
    /// Instance exactly from total elapsed frames ("frame number") at a given frame rate.
    ///
    /// Validation is based on the `upperLimit` and `subFramesBase` properties.
    @inlinable public init?(_ exactly: FrameCount,
                            at rate: FrameRate,
                            limit: UpperLimit = ._24hours,
                            format: StringFormat = .default()) {
        
        self.frameRate = rate
        self.upperLimit = limit
        self.subFramesBase = exactly.subFramesBase
        self.stringFormat = format
        
        if !setTimecode(exactly: exactly.value) { return nil }
        
    }
    
    
    // MARK: - Components
    
    /// Instance exactly from timecode values and frame rate.
    ///
    /// If any values are out-of-bounds `nil` will be returned, indicating an invalid timecode.
    ///
    /// Validation is based on the `upperLimit` and `subFramesBase` properties.
    @inlinable public init?(_ exactly: Components,
                            at rate: FrameRate,
                            limit: UpperLimit = ._24hours,
                            base: SubFramesBase = .default(),
                            format: StringFormat = .default()) {
        
        self.frameRate = rate
        self.upperLimit = limit
        self.subFramesBase = base
        self.stringFormat = format
        
        if !setTimecode(exactly: exactly) { return nil }
        
    }
    
    /// Instance from timecode values and frame rate, clamping to valid timecodes if necessary.
    ///
    /// Clamping is based on the `upperLimit` and `subFramesBase` properties.
    @inlinable public init(clamping source: Components,
                           at rate: FrameRate,
                           limit: UpperLimit = ._24hours,
                           base: SubFramesBase = .default(),
                           format: StringFormat = .default()) {
        
        self.frameRate = rate
        self.upperLimit = limit
        self.subFramesBase = base
        self.stringFormat = format
        
        setTimecode(clamping: source)
        
    }
    
    /// Instance from timecode values and frame rate, clamping individual values if necessary.
    ///
    /// Values which are out-of-bounds will be clamped to minimum or maximum possible values.
    ///
    /// Clamping is based on the `upperLimit` and `subFramesBase` properties.
    @inlinable public init(clampingEach values: Components,
                           at rate: FrameRate,
                           limit: UpperLimit = ._24hours,
                           base: SubFramesBase = .default(),
                           format: StringFormat = .default()) {
        
        self.frameRate = rate
        self.upperLimit = limit
        self.subFramesBase = base
        self.stringFormat = format
        
        setTimecode(clampingEach: values)
        
    }
    
    /// Instance from timecode values and frame rate, wrapping timecode if necessary.
    ///
    /// Timecodes will be wrapped around the timecode clock if out-of-bounds.
    ///
    /// Wrapping is based on the `upperLimit` and `subFramesBase` properties.
    @inlinable public init(wrapping source: Components,
                           at rate: FrameRate,
                           limit: UpperLimit = ._24hours,
                           base: SubFramesBase = .default(),
                           format: StringFormat = .default()) {
        
        self.frameRate = rate
        self.upperLimit = limit
        self.subFramesBase = base
        self.stringFormat = format
        
        setTimecode(wrapping: source)
        
    }
    
    /// Instance from raw timecode values and frame rate.
    ///
    /// Timecode values will not be validated or rejected if they overflow.
    ///
    /// This is useful, for example, when intending on running timecode validation methods against timecode values that are unknown to be valid or not at the time of initializing.
    @inlinable public init(rawValues source: Components,
                           at rate: FrameRate,
                           limit: UpperLimit = ._24hours,
                           base: SubFramesBase = .default(),
                           format: StringFormat = .default()) {
        
        self.frameRate = rate
        self.upperLimit = limit
        self.subFramesBase = base
        self.stringFormat = format
        
        setTimecode(rawValues: source)
        
    }
    
    
    // MARK: - String
    
    /// Instance exactly from timecode string and frame rate.
    ///
    /// An improperly formatted timecode string or one with out-of-bounds values will return `nil`.
    ///
    /// Validation is based on the `upperLimit` and `subFramesBase` properties.
    @inlinable public init?(_ exactly: String,
                            at rate: FrameRate,
                            limit: UpperLimit = ._24hours,
                            base: SubFramesBase = .default(),
                            format: StringFormat = .default()) {
        
        self.frameRate = rate
        self.upperLimit = limit
        self.subFramesBase = base
        self.stringFormat = format
        
        if !setTimecode(exactly: exactly) { return nil }
        
    }
    
    /// Instance from timecode string and frame rate, clamping to valid timecodes if necessary.
    ///
    /// Clamping is based on the `upperLimit` and `subFramesBase` properties.
    @inlinable public init?(clamping source: String,
                            at rate: FrameRate,
                            limit: UpperLimit = ._24hours,
                            base: SubFramesBase = .default(),
                            format: StringFormat = .default()) {
        
        self.frameRate = rate
        self.upperLimit = limit
        self.subFramesBase = base
        self.stringFormat = format
        
        if !setTimecode(clamping: source) { return nil }
        
    }
    
    /// Instance from timecode string and frame rate, clamping if values necessary.
    ///
    /// Individual values which are out-of-bounds will be clamped to minimum or maximum possible values.
    ///
    /// Clamping is based on the `upperLimit` and `subFramesBase` properties.
    @inlinable public init?(clampingEach source: String,
                            at rate: FrameRate,
                            limit: UpperLimit = ._24hours,
                            base: SubFramesBase = .default(),
                            format: StringFormat = .default()) {
        
        self.frameRate = rate
        self.upperLimit = limit
        self.subFramesBase = base
        self.stringFormat = format
        
        if !setTimecode(clampingEach: source) { return nil }
        
    }
    
    /// Instance from timecode string and frame rate, wrapping timecode if necessary.
    ///
    /// An improperly formatted timecode string or one with invalid values will return `nil`.
    ///
    /// Wrapping is based on the `upperLimit` and `subFramesBase` properties.
    @inlinable public init?(wrapping source: String,
                            at rate: FrameRate,
                            limit: UpperLimit = ._24hours,
                            base: SubFramesBase = .default(),
                            format: StringFormat = .default()) {
        
        self.frameRate = rate
        self.upperLimit = limit
        self.subFramesBase = base
        self.stringFormat = format
        
        if !setTimecode(wrapping: source) { return nil }
        
    }
    
    /// Instance from raw timecode values formatted as a timecode string and frame rate.
    ///
    /// Timecode values will not be validated or rejected if they overflow.
    ///
    /// This is useful, for example, when intending on running timecode validation methods against timecode values that are unknown to be valid or not at the time of initializing.
    @inlinable public init?(rawValues source: String,
                            at rate: FrameRate,
                            limit: UpperLimit = ._24hours,
                            base: SubFramesBase = .default(),
                            format: StringFormat = .default()) {
        
        self.frameRate = rate
        self.upperLimit = limit
        self.subFramesBase = base
        self.stringFormat = format
        
        if !setTimecode(rawValues: source) { return nil }
        
    }
    
    
    // MARK: - Real time
    
    /// Instance from real time and frame rate.
    ///
    /// - Note: This may be lossy.
    @inlinable public init?(realTimeValue source: TimeInterval,
                            at rate: FrameRate,
                            limit: UpperLimit = ._24hours,
                            base: SubFramesBase = .default(),
                            format: StringFormat = .default()) {
        
        self.frameRate = rate
        self.upperLimit = limit
        self.subFramesBase = base
        self.stringFormat = format
        
        if !self.setTimecode(fromRealTimeValue: source) { return nil }
        
    }
    
    
    // MARK: - Audio samples
    
    /// Instance from audio samples and sample rate.
    ///
    /// - Note: This may be lossy.
    @inlinable public init?(samples source: Double,
                            sampleRate: Int,
                            at rate: FrameRate,
                            limit: UpperLimit = ._24hours,
                            base: SubFramesBase = .default(),
                            format: StringFormat = .default()) {
        
        self.frameRate = rate
        self.upperLimit = limit
        self.subFramesBase = base
        self.stringFormat = format
        
        if !self.setTimecode(fromSamplesValue: source,
                             atSampleRate: sampleRate) { return nil }
        
    }
    
}
