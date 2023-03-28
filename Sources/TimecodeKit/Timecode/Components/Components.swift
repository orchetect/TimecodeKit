//
//  Components.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

extension Timecode {
    /// Primitive struct describing timecode values, agnostic of frame rate.
    ///
    /// Raw values are stored and are not implicitly validated or clamped.
    public struct Components {
        // MARK: Contents
        
        /// Timecode days component.
        ///
        /// Valid only if ``Timecode/upperLimit-swift.property`` is set to `._100days`.
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
        
        /// Timecode sub-frames component. Represents a partial division of a frame.
        ///
        /// Some implementations refer to these as SMPTE frame "bits".
        ///
        /// There are no set industry standards regarding subframe divisors.
        /// - Cubase/Nuendo, Logic Pro/Final Cut Pro use 80 subframes per frame (0 ... 79);
        /// - Pro Tools uses 100 subframes (0 ... 99).
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
            self.days = d
            self.hours = h
            self.minutes = m
            self.seconds = s
            self.frames = f
            self.subFrames = sf
        }
    }
}

extension Timecode.Components: Equatable { }

extension Timecode.Components: Hashable { }

extension Timecode.Components: Codable { }

// MARK: - Static Constructors

extension Timecode.Components {
    /// Components value of zero (00:00:00:00)
    public static let zero: Self = .init(h: 0, m: 0, s: 0, f: 0)
}
