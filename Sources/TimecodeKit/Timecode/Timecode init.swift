//
//  Timecode init.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension Timecode {
    // MARK: - TimecodeSource
    
    /// Initialize by converting a time source to timecode at a given frame rate.
    /// Uses defaulted properties.
    public init(
        _ source: TimecodeSource,
        using frameRate: TimecodeFrameRate
    ) throws {
        properties = Properties(rate: frameRate)
        try set(source)
    }
    
    /// Initialize by converting a time source to timecode at a given frame rate.
    /// Uses defaulted properties.
    public init(
        _ source: TimecodeSource,
        using frameRate: TimecodeFrameRate,
        by validation: Validation
    ) {
        properties = Properties(rate: frameRate)
        set(source, by: validation)
    }
    
    /// Initialize by converting a time source to timecode using the given properties.
    public init(
        _ source: TimecodeSource,
        using properties: Properties
    ) throws {
        self.properties = properties
        try set(source)
    }
    
    /// Initialize by converting a time source to timecode using the given properties.
    public init(
        _ source: TimecodeSource,
        using properties: Properties,
        by validation: Validation
    ) {
        self.properties = properties
        set(source, by: validation)
    }
    
    // MARK: - RichTimecodeSource
    
    /// Initialize by converting a rich time source to timecode.
    public init(
        _ source: RichTimecodeSource,
        using properties: Properties? = nil
    ) throws {
        self.properties = properties ?? .init(rate: ._24)
        try set(source, overriding: properties)
    }
    
    // MARK: - GuaranteedTimecodeSource
    
    public init(
        _ source: GuaranteedTimecodeSource,
        using frameRate: TimecodeFrameRate
    ) {
        properties = Properties(rate: frameRate)
        set(source)
    }
    
    public init(
        _ source: GuaranteedTimecodeSource,
        using properties: Properties
    ) {
        self.properties = properties
        set(source)
    }
    
    // MARK: - GuaranteedRichTimecodeSource
    
    /// Initialize by converting a rich time source to timecode.
    public init(
        _ source: GuaranteedRichTimecodeSource
    ) {
        self.properties = .init(rate: ._24) // needs to be initialized with something first
        self.properties = set(source)
    }
}

// MARK: - TimecodeSource Category Methods

extension TimecodeSource {
    /// Returns a new ``Timecode`` instance by converting a time source at the given frame rate.
    /// Uses defaulted properties.
    public func toTimecode(
        using frameRate: TimecodeFrameRate
    ) throws -> Timecode {
        try Timecode(self, using: frameRate)
    }
    
    /// Returns a new ``Timecode`` instance by converting a time source at the given frame rate.
    /// Uses defaulted properties.
    public func toTimecode(
        using frameRate: TimecodeFrameRate,
        by validation: Timecode.Validation
    ) -> Timecode {
        Timecode(self, using: frameRate, by: validation)
    }
    
    /// Returns a new ``Timecode`` instance by converting a time source.
    public func toTimecode(
        using properties: Timecode.Properties
    ) throws -> Timecode {
        try Timecode(self, using: properties)
    }
    
    /// Returns a new ``Timecode`` instance by converting a time source.
    public func toTimecode(
        using properties: Timecode.Properties,
        by validation: Timecode.Validation
    ) -> Timecode {
        Timecode(self, using: properties, by: validation)
    }
}
