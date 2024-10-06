//
//  Timecode init.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension Timecode {
    // MARK: - TimecodeSource
    
    /// Initialize by converting a time source to timecode at a given frame rate.
    ///
    /// - Throws: ``ValidationError``
    public init(
        _ source: TimecodeSourceValue,
        at frameRate: TimecodeFrameRate,
        base: SubFramesBase = .default(),
        limit: UpperLimit = .max24Hours
    ) throws {
        properties = Properties(rate: frameRate, base: base, limit: limit)
        try set(source.value)
    }
    
    /// Initialize by converting a time source to timecode at a given frame rate and validation rule.
    public init(
        _ source: TimecodeSourceValue,
        at frameRate: TimecodeFrameRate,
        base: SubFramesBase = .default(),
        limit: UpperLimit = .max24Hours,
        by validation: ValidationRule
    ) {
        properties = Properties(rate: frameRate, base: base, limit: limit)
        set(source.value, by: validation)
    }
    
    /// Initialize by converting a time source to timecode using the given properties.
    ///
    /// - Throws: ``ValidationError``
    public init(
        _ source: TimecodeSourceValue,
        using properties: Properties
    ) throws {
        self.properties = properties
        try set(source.value)
    }
    
    /// Initialize by converting a time source to timecode using the given properties.
    public init(
        _ source: TimecodeSourceValue,
        using properties: Properties,
        by validation: ValidationRule
    ) {
        self.properties = properties
        set(source.value, by: validation)
    }
    
    // MARK: - AsyncTimecodeSource
    
    /// Initialize by converting a time source to timecode at a given frame rate.
    ///
    /// - Throws: ``ValidationError``
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public init(
        _ source: AsyncTimecodeSourceValue,
        at frameRate: TimecodeFrameRate,
        base: SubFramesBase = .default(),
        limit: UpperLimit = .max24Hours
    ) async throws {
        properties = Properties(rate: frameRate, base: base, limit: limit)
        try await set(source.value)
    }
    
    /// Initialize by converting a time source to timecode at a given frame rate and validation rule.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public init(
        _ source: AsyncTimecodeSourceValue,
        at frameRate: TimecodeFrameRate,
        base: SubFramesBase = .default(),
        limit: UpperLimit = .max24Hours,
        by validation: ValidationRule
    ) async {
        properties = Properties(rate: frameRate, base: base, limit: limit)
        await set(source.value, by: validation)
    }
    
    /// Initialize by converting a time source to timecode using the given properties.
    ///
    /// - Throws: ``ValidationError``
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public init(
        _ source: AsyncTimecodeSourceValue,
        using properties: Properties
    ) async throws {
        self.properties = properties
        try await set(source.value)
    }
    
    /// Initialize by converting a time source to timecode using the given properties.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public init(
        _ source: AsyncTimecodeSourceValue,
        using properties: Properties,
        by validation: ValidationRule
    ) async {
        self.properties = properties
        await set(source.value, by: validation)
    }
    
    // MARK: - FormattedTimecodeSource
    
    /// Initialize by converting a time source to timecode at a given frame rate.
    ///
    /// - Throws: ``ValidationError``
    public init(
        _ source: FormattedTimecodeSourceValue,
        at frameRate: TimecodeFrameRate,
        base: SubFramesBase = .default(),
        limit: UpperLimit = .max24Hours
    ) throws {
        properties = Properties(rate: frameRate, base: base, limit: limit)
        try set(source.value)
    }
    
    /// Initialize by converting a time source to timecode at a given frame rate and validation rule.
    ///
    /// - Throws: ``ValidationError``
    public init(
        _ source: FormattedTimecodeSourceValue,
        at frameRate: TimecodeFrameRate,
        base: SubFramesBase = .default(),
        limit: UpperLimit = .max24Hours,
        by validation: ValidationRule
    ) throws {
        properties = Properties(rate: frameRate, base: base, limit: limit)
        try set(source.value, by: validation)
    }
    
    /// Initialize by converting a time source to timecode using the given properties.
    ///
    /// - Throws: ``ValidationError``
    public init(
        _ source: FormattedTimecodeSourceValue,
        using properties: Properties
    ) throws {
        self.properties = properties
        try set(source.value)
    }
    
    /// Initialize by converting a time source to timecode using the given properties.
    ///
    /// - Throws: ``ValidationError``
    public init(
        _ source: FormattedTimecodeSourceValue,
        using properties: Properties,
        by validation: ValidationRule
    ) throws {
        self.properties = properties
        try set(source.value, by: validation)
    }
    
    // MARK: - RichTimecodeSource
    
    /// Initialize by converting a rich time source to timecode.
    ///
    /// - Throws: ``ValidationError``
    public init(
        _ source: RichTimecodeSourceValue
    ) throws {
        properties = Properties(rate: .fps24) // must init to a default first
        try set(source.value)
    }
    
    // MARK: - AsyncRichTimecodeSource
    
    /// Initialize by converting a rich time source to timecode.
    ///
    /// - Throws: ``ValidationError``
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public init(
        _ source: AsyncRichTimecodeSourceValue
    ) async throws {
        properties = Properties(rate: .fps24) // must init to a default first
        try await set(source.value)
    }
    
    // MARK: - GuaranteedTimecodeSource
    
    /// Initialize by converting a time source to timecode at a given frame rate.
    public init(
        _ source: GuaranteedTimecodeSourceValue,
        at frameRate: TimecodeFrameRate,
        base: SubFramesBase = .default(),
        limit: UpperLimit = .max24Hours
    ) {
        properties = Properties(rate: frameRate, base: base, limit: limit)
        set(source.value)
    }
    
    /// Initialize by converting a time source to timecode using the given properties.
    public init(
        _ source: GuaranteedTimecodeSourceValue,
        using properties: Properties
    ) {
        self.properties = properties
        set(source.value)
    }
    
    // MARK: - GuaranteedRichTimecodeSource
    
    /// Initialize by converting a rich time source to timecode.
    public init(
        _ source: GuaranteedRichTimecodeSourceValue
    ) {
        properties = Properties(rate: .fps24) // needs to be initialized with something first
        properties = set(source.value)
    }
}
