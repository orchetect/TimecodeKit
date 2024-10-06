//
//  Timecode set.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
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

// MARK: - AsyncTimecodeSource

extension Timecode {
    /// Set timecode by converting from a time source.
    ///
    /// - Throws: ``ValidationError``
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public mutating func set(_ source: AsyncTimecodeSourceValue) async throws {
        try await set(source.value)
    }
    
    /// Set timecode by converting from a time source.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public mutating func set(_ source: AsyncTimecodeSourceValue, by validation: ValidationRule) async {
        await set(source.value, by: validation)
    }
    
    /// Returns a copy of this instance, setting its timecode by converting from a time source.
    ///
    /// - Throws: ``ValidationError``
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public func setting(_ source: AsyncTimecodeSourceValue) async throws -> Timecode {
        try await setting(source.value)
    }
    
    /// Returns a copy of this instance, setting its timecode by converting from a time source.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public func setting(_ source: AsyncTimecodeSourceValue, by validation: ValidationRule) async -> Timecode {
        await setting(source.value, by: validation)
    }
}

extension Timecode {
    /// - Throws: ``ValidationError``
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    mutating func set(_ source: _AsyncTimecodeSource) async throws {
        try await source.set(timecode: &self)
    }
    
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    mutating func set(_ source: _AsyncTimecodeSource, by validation: ValidationRule) async {
        await source.set(timecode: &self, by: validation)
    }
    
    /// - Throws: ``ValidationError``
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    func setting(_ value: _AsyncTimecodeSource) async throws -> Timecode {
        var copy = self
        try await copy.set(value)
        return copy
    }
    
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    func setting(_ value: _AsyncTimecodeSource, by validation: ValidationRule) async -> Timecode {
        var copy = self
        await copy.set(value, by: validation)
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

// MARK: - AsyncRichTimecodeSource

extension Timecode {
    /// Set timecode by converting from a time source.
    ///
    /// - Throws: ``ValidationError``
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public mutating func set(
        _ source: AsyncRichTimecodeSourceValue
    ) async throws {
        try await set(source.value)
    }
    
    /// Returns a copy of this instance, setting its timecode by converting from a time source.
    ///
    /// - Throws: ``ValidationError``
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public func setting(
        _ source: AsyncRichTimecodeSourceValue
    ) async throws -> Timecode {
        try await setting(source.value)
    }
}

extension Timecode {
    /// - Throws: ``ValidationError``
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    mutating func set(
        _ source: _AsyncRichTimecodeSource
    ) async throws {
        properties = try await source.set(timecode: &self)
    }
    
    /// - Throws: ``ValidationError``
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    func setting(
        _ source: _AsyncRichTimecodeSource
    ) async throws -> Timecode {
        var copy = self
        try await copy.set(source)
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
