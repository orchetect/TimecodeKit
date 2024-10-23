//
//  TimecodeKitCore-API-2.3.2.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: API Changes in TimecodeKit 2.3.2

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
