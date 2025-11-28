//
//  SwiftTimecodeCore-API-2.3.1.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: API Changes in swift-timecode 2.3.1

@_documentation(visibility: internal)
extension Timecode {
    @available(*, deprecated, renamed: "stringValueVerbose")
    public var verboseDescription: String {
        stringValueVerbose
    }
}

@_documentation(visibility: internal)
extension Timecode.StringFormat {
    @available(*, deprecated, message: "Use [.showSubFrames] instead.")
    public static let showSubFrames: Self = [.showSubFrames]
}
