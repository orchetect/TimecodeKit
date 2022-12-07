//
//  API-1.5.0.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: API Changes in TimecodeKit 1.5.0


// MARK: Real Time Value

extension Timecode {
    @available(*, deprecated, renamed: "setTimecode(realTimeValue:)")
    public mutating func setTimecode(fromRealTimeValue: TimeInterval) throws {
        try setTimecode(realTimeValue: fromRealTimeValue)
    }
}

// MARK: Samples

extension Timecode {
    @available(*, deprecated, renamed: "samplesDoubleValue(sampleRate:)")
    public func samplesValue(atSampleRate: Int) -> Double {
        samplesDoubleValue(sampleRate: atSampleRate)
    }
    
    @available(*, deprecated, renamed: "setTimecode(exactlySamplesValue:sampleRate:)")
    public mutating func setTimecode(
        fromSamplesValue: Double,
        atSampleRate: Int
    ) throws {
        try setTimecode(exactlySamplesValue: fromSamplesValue,
                        sampleRate: atSampleRate)
    }
}
