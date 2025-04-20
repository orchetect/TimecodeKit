//
//  Components.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

extension Timecode {
    /// Primitive struct describing timecode component values, agnostic of frame rate.
    ///
    /// In order to help facilitate defining a set of timecode component values, a simple struct is provided.
    ///
    /// This struct can be passed into many methods and initializers.
    ///
    /// ```swift
    /// let components = Timecode.Components(h: 1)
    /// Timecode(.components(components), at: .fps23_976)
    ///
    /// // is the same as using the shorthand:
    /// Timecode(.components(h: 1), at: .fps23_976)
    /// ```
    ///
    /// ```swift
    /// let components = try Timecode(.string("01:12:20:05"), at: .fps23_976)
    ///     .components // Timecode.Components
    ///
    /// components.days      // == 0
    /// components.hours     // == 1
    /// components.minutes   // == 12
    /// components.seconds   // == 20
    /// components.frames    // == 5
    /// components.subFrames // == 0
    /// ```
    ///
    /// Raw values are stored verbatim and are not implicitly validated or clamped.
    ///
    /// ## Days Component
    ///
    /// Using the Days timecode component.
    ///
    /// Although not covered by SMPTE spec, some DAWs (digital audio workstation) such as Cubase support the use of the Days timecode
    /// component for timelines longer than (or outside of) 24 hours.
    ///
    /// By default, ``Timecode`` is constructed with an ``Timecode/upperLimit`` of 24-hour maximum expression (`.max24Hours`) which
    /// suppresses the ability to use Days. To enable Days, set the limit to `.max100Days`.
    ///
    /// The limit setting naturally affects internal timecode validation routines, as well as clamping and wrapping.
    ///
    /// ```swift
    /// // valid timecode range at 24 fps, with 24 hours limit
    /// "00:00:00:00" ... "23:59:59:23"
    ///
    /// // valid timecode range at 24 fps, with 100 days limit
    /// "00:00:00:00" ... "99 23:59:59:23"
    /// ```
    ///
    /// ## SubFrames Component
    ///
    /// Using the SubFrames timecode component.
    ///
    /// Subframes represent a fraction (subdivision) of a single frame.
    ///
    /// Subframes are only used by some software and hardware, and since there are no industry standards, each manufacturer can decide how
    /// they want to implement subframes. Subframes are frame rate agnostic, meaning the subframe base (divisor) is mutually exclusive of
    /// frame rate.
    ///
    /// For example:
    ///
    /// - *Cubase/Nuendo* and *Logic Pro* globally use 80 subframes per frame (0 ... 79) regardless of frame rate
    /// - *Pro Tools* uses 100 subframes (0 ... 99) globally regardless of frame rate
    ///
    /// Timecode supports subframes throughout. However, by default subframes are not displayed in ``Timecode/stringValue(format:)``. You
    /// can enable them:
    ///
    /// ```swift
    /// var tc = try Timecode(
    ///     .string("01:12:20:05.62"),
    ///     at: .fps24,
    ///     base: .max80SubFrames
    /// )
    ///
    /// // string with default formatting
    /// tc.stringValue() // == "01:12:20:05"
    /// tc.subFrames     // == 62 (subframes are preserved even though not displayed in stringValue)
    ///
    /// // string with subframes shown
    /// tc.stringValue(format: .showSubFrames) // == "01:12:20:05.62"
    /// ```
    ///
    /// Subframes are always calculated when performing operations on the ``Timecode`` instance, even if they are not expressed in the
    /// timecode string when not displaying subframes.
    ///
    /// ```swift
    /// var tc = try Timecode(
    ///     .string("00:00:00:00.40"),
    ///     at: .fps24,
    ///     base: .max80SubFrames
    /// )
    ///
    /// tc.stringValue() // == "00:00:00:00"
    /// tc.stringValue(format: .showSubFrames) // == "00:00:00:00.40"
    ///
    /// // multiply timecode by 2.
    /// // 40 subframes is half of a frame at 80 subframes per frame
    /// (tc * 2).stringValue(format: .showSubFrames) // == "00:00:00:01.00"
    /// ```
    public struct Components {
        // MARK: Contents
        
        /// Timecode days component.
        ///
        /// Valid only if ``Timecode/upperLimit-swift.property`` is set to `.max100Days`.
        ///
        /// Setting this value directly does not trigger any validation.
        public var days: Int
        
        /// Timecode hours component.
        ///
        /// Valid range: 0 ... 23.
        ///
        /// Setting this value directly does not trigger any validation.
        public var hours: Int
        
        /// Timecode minutes component.
        ///
        /// Valid range: 0 ... 59.
        ///
        /// Setting this value directly does not trigger any validation.
        public var minutes: Int
        
        /// Timecode seconds component.
        ///
        /// Valid range: 0 ... 59.
        ///
        /// Setting this value directly does not trigger any validation.
        public var seconds: Int
        
        /// Timecode frames component.
        ///
        /// Valid range is dependent on the `frameRate` property.
        ///
        /// Setting this value directly does not trigger any validation.
        public var frames: Int
        
        /// Timecode subframes component.
        /// Represents a subdivision of the current frame.
        ///
        /// Some implementations refer to these as SMPTE frame "bits".
        ///
        /// Industry standards vary regarding subframe divisors depending on manufacturers and formats,
        /// and not all manufacturers support the usage of subframes.
        /// - DAWs such as Cubase, Nuendo, Logic Pro, and Final Cut Pro use 80 subframes per frame (0 ... 79).
        /// - DAWs such as Pro Tools use 100 subframes per frame (0 ... 99).
        /// - MIDI Timecode (MTC) uses 4 subframes per frame, also known as quarter-frames (0 ... 3).
        public var subFrames: Int
        
        // MARK: init
        
        public init(
            d: Int = 0,
            h: Int = 0,
            m: Int = 0,
            s: Int = 0,
            f: Int = 0,
            sf: Int = 0
        ) {
            days = d
            hours = h
            minutes = m
            seconds = s
            frames = f
            subFrames = sf
        }
    }
}

extension Timecode.Components: Equatable { }

extension Timecode.Components: Hashable { }

@available(macOS 10.15, macCatalyst 13, iOS 11, tvOS 11, watchOS 6, *)
extension Timecode.Components: Identifiable {
    public var id: Self { self }
}

extension Timecode.Components: Sendable { }

extension Timecode.Components: Codable { }

// MARK: - Static Constructors

extension Timecode.Components {
    /// Components value of zero (00:00:00:00).
    public static let zero: Self = .init(d: 0, h: 0, m: 0, s: 0, f: 0, sf: 0)
    
    /// Create a new set of valid timecode components with random values using the given properties.
    public static func random(using properties: Timecode.Properties) -> Self {
        .init(randomUsing: properties)
    }
    
    /// Create a new set of timecode components within the given ranges, allowing potential invalid values.
    public static func random(in ranges: Timecode.ComponentRanges) -> Self {
        .init(randomIn: ranges)
    }
}

// MARK: - Random Inits

extension Timecode.Components {
    /// Create a new set of valid timecode components with random values using the given properties.
    init(randomUsing properties: Timecode.Properties) {
        var components = Self.zero
        
        if properties.upperLimit == .max100Days {
            components.days = components.validRange(of: .days, using: properties).randomElement()!
        }
        components.hours = components.validRange(of: .hours, using: properties).randomElement()!
        components.minutes = components.validRange(of: .minutes, using: properties).randomElement()!
        components.seconds = components.validRange(of: .seconds, using: properties).randomElement()!
        components.frames = components.validRange(of: .frames, using: properties).randomElement()!
        components.subFrames = components.validRange(of: .subFrames, using: properties).randomElement()!
        
        self = components
    }
    
    /// Create a new set of timecode components within the given ranges, allowing potential invalid values.
    init(randomIn ranges: Timecode.ComponentRanges) {
        self.init(
            d: Int.random(in: ranges.days),
            h: Int.random(in: ranges.hours),
            m: Int.random(in: ranges.minutes),
            s: Int.random(in: ranges.seconds),
            f: Int.random(in: ranges.frames),
            sf: Int.random(in: ranges.subFrames)
        )
    }
}

// MARK: - Data Structures

extension Timecode.Components {
    /// Initialize from a component value dictionary keyed by ``Timecode/Component``.
    public init(_ dictionary: [Timecode.Component: Int]) {
        self.init(
            d: dictionary[.days] ?? 0,
            h: dictionary[.hours] ?? 0,
            m: dictionary[.minutes] ?? 0,
            s: dictionary[.seconds] ?? 0,
            f: dictionary[.frames] ?? 0,
            sf: dictionary[.subFrames] ?? 0
        )
    }
    
    /// Get or set the timecode component values as a dictionary keyed by ``Timecode/Component``.
    public var dictionary: [Timecode.Component: Int] {
        get {
            [
                .days: days,
                .hours: hours,
                .minutes: minutes,
                .seconds: seconds,
                .frames: frames,
                .subFrames: subFrames
            ]
        }
        set {
            set(from: newValue)
        }
    }
    
    /// Internal:
    /// Sets component values from a dictionary keyed by ``Timecode/Component``.
    mutating func set(from dictionary: [Timecode.Component: Int]) {
        for component in Timecode.Component.allCases {
            if let value = dictionary[component] {
                switch component {
                case .days: days = value
                case .hours: hours = value
                case .minutes: minutes = value
                case .seconds: seconds = value
                case .frames: frames = value
                case .subFrames: subFrames = value
                }
            }
        }
    }
}

extension Timecode.Components {
    /// Initialize from a component key/value pair array keyed by ``Timecode/Component``.
    public init(_ array: [(component: Timecode.Component, value: Int)]) {
        // TODO: not the most performant, but by far the simplest way to achieve this
        self.init()
        set(from: array)
    }
    
    /// Get or set the timecode component values as an array of key/value pairs keyed by ``Timecode/Component``.
    public var array: [(component: Timecode.Component, value: Int)] {
        get {
            [
                (.days, days),
                (.hours, hours),
                (.minutes, minutes),
                (.seconds, seconds),
                (.frames, frames),
                (.subFrames, subFrames)
            ]
        }
        set {
            set(from: newValue)
        }
    }
    
    /// Internal:
    /// Sets component values from an array of key/value pairs keyed by ``Timecode/Component``.
    mutating func set(from array: [(component: Timecode.Component, value: Int)]) {
        for (component, value) in array {
            switch component {
            case .days: days = value
            case .hours: hours = value
            case .minutes: minutes = value
            case .seconds: seconds = value
            case .frames: frames = value
            case .subFrames: subFrames = value
            }
        }
    }
}

// MARK: - Iterators

extension Timecode.Components: Sequence {
    /// Returns an ordered iterator over timecode component key/value pairs.
    ///
    /// Example usage:
    ///
    /// ```swift
    /// let components = Timecode.Components( ... )
    ///
    /// for (component, value) in components {
    ///     // ...
    /// }
    /// ```
    public func makeIterator() -> IndexingIterator<[(component: Timecode.Component, value: Int)]> {
        array.makeIterator()
    }
}

// MARK: - Validation

extension Timecode.Components {
    /// Returns a set of invalid components, if any.
    /// A fully valid timecode will return an empty set.
    public func invalidComponents(
        at frameRate: TimecodeFrameRate,
        base: Timecode.SubFramesBase = .default(),
        limit: Timecode.UpperLimit = .max24Hours
    ) -> Set<Timecode.Component> {
        let properties = Timecode.Properties(rate: frameRate, base: base, limit: limit)
        return invalidComponents(using: properties)
    }
    
    /// Returns a set of invalid components, if any.
    /// A fully valid timecode will return an empty set.
    public func invalidComponents(
        using properties: Timecode.Properties
    ) -> Set<Timecode.Component> {
        var invalids: Set<Timecode.Component> = []
        
        if !validRange(of: .days, using: properties)
            .contains(days)
        { invalids.insert(.days) }
        
        if !validRange(of: .hours, using: properties)
            .contains(hours)
        { invalids.insert(.hours) }
        
        if !validRange(of: .minutes, using: properties)
            .contains(minutes)
        { invalids.insert(.minutes) }
        
        if !validRange(of: .seconds, using: properties)
            .contains(seconds)
        { invalids.insert(.seconds) }
        
        if !validRange(of: .frames, using: properties)
            .contains(frames)
        { invalids.insert(.frames) }
        
        if !validRange(of: .subFrames, using: properties)
            .contains(subFrames)
        { invalids.insert(.subFrames) }
        
        return invalids
    }
}

extension Timecode.Components {
    /// Returns `true` if all component values are within acceptable number of digit range based on the specified frame
    /// rate and subframes base.
    ///
    /// > NOTE:
    /// > This method does not validate the values themselves, but merely the number of digit places they occupy.
    /// >
    /// > For example, the `frames` value could be `99` which is an invalid value at most frame rates, however it is
    /// > still within the allowable digit count for those frame rates (2 digit places).
    /// >
    /// > To validate timecode component values, construct a ``Timecode`` instance using the
    /// > ``Timecode/ValidationRule/allowingInvalid`` validation rule and then query its ``Timecode/isValid`` property
    /// > instead. Alternatively, the ``Timecode/invalidComponents`` property can granularly return which
    /// > individual components are invalid, if any.
    public func isWithinValidDigitCounts(
        at frameRate: TimecodeFrameRate,
        base: Timecode.SubFramesBase
    ) -> Bool {
        allSatisfy { (component: Timecode.Component, value: Int) in
            value.numberOfDigits <=
                component.numberOfDigits(at: frameRate, base: base)
        }
    }
}
