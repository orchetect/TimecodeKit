//
//  TimecodeInterval.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Represents an interval duration of timecode, either positive or negative.
/// See the <doc:Timecode-Interval> topic for details.
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
}

extension TimecodeInterval {
    // MARK: - Public Properties
        
    /// Returns `true` if the sign is negative.
    public var isNegative: Bool {
        sign == .minus
    }
    
    /// Flattens the interval and returns it expressed as valid timecode, wrapping as necessary based on the
    /// ``Timecode/upperLimit-swift.property`` of the interval.
    ///
    /// If the interval is already valid timecode and the sign is positive, the interval is returned as-is.
    public func flattened() -> Timecode {
        // since `absoluteInterval` may contain raw values that overflow valid timecode,
        // we invoke methods that can wrap it in-place by using zero timecode as an operand
        
        switch sign {
        case .plus:
            return absoluteInterval
                .adding(Timecode.Components(), by: .wrapping)
            
        case .minus:
            return Timecode(
                .zero,
                at: absoluteInterval.frameRate,
                base: absoluteInterval.subFramesBase,
                limit: absoluteInterval.upperLimit
            )
            .subtracting(absoluteInterval.components, by: .wrapping)
        }
    }
    
    // MARK: - Internal Helpers
    
    /// Internal:
    /// Returns a `Timecode` value offsetting it by the interval, wrapping around lower/upper timecode limit bounds if necessary.
    func timecode(offsetting base: Timecode) -> Timecode {
        switch sign {
        case .plus:
            return base + absoluteInterval
        case .minus:
            return base - absoluteInterval
        }
    }
}

@available(macOS 10.15, macCatalyst 13, iOS 11, tvOS 11, watchOS 6, *)
extension TimecodeInterval: Identifiable {
    public var id: Self { self }
}

extension TimecodeInterval: Sendable { }

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
