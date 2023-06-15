//
//  TimecodeInterval.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Represents an interval duration of timecode, either positive or negative.
public struct TimecodeInterval: Equatable, Hashable {
    /// The interval's absolute distance, stripping sign negation if present.
    /// The ``isNegative`` property determines the delta direction of the interval.
    public let absoluteInterval: Timecode
        
    /// The `interval` sign.
    public let sign: FloatingPointSign
    
    // MARK: - Init
    
    public init(
        _ interval: Timecode,
        _ sign: FloatingPointSign = .plus
    ) {
        absoluteInterval = interval
        self.sign = sign
    }
    
    // MARK: - Public Properties
        
    /// Returns `true` if the sign is negative.
    public var isNegative: Bool {
        sign == .minus
    }
        
    /// Returns real-time (wall-clock time) equivalent of the interval time.
    /// Expressed as either a positive or negative number.
    public var realTimeValue: TimeInterval {
        switch sign {
        case .plus:
            return absoluteInterval.realTimeValue
                
        case .minus:
            return -(absoluteInterval.realTimeValue)
        }
    }
    
    /// Flattens the interval and returns it expressed as valid timecode, wrapping as necessary based on the ``Timecode/upperLimit-swift.property`` of the interval.
    ///
    /// If the interval is already valid timecode and the sign is positive, the interval is returned as-is.
    public func flattened() -> Timecode {
        // since `absoluteInterval` may contain raw values that overflow valid timecode,
        // we invoke methods that can wrap it in-place by using zero timecode as an operand
        
        switch sign {
        case .plus:
            return absoluteInterval.adding(Timecode.Components(), by: .wrapping)
            
        case .minus:
            return Timecode(
                .components(.zero),
                at: absoluteInterval.frameRate,
                base: absoluteInterval.subFramesBase,
                limit: absoluteInterval.upperLimit,
                by: .allowingInvalid
            )
            .subtracting(absoluteInterval.components, by: .wrapping)
        }
    }
    
    // MARK: - Internal Helpers
    
    /// Internal:
    /// Returns a `Timecode` value offsetting it by the interval, wrapping around lower/upper timecode limit bounds if necessary.
    internal func timecode(offsetting base: Timecode) -> Timecode {
        switch sign {
        case .plus:
            return base + absoluteInterval
        case .minus:
            return base - absoluteInterval
        }
    }
}

// MARK: - CustomStringConvertible

extension TimecodeInterval: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        switch sign {
        case .plus: return absoluteInterval.description
        case .minus: return "-\(absoluteInterval.description)"
        }
    }
    
    public var debugDescription: String {
        "TimecodeInterval(\(description))"
    }
    
    public var verboseDescription: String {
        "TimecodeInterval \(description) @ \(absoluteInterval.frameRate.stringValueVerbose)"
    }
}

// MARK: - Static Constructors

extension TimecodeInterval {
    /// Constructs a new `TimecodeInterval` instance with positive sign.
    public static func positive(_ interval: Timecode) -> Self {
        .init(interval, .plus)
    }
    
    /// Constructs a new `TimecodeInterval` instance with negative sign.
    public static func negative(_ interval: Timecode) -> Self {
        .init(interval, .minus)
    }
}
