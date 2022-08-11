//
//  Transformer.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//

extension Timecode {
    public struct Transformer {
        public var transform: Transform
        
        /// Sets whether the transform is enabled.
        public var enabled = true
        
        public init(_ transform: Transform) {
            self.transform = transform
        }
        
        @inlinable
        public func transform(_ input: Timecode) -> Timecode {
            // return input if transformer is bypassed
            guard enabled else { return input }
            
            switch transform {
            case .none:
                return input
                
            case let .offset(by: delta):
                return input.offsetting(by: delta)
                
            case let .custom(closure):
                return closure(input)
            }
        }
    }
}

extension Timecode.Transformer {
    public enum Transform {
        /// No transform is defined.
        case none
        
        /// Offsets timecode by a `Delta` amount.
        case offset(by: Timecode.Delta)
        
        /// A custom transformer that processes input `Timecode` with the supplied closure.
        case custom((Timecode) -> Timecode)
    }
}
