//
//  Timecode init.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
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
        limit: UpperLimit = ._24Hours
    ) throws {
        properties = Properties(rate: frameRate, base: base, limit: limit)
        try set(source.value)
    }
    
    /// Initialize by converting a time source to timecode at a given frame rate and validation rule.
    public init(
        _ source: TimecodeSourceValue,
        at frameRate: TimecodeFrameRate,
        base: SubFramesBase = .default(),
        limit: UpperLimit = ._24Hours,
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
    
    // MARK: - FormattedTimecodeSource
    
    /// Initialize by converting a time source to timecode at a given frame rate.
    ///
    /// - Throws: ``ValidationError``
    public init(
        _ source: FormattedTimecodeSourceValue,
        at frameRate: TimecodeFrameRate,
        base: SubFramesBase = .default(),
        limit: UpperLimit = ._24Hours
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
        limit: UpperLimit = ._24Hours,
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
    
    // MARK: - GuaranteedTimecodeSource
    
    /// Initialize by converting a time source to timecode at a given frame rate.
    public init(
        _ source: GuaranteedTimecodeSourceValue,
        at frameRate: TimecodeFrameRate,
        base: SubFramesBase = .default(),
        limit: UpperLimit = ._24Hours
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

// MARK: - TimecodeSource Category Methods

extension TimecodeSource {
    /// Returns a new ``Timecode`` instance by converting a time source at the given frame rate.
    ///
    /// - Throws: ``Timecode/ValidationError``
    public func timecode(
        at frameRate: TimecodeFrameRate,
        base: Timecode.SubFramesBase = .default(),
        limit: Timecode.UpperLimit = ._24Hours
    ) throws -> Timecode {
        let value = TimecodeSourceValue(value: self)
        return try Timecode(value, at: frameRate, base: base, limit: limit)
    }
    
    /// Returns a new ``Timecode`` instance by converting a time source at the given frame rate.
    public func timecode(
        at frameRate: TimecodeFrameRate,
        base: Timecode.SubFramesBase = .default(),
        limit: Timecode.UpperLimit = ._24Hours,
        by validation: Timecode.ValidationRule
    ) -> Timecode {
        let value = TimecodeSourceValue(value: self)
        return Timecode(value, at: frameRate, base: base, limit: limit, by: validation)
    }
    
    /// Returns a new ``Timecode`` instance by converting a time source.
    ///
    /// - Throws: ``Timecode/ValidationError``
    public func timecode(
        using properties: Timecode.Properties
    ) throws -> Timecode {
        let value = TimecodeSourceValue(value: self)
        return try Timecode(value, using: properties)
    }
    
    /// Returns a new ``Timecode`` instance by converting a time source.
    public func timecode(
        using properties: Timecode.Properties,
        by validation: Timecode.ValidationRule
    ) -> Timecode {
        let value = TimecodeSourceValue(value: self)
        return Timecode(value, using: properties, by: validation)
    }
}

// MARK: - FormattedTimecodeSource Category Methods

extension FormattedTimecodeSource {
    /// Returns a new ``Timecode`` instance by converting a time source at the given frame rate.
    ///
    /// - Throws: ``Timecode/ValidationError``
    public func timecode(
        at frameRate: TimecodeFrameRate,
        base: Timecode.SubFramesBase = .default(),
        limit: Timecode.UpperLimit = ._24Hours
    ) throws -> Timecode {
        let value = FormattedTimecodeSourceValue(value: self)
        return try Timecode(value, at: frameRate, base: base, limit: limit)
    }
    
    /// Returns a new ``Timecode`` instance by converting a time source at the given frame rate.
    ///
    /// - Throws: ``Timecode/ValidationError``
    public func timecode(
        at frameRate: TimecodeFrameRate,
        base: Timecode.SubFramesBase = .default(),
        limit: Timecode.UpperLimit = ._24Hours,
        by validation: Timecode.ValidationRule
    ) throws -> Timecode {
        let value = FormattedTimecodeSourceValue(value: self)
        return try Timecode(value, at: frameRate, base: base, limit: limit, by: validation)
    }
    
    /// Returns a new ``Timecode`` instance by converting a time source.
    ///
    /// - Throws: ``Timecode/ValidationError``
    public func timecode(
        using properties: Timecode.Properties
    ) throws -> Timecode {
        let value = FormattedTimecodeSourceValue(value: self)
        return try Timecode(value, using: properties)
    }
    
    /// Returns a new ``Timecode`` instance by converting a time source.
    ///
    /// - Throws: ``Timecode/ValidationError``
    public func timecode(
        using properties: Timecode.Properties,
        by validation: Timecode.ValidationRule
    ) throws -> Timecode {
        let value = FormattedTimecodeSourceValue(value: self)
        return try Timecode(value, using: properties, by: validation)
    }
}

// MARK: - RichTimecodeSource Category Methods

extension RichTimecodeSource {
    /// Returns a new ``Timecode`` instance by converting a time source.
    ///
    /// - Throws: ``Timecode/ValidationError``
    public func timecode() throws -> Timecode {
        let value = RichTimecodeSourceValue(value: self)
        return try Timecode(value)
    }
}

// MARK: - GuaranteedTimecodeSource Category Methods

extension GuaranteedTimecodeSource {
    /// Returns a new ``Timecode`` instance by converting a time source at a given frame rate.
    public func timecode(
        at frameRate: TimecodeFrameRate,
        base: Timecode.SubFramesBase = .default(),
        limit: Timecode.UpperLimit = ._24Hours
    ) -> Timecode {
        let value = GuaranteedTimecodeSourceValue(value: self)
        return Timecode(value, at: frameRate, base: base, limit: limit)
    }
    
    /// Returns a new ``Timecode`` instance by converting a time source.
    public func timecode(
        using properties: Timecode.Properties
    ) -> Timecode {
        let value = GuaranteedTimecodeSourceValue(value: self)
        return Timecode(value, using: properties)
    }
}

// MARK: - GuaranteedRichTimecodeSource Category Methods

extension GuaranteedRichTimecodeSource {
    /// Returns a new ``Timecode`` instance by converting a time source.
    public func timecode() -> Timecode {
        let value = GuaranteedRichTimecodeSourceValue(value: self)
        return Timecode(value)
    }
}
