//
//  Errors.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
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
