//
//  Timecode set.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension Timecode {
    public mutating func set(_ value: Source) throws {
        #warning("> finish this")
    }
    
    public mutating func set(_ value: Source, by validation: Validation) {
        #warning("> finish this")
    }
    
    public func setting(_ value: Source) throws -> Timecode {
        var copy = self
        try copy.set(value)
        return copy
    }
    
    public func setting(_ value: Source, by validation: Validation) -> Timecode {
        var copy = self
        copy.set(value, by: validation)
        return copy
    }
}
