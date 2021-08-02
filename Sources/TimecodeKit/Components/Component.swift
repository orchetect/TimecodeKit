//
//  Component.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//

extension Timecode {
    
    /// Enum naming an individual timecode component
    public enum Component: Equatable, Hashable, CaseIterable {
        
        case days
        case hours
        case minutes
        case seconds
        case frames
        case subFrames
        
    }
    
}
