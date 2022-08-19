//
//  Transformer.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

extension Timecode {
    /// A timecode transformer containing one or more transform rules in series.
    public struct Transformer {
        public var transforms: [Transform]
        
        /// Sets whether the transformer is enabled.
        /// When `false`, the ``transform(_:)`` method will simply pass its input to the output unmodified.
        public var enabled = true
        
        /// Initialize the transformer with a single transform.
        public init(_ transform: Transform) {
            self.transforms = [transform]
        }
        
        /// Initialize the transformer with multiple transforms in series.
        public init(_ transforms: [Transform]) {
            self.transforms = transforms
        }
        
        public func transform(_ input: Timecode) -> Timecode {
            // return input if transformer is bypassed
            guard enabled else { return input }
            
            return transforms.reduce(into: input) { tc, transform in
                switch transform {
                case .none:
                    return
                    
                case let .offset(by: interval):
                    tc = tc.offsetting(by: interval)
                    
                case let .custom(closure):
                    tc = closure(tc)
                }
            }
        }
    }
}

extension Timecode.Transformer {
    /// A timecode transform rule or logic.
    public enum Transform {
        /// No transform is defined.
        case none
        
        /// Offsets timecode by a delta interval.
        case offset(by: TimecodeInterval)
        
        /// A custom transformer that processes input `Timecode` with the supplied closure.
        case custom((Timecode) -> Timecode)
    }
}
