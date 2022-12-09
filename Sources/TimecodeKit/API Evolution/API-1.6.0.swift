//
//  API-1.6.0.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: API Changes in TimecodeKit 1.6.0

// MARK: Timecode.FrameRate

extension Timecode.FrameRate {
    @available(*, deprecated, renamed: "rationalFrameRate")
    public var fraction: (numerator: Int, denominator: Int) {
        (
            numerator: rationalFrameRate.numerator,
            denominator: rationalFrameRate.denominator
        )
    }
}

#if canImport(CoreMedia)
import CoreMedia

extension Timecode.FrameRate {
    @available(*, deprecated, renamed: "rationalFrameDurationCMTime")
    @available(macOS 10.7, iOS 4.0, tvOS 9.0, watchOS 6.0, *)
    public var frameDurationCMTime: CMTime {
        rationalFrameDurationCMTime
    }
}
#endif
