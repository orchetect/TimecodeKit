//
//  Delta.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//

import Foundation

extension Timecode {
    /// Represents an abstract delta between two `Timecode` structs.
    public struct Delta {
        /// Delta duration expressed as a positive `Timecode`.
        /// Refer to `.isNegative` property to determine whether this is a positive or negative delta.
        public let delta: Timecode
        
        @usableFromInline
        let sign: Sign
        
        @inlinable
        public init(
            _ delta: Timecode,
            _ sign: Sign = .positive
        ) {
            self.delta = delta
            self.sign = sign
        }
        
        /// Returns `true` if sign is negative.
        @inlinable
        public var isNegative: Bool {
            sign == .negative
        }
        
        /// Returns the delta value expressed as a concrete `Timecode` value by wrapping around lower/upper timecode limit bounds if necessary.
        @inlinable
        public var timecode: Timecode {
            switch sign {
            case .positive:
                return delta.adding(wrapping: TCC())
                
            case .negative:
                return
                    Timecode(
                        rawValues: TCC(f: 0),
                        at: delta.frameRate,
                        limit: delta.upperLimit,
                        base: delta.subFramesBase,
                        format: delta.stringFormat
                    )
                    .subtracting(wrapping: delta.components)
            }
        }
        
        /// Returns a `Timecode` value offsetting it by the delta value, wrapping around lower/upper timecode limit bounds if necessary.
        @inlinable
        public func timecode(offsetting base: Timecode) -> Timecode {
            base + timecode
        }
        
        /// Returns real-time (wall-clock time) equivalent of the delta time.
        /// Expressed as either a positive or negative number.
        @inline(__always)
        public var realTimeValue: TimeInterval {
            switch sign {
            case .positive:
                return delta.realTimeValue
                
            case .negative:
                return -delta.realTimeValue
            }
        }
    }
}

extension Timecode.Delta: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        switch sign {
        case .positive: return delta.description
        case .negative: return "-\(delta.description)"
        }
    }
    
    public var debugDescription: String {
        switch sign {
        case .positive: return "Timecode.Delta(\(delta.description))"
        case .negative: return "Timecode.Delta(-\(delta.description))"
        }
    }
    
    public var verboseDescription: String {
        "Timecode Delta \(description) @ \(delta.frameRate.stringValue)"
    }
}

extension Timecode.Delta {
    public enum Sign: Equatable, Hashable, CaseIterable {
        case positive
        case negative
    }
}
