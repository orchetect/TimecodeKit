//
//  Timecode Components.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

extension Timecode {
    /// Timecode components.
    ///
    /// When setting, raw values are accepted and are not validated prior to setting.
    ///
    /// (Validation is based on the frame rate and `upperLimit` property.)
    public var components: Components {
        get {
            Components(
                d: days,
                h: hours,
                m: minutes,
                s: seconds,
                f: frames,
                sf: subFrames
            )
        }
        set {
            setTimecode(rawValues: newValue)
        }
    }
    
    /// Set timecode from tuple values.
    ///
    /// Returns true/false depending on whether the string values are valid or not.
    ///
    /// Values which are out-of-bounds will return false.
    ///
    /// (Validation is based on the frame rate and `upperLimit` property.)
    ///
    /// - Throws: `Timecode.ValidationError`
    public mutating func setTimecode(exactly values: Components) throws {
        guard values
            .invalidComponents(
                at: frameRate,
                limit: upperLimit,
                base: subFramesBase
            )
            .isEmpty
        else { throw ValidationError.outOfBounds }
        
        days = values.d
        hours = values.h
        minutes = values.m
        seconds = values.s
        frames = values.f
        subFrames = values.sf
    }
    
    /// Set timecode from components.
    /// Clamps to valid timecodes as set by the `upperLimit` property.
    ///
    /// (Validation is based on the frame rate and `upperLimit` property.)
    public mutating func setTimecode(clamping source: Components) {
        let result = __add(clamping: source, to: TCC())
        
        setTimecode(rawValues: result)
    }
    
    /// Set timecode from components, clamping individual values if necessary.
    ///
    /// (Validation is based on the frame rate and `upperLimit` property.)
    public mutating func setTimecode(clampingEach values: Components) {
        days = values.d
        hours = values.h
        minutes = values.m
        seconds = values.s
        frames = values.f
        subFrames = values.sf
        
        clampComponents()
    }
    
    /// Set timecode from tuple values.
    ///
    /// Timecode will wrap if out-of-bounds. Will handle negative values and wrap accordingly.
    ///
    /// (Wrapping is based on the frame rate and `upperLimit` property.)
    public mutating func setTimecode(wrapping values: Components) {
        setTimecode(rawValues: __add(
            wrapping: values,
            to: Components(f: 0)
        ))
    }
    
    /// Set timecode from tuple values.
    /// Timecode values will not be validated or rejected if they overflow.
    public mutating func setTimecode(rawValues values: Components) {
        days = values.d
        hours = values.h
        minutes = values.m
        seconds = values.s
        frames = values.f
        subFrames = values.sf
    }
}

// MARK: - .toTimecode

extension Timecode.Components {
    /// Returns an instance of `Timecode(exactly:)`.
    public func toTimecode(
        at rate: Timecode.FrameRate,
        limit: Timecode.UpperLimit = ._24hours,
        base: Timecode.SubFramesBase = .default(),
        format: Timecode.StringFormat = .default()
    ) throws -> Timecode {
        try Timecode(
            self,
            at: rate,
            limit: limit,
            base: base,
            format: format
        )
    }
    
    /// Returns an instance of `Timecode(rawValues:)`.
    public func toTimecode(
        rawValuesAt rate: Timecode.FrameRate,
        limit: Timecode.UpperLimit = ._24hours,
        base: Timecode.SubFramesBase = .default(),
        format: Timecode.StringFormat = .default()
    ) -> Timecode {
        Timecode(
            rawValues: self,
            at: rate,
            limit: limit,
            base: base,
            format: format
        )
    }
}
