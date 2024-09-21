//
//  SubFramesBase.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension Timecode {
    /// Represents the base (denominator) used when dealing with subframes.
    /// This defines how many equal parts a single frame may be divided up into.
    ///
    /// Some implementations refer to these as SMPTE frame "bits".
    ///
    /// Industry standards vary regarding subframe divisors depending on manufacturers and formats,
    /// and not all manufacturers support the usage of subframes.
    /// See documentation for individual cases for more details.
    ///
    /// Subframes base may be defined independently of frame rate, insomuch as it simply
    /// defines the number of equal subdivisions of a frame at the current frame rate.
    public enum SubFramesBase: Int, CaseIterable {
        /// 80 subframes per frame (0 ... 79).
        /// DAWs such as Cubase, Nuendo, Logic Pro, and Final Cut Pro use this standard.
        case max80SubFrames = 80
        
        /// 100 subframes per frame (0 ... 99).
        /// DAWs such as Pro Tools use this standard.
        case max100SubFrames = 100
        
        /// 4 subframes per frame (0 ... 3).
        /// Typically used in a MIDI Timecode (MTC) context.
        case quarterFrames = 4
    }
}

extension Timecode.SubFramesBase {
    public static func `default`() -> Self {
        .max100SubFrames
    }
}

extension Timecode.SubFramesBase: CustomStringConvertible {
    public var description: String {
        "\(rawValue)"
    }
}

@available(macOS 10.15, macCatalyst 13, iOS 11, tvOS 11, watchOS 6, *)
extension Timecode.SubFramesBase: Identifiable {
    public var id: Self { self }
}

extension Timecode.SubFramesBase: Sendable { }

extension Timecode.SubFramesBase: Codable { }

// MARK: - Methods

extension Timecode.SubFramesBase {
    /// Converts a given number of subframes at this subframes base to a different subframes base.
    public func convert(subFrames: Int, to other: Self) -> Int {
        // early return if we don't need to scale subframes
        guard self != other, subFrames != 0 else { return subFrames }
        
        let calc = (Double(subFrames) / Double(rawValue)) * Double(other.rawValue)
        return Int(calc)
    }
}
