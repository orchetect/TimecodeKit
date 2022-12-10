//
//  Timecode FrameCount Value.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - Init

extension Timecode {
    /// Instance exactly from total elapsed frames ("frame number") at a given frame rate.
    ///
    /// Validation is based on the `upperLimit` and `subFramesBase` properties.
    ///
    /// - Throws: ``ValidationError``
    public init(
        _ exactly: FrameCount.Value,
        at rate: TimecodeFrameRate,
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
    
    /// Instance exactly from total elapsed frames ("frame number"), clamping to valid timecode if
    /// necessary.
    ///
    /// Clamping is based on the `upperLimit` and `subFramesBase` properties.
    public init(
        clamping source: FrameCount.Value,
        at rate: TimecodeFrameRate,
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
    
    /// Instance exactly from total elapsed frames ("frame number"), wrapping timecode if necessary.
    ///
    /// Timecode will be wrapped around the timecode clock if out-of-bounds.
    public init(
        wrapping source: FrameCount.Value,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        frameRate = rate
        upperLimit = limit
        subFramesBase = base
        stringFormat = format
        
        setTimecode(wrapping: source)
    }
    
    /// Instance exactly from total elapsed frames ("frame number").
    ///
    /// Allows for invalid raw values (in this case, unbounded Days component).
    public init(
        rawValues source: FrameCount.Value,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        frameRate = rate
        upperLimit = limit
        subFramesBase = base
        stringFormat = format
        
        setTimecode(rawValues: source)
    }
}

// MARK: - Get and Set

extension Timecode {
    /// Set timecode from total elapsed frames ("frame number").
    ///
    /// Subframes are represented by the fractional portion of the number.
    /// Timecode is updated as long as the value passed is in valid range.
    /// (Validation is based on the frame rate and `upperLimit` property.)
    ///
    /// - Throws: ``ValidationError``
    public mutating func setTimecode(exactly frameCountValue: FrameCount.Value) throws {
        let convertedComponents = try components(exactly: frameCountValue)
        
        days = convertedComponents.d
        hours = convertedComponents.h
        minutes = convertedComponents.m
        seconds = convertedComponents.s
        frames = convertedComponents.f
        subFrames = convertedComponents.sf
    }
    
    /// Set timecode from total elapsed frames ("frame number").
    ///
    /// Clamps to valid timecode.
    ///
    /// Subframes are represented by the fractional portion of the number.
    public mutating func setTimecode(clamping source: FrameCount.Value) {
        let convertedComponents = components(rawValues: source)
        setTimecode(clamping: convertedComponents)
    }
    
    /// Set timecode from total elapsed frames ("frame number").
    ///
    /// Timecode will be wrapped around the timecode clock if out-of-bounds.
    ///
    /// Subframes are represented by the fractional portion of the number.
    public mutating func setTimecode(wrapping source: FrameCount.Value) {
        let convertedComponents = components(rawValues: source)
        setTimecode(wrapping: convertedComponents)
    }
    
    /// Set timecode from total elapsed frames ("frame number").
    ///
    /// Allows for invalid raw values (in this case, unbounded Days component).
    ///
    /// Subframes are represented by the fractional portion of the number.
    public mutating func setTimecode(rawValues source: FrameCount.Value) {
        let convertedComponents = components(rawValues: source)
        setTimecode(rawValues: convertedComponents)
    }
    
    // MARK: Internal Methods
    
    /// Internal:
    /// Returns frame count value converted to components using the instance's
    /// frame rate and subframes base.
    ///
    /// - Throws: ``ValidationError``
    internal func components(exactly source: FrameCount.Value) throws -> Components {
        let fc = FrameCount(source, base: subFramesBase)
        
        guard fc.subFrameCount >= 0,
              fc <= maxFrameCountExpressible
        else { throw ValidationError.outOfBounds }
        
        return Self.components(
            of: fc,
            at: frameRate
        )
    }
    
    /// Internal:
    /// Returns frame count value converted to components using the instance's
    /// frame rate and subframes base.
    internal func components(rawValues source: FrameCount.Value) -> Components {
        let fc = FrameCount(source, base: subFramesBase)
        
        return Self.components(
            of: fc,
            at: frameRate
        )
    }
}
