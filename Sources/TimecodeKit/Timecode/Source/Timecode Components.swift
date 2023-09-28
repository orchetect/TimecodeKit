//
//  Timecode Components.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

// MARK: - TimecodeSource

extension Timecode.Components: _TimecodeSource {
    func set(timecode: inout Timecode) throws {
        try timecode._setTimecode(exactly: self)
    }
    
    func set(timecode: inout Timecode, by validation: Timecode.ValidationRule) {
        switch validation {
        case .clamping:
            timecode._setTimecode(clamping: self)
        case .clampingComponents:
            timecode._setTimecode(clampingComponents: self)
        case .wrapping:
            timecode._setTimecode(wrapping: self)
        case .allowingInvalid:
            timecode._setTimecode(rawValues: self)
        }
    }
}

// MARK: - Static Constructors

extension TimecodeSourceValue {
    /// Timecode components.
    public static func components(_ source: Timecode.Components) -> Self {
        .init(value: source)
    }
    
    /// Timecode components.
    public static func components(
        d: Int = 0,
        h: Int = 0,
        m: Int = 0,
        s: Int = 0,
        f: Int = 0,
        sf: Int = 0
    ) -> Self {
        .init(value: Timecode.Components(d: d, h: h, m: m, s: s, f: f, sf: sf))
    }
}

// MARK: - Get

// no getter - Timecode contains stored components property

// MARK: - Set

extension Timecode {
    /// Set timecode from tuple values.
    ///
    /// Returns true/false depending on whether the string values are valid or not.
    ///
    /// Values which are out-of-bounds will return false.
    ///
    /// (Validation is based on the frame rate and `upperLimit` property.)
    ///
    /// - Throws: ``ValidationError``
    mutating func _setTimecode(exactly values: Components) throws {
        guard values
            .invalidComponents(using: properties)
            .isEmpty
        else { throw ValidationError.outOfBounds }
        
        components = values
    }
    
    /// Set timecode from components.
    /// Clamps to valid timecode as set by the `upperLimit` property.
    ///
    /// (Validation is based on the frame rate and `upperLimit` property.)
    mutating func _setTimecode(clamping source: Components) {
        let result = _add(clamping: source, to: .zero)
        
        _setTimecode(rawValues: result)
    }
    
    /// Set timecode from components, clamping individual values if necessary.
    ///
    /// (Validation is based on the frame rate and `upperLimit` property.)
    mutating func _setTimecode(clampingComponents values: Components) {
        components = values
        
        clampComponents()
    }
    
    /// Set timecode from tuple values.
    ///
    /// Timecode will wrap if out-of-bounds. Will handle negative values and wrap accordingly.
    ///
    /// (Wrapping is based on the frame rate and `upperLimit` property.)
    mutating func _setTimecode(wrapping values: Components) {
        _setTimecode(rawValues: _add(
            wrapping: values,
            to: .zero
        ))
    }
    
    /// Set timecode from tuple values.
    /// Timecode values will not be validated or rejected if they overflow.
    mutating func _setTimecode(rawValues values: Components) {
        components = values
    }
}
