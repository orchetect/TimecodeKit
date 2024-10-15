//
//  Timecode TimecodeInterval.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

// MARK: - TimecodeSource

extension TimecodeInterval: _GuaranteedRichTimecodeSource {
    package func set(timecode: inout Timecode) -> Timecode.Properties {
        timecode.set(self)
    }
}

// MARK: - Static Constructors

extension GuaranteedRichTimecodeSourceValue {
    /// Instance by flattening a ``TimecodeInterval``, wrapping as necessary based on the
    /// ``Timecode/Properties-swift.struct/upperLimit`` and
    /// ``Timecode/Properties-swift.struct/frameRate`` of the interval.
    public static func interval(flattening interval: TimecodeInterval) -> Self {
        .init(value: interval)
    }
}
