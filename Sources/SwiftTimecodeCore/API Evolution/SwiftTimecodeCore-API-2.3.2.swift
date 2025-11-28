//
//  SwiftTimecodeCore-API-2.3.2.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: API Changes in swift-timecode 2.3.2

@_documentation(visibility: internal)
extension Timecode.Components {
    @available(*, deprecated, renamed: "isWithinValidDigitCounts(at:base:)")
    public func isWithinValidDigitCount(
        at frameRate: TimecodeFrameRate,
        base: Timecode.SubFramesBase
    ) -> Bool {
        isWithinValidDigitCounts(at: frameRate, base: base)
    }
}
