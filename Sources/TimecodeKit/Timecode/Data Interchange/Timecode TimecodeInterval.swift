//
//  Timecode TimecodeInterval.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// MARK: - TimecodeSource

extension TimecodeInterval: RichTimecodeSource {
    public func set(timecode: inout Timecode, overriding properties: Timecode.Properties?) throws -> Timecode.Properties {
        try timecode.set(self, overriding: properties)
        return timecode.properties
    }
}

extension RichTimecodeSource where Self == TimecodeInterval {
    /// Instance by flattening a ``TimecodeInterval``, wrapping as necessary based on the
    /// ``upperLimit-swift.property`` and ``frameRate-swift.property`` of the interval.
    public static func interval(flattening interval: TimecodeInterval) -> Self {
        interval
    }
}
