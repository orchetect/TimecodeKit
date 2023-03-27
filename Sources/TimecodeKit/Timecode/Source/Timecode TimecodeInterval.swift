//
//  Timecode TimecodeInterval.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// MARK: - TimecodeSource

extension TimecodeInterval: GuaranteedRichTimecodeSource {
    public func set(timecode: inout Timecode) -> Timecode.Properties {
        _ = timecode.set(self)
        return timecode.properties
    }
}

extension GuaranteedRichTimecodeSource where Self == TimecodeInterval {
    /// Instance by flattening a ``TimecodeInterval``, wrapping as necessary based on the
    /// ``upperLimit-swift.property`` and ``frameRate-swift.property`` of the interval.
    public static func interval(flattening interval: TimecodeInterval) -> Self {
        interval
    }
}
