//
//  FrameRate String Extensions.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

extension String {
    /// Convenience method to call `Timecode.FrameRate(stringValue: self)`
    @_disfavoredOverload
    public var toFrameRate: Timecode.FrameRate? {
        Timecode.FrameRate(stringValue: self)
    }
}
