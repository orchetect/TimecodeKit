//
//  Timecode set.swift
//  
//
//  Created by Steffan Andrews on 2023-03-22.
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
