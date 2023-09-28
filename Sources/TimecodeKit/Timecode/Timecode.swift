//
//  Timecode.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

/// Value type representing SMPTE timecode.
///
/// - A variety of initializers and methods are available for string and numeric representation,
///   validation, and conversion
/// - Mathematical operators are available between two instances: `+`, `-`, `*`, `\`
/// - Comparison operators are available between two instances: `==`, `!=`, `<`, `>`
/// - `Range` and `Stride` can be formed between two instances
/// - Many more features are detailed in the documentation
public struct Timecode {
    // MARK: - Components
    
    /// Numerical timecode components.
    /// (This components store makes it convenient to port around timecode component values agnostic
    /// of frame rate or other properties to other Timecode initializers or methods.)
    public var components: Components = .zero
    
    /// Timecode days component.
    ///
    /// Valid only if ``upperLimit-swift.property`` is set to `.max100Days`.
    ///
    /// Setting this value directly does not trigger any validation.
    public var days: Int {
        get { components.days }
        set { components.days = newValue }
    }
    
    /// Timecode hours component.
    ///
    /// Valid range: 0 ... 23.
    ///
    /// Setting this value directly does not trigger any validation.
    public var hours: Int {
        get { components.hours }
        set { components.hours = newValue }
    }
    
    /// Timecode minutes component.
    ///
    /// Valid range: 0 ... 59.
    ///
    /// Setting this value directly does not trigger any validation.
    public var minutes: Int {
        get { components.minutes }
        set { components.minutes = newValue }
    }
    
    /// Timecode seconds component.
    ///
    /// Valid range: 0 ... 59.
    ///
    /// Setting this value directly does not trigger any validation.
    public var seconds: Int {
        get { components.seconds }
        set { components.seconds = newValue }
    }
    
    /// Timecode frames component.
    ///
    /// Valid range is dependent on the `frameRate` property.
    ///
    /// Setting this value directly does not trigger any validation.
    public var frames: Int {
        get { components.frames }
        set { components.frames = newValue }
    }
    
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
    public var subFrames: Int {
        get { components.subFrames }
        set { components.subFrames = newValue }
    }
    
    // MARK: - Properties
    
    /// Timecode properties.
    /// (This property store makes it convenient to port around relevant timecode attributes to
    /// other Timecode initializers or methods.)
    public var properties: Properties
    
    /// Frame rate.
    ///
    /// - Note: Several properties are available on the frame rate that is selected, including its
    /// ``stringValue(format:)`` representation or whether the rate ``TimecodeFrameRate/isDrop``.
    ///
    /// - Note: Setting this value directly does not trigger any validation.
    public var frameRate: TimecodeFrameRate {
        get { properties.frameRate }
        set { properties.frameRate = newValue }
    }
    
    /// Subframes base (divisor).
    ///
    /// The number of subframes that make up a single frame.
    ///
    /// (ie: a divisor of 80 subframes per frame implies a visible value range of 00...79)
    ///
    /// This will vary depending on application. Most common divisors are 80 or 100.
    ///
    /// - Note: Setting this value directly does not trigger any validation.
    public var subFramesBase: SubFramesBase {
        get { properties.subFramesBase }
        set { properties.subFramesBase = newValue }
    }
    
    /// Timecode maximum upper bound.
    ///
    /// This also affects how timecode values wrap when adding or clamping.
    ///
    /// - Note: Setting this value directly does not trigger any validation.
    public var upperLimit: UpperLimit {
        get { properties.upperLimit }
        set { properties.upperLimit = newValue }
    }
    
    // Just to disable synthesized init
    private init() {
        properties = Properties(rate: .fps24)
    }
}
