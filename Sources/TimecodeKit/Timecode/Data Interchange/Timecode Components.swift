//
//  Timecode Components.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// MARK: - Init

extension Timecode {
    /// Instance exactly from timecode values and frame rate.
    ///
    /// If any values are out-of-bounds an error will be thrown, indicating an invalid timecode.
    ///
    /// Validation is based on the `upperLimit` and `subFramesBase` properties.
    ///
    /// - Throws: ``ValidationError``
    public init(
        _ exactly: Components,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default()
    ) throws {
        properties = Properties(rate: rate, base: base, limit: limit)
        
        try setTimecode(exactly: exactly)
    }
    
    /// Instance from timecode values and frame rate, clamping to valid timecode if necessary.
    ///
    /// Clamping is based on the `upperLimit` and `subFramesBase` properties.
    public init(
        clamping rawValues: Components,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default()
    ) {
        properties = Properties(rate: rate, base: base, limit: limit)
        
        setTimecode(clamping: rawValues)
    }
    
    /// Instance from timecode values and frame rate, clamping individual values if necessary.
    ///
    /// Individual components which are out-of-bounds will be clamped to minimum or maximum possible
    /// values.
    ///
    /// Clamping is based on the `upperLimit` and `subFramesBase` properties.
    public init(
        clampingEach rawValues: Components,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default()
    ) {
        properties = Properties(rate: rate, base: base, limit: limit)
        
        setTimecode(clampingEach: rawValues)
    }
    
    /// Instance from timecode values and frame rate, wrapping timecode if necessary.
    ///
    /// Timecode will be wrapped around the timecode clock if out-of-bounds.
    ///
    /// Wrapping is based on the `upperLimit` and `subFramesBase` properties.
    public init(
        wrapping rawValues: Components,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default()
    ) {
        properties = Properties(rate: rate, base: base, limit: limit)
        
        setTimecode(wrapping: rawValues)
    }
    
    /// Instance from raw timecode values and frame rate.
    ///
    /// Timecode values will not be validated or rejected if they overflow.
    ///
    /// This is useful, for example, when intending on running timecode validation methods against timecode values that are unknown to be valid or not at the time of initializing.
    public init(
        rawValues: Components,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default()
    ) {
        properties = Properties(rate: rate, base: base, limit: limit)
        
        setTimecode(rawValues: rawValues)
    }
}

// MARK: - Get and Set

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

// MARK: - .toTimecode

extension Timecode.Components {
    /// Returns an instance of `Timecode(exactly:)`.
    ///
    /// - Throws: ``Timecode/ValidationError``
    public func toTimecode(
        at rate: TimecodeFrameRate,
        limit: Timecode.UpperLimit = ._24hours,
        base: Timecode.SubFramesBase = .default()
    ) throws -> Timecode {
        try Timecode(
            self,
            at: rate,
            limit: limit,
            base: base
        )
    }
    
    /// Returns an instance of `Timecode(rawValues:)`.
    public func toTimecode(
        rawValuesAt rate: TimecodeFrameRate,
        limit: Timecode.UpperLimit = ._24hours,
        base: Timecode.SubFramesBase = .default()
    ) -> Timecode {
        Timecode(
            rawValues: self,
            at: rate,
            limit: limit,
            base: base
        )
    }
}
