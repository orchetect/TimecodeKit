//
//  Timecode set.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - TimecodeSource

extension Timecode {
    /// Set timecode by converting from a time source.
    ///
    /// - Throws: ``ValidationError``
    public mutating func set(_ source: TimecodeSourceValue) throws {
        try set(source.value)
    }
    
    /// Set timecode by converting from a time source.
    public mutating func set(_ source: TimecodeSourceValue, by validation: ValidationRule) {
        set(source.value, by: validation)
    }
    
    /// Returns a copy of this instance, setting its timecode by converting from a time source.
    ///
    /// - Throws: ``ValidationError``
    public func setting(_ source: TimecodeSourceValue) throws -> Timecode {
        try setting(source.value)
    }
    
    /// Returns a copy of this instance, setting its timecode by converting from a time source.
    public func setting(_ source: TimecodeSourceValue, by validation: ValidationRule) -> Timecode {
        setting(source.value, by: validation)
    }
}

extension Timecode {
    /// - Throws: ``ValidationError``
    mutating func set(_ source: _TimecodeSource) throws {
        try source.set(timecode: &self)
    }
    
    mutating func set(_ source: _TimecodeSource, by validation: ValidationRule) {
        source.set(timecode: &self, by: validation)
    }
    
    /// - Throws: ``ValidationError``
    func setting(_ value: _TimecodeSource) throws -> Timecode {
        var copy = self
        try copy.set(value)
        return copy
    }
    
    func setting(_ value: _TimecodeSource, by validation: ValidationRule) -> Timecode {
        var copy = self
        copy.set(value, by: validation)
        return copy
    }
}

// MARK: - FormattedTimecodeSource

extension Timecode {
    /// Set timecode by converting from a time source.
    ///
    /// - Throws: ``ValidationError``
    public mutating func set(_ source: FormattedTimecodeSourceValue) throws {
        try set(source.value)
    }
    
    /// Set timecode by converting from a time source.
    public mutating func set(_ source: FormattedTimecodeSourceValue, by validation: ValidationRule) throws {
        try set(source.value, by: validation)
    }
    
    /// Returns a copy of this instance, setting its timecode by converting from a time source.
    ///
    /// - Throws: ``ValidationError``
    public func setting(_ source: FormattedTimecodeSourceValue) throws -> Timecode {
        try setting(source.value)
    }
    
    /// Returns a copy of this instance, setting its timecode by converting from a time source.
    public func setting(_ source: FormattedTimecodeSourceValue, by validation: ValidationRule) throws -> Timecode {
        try setting(source.value, by: validation)
    }
}

extension Timecode {
    /// - Throws: ``ValidationError``
    mutating func set(_ source: _FormattedTimecodeSource) throws {
        try source.set(timecode: &self)
    }
    
    mutating func set(_ source: _FormattedTimecodeSource, by validation: ValidationRule) throws {
        try source.set(timecode: &self, by: validation)
    }
    
    /// - Throws: ``ValidationError``
    func setting(_ source: _FormattedTimecodeSource) throws -> Timecode {
        var copy = self
        try copy.set(source)
        return copy
    }
    
    func setting(_ source: _FormattedTimecodeSource, by validation: ValidationRule) throws -> Timecode {
        var copy = self
        try copy.set(source, by: validation)
        return copy
    }
}

// MARK: - RichTimecodeSource

extension Timecode {
    /// Set timecode by converting from a time source.
    ///
    /// - Throws: ``ValidationError``
    public mutating func set(
        _ source: RichTimecodeSourceValue
    ) throws {
        try set(source.value)
    }
    
    /// Returns a copy of this instance, setting its timecode by converting from a time source.
    ///
    /// - Throws: ``ValidationError``
    public func setting(
        _ source: RichTimecodeSourceValue
    ) throws -> Timecode {
        try setting(source.value)
    }
}

extension Timecode {
    /// - Throws: ``ValidationError``
    mutating func set(
        _ source: _RichTimecodeSource
    ) throws {
        properties = try source.set(timecode: &self)
    }
    
    /// - Throws: ``ValidationError``
    func setting(
        _ source: _RichTimecodeSource
    ) throws -> Timecode {
        var copy = self
        try copy.set(source)
        return copy
    }
}

// MARK: - GuaranteedTimecodeSource

extension Timecode {
    /// Set timecode by converting from a time source.
    public mutating func set(
        _ source: GuaranteedTimecodeSourceValue
    ) {
        set(source.value)
    }
    
    /// Returns a copy of this instance, setting its timecode by converting from a time source.
    public func setting(
        _ source: GuaranteedTimecodeSourceValue
    ) -> Timecode {
        setting(source.value)
    }
}

extension Timecode {
    mutating func set(
        _ source: _GuaranteedTimecodeSource
    ) {
        source.set(timecode: &self)
    }
    
    func setting(
        _ source: _GuaranteedTimecodeSource
    ) -> Timecode {
        var copy = self
        copy.set(source)
        return copy
    }
}

// MARK: - GuaranteedRichTimecodeSource

extension Timecode {
    /// Set timecode by converting from a time source.
    public mutating func set(
        _ source: GuaranteedRichTimecodeSourceValue
    ) -> Properties {
        set(source.value)
    }
    
    /// Returns a copy of this instance, setting its timecode by converting from a time source.
    public func setting(
        _ source: GuaranteedRichTimecodeSourceValue
    ) -> Timecode {
        setting(source.value)
    }
}

extension Timecode {
    mutating func set(
        _ source: _GuaranteedRichTimecodeSource
    ) -> Properties {
        source.set(timecode: &self)
    }
    
    func setting(
        _ source: _GuaranteedRichTimecodeSource
    ) -> Timecode {
        var copy = self
        copy.properties = copy.set(source)
        return copy
    }
}
