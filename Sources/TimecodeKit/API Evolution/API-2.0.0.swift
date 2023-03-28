//
//  API-2.0.0.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: API Changes in TimecodeKit 2.0.0

// MARK: - Inits

extension Timecode {
    @available(*, deprecated, message: "Renamed to Timecode(.zero, using:)")
    public init(
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(.zero, using: properties)
    }
    
    @available(*, deprecated, message: "Renamed to Timecode(.interval(flattening:))")
    public init(
        flattening interval: TimecodeInterval
    ) {
        self.init(.interval(flattening: interval))
    }
}

// MARK: - AVAsset

// AVAssetReader is unavailable on watchOS so we can't support any AVAsset operations
#if canImport(AVFoundation) && !os(watchOS)

import Foundation
import AVFoundation

extension AVAsset {
    @available(*, deprecated, renamed: "startTimecode(using:base:limit:)")
    @_disfavoredOverload
    public func startTimecode(
        at frameRate: TimecodeFrameRate? = nil,
        base: Timecode.SubFramesBase = .default(),
        limit: Timecode.UpperLimit = ._24hours,
        format: Timecode.StringFormat
    ) throws -> Timecode? {
        try startTimecode(using: frameRate, base: base, limit: limit)
    }
    
    @available(*, deprecated, renamed: "endTimecode(using:base:limit:)")
    @_disfavoredOverload
    public func endTimecode(
        at frameRate: TimecodeFrameRate? = nil,
        base: Timecode.SubFramesBase = .default(),
        limit: Timecode.UpperLimit = ._24hours,
        format: Timecode.StringFormat
    ) throws -> Timecode? {
        try endTimecode(using: frameRate, base: base, limit: limit)
    }
    
    @available(*, deprecated, renamed: "durationTimecode(using:base:limit:)")
    @_disfavoredOverload
    public func durationTimecode(
        at frameRate: TimecodeFrameRate? = nil,
        limit: Timecode.UpperLimit = ._24hours,
        base: Timecode.SubFramesBase = .default(),
        format: Timecode.StringFormat = .default()
    ) throws -> Timecode {
        try durationTimecode(using: frameRate, base: base, limit: limit)
    }
}

extension Timecode {
    @available(*, deprecated, message: "Renamed to Timecode(.avAsset(asset, .start))")
    public init(
        startOf asset: AVAsset,
        at rate: TimecodeFrameRate? = nil,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        if let rate {
            let properties = Properties(rate: rate, base: base, limit: limit)
            try self.init(.avAsset(asset, .start), using: properties)
        } else {
            try self.init(.avAsset(asset, .start))
        }
    }
    
    @available(*, deprecated, message: "Renamed to Timecode(.avAsset(asset, .end))")
    public init(
        endOf asset: AVAsset,
        at rate: TimecodeFrameRate? = nil,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        if let rate {
            let properties = Properties(rate: rate, base: base, limit: limit)
            try self.init(.avAsset(asset, .start), using: properties)
        } else {
            try self.init(.avAsset(asset, .start))
        }
    }
    
    @available(*, deprecated, message: "Renamed to Timecode(.avAsset(asset, .duration))")
    public init(
        durationOf asset: AVAsset,
        at rate: TimecodeFrameRate? = nil,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        if let rate {
            let properties = Properties(rate: rate, base: base, limit: limit)
            try self.init(.avAsset(asset, .duration), using: properties)
        } else {
            try self.init(.avAsset(asset, .duration))
        }
    }
}

#endif

// MARK: - AVAssetTrack

// AVAssetReader is unavailable on watchOS so we can't support any AVAsset operations
#if canImport(AVFoundation) && !os(watchOS)

import Foundation
import AVFoundation

extension AVAssetTrack {
    @available(*, deprecated, renamed: "durationTimecode(using:limit:base:)")
    @_disfavoredOverload
    public func durationTimecode(
        at frameRate: TimecodeFrameRate? = nil,
        limit: Timecode.UpperLimit = ._24hours,
        base: Timecode.SubFramesBase = .default(),
        format: Timecode.StringFormat = .default()
    ) throws -> Timecode {
        try durationTimecode(using: frameRate, limit: limit, base: base)
    }
}

#endif

// MARK: - Components

extension Timecode {
    @available(*, deprecated, message: "Renamed to Timecode(.components(), using:)")
    public init(
        _ exactly: Components,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        let properties = Properties(rate: rate, base: base, limit: limit)
        try self.init(exactly, using: properties)
    }
    
    @available(*, deprecated, message: "Renamed to Timecode(.components(), using:, by: .clamping)")
    public init(
        clamping rawValues: Components,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(rawValues, using: properties, by: .clamping)
    }
    
    @available(*, deprecated, message: "Renamed to Timecode(.components(), using:, by: .clampingComponents)")
    public init(
        clampingEach rawValues: Components,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(rawValues, using: properties, by: .clampingComponents)
    }
    
    @available(*, deprecated, message: "Renamed to Timecode(.components(), using:, by: .wrapping)")
    public init(
        wrapping rawValues: Components,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(rawValues, using: properties, by: .wrapping)
    }
    
    @available(*, deprecated, message: "Renamed to Timecode(.components(), using:, by: .allowingInvalid)")
    public init(
        rawValues: Components,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(rawValues, using: properties, by: .allowingInvalid)
    }
}

extension Timecode {
    @available(*, deprecated, message: "Renamed to set(.components())")
    public mutating func setTimecode(exactly values: Components) throws {
        try set(values)
    }
    
    @available(*, deprecated, message: "Renamed to set(.components(), by: .clamping)")
    public mutating func setTimecode(clamping values: Components) {
        set(values, by: .clamping)
    }
    
    @available(*, deprecated, message: "Renamed to set(.components(), by: .clampingComponents)")
    public mutating func setTimecode(clampingEach values: Components) {
        set(values, by: .clampingComponents)
    }
    
    @available(*, deprecated, message: "Renamed to set(.components(), by: .wrapping)")
    public mutating func setTimecode(wrapping values: Components) {
        set(values, by: .wrapping)
    }
    
    @available(*, deprecated, message: "Renamed to set(.components(), by: .allowingInvalid)")
    public mutating func setTimecode(rawValues values: Components) {
        set(values, by: .allowingInvalid)
    }
}

extension Timecode.Components {
    @available(*, deprecated, renamed: "timecode(using:)")
    public func toTimecode(
        at rate: TimecodeFrameRate,
        limit: Timecode.UpperLimit = ._24hours,
        base: Timecode.SubFramesBase = .default(),
        format: Timecode.StringFormat = .default()
    ) throws -> Timecode {
        let properties = Timecode.Properties(rate: rate, base: base, limit: limit)
        return try timecode(using: properties)
    }
    
    @available(*, deprecated, message: "Renamed to timecode(using:, by: .allowingInvalid)")
    public func toTimecode(
        rawValuesAt rate: TimecodeFrameRate,
        limit: Timecode.UpperLimit = ._24hours,
        base: Timecode.SubFramesBase = .default(),
        format: Timecode.StringFormat = .default()
    ) -> Timecode {
        let properties = Timecode.Properties(rate: rate, base: base, limit: limit)
        return timecode(using: properties, by: .allowingInvalid)
    }
    
    @available(*, deprecated, renamed: "invalidComponents(using:)")
    public func invalidComponents(
        at rate: TimecodeFrameRate,
        limit: Timecode.UpperLimit,
        base: Timecode.SubFramesBase
    ) -> Set<Timecode.Component> {
        let properties = Timecode.Properties(rate: rate, base: base, limit: limit)
        return invalidComponents(using: properties)
    }
}

// MARK: - FeetAndFrames

extension Timecode {
    @available(*, deprecated, message: "Renamed to Timecode(.feetAndFrames(), using:)")
    public init(
        _ exactly: FeetAndFrames,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        let properties = Properties(rate: rate, base: base, limit: limit)
        try self.init(exactly, using: properties)
    }
}

extension Timecode {
    @available(*, deprecated, message: "Renamed to set(.feetAndFrames())")
    public mutating func setTimecode(exactly feetAndFrames: FeetAndFrames) throws {
        try set(feetAndFrames)
    }
}

// MARK: - FrameCount Value

extension Timecode {
    @available(*, deprecated, message: "Renamed to Timecode(.frames(), using:)")
    public init(
        _ exactly: FrameCount.Value,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        let properties = Properties(rate: rate, base: base, limit: limit)
        try self.init(exactly, using: properties)
    }
    
    @available(*, deprecated, message: "Renamed to Timecode(.frames(), using:, by: .clamping)")
    public init(
        clamping source: FrameCount.Value,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(source, using: properties, by: .clamping)
    }
    
    @available(*, deprecated, message: "Renamed to Timecode(.frames(), using:, by: .wrapping)")
    public init(
        wrapping source: FrameCount.Value,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(source, using: properties, by: .wrapping)
    }
    
    @available(*, deprecated, message: "Renamed to Timecode(.frames(), using:, by: .allowingInvalid)")
    public init(
        rawValues source: FrameCount.Value,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(source, using: properties, by: .allowingInvalid)
    }
}

extension Timecode {
    @available(*, deprecated, message: "Renamed to set(.frames())")
    public mutating func setTimecode(exactly frameCountValue: FrameCount.Value) throws {
        try set(frameCountValue)
    }
    
    @available(*, deprecated, message: "Renamed to set(.frames(), by: .clamping)")
    public mutating func setTimecode(clamping source: FrameCount.Value) {
        set(source, by: .clamping)
    }
    
    @available(*, deprecated, message: "Renamed to set(.frames(), by: .wrapping)")
    public mutating func setTimecode(wrapping source: FrameCount.Value) {
        set(source, by: .wrapping)
    }
    
    @available(*, deprecated, message: "Renamed to set(.frames(), by: .allowingInvalid)")
    public mutating func setTimecode(rawValues source: FrameCount.Value) {
        set(source, by: .allowingInvalid)
    }
}

// MARK: - FrameCount

extension Timecode {
    @available(*, deprecated, message: "Renamed to Timecode(.frames(count:), using:)")
    public init(
        _ exactly: FrameCount,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        format: StringFormat = .default()
    ) throws {
        let properties = Properties(rate: rate, base: .default(), limit: limit)
        try self.init(exactly, using: properties)
    }
    
    @available(*, deprecated, message: "Renamed to Timecode(.frames(count:), using:, by: .clamping)")
    public init(
        clamping source: FrameCount,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: .default(), limit: limit)
        self.init(source, using: properties, by: .clamping)
    }
    
    @available(*, deprecated, message: "Renamed to Timecode(.frames(count:), using:, by: .wrapping)")
    public init(
        wrapping source: FrameCount,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: .default(), limit: limit)
        self.init(source, using: properties, by: .wrapping)
    }
    
    @available(*, deprecated, message: "Renamed to Timecode(.frames(count:), using:, by: .allowingInvalid)")
    public init(
        rawValues source: FrameCount,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: .default(), limit: limit)
        self.init(source, using: properties, by: .allowingInvalid)
    }
}

extension Timecode {
    @available(*, deprecated, message: "Renamed to set(.frames(count:))")
    public mutating func setTimecode(exactly source: FrameCount) throws {
        try set(source)
    }
    
    @available(*, deprecated, message: "Renamed to set(.frames(count:), by: .clamping)")
    public mutating func setTimecode(clamping source: FrameCount) {
        set(source, by: .clamping)
    }
    
    @available(*, deprecated, message: "Renamed to set(.frames(count:), by: .clamping)")
    public mutating func setTimecode(wrapping source: FrameCount) {
        set(source, by: .wrapping)
    }
    
    @available(*, deprecated, message: "Renamed to set(.frames(count:), by: .clamping)")
    public mutating func setTimecode(rawValues source: FrameCount) {
        set(source, by: .allowingInvalid)
    }
}

// MARK: - CMTime

#if canImport(CoreMedia)

import Foundation
import CoreMedia

@available(macOS 10.7, iOS 4.0, tvOS 9.0, watchOS 6.0, *)
extension Timecode {
    @available(*, deprecated, message: "Renamed to Timecode(.cmTime(), using:)")
    public init(
        _ source: CMTime,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        let properties = Properties(rate: rate, base: base, limit: limit)
        try self.init(source, using: properties)
    }
    
    @available(*, deprecated, message: "Renamed to Timecode(.cmTime(), using:, by: .clamping)")
    public init(
        clamping source: CMTime,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(source, using: properties, by: .clamping)
    }
    
    @available(*, deprecated, message: "Renamed to Timecode(.cmTime(), using:, by: .wrapping)")
    public init(
        wrapping source: CMTime,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(source, using: properties, by: .wrapping)
    }
    
    @available(*, deprecated, message: "Renamed to Timecode(.cmTime(), using:, by: .allowingInvalid)")
    public init(
        rawValues source: CMTime,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(source, using: properties, by: .allowingInvalid)
    }
}

@available(macOS 10.7, iOS 4.0, tvOS 9.0, watchOS 6.0, *)
extension Timecode {
    @available(*, deprecated, message: "Renamed to set(.cmTime())")
    public mutating func setTimecode(_ exactly: CMTime) throws {
        try set(exactly)
    }
    
    @available(*, deprecated, message: "Renamed to set(.cmTime(), by: .clamping)")
    public mutating func setTimecode(clamping source: CMTime) {
        set(source, by: .clamping)
    }
    
    @available(*, deprecated, message: "Renamed to set(.cmTime(), by: .wrapping)")
    public mutating func setTimecode(wrapping source: CMTime) {
        set(source, by: .wrapping)
    }
    
    @available(*, deprecated, message: "Renamed to set(.cmTime(), by: .allowingInvalid)")
    public mutating func setTimecode(rawValues source: CMTime) {
        set(source, by: .allowingInvalid)
    }
}

@available(macOS 10.7, iOS 4.0, tvOS 9.0, watchOS 6.0, *)
extension CMTime {
    @available(*, deprecated, renamed: "timecode(using:)")
    public func toTimecode(
        at rate: TimecodeFrameRate,
        limit: Timecode.UpperLimit = ._24hours,
        base: Timecode.SubFramesBase = .default(),
        format: Timecode.StringFormat = .default()
    ) throws -> Timecode {
        let properties = Timecode.Properties(rate: rate, base: base, limit: limit)
        return try timecode(using: properties)
    }
}

#endif

// MARK: - Fraction

extension Timecode {
    @available(*, deprecated, message: "Renamed to Timecode(.rational(), using:)")
    public init(
        _ exactly: Fraction,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        let properties = Properties(rate: rate, base: base, limit: limit)
        try self.init(exactly, using: properties)
    }
    
    @available(*, deprecated, message: "Renamed to Timecode(.rational(), using:, by: .clamping)")
    public init(
        clamping source: Fraction,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(source, using: properties, by: .clamping)
    }
    
    @available(*, deprecated, message: "Renamed to Timecode(.rational(), using:, by: .wrapping)")
    /// fractions.)
    public init(
        wrapping source: Fraction,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(source, using: properties, by: .wrapping)
    }
    
    @available(*, deprecated, message: "Renamed to Timecode(.rational(), using:, by: .allowingInvalid)")
    public init(
        rawValues source: Fraction,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(source, using: properties, by: .allowingInvalid)
    }
}

extension Timecode {
    @available(*, deprecated, message: "Renamed to set(.rational())")
    public mutating func setTimecode(_ exactly: Fraction) throws {
        try set(exactly)
    }
    
    @available(*, deprecated, message: "Renamed to set(.rational(), by: .clamping)")
    public mutating func setTimecode(clamping source: Fraction) {
        set(source, by: .clamping)
    }
    
    @available(*, deprecated, message: "Renamed to set(.rational(), by: .wrapping)")
    public mutating func setTimecode(wrapping source: Fraction) {
        set(source, by: .wrapping)
    }
    
    @available(*, deprecated, message: "Renamed to set(.rational(), by: .allowingInvalid)")
    public mutating func setTimecode(rawValues source: Fraction) {
        set(source, by: .allowingInvalid)
    }
}

extension Fraction {
    @available(*, deprecated, renamed: "timecode(using:)")
    public func toTimecode(
        at rate: TimecodeFrameRate,
        limit: Timecode.UpperLimit = ._24hours,
        base: Timecode.SubFramesBase = .default(),
        format: Timecode.StringFormat = .default()
    ) throws -> Timecode {
        let properties = Timecode.Properties(rate: rate, base: base, limit: limit)
        return try timecode(using: properties)
    }
    
    @available(*, deprecated, renamed: "timecodeInterval(using:)")
    public func toTimecodeInterval(
        at rate: TimecodeFrameRate,
        limit: Timecode.UpperLimit = ._24hours,
        base: Timecode.SubFramesBase = .default(),
        format: Timecode.StringFormat = .default()
    ) throws -> TimecodeInterval {
        let properties = Timecode.Properties(rate: rate, base: base, limit: limit)
        return try timecodeInterval(using: properties)
    }
}

// MARK: - Real Time

extension Timecode {
    @available(*, deprecated, message: "Renamed to Timecode(.realTime(), using:)")
    public init(
        realTime exactly: TimeInterval,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        let properties = Properties(rate: rate, base: base, limit: limit)
        try self.init(exactly, using: properties)
    }
    
    @available(*, deprecated, message: "Renamed to Timecode(.realTime(), using:, by: .clamping)")
    public init(
        clampingRealTime source: TimeInterval,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(source, using: properties, by: .clamping)
    }
    
    @available(*, deprecated, message: "Renamed to Timecode(.realTime(), using:, by: .wrapping)")
    public init(
        wrappingRealTime source: TimeInterval,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(source, using: properties, by: .wrapping)
    }
    
    @available(*, deprecated, message: "Renamed to Timecode(.realTime(), using:, by: .allowingInvalid)")
    public init(
        rawValuesRealTime source: TimeInterval,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(source, using: properties, by: .allowingInvalid)
    }
}

extension Timecode {
    @available(*, deprecated, message: "Renamed to set(.realTime())")
    public mutating func setTimecode(realTime: TimeInterval) throws {
        try set(realTime)
    }
    
    @available(*, deprecated, message: "Renamed to set(.realTime(), by: .clamping)")
    public mutating func setTimecode(clampingRealTime source: TimeInterval) {
        set(source, by: .clamping)
    }
    
    @available(*, deprecated, message: "Renamed to set(.realTime(), by: .wrapping)")
    public mutating func setTimecode(wrappingRealTime source: TimeInterval) {
        set(source, by: .wrapping)
    }
    
    @available(*, deprecated, message: "Renamed to set(.realTime(), by: .allowingInvalid)")
    public mutating func setTimecode(rawValuesRealTime source: TimeInterval) {
        set(source, by: .allowingInvalid)
    }
}

extension TimeInterval {
    @available(*, deprecated, renamed: "timecode(using:)")
    public func toTimecode(
        at rate: TimecodeFrameRate,
        limit: Timecode.UpperLimit = ._24hours,
        base: Timecode.SubFramesBase = .default(),
        format: Timecode.StringFormat = .default()
    ) throws -> Timecode {
        let properties = Timecode.Properties(rate: rate, base: base, limit: limit)
        return try timecode(using: properties)
    }
}

// MARK: - Samples

extension Timecode {
    // MARK: Int
    
    @available(*, deprecated, message: "Renamed to Timecode(.samples(_:sampleRate:), using:)")
    public init(
        samples exactly: Int,
        sampleRate: Int,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        let properties = Properties(rate: rate, base: base, limit: limit)
        try self.init(.samples(exactly, sampleRate: sampleRate), using: properties)
    }
    
    @available(*, deprecated, message: "Renamed to Timecode(.samples(_:sampleRate:), using:, by: .clamping)")
    public init(
        clampingSamples source: Int,
        sampleRate: Int,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(.samples(source, sampleRate: sampleRate), using: properties, by: .clamping)
    }
    
    @available(*, deprecated, message: "Renamed to Timecode(.samples(_:sampleRate:), using:, by: .wrapping)")
    public init(
        wrappingSamples source: Int,
        sampleRate: Int,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(.samples(source, sampleRate: sampleRate), using: properties, by: .wrapping)
    }
    
    @available(*, deprecated, message: "Renamed to Timecode(.samples(_:sampleRate:), using:, by: .allowingInvalid)")
    public init(
        rawValuesSamples source: Int,
        sampleRate: Int,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(.samples(source, sampleRate: sampleRate), using: properties, by: .allowingInvalid)
    }
    
    // MARK: Double
    
    @available(*, deprecated, message: "Renamed to Timecode(.samples(_:sampleRate:), using:)")
    public init(
        samples exactly: Double,
        sampleRate: Int,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        let properties = Properties(rate: rate, base: base, limit: limit)
        try self.init(.samples(exactly, sampleRate: sampleRate), using: properties)
    }
    
    @available(*, deprecated, message: "Renamed to Timecode(.samples(_:sampleRate:), using:, by: .clamping)")
    public init(
        clampingSamples source: Double,
        sampleRate: Int,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(.samples(source, sampleRate: sampleRate), using: properties, by: .clamping)
    }
    
    @available(*, deprecated, message: "Renamed to Timecode(.samples(_:sampleRate:), using:, by: .wrapping)")
    public init(
        wrappingSamples source: Double,
        sampleRate: Int,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(.samples(source, sampleRate: sampleRate), using: properties, by: .wrapping)
    }
    
    @available(*, deprecated, message: "Renamed to Timecode(.samples(_:sampleRate:), using:, by: .allowingInvalid)")
    public init(
        rawValuesSamples source: Double,
        sampleRate: Int,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(.samples(source, sampleRate: sampleRate), using: properties, by: .allowingInvalid)
    }
}

extension Timecode {
    // MARK: Int
    
    @available(*, deprecated, message: "Renamed to set(.samples(_:sampleRate:))")
    public mutating func setTimecode(samples: Int, sampleRate: Int) throws {
        try set(.samples(samples, sampleRate: sampleRate))
    }
    
    @available(*, deprecated, message: "Renamed to set(.samples(_:sampleRate:), by: .clamping)")
    public mutating func setTimecode(clampingSamples: Int, sampleRate: Int) {
        set(.samples(clampingSamples, sampleRate: sampleRate), by: .clamping)
    }
    
    @available(*, deprecated, message: "Renamed to set(.samples(_:sampleRate:), by: .wrapping)")
    public mutating func setTimecode(wrappingSamples: Int, sampleRate: Int) {
        set(.samples(wrappingSamples, sampleRate: sampleRate), by: .wrapping)
    }
    
    @available(*, deprecated, message: "Renamed to set(.samples(_:sampleRate:), by: .allowingInvalid)")
    public mutating func setTimecode(rawValuesSamples: Int, sampleRate: Int) {
        set(.samples(rawValuesSamples, sampleRate: sampleRate), by: .allowingInvalid)
    }
    
    // MARK: Double
    
    @available(*, deprecated, message: "Renamed to set(.samples(_:sampleRate:))")
    public mutating func setTimecode(samples: Double, sampleRate: Int) throws {
        try set(.samples(samples, sampleRate: sampleRate))
    }
    
    @available(*, deprecated, message: "Renamed to set(.samples(_:sampleRate:), by: .clamping)")
    public mutating func setTimecode(clampingSamples: Double, sampleRate: Int) {
        set(.samples(clampingSamples, sampleRate: sampleRate), by: .clamping)
    }
    
    @available(*, deprecated, message: "Renamed to set(.samples(_:sampleRate:), by: .wrapping)")
    public mutating func setTimecode(wrappingSamples: Double, sampleRate: Int) {
        set(.samples(wrappingSamples, sampleRate: sampleRate), by: .wrapping)
    }
    
    @available(*, deprecated, message: "Renamed to set(.samples(_:sampleRate:), by: .allowingInvalid)")
    public mutating func setTimecode(rawValuesSamples: Double, sampleRate: Int) {
        set(.samples(rawValuesSamples, sampleRate: sampleRate), by: .allowingInvalid)
    }
}

// MARK: - String

extension Timecode {
    @available(*, deprecated, message: "Renamed to Timecode(.string(), using:)")
    public init(
        _ exactlyTimecodeString: String,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        let properties = Properties(rate: rate, base: base, limit: limit)
        try self.init(exactlyTimecodeString, using: properties)
    }
    
    @available(*, deprecated, message: "Renamed to Timecode(.string(), using:, by: .clamping)")
    public init(
        clamping timecodeString: String,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        let properties = Properties(rate: rate, base: base, limit: limit)
        try self.init(timecodeString, using: properties, by: .clamping)
    }
    
    @available(*, deprecated, message: "Renamed to Timecode(.string(), using:, by: .clampingComponents)")
    public init(
        clampingEach timecodeString: String,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        let properties = Properties(rate: rate, base: base, limit: limit)
        try self.init(timecodeString, using: properties, by: .clampingComponents)
    }
    
    @available(*, deprecated, message: "Renamed to Timecode(.string(), using:, by: .wrapping)")
    public init(
        wrapping timecodeString: String,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        let properties = Properties(rate: rate, base: base, limit: limit)
        try self.init(timecodeString, using: properties, by: .wrapping)
    }
    
    @available(*, deprecated, message: "Renamed to Timecode(.string(), using:, by: .allowingInvalid)")
    public init(
        rawValues timecodeString: String,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        let properties = Properties(rate: rate, base: base, limit: limit)
        try self.init(timecodeString, using: properties, by: .allowingInvalid)
    }
}

extension Timecode {
    @available(*, deprecated, renamed: "stringValue()")
    public var stringValue: String { stringValue() }
    
    @available(*, deprecated, message: "Renamed to stringValue(format: [.filenameCompatible])")
    public var stringValueFileNameCompatible: String {
        stringValue(format: [.filenameCompatible])
    }
}

extension Timecode {
    @available(*, deprecated, message: "Renamed to set(.string())")
    public mutating func setTimecode(exactly string: String) throws {
        try set(string)
    }
    
    @available(*, deprecated, message: "Renamed to set(.string(), by: .clamping)")
    public mutating func setTimecode(clamping string: String) throws {
        try set(string, by: .clamping)
    }
    
    @available(*, deprecated, message: "Renamed to set(.string(), by: .clampingComponents)")
    public mutating func setTimecode(clampingEach string: String) throws {
        try set(string, by: .clampingComponents)
    }
    
    @available(*, deprecated, message: "Renamed to set(.string(), by: .wrapping)")
    public mutating func setTimecode(wrapping string: String) throws {
        try set(string, by: .wrapping)
    }
    
    @available(*, deprecated, message: "Renamed to set(.string(), by: .allowingInvalid)")
    public mutating func setTimecode(rawValues string: String) throws {
        try set(string, by: .allowingInvalid)
    }
}

extension String {
    @available(*, deprecated, renamed: "timecode(using:)")
    public func toTimecode(
        at rate: TimecodeFrameRate,
        limit: Timecode.UpperLimit = ._24hours,
        base: Timecode.SubFramesBase = .default(),
        format: Timecode.StringFormat = .default()
    ) throws -> Timecode {
        let properties = Timecode.Properties(rate: rate, base: base, limit: limit)
        return try timecode(using: properties)
    }
    
    @available(*, deprecated, message: "Renamed to timecode(using:, by: .allowingInvalid)")
    public func toTimecode(
        rawValuesAt rate: TimecodeFrameRate,
        limit: Timecode.UpperLimit = ._24hours,
        base: Timecode.SubFramesBase = .default(),
        format: Timecode.StringFormat = .default()
    ) throws -> Timecode {
        let properties = Timecode.Properties(rate: rate, base: base, limit: limit)
        return try timecode(using: properties, by: .allowingInvalid)
    }
}

// MARK: - TimecodeFrameRate

extension String {
    @available(*, deprecated, renamed: "timecodeFrameRate()")
    @_disfavoredOverload
    public var toTimecodeFrameRate: TimecodeFrameRate? {
        timecodeFrameRate()
    }
}

// MARK: - VideoFrameRate

extension String {
    @available(*, deprecated, renamed: "videoFrameRate()")
    @_disfavoredOverload
    public var toVideoFrameRate: VideoFrameRate? {
        VideoFrameRate(stringValue: self)
    }
}

// MARK: - TimecodeInterval

#if canImport(CoreMedia)

import Foundation
import CoreMedia

@available(macOS 10.7, iOS 4.0, tvOS 9.0, watchOS 6.0, *)
extension TimecodeInterval {
    @available(*, deprecated, renamed: "init(_:using:)")
    public init(
        _ cmTime: CMTime,
        at rate: TimecodeFrameRate,
        limit: Timecode.UpperLimit = ._24hours,
        base: Timecode.SubFramesBase = .default(),
        format: Timecode.StringFormat = .default()
    ) throws {
        let properties = Timecode.Properties(rate: rate, base: base, limit: limit)
        try self.init(cmTime, using: properties)
    }
}

@available(macOS 10.7, iOS 4.0, tvOS 9.0, watchOS 6.0, *)
extension CMTime {
    @available(*, deprecated, renamed: "timecodeInterval(using:)")
    public func toTimecodeInterval(
        at rate: TimecodeFrameRate,
        limit: Timecode.UpperLimit = ._24hours,
        base: Timecode.SubFramesBase = .default(),
        format: Timecode.StringFormat = .default()
    ) throws -> TimecodeInterval {
        let properties = Timecode.Properties(rate: rate, base: base, limit: limit)
        return try timecodeInterval(using: properties)
    }
}

#endif
