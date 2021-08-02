//
//  Timecode Math Public.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//

extension Timecode {
    
    // MARK: - Add
    
    /// Add a duration to the current timecode.
    /// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
    ///
    /// - Throws: `Timecode.ValidationError`
    @inlinable public mutating func add(_ exactly: Components) throws {
        
        guard let newTC = __add(exactly: exactly, to: components)
        else { throw ValidationError.outOfBounds }
        
        try setTimecode(exactly: newTC)
        
    }
    
    /// Add a duration to the current timecode.
    /// Clamps to valid timecodes as set by the `upperLimit` property.
    /// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
    @inlinable public mutating func add(clamping values: Components) {
        
        let newTC = __add(clamping: values, to: components)
        
        setTimecode(rawValues: newTC)
        
    }
    
    /// Add a duration to the current timecode.
    /// Wraps around the clock as set by the `upperLimit` property.
    /// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
    @inlinable public mutating func add(wrapping values: Components) {
        
        let newTC = __add(wrapping: values, to: components)
        
        setTimecode(rawValues: newTC)
        
    }
    
    /// Add a duration to the current timecode and return a new instance with the new timecode.
    /// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
    ///
    /// - Throws: `Timecode.ValidationError`
    @inlinable public func adding(_ exactly: Components) throws -> Timecode {
        
        guard let newTC = __add(exactly: exactly, to: components)
        else { throw ValidationError.outOfBounds }
        
        var newTimecode = self
        try newTimecode.setTimecode(exactly: newTC)
        
        return newTimecode
        
    }
    
    /// Add a duration to the current timecode and return a new instance with the new timecode.
    /// Clamps to valid timecodes as set by the `upperLimit` property.
    /// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
    @inlinable public func adding(clamping values: Components) -> Timecode {
        
        let newTC = __add(clamping: values, to: components)
        
        var newTimecode = self
        newTimecode.setTimecode(rawValues: newTC)
        
        return newTimecode
        
    }
    
    /// Add a duration to the current timecode and return a new instance with the new timecode.
    /// Wraps around the clock as set by the `upperLimit` property.
    /// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
    @inlinable public func adding(wrapping values: Components) -> Timecode {
        
        let newTC = __add(wrapping: values, to: components)
        
        var newTimecode = self
        newTimecode.setTimecode(rawValues: newTC)
        
        return newTimecode
        
    }
    
    
    // MARK: - Subtract
    
    /// Subtract a duration from the current timecode.
    /// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
    ///
    /// - Throws: `Timecode.ValidationError`
    @inlinable public mutating func subtract(_ exactly: Components) throws {
        
        guard let newTC = __subtract(exactly: exactly, from: components)
        else { throw ValidationError.outOfBounds }
        
        try setTimecode(exactly: newTC)
        
    }
    
    /// Subtract a duration from the current timecode.
    /// Clamps to valid timecodes.
    /// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
    @inlinable public mutating func subtract(clamping: Components) {
        
        let newTC = __subtract(clamping: clamping, from: components)
        
        setTimecode(rawValues: newTC)
        
    }
    
    /// Subtract a duration from the current timecode.
    /// Wraps around the clock as set by the `upperLimit` property.
    /// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
    @inlinable public mutating func subtract(wrapping: Components) {
        
        let newTC = __subtract(wrapping: wrapping, from: components)
        
        setTimecode(rawValues: newTC)
        
    }
    
    /// Subtract a duration from the current timecode and return a new instance with the new timecode.
    /// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
    ///
    /// - Throws: `Timecode.ValidationError`
    @inlinable public func subtracting(_ exactly: Components) throws -> Timecode {
        
        guard let newTC = __subtract(exactly: exactly, from: components)
        else { throw ValidationError.outOfBounds }
        
        var newTimecode = self
        try newTimecode.setTimecode(exactly: newTC)
        
        return newTimecode
        
    }
    
    /// Subtract a duration from the current timecode and return a new instance with the new timecode.
    /// Clamps to valid timecodes as set by the `upperLimit` property.
    /// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
    @inlinable public func subtracting(clamping values: Components) -> Timecode {
        
        let newTC = __subtract(clamping: values, from: components)
        
        var newTimecode = self
        newTimecode.setTimecode(rawValues: newTC)
        
        return newTimecode
        
    }
    
    /// Subtract a duration from the current timecode and return a new instance with the new timecode.
    /// Wraps around the clock as set by the `upperLimit` property.
    /// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
    @inlinable public func subtracting(wrapping values: Components) -> Timecode {
        
        let newTC = __subtract(wrapping: values, from: components)
        
        var newTimecode = self
        newTimecode.setTimecode(rawValues: newTC)
        
        return newTimecode
        
    }
    
    
    // MARK: - Multiply
    
    /// Multiply the current timecode by an amount.
    ///
    /// - Throws: `Timecode.ValidationError`
    public mutating func multiply(_ exactly: Double) throws {
        
        guard let newTC = __multiply(exactly: exactly, with: components)
        else { throw ValidationError.outOfBounds }
        
        try setTimecode(exactly: newTC)
        
    }
    
    /// Multiply the current timecode by an amount.
    /// Clamps to valid timecodes as set by the `upperLimit` property.
    public mutating func multiply(clamping value: Double) {
        
        let newTC = __multiply(clamping: value, with: components)
        
        setTimecode(rawValues: newTC)
        
    }
    
    /// Multiply the current timecode by an amount.
    /// Wraps around the clock as set by the `upperLimit` property.
    public mutating func multiply(wrapping value: Double) {
        
        let newTC = __multiply(wrapping: value, with: components)
        
        setTimecode(rawValues: newTC)
        
    }
    
    /// Multiply a duration from the current timecode and return a new instance with the new timecode.
    /// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
    ///
    /// - Throws: `Timecode.ValidationError`
    public func multiplying(_ exactly: Double) throws -> Timecode {
        
        guard let newTC = __multiply(exactly: exactly, with: components)
        else { throw ValidationError.outOfBounds }
        
        var newTimecode = self
        try newTimecode.setTimecode(exactly: newTC)
        
        return newTimecode
        
    }
    
    /// Multiply a duration from the current timecode and return a new instance with the new timecode.
    /// Clamps to valid timecodes.
    /// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
    public func multiplying(clamping value: Double) -> Timecode {
        
        let newTC = __multiply(clamping: value, with: components)
        
        var newTimecode = self
        newTimecode.setTimecode(rawValues: newTC)
        
        return newTimecode
        
    }
    
    /// Multiply a duration from the current timecode and return a new instance with the new timecode.
    /// Wraps around the clock as set by the `upperLimit` property.
    /// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
    public func multiplying(wrapping value: Double) -> Timecode {
        
        let newTC = __multiply(wrapping: value, with: components)
        
        var newTimecode = self
        newTimecode.setTimecode(rawValues: newTC)
        
        return newTimecode
        
    }
    
    
    // MARK: - Divide
    
    /// Divide the current timecode by a duration.
    ///
    /// - Throws: `Timecode.ValidationError`
    public mutating func divide(_ exactly: Double) throws {
        
        guard let newTC = __divide(exactly: exactly, into: components)
        else { throw ValidationError.outOfBounds }
        
        try setTimecode(exactly: newTC)
        
    }
    
    /// Divide the current timecode by a duration.
    /// Clamps to valid timecodes as set by the `upperLimit` property.
    public mutating func divide(clamping value: Double) {
        
        let newTC = __divide(clamping: value, into: components)
        
        setTimecode(rawValues: newTC)
        
    }
    
    /// Divide the current timecode by a duration.
    /// Wraps around the clock as set by the `upperLimit` property.
    public mutating func divide(wrapping value: Double) {
        
        let newTC = __divide(wrapping: value, into: components)
        
        setTimecode(rawValues: newTC)
        
    }
    
    /// Divide the current timecode by a duration and return a new instance with the new timecode.
    /// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
    ///
    /// - Throws: `Timecode.ValidationError`
    public func dividing(_ exactly: Double) throws -> Timecode {
        
        guard let newTC = __divide(exactly: exactly, into: components)
        else { throw ValidationError.outOfBounds }
        
        var newTimecode = self
        try newTimecode.setTimecode(exactly: newTC)
        
        return newTimecode
        
    }
    
    /// Divide the current timecode by a duration and return a new instance with the new timecode.
    /// Clamps to valid timecodes as set by the `upperLimit` property.
    /// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
    public func dividing(clamping value: Double) -> Timecode {
        
        let newTC = __divide(clamping: value, into: components)
        
        var newTimecode = self
        newTimecode.setTimecode(rawValues: newTC)
        
        return newTimecode
        
    }
    
    /// Divide the current timecode by a duration and return a new instance with the new timecode.
    /// Wraps around the clock as set by the `upperLimit` property.
    /// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
    public func dividing(wrapping value: Double) -> Timecode {
        
        let newTC = __divide(wrapping: value, into: components)
        
        var newTimecode = self
        newTimecode.setTimecode(rawValues: newTC)
        
        return newTimecode
        
    }
    
    
    // MARK: - Offset / Delta
    
    /// Offsets the current timecode by a `Delta` amount.
    /// Wraps around the clock as set by the `upperLimit` property.
    public mutating func offset(by delta: Delta) {
        
        self = delta.timecode(offsetting: self)
        
    }
    
    /// Returns the timecode offset by a `Delta` amount.
    /// Wraps around the clock as set by the `upperLimit` property.
    public func offsetting(by delta: Delta) -> Timecode {
        
        delta.timecode(offsetting: self)
        
    }
    
    /// Returns an abstract delta distance between the current timecode and another timecode.
    public func delta(to other: Timecode) -> Delta {
        
        if frameRate == other.frameRate {
            return __offset(to: other.components)
        } else {
            guard let otherConverted = try? other.converted(to: frameRate) else {
                assertionFailure("Could not convert other Timecode to self Timecode frameRate.")
                return .init(TCC().toTimecode(rawValuesAt: frameRate))
            }
            
            return __offset(to: otherConverted.components)
        }
        
    }
    
}
