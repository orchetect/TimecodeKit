//
//  VideoFrameRate String Extensions.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

extension String {
    /// Convenience method to call `VideoFrameRate(stringValue: self)`
    @_disfavoredOverload
    public var toVideoFrameRate: VideoFrameRate? {
        VideoFrameRate(stringValue: self)
    }
}
