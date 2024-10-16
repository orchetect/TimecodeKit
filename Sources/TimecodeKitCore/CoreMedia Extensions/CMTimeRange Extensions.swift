//
//  CMTimeRange Extensions.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(CoreMedia)

import CoreMedia

extension CMTimeRange {
    /// Returns the time range as a timecode range.
    ///
    /// Throws an error if the range is invalid or if one or both of the times cannot be converted
    /// to valid timecode.
    ///
    /// - Throws: ``Timecode/ValidationError``
    public func timecodeRange(
        at frameRate: TimecodeFrameRate,
        base: Timecode.SubFramesBase = .default(),
        limit: Timecode.UpperLimit = .max24Hours
    ) throws -> ClosedRange<Timecode> {
        let properties = Timecode.Properties(rate: frameRate, base: base, limit: limit)
        return try timecodeRange(using: properties)
    }
    
    /// Returns the time range as a timecode range.
    ///
    /// Throws an error if the range is invalid or if one or both of the times cannot be converted
    /// to valid timecode.
    ///
    /// - Throws: ``Timecode/ValidationError``
    public func timecodeRange(
        using properties: Timecode.Properties
    ) throws -> ClosedRange<Timecode> {
        guard isValid else {
            throw Timecode.ValidationError.invalid
        }
        guard start <= end else {
            throw Timecode.ValidationError.outOfBounds
        }
        
        let timecodes = try [start, end]
            .map {
                try Timecode(.cmTime($0), using: properties)
            }
        
        return timecodes[0] ... timecodes[1]
    }
}

#endif
