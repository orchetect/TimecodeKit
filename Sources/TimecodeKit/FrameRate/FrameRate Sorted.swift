//
//  FrameRate Sorted.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//

extension Timecode.FrameRate {
    
    fileprivate var sortOrder: Int {
        
        switch self {
        case ._23_976:       return 0
        case ._24:           return 1
        case ._24_98:        return 2
        case ._25:           return 3
        case ._29_97:        return 4
        case ._29_97_drop:   return 5
        case ._30:           return 6
        case ._30_drop:      return 7
        case ._47_952:       return 8
        case ._48:           return 9
        case ._50:           return 10
        case ._59_94:        return 11
        case ._59_94_drop:   return 12
        case ._60:           return 13
        case ._60_drop:      return 14
        case ._100:          return 15
        case ._119_88:       return 16
        case ._119_88_drop:  return 17
        case ._120:          return 18
        case ._120_drop:     return 19
        }
        
    }
    
}

extension Collection where Element == Timecode.FrameRate {
    
    /// Returns an array containing Elements logically sorted.
    public func sorted() -> [Element] {
        
        sorted { $0.sortOrder < $1.sortOrder }
        
    }
    
}
