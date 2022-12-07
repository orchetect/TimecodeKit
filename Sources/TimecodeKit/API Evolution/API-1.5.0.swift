//
//  API-1.5.0.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: API Changes in TimecodeKit 1.5.0

// MARK: Timecode FrameCount

extension Timecode {
    @available(*, deprecated, renamed: "components(of:at:)")
    public static func components(
        from frameCount: FrameCount,
        at frameRate: FrameRate
    ) -> Components {
        components(of: frameCount, at: frameRate)
    }
}


// MARK: Real Time

extension Timecode {
    @available(*, deprecated, renamed: "init(realTime:at:limit:base:format:)")
    public init(
        realTimeValue exactly: TimeInterval,
        at rate: FrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        try self.init(
            realTime: exactly,
            at: rate,
            limit: limit,
            base: base,
            format: format
        )
    }
    
    @available(*, deprecated, renamed: "setTimecode(realTime:)")
    public mutating func setTimecode(fromRealTimeValue: TimeInterval) throws {
        try setTimecode(realTime: fromRealTimeValue)
    }
}

// MARK: Samples

extension Timecode {
    @available(*, deprecated, renamed: "samplesDoubleValue(sampleRate:)")
    public func samplesValue(atSampleRate: Int) -> Double {
        samplesDoubleValue(sampleRate: atSampleRate)
    }
    
    @available(*, deprecated, renamed: "setTimecode(samples:sampleRate:)")
    public mutating func setTimecode(
        fromSamplesValue: Double,
        atSampleRate: Int
    ) throws {
        try setTimecode(
            samples: fromSamplesValue,
            sampleRate: atSampleRate
        )
    }
}
