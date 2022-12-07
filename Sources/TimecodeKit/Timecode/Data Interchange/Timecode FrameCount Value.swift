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
        let fc = FrameCount(frameCountValue, base: subFramesBase)
        
        guard fc.subFrameCount >= 0,
              fc <= maxFrameCountExpressible
        else { throw ValidationError.outOfBounds }
        
        let converted = Self.components(
            of: fc,
            at: frameRate
        )
        
        days = converted.d
        hours = converted.h
        minutes = converted.m
        seconds = converted.s
        frames = converted.f
        subFrames = converted.sf
    }
}
