//
//  Timecode Errors.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
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
