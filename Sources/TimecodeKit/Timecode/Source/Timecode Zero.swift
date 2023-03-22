//
//  Timecode Zero.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

extension Timecode {
    /// Zero timecode.
    public struct Zero {
        public init() { }
    }
}

// MARK: - TimecodeSource

extension Timecode.Zero: GuaranteedTimecodeSource {
    public func set(timecode: inout Timecode) {
        timecode.set(Timecode.Components.zero, by: .allowingInvalidComponents)
    }
}

extension GuaranteedTimecodeSource where Self == Timecode.Zero {
    public static var zero: Self { Timecode.Zero() }
}
