//
//  TimecodeInterval.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Represents an interval duration of timecode, either positive or negative.
public struct TimecodeInterval {
    /// The interval's absolute distance, stripping sign negation if present.
    /// The ``isNegative`` property determines the delta direction of the interval.
    public let absoluteInterval: Timecode
        
    /// The `interval` sign.
    let intervalSign: Sign
    
    // MARK: - Init
    
    public init(
        _ interval: Timecode,
        _ sign: Sign = .positive
    ) {
        self.absoluteInterval = interval
        self.intervalSign = sign
    }
    
    // MARK: - Public Properties
        
    /// Returns `true` if the sign is negative.
    public var isNegative: Bool {
        intervalSign == .negative
    }
        
    /// Returns real-time (wall-clock time) equivalent of the interval time.
    /// Expressed as either a positive or negative number.
    public var realTimeValue: TimeInterval {
        switch intervalSign {
        case .positive:
            return absoluteInterval.realTimeValue
                
        case .negative:
            return -(absoluteInterval.realTimeValue)
        }
    }
    
    /// Flattens the interval and returns it expressed as valid timecode, wrapping as necessary based on the ``Timecode/upperLimit-swift.property`` of the interval.
    ///
    /// If the interval is already valid timecode and the sign is positive, the interval is returned as-is.
    public func flattened() -> Timecode {
        // since `absoluteInterval` may contain raw values that overflow valid timecode,
        // we invoke methods that can wrap it in-place by using zero timecode as an operand
        
        switch intervalSign {
        case .positive:
            return absoluteInterval.adding(wrapping: TCC())
            
        case .negative:
            return Timecode(
                rawValues: TCC(f: 0),
                at: absoluteInterval.frameRate,
                limit: absoluteInterval.upperLimit,
                base: absoluteInterval.subFramesBase,
                format: absoluteInterval.stringFormat
            )
            .subtracting(wrapping: absoluteInterval.components)
        }
    }
    
    // MARK: - Internal Helpers
    
    /// Internal:
    /// Returns a `Timecode` value offsetting it by the interval, wrapping around lower/upper timecode limit bounds if necessary.
    internal func timecode(offsetting base: Timecode) -> Timecode {
        switch intervalSign {
        case .positive:
            return base + absoluteInterval
        case .negative:
            return base - absoluteInterval
        }
    }
}

// MARK: - CustomStringConvertible

extension TimecodeInterval: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        switch intervalSign {
        case .positive: return absoluteInterval.description
        case .negative: return "-\(absoluteInterval.description)"
        }
    }
    
    public var debugDescription: String {
        "TimecodeInterval(\(description))"
    }
    
    public var verboseDescription: String {
        "TimecodeInterval \(description) @ \(absoluteInterval.frameRate.stringValue)"
    }
}

extension TimecodeInterval {
    /// Timecode interval sign (polarity).
    public enum Sign: Equatable, Hashable, CaseIterable {
        case positive
        case negative
    }
}

// MARK: - Static Constructors

extension TimecodeInterval {
    /// Constructs a new `TimecodeInterval` instance with positive sign.
    public static func positive(_ interval: Timecode) -> Self {
        .init(interval, .positive)
    }
    
    /// Constructs a new `TimecodeInterval` instance with negative sign.
    public static func negative(_ interval: Timecode) -> Self {
        .init(interval, .negative)
    }
}

// MARK: - API Changes for 1.3.0

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
