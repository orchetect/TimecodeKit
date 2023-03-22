//
//  Timecode Components.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// MARK: - TimecodeSource

extension Timecode.Components: TimecodeSource {
    public func set(timecode: inout Timecode) throws {
        try timecode.setTimecode(exactly: self)
    }
    
    public func set(timecode: inout Timecode, by validation: Timecode.Validation) {
        switch validation {
        case .clamping:
            timecode.setTimecode(clamping: self)
        case .clampingEach:
            timecode.setTimecode(clampingEach: self)
        case .wrapping:
            timecode.setTimecode(wrapping: self)
        case .allowingInvalidComponents:
            timecode.setTimecode(rawValues: self)
        }
    }
}

extension TimecodeSource where Self == Timecode.Components {
    public static func components(_ source: Timecode.Components) -> Self {
        source
    }
    
    public static func components(
        d: Int = 0,
        h: Int = 0,
        m: Int = 0,
        s: Int = 0,
        f: Int = 0,
        sf: Int = 0
    ) -> Self {
        Timecode.Components(d: d, h: h, m: m, s: s, f: f, sf: sf)
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
    internal mutating func setTimecode(exactly values: Components) throws {
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
    internal mutating func setTimecode(clamping source: Components) {
        let result = __add(clamping: source, to: .zero)
        
        setTimecode(rawValues: result)
    }
    
    /// Set timecode from components, clamping individual values if necessary.
    ///
    /// (Validation is based on the frame rate and `upperLimit` property.)
    internal mutating func setTimecode(clampingEach values: Components) {
        components = values
        
        clampComponents()
    }
    
    /// Set timecode from tuple values.
    ///
    /// Timecode will wrap if out-of-bounds. Will handle negative values and wrap accordingly.
    ///
    /// (Wrapping is based on the frame rate and `upperLimit` property.)
    internal mutating func setTimecode(wrapping values: Components) {
        setTimecode(rawValues: __add(
            wrapping: values,
            to: .zero
        ))
    }
    
    /// Set timecode from tuple values.
    /// Timecode values will not be validated or rejected if they overflow.
    internal mutating func setTimecode(rawValues values: Components) {
        components = values
    }
}
