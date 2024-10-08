//
//  Components.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

extension Timecode {
    /// Primitive struct describing timecode values, agnostic of frame rate.
    ///
    /// In order to help facilitate defining a set of timecode component values, a simple ``Timecode/Components`` struct is implemented.
    /// This struct can be passed into many methods and initializers.
    ///
    /// ```swift
    /// let tcc = Timecode.Components(h: 1)
    /// Timecode(.components(tcc), at: .fps23_976)
    ///
    /// // is the same as using the shorthand:
    /// Timecode(.components(h: 1), at: .fps23_976)
    /// ```
    ///
    /// ```swift
    /// let cmp = try "01:12:20:05"
    ///     .timecode(at: .fps23_976)
    ///     .components // Timecode.Components
    ///
    /// cmp.days      // == 0
    /// cmp.hours     // == 1
    /// cmp.minutes   // == 12
    /// cmp.seconds   // == 20
    /// cmp.frames    // == 5
    /// cmp.subFrames // == 0
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
    /// var tc = try "01:12:20:05.62"
    ///     .timecode(at: .fps24, base: .max80SubFrames)
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
    /// var tc = try "00:00:00:00.40"
    ///     .timecode(at: .fps24, base: .max80SubFrames)
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
    @_disfavoredOverload
    public static let zero: Self = .init(h: 0, m: 0, s: 0, f: 0)
    
    /// Create a new set of timecode components with random values using the given properties.
    public static func random(using properties: Timecode.Properties) -> Self {
        .init(randomUsing: properties)
    }
}

// MARK: - Random

extension Timecode.Components {
    /// Create a new set of timecode components with random values using the given properties.
    public init(randomUsing properties: Timecode.Properties) {
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
}
