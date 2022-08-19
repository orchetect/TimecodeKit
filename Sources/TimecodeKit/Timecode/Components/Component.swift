//
//  Component.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

extension Timecode {
    /// Individual timecode component tokens.
    public enum Component: Equatable, Hashable, CaseIterable {
        case days
        case hours
        case minutes
        case seconds
        case frames
        case subFrames
    }
}
