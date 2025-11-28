//
//  Timecode Errors.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

extension Timecode {
    public enum MediaParseError: Error {
        case missingOrNonStandardFrameRate
        case unknownTimecode
        case internalError
        case noData
    }
    
    public enum MediaWriteError: Error {
        case internalError
    }
}
