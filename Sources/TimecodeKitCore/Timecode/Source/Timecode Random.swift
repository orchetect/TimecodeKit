//
//  Timecode Random.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

// MARK: - Predicate

extension Timecode {
    /// Constrains component values to only valid values at the given frame rate, subframes base and upper limit.
    public struct SafeRandomComponents {
        init() { }
    }
    
    /// Randomize timecode components within the given ranges, allowing potential invalid values.
    public struct UnsafeRandomComponents {
        let ranges: Timecode.ComponentRanges
        
        init(ranges: Timecode.ComponentRanges) {
            self.ranges = ranges
        }
    }
    
    /// Randomizes timecode properties and generates random component values constrained to only valid values at the
    /// generated frame rate, subframes base and upper limit.
    public struct SafeRandomComponentsAndProperties {
        init() { }
    }
    
    /// Randomizes timecode properties and generates random component values, allowing potential invalid values.
    public struct UnsafeRandomComponentsAndProperties {
        let ranges: Timecode.ComponentRanges
        
        init(ranges: Timecode.ComponentRanges) {
            self.ranges = ranges
        }
    }
}

// MARK: - TimecodeSource

extension Timecode.SafeRandomComponents: _GuaranteedTimecodeSource {
    func set(timecode: inout Timecode) {
        let components: Timecode.Components = .random(using: timecode.properties)
        timecode.set(components, by: .allowingInvalid)
    }
}

extension Timecode.UnsafeRandomComponents: _TimecodeSource {
    func set(timecode: inout Timecode) throws {
        let components: Timecode.Components = .random(in: ranges)
        try timecode.set(components)
    }
    
    func set(timecode: inout Timecode, by validation: Timecode.ValidationRule) {
        let components: Timecode.Components = .random(in: ranges)
        timecode.set(components, by: validation)
    }
}

extension Timecode.SafeRandomComponentsAndProperties: _GuaranteedRichTimecodeSource {
    func set(timecode: inout Timecode) -> Timecode.Properties {
        timecode.upperLimit = Timecode.UpperLimit.allCases.randomElement()!
        timecode.subFramesBase = Timecode.SubFramesBase.allCases.randomElement()!
        timecode.frameRate = TimecodeFrameRate.allCases.randomElement()!
        
        let components: Timecode.Components = .random(using: timecode.properties)
        timecode.set(components, by: .allowingInvalid)
        
        return timecode.properties
    }
}

extension Timecode.UnsafeRandomComponentsAndProperties: _RichTimecodeSource {
    func set(timecode: inout Timecode) throws -> Timecode.Properties {
        timecode.upperLimit = Timecode.UpperLimit.allCases.randomElement()!
        timecode.subFramesBase = Timecode.SubFramesBase.allCases.randomElement()!
        timecode.frameRate = TimecodeFrameRate.allCases.randomElement()!
        
        let components: Timecode.Components = .random(in: ranges)
        try timecode.set(components)
        
        return timecode.properties
    }
    
    func set(timecode: inout Timecode, by validation: Timecode.ValidationRule) -> Timecode.Properties {
        timecode.upperLimit = Timecode.UpperLimit.allCases.randomElement()!
        timecode.subFramesBase = Timecode.SubFramesBase.allCases.randomElement()!
        timecode.frameRate = TimecodeFrameRate.allCases.randomElement()!
        
        let components: Timecode.Components = .random(in: ranges)
        timecode.set(components, by: validation)
        
        return timecode.properties
    }
}

// MARK: - Static Constructors

extension GuaranteedTimecodeSourceValue {
    /// Random timecode components.
    /// Create a new timecode instance with valid random component values using the given properties.
    public static let randomComponents: Self = .init(value: Timecode.SafeRandomComponents())
}

extension TimecodeSourceValue {
    /// Random timecode components.
    /// Components are randomized within the given ranges, allowing potential invalid values.
    ///
    /// - Parameters:
    ///   - ranges: Component value ranges with which to constrain random values.
    public static func randomComponents(
        in ranges: Timecode.ComponentRanges = .unsafeRandomRanges
    ) -> Self {
        .init(value: Timecode.UnsafeRandomComponents(ranges: ranges))
    }
}

extension GuaranteedRichTimecodeSourceValue {
    /// Random timecode components and properties.
    /// Create a new timecode instance with valid random component values using the given properties.
    public static let randomComponentsAndProperties: Self = .init(
        value: Timecode.SafeRandomComponentsAndProperties()
    )
}

extension RichTimecodeSourceValue {
    /// Random timecode components and properties.
    /// Components are randomized within the given ranges, allowing potential invalid values.
    ///
    /// - Parameters:
    ///   - ranges: Component value ranges with which to constrain random values.
    public static func randomComponentsAndProperties(
        in ranges: Timecode.ComponentRanges
    ) -> Self {
        .init(value: Timecode.UnsafeRandomComponentsAndProperties(ranges: ranges))
    }
}
