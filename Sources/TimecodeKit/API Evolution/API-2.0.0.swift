//
//  API-2.0.0.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: API Changes in TimecodeKit 2.0.0

extension Timecode.UpperLimit {
    @available(*, renamed: "_24Hours")
    public static let _24hours: Self = ._24Hours
    
    @available(*, renamed: "_100Days")
    public static let _100days: Self = ._100Days
}


// MARK: - Additional Deprecations

// NOTE:
// These are disabled because the API changes from 1.x to 2.x were too extensive to fully/properly
// implement using @available() attributes and was actually causing issues with Xcode's autocomplete
// in the IDE's code editor.
// So instead, a 1.x -> 2.x Migration Guide was written and included in TimecodeKit 2's documentation.

#if ENABLE_API_DEPRECATIONS

// MARK: - TCC

@available(
    *,
    deprecated,
    message: "TCC() is removed in TimecodeKit 2.x. Use Timecode(.components(), at:) instead."
)
public typealias TCC = Timecode.Components

// MARK: - Inits

extension Timecode {
    @available(*, deprecated, message: "Renamed to Timecode(.zero, using:)")
    public init(
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24Hours,
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

// MARK: - Math

extension Timecode {
    // MARK: Add
    
    @available(*, deprecated, message: "Renamed to add(_:, by: .clamping)")
    public mutating func add(clamping values: Components) {
        add(values, by: .clamping)
    }
    
    @available(*, deprecated, message: "Renamed to add(_:, by: .wrapping)")
    public mutating func add(wrapping values: Components) {
        add(values, by: .wrapping)
    }
    
    @available(*, deprecated, message: "Renamed to adding(_:, by: .clamping)")
    public func adding(clamping values: Components) -> Timecode {
        adding(values, by: .clamping)
    }
    
    @available(*, deprecated, message: "Renamed to adding(_:, by: .wrapping)")
    public func adding(wrapping values: Components) -> Timecode {
        adding(values, by: .wrapping)
    }
    
    // MARK: Subtract
    
    @available(*, deprecated, message: "Renamed to subtract(_:, by: .clamping)")
    public mutating func subtract(clamping values: Components) {
        subtract(values, by: .clamping)
    }
    
    @available(*, deprecated, message: "Renamed to subtract(_:, by: .wrapping)")
    public mutating func subtract(wrapping values: Components) {
        subtract(values, by: .wrapping)
    }
    
    @available(*, deprecated, message: "Renamed to subtracting(_:, by: .clamping)")
    public func subtracting(clamping values: Components) -> Timecode {
        subtracting(values, by: .clamping)
    }
    
    @available(*, deprecated, message: "Renamed to subtracting(_:, by: .wrapping)")
    public func subtracting(wrapping values: Components) -> Timecode {
        subtracting(values, by: .wrapping)
    }
    
    // MARK: Multiply
    
    @available(*, deprecated, message: "Renamed to multiply(_:, by: .clamping)")
    public mutating func multiply(clamping value: Double) {
        multiply(value, by: .clamping)
    }
    
    @available(*, deprecated, message: "Renamed to multiply(_:, by: .wrapping)")
    public mutating func multiply(wrapping value: Double) {
        multiply(value, by: .wrapping)
    }
    
    @available(*, deprecated, message: "Renamed to multiplying(_:, by: .clamping)")
    public func multiplying(clamping value: Double) -> Timecode {
        multiplying(value, by: .clamping)
    }
    
    @available(*, deprecated, message: "Renamed to multiplying(_:, by: .wrapping)")
    public func multiplying(wrapping value: Double) -> Timecode {
        multiplying(value, by: .wrapping)
    }
    
    // MARK: Divide
    
    @available(*, deprecated, message: "Renamed to divide(_:, by: .clamping)")
    public mutating func divide(clamping value: Double) {
        divide(value, by: .clamping)
    }
    
    @available(*, deprecated, message: "Renamed to divide(_:, by: .wrapping)")
    public mutating func divide(wrapping value: Double) {
        divide(value, by: .wrapping)
    }
    
    @available(*, deprecated, message: "Renamed to dividing(_:, by: .clamping)")
    public func dividing(clamping value: Double) -> Timecode {
        dividing(value, by: .clamping)
    }
    
    @available(*, deprecated, message: "Renamed to dividing(_:, by: .wrapping)")
    public func dividing(wrapping value: Double) -> Timecode {
        dividing(value, by: .wrapping)
    }
}

// MARK: - AVAsset

// AVAssetReader is unavailable on watchOS so we can't support any AVAsset operations
#if canImport(AVFoundation) && !os(watchOS)

import AVFoundation
import Foundation

extension AVAsset {
    @available(*, deprecated, renamed: "startTimecode(at:base:limit:)")
    @_disfavoredOverload
    public func startTimecode(
        at frameRate: TimecodeFrameRate? = nil,
        base: Timecode.SubFramesBase = .default(),
        limit: Timecode.UpperLimit = ._24Hours,
        format: Timecode.StringFormat
    ) throws -> Timecode? {
        try startTimecode(at: frameRate, base: base, limit: limit)
    }
    
    @available(*, deprecated, renamed: "endTimecode(at:base:limit:)")
    @_disfavoredOverload
    public func endTimecode(
        at frameRate: TimecodeFrameRate? = nil,
        base: Timecode.SubFramesBase = .default(),
        limit: Timecode.UpperLimit = ._24Hours,
        format: Timecode.StringFormat
    ) throws -> Timecode? {
        try endTimecode(at: frameRate, base: base, limit: limit)
    }
    
    @available(*, deprecated, renamed: "durationTimecode(at:base:limit:)")
    @_disfavoredOverload
    public func durationTimecode(
        at frameRate: TimecodeFrameRate? = nil,
        limit: Timecode.UpperLimit = ._24Hours,
        base: Timecode.SubFramesBase = .default(),
        format: Timecode.StringFormat = .default()
    ) throws -> Timecode {
        try durationTimecode(at: frameRate, base: base, limit: limit)
    }
}

extension Timecode {
    @available(*, deprecated, message: "Renamed to Timecode(.avAsset(asset, .start))")
    public init(
        startOf asset: AVAsset,
        at rate: TimecodeFrameRate? = nil,
        limit: UpperLimit = ._24Hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        if let rate = rate {
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
        limit: UpperLimit = ._24Hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        if let rate = rate {
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
        limit: UpperLimit = ._24Hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        if let rate = rate {
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

import AVFoundation
import Foundation

extension AVAssetTrack {
    @available(*, deprecated, renamed: "durationTimecode(at:limit:base:)")
    @_disfavoredOverload
    public func durationTimecode(
        at frameRate: TimecodeFrameRate? = nil,
        limit: Timecode.UpperLimit = ._24Hours,
        base: Timecode.SubFramesBase = .default(),
        format: Timecode.StringFormat = .default()
    ) throws -> Timecode {
        try durationTimecode(at: frameRate, limit: limit, base: base)
    }
}

#endif

// MARK: - Components

extension Timecode {
    @available(*, deprecated, message: "Renamed to Timecode(.components(), at:, base:, limit:)")
    @_disfavoredOverload
    public init(
        _ exactly: Components,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24Hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        let properties = Properties(rate: rate, base: base, limit: limit)
        try self.init(.components(exactly), using: properties)
    }
    
    @available(
        *,
        deprecated,
        message: "Renamed to Timecode(.components(), at:, base:, limit:, by: .clamping)"
    )
    public init(
        clamping rawValues: Components,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24Hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(.components(rawValues), using: properties, by: .clamping)
    }
    
    @available(
        *,
        deprecated,
        message: "Renamed to Timecode(.components(), at:, base:, limit:, by: .clampingComponents)"
    )
    public init(
        clampingEach rawValues: Components,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24Hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(.components(rawValues), using: properties, by: .clampingComponents)
    }
    
    @available(
        *,
        deprecated,
        message: "Renamed to Timecode(.components(), at:, base:, limit:, by: .wrapping)"
    )
    public init(
        wrapping rawValues: Components,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24Hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(.components(rawValues), using: properties, by: .wrapping)
    }
    
    @available(
        *,
        deprecated,
        message: "Renamed to Timecode(.components(), at:, base:, limit:, by: .allowingInvalid)"
    )
    public init(
        rawValues: Components,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24Hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(.components(rawValues), using: properties, by: .allowingInvalid)
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
    @available(*, deprecated, renamed: "timecode(at:base:limit:)")
    public func toTimecode(
        at rate: TimecodeFrameRate,
        limit: Timecode.UpperLimit = ._24Hours,
        base: Timecode.SubFramesBase = .default(),
        format: Timecode.StringFormat = .default()
    ) throws -> Timecode {
        let properties = Timecode.Properties(rate: rate, base: base, limit: limit)
        return try timecode(using: properties)
    }
    
    @available(*, deprecated, message: "Renamed to timecode(at:base:limit: by: .allowingInvalid)")
    public func toTimecode(
        rawValuesAt rate: TimecodeFrameRate,
        limit: Timecode.UpperLimit = ._24Hours,
        base: Timecode.SubFramesBase = .default(),
        format: Timecode.StringFormat = .default()
    ) -> Timecode {
        let properties = Timecode.Properties(rate: rate, base: base, limit: limit)
        return timecode(using: properties, by: .allowingInvalid)
    }
    
    @available(*, deprecated, renamed: "invalidComponents(at:base:limit:)")
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
    @available(*, deprecated, message: "Renamed to Timecode(.feetAndFrames(), at:, base:, limit:)")
    @_disfavoredOverload
    public init(
        _ exactly: FeetAndFrames,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24Hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        let properties = Properties(rate: rate, base: base, limit: limit)
        try self.init(.feetAndFrames(exactly), using: properties)
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
    @available(*, deprecated, message: "Renamed to Timecode(.frames(), at:, base:, limit:)")
    @_disfavoredOverload
    public init(
        _ exactly: FrameCount.Value,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24Hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        let properties = Properties(rate: rate, base: base, limit: limit)
        try self.init(.frames(exactly), using: properties)
    }
    
    @available(
        *,
        deprecated,
        message: "Renamed to Timecode(.frames(), at:, base:, limit:, by: .clamping)"
    )
    public init(
        clamping source: FrameCount.Value,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24Hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(.frames(source), using: properties, by: .clamping)
    }
    
    @available(
        *,
        deprecated,
        message: "Renamed to Timecode(.frames(), at:, base:, limit:, by: .wrapping)"
    )
    public init(
        wrapping source: FrameCount.Value,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24Hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(.frames(source), using: properties, by: .wrapping)
    }
    
    @available(
        *,
        deprecated,
        message: "Renamed to Timecode(.frames(), at:, base:, limit:, by: .allowingInvalid)"
    )
    public init(
        rawValues source: FrameCount.Value,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24Hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(.frames(source), using: properties, by: .allowingInvalid)
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
    @available(*, deprecated, message: "Renamed to Timecode(.frames(), at:, base:, limit:)")
    @_disfavoredOverload
    public init(
        _ exactly: FrameCount,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24Hours,
        format: StringFormat = .default()
    ) throws {
        let properties = Properties(rate: rate, base: .default(), limit: limit)
        try self.init(.frames(exactly), using: properties)
    }
    
    @available(
        *,
        deprecated,
        message: "Renamed to Timecode(.frames(), at:, base:, limit:, by: .clamping)"
    )
    public init(
        clamping source: FrameCount,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24Hours,
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: .default(), limit: limit)
        self.init(.frames(source), using: properties, by: .clamping)
    }
    
    @available(
        *,
        deprecated,
        message: "Renamed to Timecode(.frames(), at:, base:, limit:, by: .wrapping)"
    )
    public init(
        wrapping source: FrameCount,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24Hours,
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: .default(), limit: limit)
        self.init(.frames(source), using: properties, by: .wrapping)
    }
    
    @available(
        *,
        deprecated,
        message: "Renamed to Timecode(.frames(), at:, base:, limit:, by: .allowingInvalid)"
    )
    public init(
        rawValues source: FrameCount,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24Hours,
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: .default(), limit: limit)
        self.init(.frames(source), using: properties, by: .allowingInvalid)
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

import CoreMedia
import Foundation

@available(macOS 10.7, iOS 4.0, tvOS 9.0, watchOS 6.0, *)
extension Timecode {
    @available(*, deprecated, message: "Renamed to Timecode(.cmTime(), at:, base:, limit:)")
    @_disfavoredOverload
    public init(
        _ source: CMTime,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24Hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        let properties = Properties(rate: rate, base: base, limit: limit)
        try self.init(.cmTime(source), using: properties)
    }
    
    @available(
        *,
        deprecated,
        message: "Renamed to Timecode(.cmTime(), at:, base:, limit:, by: .clamping)"
    )
    public init(
        clamping source: CMTime,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24Hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(.cmTime(source), using: properties, by: .clamping)
    }
    
    @available(
        *,
        deprecated,
        message: "Renamed to Timecode(.cmTime(), at:, base:, limit:, by: .wrapping)"
    )
    public init(
        wrapping source: CMTime,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24Hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(.cmTime(source), using: properties, by: .wrapping)
    }
    
    @available(
        *,
        deprecated,
        message: "Renamed to Timecode(.cmTime(), at:, base:, limit:, by: .allowingInvalid)"
    )
    public init(
        rawValues source: CMTime,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24Hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(.cmTime(source), using: properties, by: .allowingInvalid)
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
    @available(*, deprecated, renamed: "timecode(at:base:limit:)")
    public func toTimecode(
        at rate: TimecodeFrameRate,
        limit: Timecode.UpperLimit = ._24Hours,
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
    @available(*, deprecated, message: "Renamed to Timecode(.rational(), at:, base:, limit:)")
    @_disfavoredOverload
    public init(
        _ exactly: Fraction,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24Hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        let properties = Properties(rate: rate, base: base, limit: limit)
        try self.init(.rational(exactly), using: properties)
    }
    
    @available(
        *,
        deprecated,
        message: "Renamed to Timecode(.rational(), at:, base:, limit:, by: .clamping)"
    )
    public init(
        clamping source: Fraction,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24Hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(.rational(source), using: properties, by: .clamping)
    }
    
    @available(
        *,
        deprecated,
        message: "Renamed to Timecode(.rational(), at:, base:, limit:, by: .wrapping)"
    )
    /// fractions.)
    public init(
        wrapping source: Fraction,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24Hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(.rational(source), using: properties, by: .wrapping)
    }
    
    @available(
        *,
        deprecated,
        message: "Renamed to Timecode(.rational(), at:, base:, limit::, by: .allowingInvalid)"
    )
    public init(
        rawValues source: Fraction,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24Hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(.rational(source), using: properties, by: .allowingInvalid)
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
    @available(*, deprecated, renamed: "timecode(at:base:limit:)")
    public func toTimecode(
        at rate: TimecodeFrameRate,
        limit: Timecode.UpperLimit = ._24Hours,
        base: Timecode.SubFramesBase = .default(),
        format: Timecode.StringFormat = .default()
    ) throws -> Timecode {
        let properties = Timecode.Properties(rate: rate, base: base, limit: limit)
        return try timecode(using: properties)
    }
    
    @available(*, deprecated, renamed: "timecodeInterval(at:base:limit:)")
    public func toTimecodeInterval(
        at rate: TimecodeFrameRate,
        limit: Timecode.UpperLimit = ._24Hours,
        base: Timecode.SubFramesBase = .default(),
        format: Timecode.StringFormat = .default()
    ) throws -> TimecodeInterval {
        let properties = Timecode.Properties(rate: rate, base: base, limit: limit)
        return try timecodeInterval(using: properties)
    }
}

// MARK: - Real Time

extension Timecode {
    @available(*, deprecated, message: "Renamed to Timecode(.realTime(), at:, base:, limit:)")
    public init(
        realTime exactly: TimeInterval,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24Hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        let properties = Properties(rate: rate, base: base, limit: limit)
        try self.init(.realTime(seconds: exactly), using: properties)
    }
    
    @available(
        *,
        deprecated,
        message: "Renamed to Timecode(.realTime(), at:, base:, limit:, by: .clamping)"
    )
    public init(
        clampingRealTime source: TimeInterval,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24Hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(.realTime(seconds: source), using: properties, by: .clamping)
    }
    
    @available(
        *,
        deprecated,
        message: "Renamed to Timecode(.realTime(), at:, base:, limit:, by: .wrapping)"
    )
    public init(
        wrappingRealTime source: TimeInterval,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24Hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(.realTime(seconds: source), using: properties, by: .wrapping)
    }
    
    @available(
        *,
        deprecated,
        message: "Renamed to Timecode(.realTime(), at:, base:, limit:, by: .allowingInvalid)"
    )
    public init(
        rawValuesRealTime source: TimeInterval,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24Hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(.realTime(seconds: source), using: properties, by: .allowingInvalid)
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
    @available(*, deprecated, renamed: "timecode(at:base:limit:)")
    public func toTimecode(
        at rate: TimecodeFrameRate,
        limit: Timecode.UpperLimit = ._24Hours,
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
    
    @available(
        *,
        deprecated,
        message: "Renamed to Timecode(.samples(_:sampleRate:), at:, base:, limit:)"
    )
    public init(
        samples exactly: Int,
        sampleRate: Int,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24Hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        let properties = Properties(rate: rate, base: base, limit: limit)
        try self.init(.samples(exactly, sampleRate: sampleRate), using: properties)
    }
    
    @available(
        *,
        deprecated,
        message: "Renamed to Timecode(.samples(_:sampleRate:), at:, base:, limit:, by: .clamping)"
    )
    public init(
        clampingSamples source: Int,
        sampleRate: Int,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24Hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(.samples(source, sampleRate: sampleRate), using: properties, by: .clamping)
    }
    
    @available(
        *,
        deprecated,
        message: "Renamed to Timecode(.samples(_:sampleRate:), at:, base:, limit:, by: .wrapping)"
    )
    public init(
        wrappingSamples source: Int,
        sampleRate: Int,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24Hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(.samples(source, sampleRate: sampleRate), using: properties, by: .wrapping)
    }
    
    @available(
        *,
        deprecated,
        message: "Renamed to Timecode(.samples(_:sampleRate:), at:, base:, limit:, by: .allowingInvalid)"
    )
    public init(
        rawValuesSamples source: Int,
        sampleRate: Int,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24Hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(.samples(source, sampleRate: sampleRate), using: properties, by: .allowingInvalid)
    }
    
    // MARK: Double
    
    @available(
        *,
        deprecated,
        message: "Renamed to Timecode(.samples(_:sampleRate:), at:, base:, limit:)"
    )
    public init(
        samples exactly: Double,
        sampleRate: Int,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24Hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        let properties = Properties(rate: rate, base: base, limit: limit)
        try self.init(.samples(exactly, sampleRate: sampleRate), using: properties)
    }
    
    @available(
        *,
        deprecated,
        message: "Renamed to Timecode(.samples(_:sampleRate:), at:, base:, limit:, by: .clamping)"
    )
    public init(
        clampingSamples source: Double,
        sampleRate: Int,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24Hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(.samples(source, sampleRate: sampleRate), using: properties, by: .clamping)
    }
    
    @available(
        *,
        deprecated,
        message: "Renamed to Timecode(.samples(_:sampleRate:), at:, base:, limit:, by: .wrapping)"
    )
    public init(
        wrappingSamples source: Double,
        sampleRate: Int,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24Hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        let properties = Properties(rate: rate, base: base, limit: limit)
        self.init(.samples(source, sampleRate: sampleRate), using: properties, by: .wrapping)
    }
    
    @available(
        *,
        deprecated,
        message: "Renamed to Timecode(.samples(_:sampleRate:), at:, base:, limit:, by: .allowingInvalid)"
    )
    public init(
        rawValuesSamples source: Double,
        sampleRate: Int,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24Hours,
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
    
    @available(
        *,
        deprecated,
        message: "Renamed to set(.samples(_:sampleRate:), by: .allowingInvalid)"
    )
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
    
    @available(
        *,
        deprecated,
        message: "Renamed to set(.samples(_:sampleRate:), by: .allowingInvalid)"
    )
    public mutating func setTimecode(rawValuesSamples: Double, sampleRate: Int) {
        set(.samples(rawValuesSamples, sampleRate: sampleRate), by: .allowingInvalid)
    }
}

// MARK: - String

extension Timecode {
    @available(*, deprecated, message: "Renamed to Timecode(.string(), at:, base:, limit:)")
    @_disfavoredOverload
    public init(
        _ exactlyTimecodeString: String,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24Hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        let properties = Properties(rate: rate, base: base, limit: limit)
        try self.init(.string(exactlyTimecodeString), using: properties)
    }
    
    @available(
        *,
        deprecated,
        message: "Renamed to Timecode(.string(), at:, base:, limit:, by: .clamping)"
    )
    public init(
        clamping timecodeString: String,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24Hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        let properties = Properties(rate: rate, base: base, limit: limit)
        try self.init(.string(timecodeString), using: properties, by: .clamping)
    }
    
    @available(
        *,
        deprecated,
        message: "Renamed to Timecode(.string(), at:, base:, limit:, by: .clampingComponents)"
    )
    public init(
        clampingEach timecodeString: String,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24Hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        let properties = Properties(rate: rate, base: base, limit: limit)
        try self.init(.string(timecodeString), using: properties, by: .clampingComponents)
    }
    
    @available(
        *,
        deprecated,
        message: "Renamed to Timecode(.string(), at:, base:, limit:, by: .wrapping)"
    )
    public init(
        wrapping timecodeString: String,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24Hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        let properties = Properties(rate: rate, base: base, limit: limit)
        try self.init(.string(timecodeString), using: properties, by: .wrapping)
    }
    
    @available(
        *,
        deprecated,
        message: "Renamed to Timecode(.string(), at:, base:, limit:, by: .allowingInvalid)"
    )
    public init(
        rawValues timecodeString: String,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24Hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        let properties = Properties(rate: rate, base: base, limit: limit)
        try self.init(.string(timecodeString), using: properties, by: .allowingInvalid)
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
    @available(*, deprecated, renamed: "timecode(at:base:limit:)")
    public func toTimecode(
        at rate: TimecodeFrameRate,
        limit: Timecode.UpperLimit = ._24Hours,
        base: Timecode.SubFramesBase = .default(),
        format: Timecode.StringFormat = .default()
    ) throws -> Timecode {
        let properties = Timecode.Properties(rate: rate, base: base, limit: limit)
        return try timecode(using: properties)
    }
    
    @available(
        *,
        deprecated,
        message: "Renamed to timecode(at:, base:, limit:, by: .allowingInvalid)"
    )
    public func toTimecode(
        rawValuesAt rate: TimecodeFrameRate,
        limit: Timecode.UpperLimit = ._24Hours,
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

import CoreMedia
import Foundation

@available(macOS 10.7, iOS 4.0, tvOS 9.0, watchOS 6.0, *)
extension TimecodeInterval {
    @available(*, deprecated, renamed: "init(_:at:base:limit:)")
    @_disfavoredOverload
    public init(
        _ cmTime: CMTime,
        at rate: TimecodeFrameRate,
        limit: Timecode.UpperLimit = ._24Hours,
        base: Timecode.SubFramesBase = .default(),
        format: Timecode.StringFormat = .default()
    ) throws {
        let properties = Timecode.Properties(rate: rate, base: base, limit: limit)
        try self.init(cmTime, using: properties)
    }
}

@available(macOS 10.7, iOS 4.0, tvOS 9.0, watchOS 6.0, *)
extension CMTime {
    @available(*, deprecated, renamed: "timecodeInterval(at:base:limit:)")
    public func toTimecodeInterval(
        at rate: TimecodeFrameRate,
        limit: Timecode.UpperLimit = ._24Hours,
        base: Timecode.SubFramesBase = .default(),
        format: Timecode.StringFormat = .default()
    ) throws -> TimecodeInterval {
        let properties = Timecode.Properties(rate: rate, base: base, limit: limit)
        return try timecodeInterval(using: properties)
    }
}

#endif

#endif
