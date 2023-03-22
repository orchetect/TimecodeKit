//
//  Timecode Source.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2023 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// A protocol for timecode time value sources that do not supply their own frame
/// rate information.
public protocol TimecodeSource {
    func set(timecode: inout Timecode) throws
    func set(timecode: inout Timecode, by validation: Timecode.Validation)
}

/// A protocol for timecode time value sources that are able to supply frame rate information.
public protocol RichTimecodeSource {
    func set(
        timecode: inout Timecode,
        overriding properties: Timecode.Properties?
    ) throws -> Timecode.Properties
}

/// A protocol for timecode time value sources that are guaranteed to be valid regardless of properties.
public protocol GuaranteedTimecodeSource {
    func set(timecode: inout Timecode)
}

/// A protocol for timecode time value sources that are able to supply frame rate information and
/// are guaranteed to be valid regardless of properties.
public protocol GuaranteedRichTimecodeSource {
    func set(timecode: inout Timecode) -> Timecode.Properties
}

/// An individual time attribute of a time range.
public enum RangeAttribute {
    case start
    case end
    case duration
}
