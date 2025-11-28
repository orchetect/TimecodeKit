//
//  ComponentRanges.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

extension Timecode {
    /// Primitive struct describing component value ranges.
    public struct ComponentRanges {
        public var days: ClosedRange<Int>
        public var hours: ClosedRange<Int>
        public var minutes: ClosedRange<Int>
        public var seconds: ClosedRange<Int>
        public var frames: ClosedRange<Int>
        public var subFrames: ClosedRange<Int>
        
        public init(
            days: ClosedRange<Int>,
            hours: ClosedRange<Int>,
            minutes: ClosedRange<Int>,
            seconds: ClosedRange<Int>,
            frames: ClosedRange<Int>,
            subFrames: ClosedRange<Int>
        ) {
            self.days = days
            self.hours = hours
            self.minutes = minutes
            self.seconds = seconds
            self.frames = frames
            self.subFrames = subFrames
        }
    }
}

extension Timecode.ComponentRanges: Equatable { }

extension Timecode.ComponentRanges: Hashable { }

extension Timecode.ComponentRanges: Sendable { }

// MARK: - Static Constructors

extension Timecode.ComponentRanges {
    /// A default set of unsafe random component value ranges.
    public static let unsafeRandomRanges = Self(
        days: 0 ... 99,
        hours: 0 ... 99,
        minutes: 0 ... 99,
        seconds: 0 ... 99,
        frames: 0 ... 99,
        subFrames: 0 ... 99
    )
}
