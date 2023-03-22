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
    public mutating func set(_ source: TimecodeSource, by validation: Validation) {
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
    public func setting(_ value: TimecodeSource, by validation: Validation) -> Timecode {
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
        _ source: RichTimecodeSource,
        overriding properties: Timecode.Properties? = nil
    ) throws {
        self.properties = try source.set(timecode: &self, overriding: properties)
    }
    
    /// Returns a copy of this instance, setting its timecode by converting from a time source.
    ///
    /// - Throws: ``ValidationError``
    public func setting(
        _ value: RichTimecodeSource,
        overriding properties: Timecode.Properties? = nil
    ) throws -> Timecode {
        var copy = self
        try copy.set(value, overriding: properties)
        return copy
    }
}
