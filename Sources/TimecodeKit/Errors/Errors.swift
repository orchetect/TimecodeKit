//
//  Errors.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//

import Foundation

extension Timecode {
    
    public enum ValidationError: Error {
        
        case outOfBounds
        
    }
    
    public enum StringParseError: Error {
        
        case malformed
        
    }
    
}
