//
//  TimecodeKitCore-API-2.3.1.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: API Changes in TimecodeKit 2.3.1

@_documentation(visibility: internal)
extension Timecode {
    @available(*, deprecated, renamed: "verboseStringValue")
    public var verboseDescription: String {
        verboseStringValue
    }
}
