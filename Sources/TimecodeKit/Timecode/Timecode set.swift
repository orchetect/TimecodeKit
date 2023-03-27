//
//  Timecode set.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - TimecodeSource

extension Timecode {
    /// Set timecode by converting from a time source.
    ///
    /// - Throws: ``ValidationError``
    public mutating func set(_ source: TimecodeSource) throws {
        try source.set(timecode: &self)
    }
    
    /// Set timecode by converting from a time source.
    public mutating func set(_ source: TimecodeSource, by validation: ValidationRule) {
        source.set(timecode: &self, by: validation)
    }
    
    /// Returns a copy of this instance, setting its timecode by converting from a time source.
    ///
    /// - Throws: ``ValidationError``
    public func setting(_ value: TimecodeSource) throws -> Timecode {
        var copy = self
        try copy.set(value)
        return copy
    }
    
    /// Returns a copy of this instance, setting its timecode by converting from a time source.
    public func setting(_ value: TimecodeSource, by validation: ValidationRule) -> Timecode {
        var copy = self
        copy.set(value, by: validation)
        return copy
    }
}

// MARK: - RichTimecodeSource

extension Timecode {
    /// Set timecode by converting from a time source.
    ///
    /// - Throws: ``ValidationError``
    public mutating func set(
        _ source: RichTimecodeSource
    ) throws {
        self.properties = try source.set(timecode: &self)
    }
    
    /// Returns a copy of this instance, setting its timecode by converting from a time source.
    ///
    /// - Throws: ``ValidationError``
    public func setting(
        _ value: RichTimecodeSource
    ) throws -> Timecode {
        var copy = self
        try copy.set(value)
        return copy
    }
}

// MARK: - GuaranteedTimecodeSource

extension Timecode {
    /// Set timecode by converting from a time source.
    public mutating func set(
        _ source: GuaranteedTimecodeSource
    ) {
        source.set(timecode: &self)
    }
    
    /// Returns a copy of this instance, setting its timecode by converting from a time source.
    public func setting(
        _ value: GuaranteedTimecodeSource
    ) -> Timecode {
        var copy = self
        copy.set(value)
        return copy
    }
}


// MARK: - GuaranteedRichTimecodeSource

extension Timecode {
    /// Set timecode by converting from a time source.
    public mutating func set(
        _ source: GuaranteedRichTimecodeSource
    ) -> Properties {
        source.set(timecode: &self)
    }
    
    /// Returns a copy of this instance, setting its timecode by converting from a time source.
    public func setting(
        _ value: GuaranteedRichTimecodeSource
    ) -> Timecode {
        var copy = self
        copy.properties = copy.set(value)
        return copy
    }
}
