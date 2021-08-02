//
//  SubFramesBase.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//

import Foundation

extension Timecode {
    
    public enum SubFramesBase: Int, Codable, CaseIterable {
        
        case _80SubFrames = 80
        
        case _100SubFrames = 100
        
        case quarterFrames = 4
        
    }
    
}

extension Timecode.SubFramesBase {
    
    public static func `default`() -> Self {
        
        ._100SubFrames
        
    }
    
}

extension Timecode.SubFramesBase: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
        case ._80SubFrames:
            return "80"
        case ._100SubFrames:
            return "100"
        case .quarterFrames:
            return "4"
        }
        
    }
    
}
