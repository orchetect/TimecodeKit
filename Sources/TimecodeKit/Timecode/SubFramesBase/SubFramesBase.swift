//
//  SubFramesBase.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension Timecode {
    /// Represents the base (denominator) a partial division of a frame.
    ///
    /// Some implementations refer to these as SMPTE frame "bits".
    ///
    /// There are no set industry standards regarding subframe divisors.
    /// - Cubase/Nuendo, Logic Pro/Final Cut Pro use 80 subframes per frame (0 ... 79);
    /// - Pro Tools uses 100 subframes (0 ... 99).
    public enum SubFramesBase: Int, CaseIterable {
        case _80SubFrames = 80
        case _100SubFrames = 100
        case quarterFrames = 4
    }
}

extension Timecode.SubFramesBase {
    public static func `default`() -> Self {
        ._100SubFrames
    }
}

extension Timecode.SubFramesBase: CustomStringConvertible {
    public var description: String {
        "\(rawValue)"
    }
}

extension Timecode.SubFramesBase: Identifiable {
    public var id: RawValue {
        rawValue
    }
}

extension Timecode.SubFramesBase: Codable { }

// MARK: Methods

extension Timecode.SubFramesBase {
    /// Converts a given number of subframes at this subframes base to a different subframes base.
    public func convert(subFrames: Int, to other: Self) -> Int {
        // early return if we don't need to scale subframes
        guard self != other, subFrames != 0 else { return subFrames }
        
        let calc = (Double(subFrames) / Double(rawValue)) * Double(other.rawValue)
        return Int(calc)
    }
}
