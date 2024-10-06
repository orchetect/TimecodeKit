//
//  Timecode Random.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

extension Timecode {
    /// Random timecode.
    /// Do not initialize directly; instead, pass `.random` into a ``Timecode`` initializer.
    struct Random {
        public init() { }
    }
}

// MARK: - TimecodeSource

extension Timecode.Random: _GuaranteedTimecodeSource {
    func set(timecode: inout Timecode) {
        let components = Timecode.Components(randomUsing: timecode.properties)
        timecode.set(components, by: .allowingInvalid)
    }
}

// MARK: - Static Constructors

extension GuaranteedTimecodeSourceValue {
    /// Random timecode.
    /// Create a new timecode instance with random component values using the given properties.
    public static let random: Self = .init(value: Timecode.Random())
}
