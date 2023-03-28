//
//  TimecodeFrameRate String Extensions.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

extension String {
    /// Convenience method to call ``TimecodeFrameRate/init(stringValue:)``.
    @_disfavoredOverload
    public func timecodeFrameRate() -> TimecodeFrameRate? {
        TimecodeFrameRate(stringValue: self)
    }
}
