//
//  API-1.6.0.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: API Changes in TimecodeKit 1.6.0

// MARK: Timecode.FrameRate

extension Timecode {
    @available(*, deprecated, renamed: "TimecodeFrameRate")
    public enum FrameRate: String, CaseIterable, Codable {
        case _23_976 = "23.976"
        case _24 = "24"
        case _24_98 = "24.98"
        case _25 = "25"
        case _29_97 = "29.97"
        case _29_97_drop = "29.97d"
        case _30 = "30"
        case _30_drop = "30d"
        case _47_952 = "47.952"
        case _48 = "48"
        case _50 = "50"
        case _59_94 = "59.94"
        case _59_94_drop = "59.94d"
        case _60 = "60"
        case _60_drop = "60d"
        case _100 = "100"
        case _119_88 = "119.88"
        case _119_88_drop = "119.88d"
        case _120 = "120"
        case _120_drop = "120d"
        
        // Identifiable
        public var id: String {
            rawValue
        }
    }
}

// MARK: Timecode.FrameRate

extension TimecodeFrameRate {
    @available(*, deprecated, renamed: "rationalFrameRate")
    public var fraction: (numerator: Int, denominator: Int) {
        (
            numerator: rationalFrameRate.numerator,
            denominator: rationalFrameRate.denominator
        )
    }
}

extension String {
    @_disfavoredOverload
    @available(*, deprecated, renamed: "toTimecodeFrameRate")
    public var toFrameRate: TimecodeFrameRate? { toTimecodeFrameRate }
}

#if canImport(CoreMedia)
import CoreMedia

extension TimecodeFrameRate {
    @available(*, deprecated, renamed: "rationalFrameDurationCMTime")
    @available(macOS 10.7, iOS 4.0, tvOS 9.0, watchOS 6.0, *)
    public var frameDurationCMTime: CMTime {
        rationalFrameDurationCMTime
    }
}
#endif
