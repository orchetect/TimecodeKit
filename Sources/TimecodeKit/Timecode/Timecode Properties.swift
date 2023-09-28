//
//  Timecode Properties.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension Timecode {
    /// ``Timecode`` properties.
    ///
    /// ## Individual Timecode Components
    ///
    /// Timecode components can be get or set directly as instance properties.
    ///
    /// ```swift
    /// let tc = try "01:12:20:05".timecode(at: .fps23_976)
    ///
    /// // get
    /// tc.days          // == 0
    /// tc.hours         // == 1
    /// tc.minutes       // == 12
    /// tc.seconds       // == 20
    /// tc.frames        // == 5
    /// tc.subFrames     // == 0
    ///
    /// // set
    /// tc.hours = 5
    /// tc.stringValue() // == "05:12:20:05"
    /// ```
    ///
    /// ## Components Struct
    ///
    /// A compact components struct can be used to initialize ``Timecode`` and can also be accessed using ``Timecode/components-swift.property``.
    ///
    /// See ``Components-swift.struct``.
    public struct Properties: Equatable, Hashable {
        /// Frame rate.
        ///
        /// - Note: Several properties are available on the frame rate that is selected, including its
        /// ``Timecode/stringValue(format:)`` representation or whether the rate ``TimecodeFrameRate/isDrop``.
        ///
        /// Setting this value directly does not trigger any validation.
        public var frameRate: TimecodeFrameRate
        
        /// Subframes base (divisor).
        ///
        /// The number of subframes that make up a single frame.
        ///
        /// (ie: a divisor of 80 subframes per frame implies a visible value range of 00...79)
        ///
        /// This will vary depending on application. Most common divisors are 80 or 100.
        ///
        /// - Note: Setting this value directly does not trigger any validation.
        public var subFramesBase: SubFramesBase
        
        /// Timecode maximum upper bound.
        ///
        /// This also affects how timecode values wrap when adding or clamping.
        ///
        /// - Note: Setting this value directly does not trigger any validation.
        public var upperLimit: UpperLimit
        
        /// ``Timecode`` properties.
        public init(
            rate: TimecodeFrameRate,
            base: SubFramesBase = .default(),
            limit: UpperLimit = ._24Hours
        ) {
            frameRate = rate
            subFramesBase = base
            upperLimit = limit
        }
    }
}

extension Timecode.Properties: Codable { }
