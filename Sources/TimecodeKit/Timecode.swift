//
//  Timecode.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//

/// Value type representing SMPTE timecode.
///
/// - A variety of initializers and utility methods are available for string and numeric representation, validation, conversion
/// - Global mathematical operators to perform calculations: `+`, `-`, `*`, `\`
/// - Instances can be compared (`==`, `!=`, `<`, `>`)
/// - `Range` and `Stride` can be formed between two instances
public struct Timecode: Codable {
    
    // MARK: - Immutable properties
    
    /// Frame rate.
    ///
    /// Note: Several properties are available on the frame rate that is selected, including its `.stringValue` representation or whether the rate `.isDrop`.
    ///
    /// Setting this value directly does not trigger any validation.
    public let frameRate: FrameRate
    
    /// Timecode maximum upper bound.
    ///
    /// This also affects how timecode values wrap when adding or clamping.
    ///
    /// Setting this value directly does not trigger any validation.
    public let upperLimit: UpperLimit
    
    /// Subframes divisor.
    ///
    /// The number of subframes that make up a single frame.
    ///
    /// (ie: a divisor of 80 subframes per frame implies a visible value range of 00...79)
    ///
    /// This will vary depending on application. Most common divisors are 80 or 100.
    public let subFramesDivisor: Int
    
    /// Determines whether subframes are included when getting `.stringValue`.
    ///
    /// This does not disable subframes from being stored or calculated, only whether they are output in the string.
    public var displaySubFrames: Bool = false
    
    // MARK: - Mutable properties
    
    /// Timecode days.
    ///
    /// Valid only if `.upperLimit` is set to `._100days`.
    ///
    /// Setting this value directly does not trigger any validation.
    public var days: Int = 0
    
    /// Timecode hours.
    ///
    /// Valid range: 0-23.
    ///
    /// Setting this value directly does not trigger any validation.
    public var hours: Int = 0
    
    /// Timecode minutes.
    ///
    /// Valid range: 0-59.
    ///
    /// Setting this value directly does not trigger any validation.
    public var minutes: Int = 0
    
    /// Timecode seconds.
    ///
    /// Valid range: 0-59.
    ///
    /// Setting this value directly does not trigger any validation.
    public var seconds: Int = 0
    
    /// Timecode frames.
    ///
    /// Valid range is dependent on the `frameRate` property (0-23 for 24NDF, 0-29 for 30NDF, 2-29 every minute except 0-29 for every 10th minute for 29.97DF, etc.).
    ///
    /// Setting this value directly does not trigger any validation.
    public var frames: Int = 0
    
    /// Timecode subframe component.
    ///
    /// (ie: traditionally Cubase/Nuendo and Logic Pro use 80 subframes per frame, Pro Tools uses 100 subframes, etc.)
    ///
    /// Setting this value directly does not trigger any validation.
    public var subFrames: Int = 0
    
}
