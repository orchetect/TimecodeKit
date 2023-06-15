//
//  Timecode Rational CMTime.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if canImport(CoreMedia)

import Foundation
import CoreMedia

// MARK: - TimecodeSource

@available(macOS 10.7, iOS 4.0, tvOS 9.0, watchOS 6.0, *)
extension CMTime: TimecodeSource {
    public func set(timecode: inout Timecode) throws {
        try timecode._setTimecode(exactly: self)
    }
    
    public func set(timecode: inout Timecode, by validation: Timecode.ValidationRule) {
        switch validation {
        case .clamping, .clampingComponents:
            timecode._setTimecode(clamping: self)
        case .wrapping:
            timecode._setTimecode(wrapping: self)
        case .allowingInvalid:
            timecode._setTimecode(rawValues: self)
        }
    }
}

// MARK: - Static Constructors

@available(macOS 10.7, iOS 4.0, tvOS 9.0, watchOS 6.0, *)
extension TimecodeSourceValue {
    /// `CMTime` value.
    ///
    /// - Note: Many AVFoundation and Core Media objects utilize `CMTime` as a way to communicate
    /// times and durations.
    public static func cmTime(_ source: CMTime) -> Self {
        .init(value: source)
    }
}

// MARK: - Get

@available(macOS 10.7, iOS 4.0, tvOS 9.0, watchOS 6.0, *)
extension Timecode {
    /// Returns the time location as a `CMTime` instance.
    ///
    /// - Note: Many AVFoundation and Core Media objects utilize `CMTime` as a way to communicate
    /// times and durations.
    public var cmTime: CMTime {
        let fraction = rationalValue
        return CMTime(
            value: CMTimeValue(fraction.numerator),
            timescale: CMTimeScale(fraction.denominator)
        )
    }
}

// MARK: - Set

@available(macOS 10.7, iOS 4.0, tvOS 9.0, watchOS 6.0, *)
extension Timecode {
    /// Instance from elapsed time `CMTime`.
    ///
    /// - Note: Many AVFoundation and Core Media objects utilize `CMTime` as a way to communicate
    /// times and durations.
    ///
    /// - Throws: ``ValidationError``
    internal mutating func _setTimecode(exactly: CMTime) throws {
        let fraction = Fraction(Int(exactly.value), Int(exactly.timescale))
        try _setTimecode(exactly: fraction)
    }
    
    /// Instance from elapsed time `CMTime`.
    ///
    /// Clamps to valid timecode.
    ///
    /// - Note: Many AVFoundation and Core Media objects utilize `CMTime` as a way to communicate
    /// times and durations.
    internal mutating func _setTimecode(clamping cmTime: CMTime) {
        let fraction = Fraction(Int(cmTime.value), Int(cmTime.timescale))
        _setTimecode(clamping: fraction)
    }
    
    /// Instance from elapsed time `CMTime`.
    ///
    /// Wraps timecode if necessary.
    ///
    /// - Note: Many AVFoundation and Core Media objects utilize `CMTime` as a way to communicate
    /// times and durations.
    internal mutating func _setTimecode(wrapping cmTime: CMTime) {
        let fraction = Fraction(Int(cmTime.value), Int(cmTime.timescale))
        _setTimecode(wrapping: fraction)
    }
    
    /// Instance from elapsed time `CMTime`.
    ///
    /// Allows for invalid raw values (in this case, unbounded Days component).
    ///
    /// - Note: Many AVFoundation and Core Media objects utilize `CMTime` as a way to communicate
    /// times and durations.
    internal mutating func _setTimecode(rawValues cmTime: CMTime) {
        let fraction = Fraction(Int(cmTime.value), Int(cmTime.timescale))
        _setTimecode(rawValues: fraction)
    }
}

#endif
