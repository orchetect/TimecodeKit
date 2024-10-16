//
//  Errors.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension Timecode {
    public enum ValidationError: Error {
        case invalid
        case outOfBounds
    }
    
    public enum StringParseError: Error {
        case malformed
    }
}
