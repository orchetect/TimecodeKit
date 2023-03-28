//
//  Timecode init.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension Timecode {
    // MARK: - TimecodeSource
    
    /// Initialize by converting a time source to timecode at a given frame rate.
    public init(
        _ source: TimecodeSource,
        using frameRate: TimecodeFrameRate,
        base: SubFramesBase = .default(),
        limit: UpperLimit = ._24hours
        
    ) throws {
        properties = Properties(rate: frameRate, base: base, limit: limit)
        try set(source)
    }
    
    /// Initialize by converting a time source to timecode at a given frame rate and validation rule.
    public init(
        _ source: TimecodeSource,
        using frameRate: TimecodeFrameRate,
        base: SubFramesBase = .default(),
        limit: UpperLimit = ._24hours,
        by validation: ValidationRule
    ) {
        properties = Properties(rate: frameRate, base: base, limit: limit)
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
        by validation: ValidationRule
    ) {
        self.properties = properties
        set(source, by: validation)
    }
    
    // MARK: - FormattedTimecodeSource
    
    /// Initialize by converting a time source to timecode at a given frame rate.
    public init(
        _ source: FormattedTimecodeSource,
        using frameRate: TimecodeFrameRate,
        base: SubFramesBase = .default(),
        limit: UpperLimit = ._24hours
    ) throws {
        properties = Properties(rate: frameRate, base: base, limit: limit)
        try set(source)
    }
    
    /// Initialize by converting a time source to timecode at a given frame rate and validation rule.
    public init(
        _ source: FormattedTimecodeSource,
        using frameRate: TimecodeFrameRate,
        base: SubFramesBase = .default(),
        limit: UpperLimit = ._24hours,
        by validation: ValidationRule
    ) throws {
        properties = Properties(rate: frameRate, base: base, limit: limit)
        try set(source, by: validation)
    }
    
    /// Initialize by converting a time source to timecode using the given properties.
    public init(
        _ source: FormattedTimecodeSource,
        using properties: Properties
    ) throws {
        self.properties = properties
        try set(source)
    }
    
    /// Initialize by converting a time source to timecode using the given properties.
    public init(
        _ source: FormattedTimecodeSource,
        using properties: Properties,
        by validation: ValidationRule
    ) throws {
        self.properties = properties
        try set(source, by: validation)
    }
    
    // MARK: - RichTimecodeSource
    
    /// Initialize by converting a rich time source to timecode.
    public init(
        _ source: RichTimecodeSource
    ) throws {
        properties = .init(rate: ._24) // must init to a default first
        try set(source)
    }
    
    // MARK: - GuaranteedTimecodeSource
    
    /// Initialize by converting a time source to timecode at a given frame rate.
    /// Uses defaulted properties.
    public init(
        _ source: GuaranteedTimecodeSource,
        using frameRate: TimecodeFrameRate,
        base: SubFramesBase = .default(),
        limit: UpperLimit = ._24hours
    ) {
        properties = Properties(rate: frameRate, base: base, limit: limit)
        set(source)
    }
    
    /// Initialize by converting a time source to timecode using the given properties.
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
        properties = .init(rate: ._24) // needs to be initialized with something first
        properties = set(source)
    }
}

// MARK: - TimecodeSource Category Methods

extension TimecodeSource {
    /// Returns a new ``Timecode`` instance by converting a time source at the given frame rate.
    public func timecode(
        using frameRate: TimecodeFrameRate,
        base: Timecode.SubFramesBase = .default(),
        limit: Timecode.UpperLimit = ._24hours
    ) throws -> Timecode {
        try Timecode(self, using: frameRate, base: base, limit: limit)
    }
    
    /// Returns a new ``Timecode`` instance by converting a time source at the given frame rate.
    public func timecode(
        using frameRate: TimecodeFrameRate,
        base: Timecode.SubFramesBase = .default(),
        limit: Timecode.UpperLimit = ._24hours,
        by validation: Timecode.ValidationRule
    ) -> Timecode {
        Timecode(self, using: frameRate, base: base, limit: limit, by: validation)
    }
    
    /// Returns a new ``Timecode`` instance by converting a time source.
    public func timecode(
        using properties: Timecode.Properties
    ) throws -> Timecode {
        try Timecode(self, using: properties)
    }
    
    /// Returns a new ``Timecode`` instance by converting a time source.
    public func timecode(
        using properties: Timecode.Properties,
        by validation: Timecode.ValidationRule
    ) -> Timecode {
        Timecode(self, using: properties, by: validation)
    }
}

// MARK: - FormattedTimecodeSource Category Methods

extension FormattedTimecodeSource {
    /// Returns a new ``Timecode`` instance by converting a time source at the given frame rate.
    public func timecode(
        using frameRate: TimecodeFrameRate,
        base: Timecode.SubFramesBase = .default(),
        limit: Timecode.UpperLimit = ._24hours
    ) throws -> Timecode {
        try Timecode(self, using: frameRate, base: base, limit: limit)
    }
    
    /// Returns a new ``Timecode`` instance by converting a time source at the given frame rate.
    public func timecode(
        using frameRate: TimecodeFrameRate,
        base: Timecode.SubFramesBase = .default(),
        limit: Timecode.UpperLimit = ._24hours,
        by validation: Timecode.ValidationRule
    ) throws -> Timecode {
        try Timecode(self, using: frameRate, base: base, limit: limit, by: validation)
    }
    
    /// Returns a new ``Timecode`` instance by converting a time source.
    public func timecode(
        using properties: Timecode.Properties
    ) throws -> Timecode {
        try Timecode(self, using: properties)
    }
    
    /// Returns a new ``Timecode`` instance by converting a time source.
    public func timecode(
        using properties: Timecode.Properties,
        by validation: Timecode.ValidationRule
    ) throws -> Timecode {
        try Timecode(self, using: properties, by: validation)
    }
}

// MARK: - RichTimecodeSource Category Methods

extension RichTimecodeSource {
    /// Returns a new ``Timecode`` instance by converting a time source.
    public func timecode() throws -> Timecode {
        try Timecode(self)
    }
}

// MARK: - GuaranteedTimecodeSource Category Methods

extension GuaranteedTimecodeSource {
    /// Returns a new ``Timecode`` instance by converting a time source at a given frame rate.
    public func timecode(
        using frameRate: TimecodeFrameRate,
        base: Timecode.SubFramesBase = .default(),
        limit: Timecode.UpperLimit = ._24hours
    ) -> Timecode {
        Timecode(self, using: frameRate, base: base, limit: limit)
    }
    
    /// Returns a new ``Timecode`` instance by converting a time source.
    public func timecode(
        using properties: Timecode.Properties
    ) -> Timecode {
        Timecode(self, using: properties)
    }
}

// MARK: - GuaranteedRichTimecodeSource Category Methods

extension GuaranteedRichTimecodeSource {
    /// Returns a new ``Timecode`` instance by converting a time source.
    public func timecode() -> Timecode {
        Timecode(self)
    }
}
