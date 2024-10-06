//
//  TimecodeFrameRate String Extensions.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

extension String {
    /// Convenience method to call ``TimecodeFrameRate/init(stringValue:)``.
    @_disfavoredOverload
    public var timecodeFrameRate: TimecodeFrameRate? {
        TimecodeFrameRate(stringValue: self)
    }
}
