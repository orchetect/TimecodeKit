//
//  Timecode Math Public.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

extension Timecode {
    // MARK: - Add Timecode
    
    /// Add a duration to the current timecode.
    ///
    /// - Throws: ``ValidationError``
    public mutating func add(_ other: Timecode) throws {
        try add(
            frameRate == other.frameRate
                ? other.components
                : other.converted(to: frameRate).components
        )
    }
    
    /// Add a duration to the current timecode.
    ///
    /// - Throws: ``ValidationError``
    public mutating func add(_ other: Timecode, by validation: ValidationRule) throws {
        try add(
            frameRate == other.frameRate
                ? other.components
                : other.converted(to: frameRate).components,
            by: validation
        )
    }
    
    // MARK: - Add Time Source Value
    
    /// Add a duration to the current timecode.
    ///
    /// - Throws: ``ValidationError``
    public mutating func add(_ other: TimecodeSourceValue) throws {
        let otherTC = try Timecode(other, using: properties)
        try add(otherTC)
    }
    
    /// Add a duration to the current timecode.
    ///
    /// - Throws: ``ValidationError``
    public mutating func add(_ other: FormattedTimecodeSourceValue) throws {
        let otherTC = try Timecode(other, using: properties)
        try add(otherTC)
    }
    
    /// Add a duration to the current timecode.
    ///
    /// - Throws: ``ValidationError``
    public mutating func add(_ other: RichTimecodeSourceValue) throws {
        let otherTC = try Timecode(other)
        try add(otherTC)
    }
    
    /// Add a duration to the current timecode.
    ///
    /// - Throws: ``ValidationError``
    public mutating func add(_ other: GuaranteedTimecodeSourceValue) throws {
        let otherTC = Timecode(other, using: properties)
        try add(otherTC)
    }
    
    /// Add a duration to the current timecode.
    ///
    /// - Throws: ``ValidationError``
    public mutating func add(_ other: GuaranteedRichTimecodeSourceValue) throws {
        let otherTC = Timecode(other)
        try add(otherTC)
    }
    
    /// Add a duration to the current timecode.
    ///
    /// - Throws: ``ValidationError``
    public mutating func add(_ other: TimecodeSourceValue, by validation: ValidationRule) throws {
        let otherTC = try Timecode(other, using: properties)
        try add(otherTC, by: validation)
    }
    
    /// Add a duration to the current timecode.
    ///
    /// - Throws: ``ValidationError``
    public mutating func add(_ other: FormattedTimecodeSourceValue, by validation: ValidationRule) throws {
        let otherTC = try Timecode(other, using: properties)
        try add(otherTC, by: validation)
    }
    
    /// Add a duration to the current timecode.
    ///
    /// - Throws: ``ValidationError``
    public mutating func add(_ other: RichTimecodeSourceValue, by validation: ValidationRule) throws {
        let otherTC = try Timecode(other)
        try add(otherTC, by: validation)
    }
    
    /// Add a duration to the current timecode.
    ///
    /// - Throws: ``ValidationError``
    public mutating func add(_ other: GuaranteedTimecodeSourceValue, by validation: ValidationRule) throws {
        let otherTC = Timecode(other, using: properties)
        try add(otherTC, by: validation)
    }
    
    /// Add a duration to the current timecode.
    ///
    /// - Throws: ``ValidationError``
    public mutating func add(_ other: GuaranteedRichTimecodeSourceValue, by validation: ValidationRule) throws {
        let otherTC = Timecode(other)
        try add(otherTC, by: validation)
    }
    
    // MARK: - Add Components
    
    /// Add a duration to the current timecode.
    /// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
    ///
    /// - Throws: ``ValidationError``
    public mutating func add(_ source: Components) throws {
        guard let newTC = _add(exactly: source, to: components)
        else { throw ValidationError.outOfBounds }
        
        try _setTimecode(exactly: newTC)
    }
    
    /// Add a duration to the current timecode.
    /// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
    public mutating func add(_ source: Components, by validation: ValidationRule) {
        let newTC: Timecode.Components = switch validation {
        case .clamping, .clampingComponents:
            _add(clamping: source, to: components)
            
        case .wrapping:
            _add(wrapping: source, to: components)
            
        case .allowingInvalid:
            _add(rawValues: source, to: components)
        }
        
        _setTimecode(rawValues: newTC)
    }
    
    // MARK: - Adding Timecode
    
    /// Add a duration to the current timecode and return a new instance.
    ///
    /// - Throws: ``ValidationError``
    public func adding(_ other: Timecode) throws -> Timecode {
        try adding(
            frameRate == other.frameRate
                ? other.components
                : other.converted(to: frameRate).components
        )
    }
    
    /// Add a duration to the current timecode and return a new instance.
    ///
    /// - Throws: ``ValidationError``
    public func adding(_ other: Timecode, by validation: ValidationRule) throws -> Timecode {
        try adding(
            frameRate == other.frameRate
                ? other.components
                : other.converted(to: frameRate).components,
            by: validation
        )
    }
    
    // MARK: - Adding Time Source Value
    
    /// Add a duration to the current timecode and return a new instance.
    ///
    /// - Throws: ``ValidationError``
    public func adding(_ other: TimecodeSourceValue) throws -> Timecode {
        let otherTC = try Timecode(other, using: properties)
        return try adding(otherTC)
    }
    
    /// Add a duration to the current timecode and return a new instance.
    ///
    /// - Throws: ``ValidationError``
    public func adding(_ other: FormattedTimecodeSourceValue) throws -> Timecode {
        let otherTC = try Timecode(other, using: properties)
        return try adding(otherTC)
    }
    
    /// Add a duration to the current timecode and return a new instance.
    ///
    /// - Throws: ``ValidationError``
    public func adding(_ other: RichTimecodeSourceValue) throws -> Timecode {
        let otherTC = try Timecode(other)
        return try adding(otherTC)
    }
    
    /// Add a duration to the current timecode and return a new instance.
    ///
    /// - Throws: ``ValidationError``
    public func adding(_ other: GuaranteedTimecodeSourceValue) throws -> Timecode {
        let otherTC = Timecode(other, using: properties)
        return try adding(otherTC)
    }
    
    /// Add a duration to the current timecode and return a new instance.
    ///
    /// - Throws: ``ValidationError``
    public func adding(_ other: GuaranteedRichTimecodeSourceValue) throws -> Timecode {
        let otherTC = Timecode(other)
        return try adding(otherTC)
    }
    
    /// Add a duration to the current timecode and return a new instance.
    ///
    /// - Throws: ``ValidationError``
    public func adding(_ other: TimecodeSourceValue, by validation: ValidationRule) throws -> Timecode {
        let otherTC = try Timecode(other, using: properties)
        return try adding(otherTC, by: validation)
    }
    
    /// Add a duration to the current timecode and return a new instance.
    ///
    /// - Throws: ``ValidationError``
    public func adding(_ other: FormattedTimecodeSourceValue, by validation: ValidationRule) throws -> Timecode {
        let otherTC = try Timecode(other, using: properties)
        return try adding(otherTC, by: validation)
    }
    
    /// Add a duration to the current timecode and return a new instance.
    ///
    /// - Throws: ``ValidationError``
    public func adding(_ other: RichTimecodeSourceValue, by validation: ValidationRule) throws -> Timecode {
        let otherTC = try Timecode(other)
        return try adding(otherTC, by: validation)
    }
    
    /// Add a duration to the current timecode and return a new instance.
    ///
    /// - Throws: ``ValidationError``
    public func adding(_ other: GuaranteedTimecodeSourceValue, by validation: ValidationRule) throws -> Timecode {
        let otherTC = Timecode(other, using: properties)
        return try adding(otherTC, by: validation)
    }
    
    /// Add a duration to the current timecode and return a new instance.
    ///
    /// - Throws: ``ValidationError``
    public func adding(_ other: GuaranteedRichTimecodeSourceValue, by validation: ValidationRule) throws -> Timecode {
        let otherTC = Timecode(other)
        return try adding(otherTC, by: validation)
    }
    
    // MARK: - Adding Components
    
    /// Add a duration to the current timecode and return a new instance.
    /// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
    ///
    /// - Throws: ``ValidationError``
    public func adding(_ source: Components) throws -> Timecode {
        var newTimecode = self
        try newTimecode.add(source)
        return newTimecode
    }
    
    /// Add a duration to the current timecode and return a new instance.
    /// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
    public func adding(_ source: Components, by validation: ValidationRule) -> Timecode {
        var newTimecode = self
        newTimecode.add(source, by: validation)
        return newTimecode
    }
    
    // MARK: - Subtract Timecode
    
    /// Subtract a duration from the current timecode.
    ///
    /// - Throws: ``ValidationError``
    public mutating func subtract(_ other: Timecode) throws {
        try subtract(
            frameRate == other.frameRate
                ? other.components
                : other.converted(to: frameRate).components
        )
    }
    
    /// Subtract a duration from the current timecode.
    ///
    /// - Throws: ``ValidationError``
    public mutating func subtract(_ other: Timecode, by validation: ValidationRule) throws {
        try subtract(
            frameRate == other.frameRate
                ? other.components
                : other.converted(to: frameRate).components,
            by: validation
        )
    }
    
    // MARK: - Subtract Time Source Value
    
    /// Subtract a duration from the current timecode.
    ///
    /// - Throws: ``ValidationError``
    public mutating func subtract(_ other: TimecodeSourceValue) throws {
        let otherTC = try Timecode(other, using: properties)
        try subtract(otherTC)
    }
    
    /// Subtract a duration from the current timecode.
    ///
    /// - Throws: ``ValidationError``
    public mutating func subtract(_ other: FormattedTimecodeSourceValue) throws {
        let otherTC = try Timecode(other, using: properties)
        try subtract(otherTC)
    }
    
    /// Subtract a duration from the current timecode.
    ///
    /// - Throws: ``ValidationError``
    public mutating func subtract(_ other: RichTimecodeSourceValue) throws {
        let otherTC = try Timecode(other)
        try subtract(otherTC)
    }
    
    /// Subtract a duration from the current timecode.
    ///
    /// - Throws: ``ValidationError``
    public mutating func subtract(_ other: GuaranteedTimecodeSourceValue) throws {
        let otherTC = Timecode(other, using: properties)
        try subtract(otherTC)
    }
    
    /// Subtract a duration from the current timecode.
    ///
    /// - Throws: ``ValidationError``
    public mutating func subtract(_ other: GuaranteedRichTimecodeSourceValue) throws {
        let otherTC = Timecode(other)
        try subtract(otherTC)
    }
    
    /// Subtract a duration from the current timecode.
    ///
    /// - Throws: ``ValidationError``
    public mutating func subtract(_ other: TimecodeSourceValue, by validation: ValidationRule) throws {
        let otherTC = try Timecode(other, using: properties)
        try subtract(otherTC, by: validation)
    }
    
    /// Subtract a duration from the current timecode.
    ///
    /// - Throws: ``ValidationError``
    public mutating func subtract(_ other: FormattedTimecodeSourceValue, by validation: ValidationRule) throws {
        let otherTC = try Timecode(other, using: properties)
        try subtract(otherTC, by: validation)
    }
    
    /// Subtract a duration from the current timecode.
    ///
    /// - Throws: ``ValidationError``
    public mutating func subtract(_ other: RichTimecodeSourceValue, by validation: ValidationRule) throws {
        let otherTC = try Timecode(other)
        try subtract(otherTC, by: validation)
    }
    
    /// Subtract a duration from the current timecode.
    ///
    /// - Throws: ``ValidationError``
    public mutating func subtract(_ other: GuaranteedTimecodeSourceValue, by validation: ValidationRule) throws {
        let otherTC = Timecode(other, using: properties)
        try subtract(otherTC, by: validation)
    }
    
    /// Subtract a duration from the current timecode.
    ///
    /// - Throws: ``ValidationError``
    public mutating func subtract(_ other: GuaranteedRichTimecodeSourceValue, by validation: ValidationRule) throws {
        let otherTC = Timecode(other)
        try subtract(otherTC, by: validation)
    }
    
    // MARK: - Subtract Components
    
    /// Subtract a duration from the current timecode.
    /// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
    ///
    /// - Throws: ``ValidationError``
    public mutating func subtract(_ exactly: Components) throws {
        guard let newTC = _subtract(exactly: exactly, from: components)
        else { throw ValidationError.outOfBounds }
        
        try _setTimecode(exactly: newTC)
    }
    
    /// Subtract a duration from the current timecode.
    /// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
    public mutating func subtract(_ source: Components, by validation: ValidationRule) {
        let newTC: Timecode.Components = switch validation {
        case .clamping, .clampingComponents:
            _subtract(clamping: source, from: components)
            
        case .wrapping:
            _subtract(wrapping: source, from: components)
            
        case .allowingInvalid:
            _subtract(rawValues: source, from: components)
        }
        
        _setTimecode(rawValues: newTC)
    }
    
    // MARK: - Subtracting Timecode
    
    /// Subtract a duration from the current timecode and return a new instance.
    ///
    /// - Throws: ``ValidationError``
    public func subtracting(_ other: Timecode) throws -> Timecode {
        try subtracting(
            frameRate == other.frameRate
                ? other.components
                : other.converted(to: frameRate).components
        )
    }
    
    /// Subtract a duration from the current timecode and return a new instance.
    ///
    /// - Throws: ``ValidationError``
    public func subtracting(_ other: Timecode, by validation: ValidationRule) throws -> Timecode {
        try subtracting(
            frameRate == other.frameRate
                ? other.components
                : other.converted(to: frameRate).components,
            by: validation
        )
    }
    
    // MARK: - Subtracting Time Source Value
    
    /// Subtract a duration from the current timecode and return a new instance.
    ///
    /// - Throws: ``ValidationError``
    public func subtracting(_ other: TimecodeSourceValue) throws -> Timecode {
        let otherTC = try Timecode(other, using: properties)
        return try subtracting(otherTC)
    }
    
    /// Subtract a duration from the current timecode and return a new instance.
    ///
    /// - Throws: ``ValidationError``
    public func subtracting(_ other: FormattedTimecodeSourceValue) throws -> Timecode {
        let otherTC = try Timecode(other, using: properties)
        return try subtracting(otherTC)
    }
    
    /// Subtract a duration from the current timecode and return a new instance.
    ///
    /// - Throws: ``ValidationError``
    public func subtracting(_ other: RichTimecodeSourceValue) throws -> Timecode {
        let otherTC = try Timecode(other)
        return try subtracting(otherTC)
    }
    
    /// Subtract a duration from the current timecode and return a new instance.
    ///
    /// - Throws: ``ValidationError``
    public func subtracting(_ other: GuaranteedTimecodeSourceValue) throws -> Timecode {
        let otherTC = Timecode(other, using: properties)
        return try subtracting(otherTC)
    }
    
    /// Subtract a duration from the current timecode and return a new instance.
    ///
    /// - Throws: ``ValidationError``
    public func subtracting(_ other: GuaranteedRichTimecodeSourceValue) throws -> Timecode {
        let otherTC = Timecode(other)
        return try subtracting(otherTC)
    }
    
    /// Subtract a duration from the current timecode and return a new instance.
    ///
    /// - Throws: ``ValidationError``
    public func subtracting(_ other: TimecodeSourceValue, by validation: ValidationRule) throws -> Timecode {
        let otherTC = try Timecode(other, using: properties)
        return try subtracting(otherTC, by: validation)
    }
    
    /// Subtract a duration from the current timecode and return a new instance.
    ///
    /// - Throws: ``ValidationError``
    public func subtracting(_ other: FormattedTimecodeSourceValue, by validation: ValidationRule) throws -> Timecode {
        let otherTC = try Timecode(other, using: properties)
        return try subtracting(otherTC, by: validation)
    }
    
    /// Subtract a duration from the current timecode and return a new instance.
    ///
    /// - Throws: ``ValidationError``
    public func subtracting(_ other: RichTimecodeSourceValue, by validation: ValidationRule) throws -> Timecode {
        let otherTC = try Timecode(other)
        return try subtracting(otherTC, by: validation)
    }
    
    /// Subtract a duration from the current timecode and return a new instance.
    ///
    /// - Throws: ``ValidationError``
    public func subtracting(_ other: GuaranteedTimecodeSourceValue, by validation: ValidationRule) throws -> Timecode {
        let otherTC = Timecode(other, using: properties)
        return try subtracting(otherTC, by: validation)
    }
    
    /// Subtract a duration from the current timecode and return a new instance.
    ///
    /// - Throws: ``ValidationError``
    public func subtracting(_ other: GuaranteedRichTimecodeSourceValue, by validation: ValidationRule) throws -> Timecode {
        let otherTC = Timecode(other)
        return try subtracting(otherTC, by: validation)
    }
    
    // MARK: - Subtracting Components
    
    /// Subtract a duration from the current timecode and return a new instance.
    /// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
    public func subtracting(_ source: Components) throws -> Timecode {
        var newTimecode = self
        try newTimecode.subtract(source)
        return newTimecode
    }
    
    /// Subtract a duration from the current timecode and return a new instance.
    /// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
    public func subtracting(_ source: Components, by validation: ValidationRule) -> Timecode {
        var newTimecode = self
        newTimecode.subtract(source, by: validation)
        return newTimecode
    }
    
    // MARK: - Multiply Double
    
    /// Multiply the current timecode by floating-point number.
    ///
    /// - Throws: ``ValidationError``
    public mutating func multiply(_ exactly: Double) throws {
        guard let newTC = _multiply(exactly: exactly, with: components)
        else { throw ValidationError.outOfBounds }
        
        try _setTimecode(exactly: newTC)
    }
    
    /// Multiply the current timecode by floating-point number.
    public mutating func multiply(_ source: Double, by validation: ValidationRule) {
        let newTC: Timecode.Components = switch validation {
        case .clamping, .clampingComponents:
            _multiply(clamping: source, with: components)
            
        case .wrapping:
            _multiply(wrapping: source, with: components)
            
        case .allowingInvalid:
            _multiply(rawValues: source, with: components)
        }
        
        _setTimecode(rawValues: newTC)
    }
    
    /// Multiply the current timecode by floating-point number and return a new instance.
    /// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
    ///
    /// - Throws: ``ValidationError``
    public func multiplying(_ source: Double) throws -> Timecode {
        var newTimecode = self
        try newTimecode.multiply(source)
        return newTimecode
    }
    
    /// Multiply the current timecode by floating-point number and return a new instance.
    /// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
    public func multiplying(_ source: Double, by validation: ValidationRule) -> Timecode {
        var newTimecode = self
        newTimecode.multiply(source, by: validation)
        return newTimecode
    }
    
    // MARK: - Divide Double
    
    /// Divide the current timecode by floating-point number.
    ///
    /// - Throws: ``ValidationError``
    public mutating func divide(_ exactly: Double) throws {
        guard let newTC = _divide(exactly: exactly, into: components)
        else { throw ValidationError.outOfBounds }
        
        try _setTimecode(exactly: newTC)
    }
    
    /// Divide the current timecode by floating-point number.
    public mutating func divide(_ source: Double, by validation: ValidationRule) {
        let newTC: Timecode.Components = switch validation {
        case .clamping, .clampingComponents:
            _divide(clamping: source, into: components)
            
        case .wrapping:
            _divide(wrapping: source, into: components)
            
        case .allowingInvalid:
            _divide(rawValues: source, into: components)
        }
        
        _setTimecode(rawValues: newTC)
    }
    
    // MARK: - Dividing Double -> Timecode
    
    /// Divide the current timecode by floating-point number and return a new instance.
    /// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000)
    /// or (0,0,500,0)
    ///
    /// - Throws: ``ValidationError``
    public func dividing(_ source: Double) throws -> Timecode {
        var newTimecode = self
        try newTimecode.divide(source)
        return newTimecode
    }
    
    /// Divide the current timecode by floating-point number and return a new instance.
    /// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000)
    /// or (0,0,500,0)
    public func dividing(_ source: Double, by validation: ValidationRule) -> Timecode {
        var newTimecode = self
        newTimecode.divide(source, by: validation)
        return newTimecode
    }
    
    // MARK: - Dividing Timecode -> Double
    
    /// Divide the current timecode by floating-point number and return a new instance.
    ///
    /// - Throws: ``ValidationError``
    public func dividing(_ other: Timecode) throws -> Double {
        try dividing(
            frameRate == other.frameRate
                ? other.components
                : other.converted(to: frameRate).components
        )
    }
    
    // MARK: - Dividing Components
    
    /// Divide the current timecode by a duration and return a new instance.
    /// Input values can be as large as desired and will be calculated recursively. ie: (0,0,0,1000) or (0,0,500,0)
    ///
    /// - Throws: ``ValidationError``
    public func dividing(_ source: Components) throws -> Double {
        guard let dbl = _divide(exactly: source, into: components)
        else { throw ValidationError.outOfBounds }
        
        return dbl
    }
    
    // MARK: - Offset / TimecodeInterval
    
    /// Offsets the current timecode by a delta amount.
    /// Wraps around the clock if needed, as set by the ``upperLimit`` property.
    public mutating func offset(by interval: TimecodeInterval) {
        self = interval.timecode(offsetting: self)
    }
    
    /// Returns the timecode offset by a delta amount.
    /// Wraps around the clock if needed, as set by the ``upperLimit`` property.
    public func offsetting(by interval: TimecodeInterval) -> Timecode {
        interval.timecode(offsetting: self)
    }
    
    /// Returns a ``TimecodeInterval`` distance between the current timecode and another timecode.
    public func interval(to other: Timecode) -> TimecodeInterval {
        if frameRate == other.frameRate {
            return _offset(to: other.components)
        } else {
            guard let otherConverted = try? other.converted(to: frameRate) else {
                assertionFailure("Could not convert other Timecode to self Timecode frameRate.")
                return .init(Timecode(.zero, using: properties))
            }
            
            return _offset(to: otherConverted.components)
        }
    }
    
    /// Constructs a new ``TimecodeInterval`` instance from `self`.
    public func asInterval(_ sign: FloatingPointSign = .plus) -> TimecodeInterval {
        TimecodeInterval(self, sign)
    }
    
    // MARK: - Convenience Attributes
    
    /// Returns `true` if timecode (including subframes) is zero (00:00:00:00.00).
    public var isZero: Bool {
        frameCount.isZero
    }
}
