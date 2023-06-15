//
//  Timecode TimecodeInterval.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// MARK: - TimecodeSource

extension TimecodeInterval: GuaranteedRichTimecodeSource {
    public func set(timecode: inout Timecode) -> Timecode.Properties {
        return timecode.set(self)
    }
}

// MARK: - Static Constructors

extension GuaranteedRichTimecodeSource where Self == TimecodeInterval {
    /// Instance by flattening a ``TimecodeInterval``, wrapping as necessary based on the
    /// ``Timecode/Properties-swift.struct/upperLimit`` and
    /// ``Timecode/Properties-swift.struct/frameRate`` of the interval.
    public static func interval(flattening interval: TimecodeInterval) -> Self {
        interval
    }
}
