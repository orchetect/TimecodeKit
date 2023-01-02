//
//  API-1.3.0.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: API Changes in TimecodeKit 1.3.0

// MARK: TimecodeInterval

extension Timecode {
    @available(*, deprecated, renamed: "TimecodeInterval")
    public typealias Delta = TimecodeInterval
}

extension TimecodeInterval {
    /// The interval's absolute distance, stripping sign negation if present.
    /// The ``isNegative`` property determines the delta direction of the interval.
    @available(*, deprecated, renamed: "absoluteInterval")
    public var delta: Timecode { absoluteInterval }
    
    /// Flattens the interval and returns it expressed as valid timecode, wrapping as necessary based on the ``Timecode/upperLimit-swift.property`` of the interval.
    ///
    /// If the interval is already valid timecode and the sign is positive, the interval is returned as-is.
    @available(*, deprecated, renamed: "flattened()")
    public var timecode: Timecode {
        flattened()
    }
}

// MARK: TimecodeTransformer

extension Timecode {
    @available(*, deprecated, renamed: "TimecodeTransformer")
    public typealias Transformer = TimecodeTransformer
}
