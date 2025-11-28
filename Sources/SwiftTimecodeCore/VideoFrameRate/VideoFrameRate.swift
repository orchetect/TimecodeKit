//
//  VideoFrameRate.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Industry-standard video frame rates.
/// Certain rates may be progressive or interleaved.
///
/// Timecode is way of encoding a frame number, therefore _timecode frame rate_ may be independent of _video frame rate_.
///
/// Part of common confusion with timecode can arise from the use of “frames per second” in both the timecode and the actual video frame
/// rate. When used to describe timecode, frames per second represents how many frames of timecode are counted before one second of timecode
/// increments. When describing video frame rates, frames per second represents how many literal video frames are played back during the
/// span of one second of real wall-clock time.
///
/// For example, 24p video typically uses 24 fps timecode rate.
/// However, 29.97p video may use 29.97 fps or 29.97-drop fps timecode rate depending on post-production facility requirements, and
/// timecode at these rates do not match wall-clock time exactly.
///
/// Some video rates may correspond (or generally be compatible with) certain timecode rates and vice-versa.
/// To return a video rate's corresponding timecode rate, see ``timecodeFrameRate(drop:)``.
///
/// ## Topics
///
/// ### Rates
///
/// - ``fps23_98p``
/// - ``fps24p``
/// - ``fps25p``
/// - ``fps25i``
/// - ``fps29_97p``
/// - ``fps29_97i``
/// - ``fps30p``
/// - ``fps47_95p``
/// - ``fps48p``
/// - ``fps50p``
/// - ``fps50i``
/// - ``fps59_94p``
/// - ``fps59_94i``
/// - ``fps60p``
/// - ``fps60i``
/// - ``fps90p``
/// - ``fps95_9p``
/// - ``fps96p``
/// - ``fps100p``
/// - ``fps119_88p``
/// - ``fps120p``
///
/// ### String Extensions
///
/// - ``Swift/String/videoFrameRate``
///
public enum VideoFrameRate: String, FrameRateProtocol {
    // TODO: Seen in professional gear: 1, 2, 3, 4, 5, 6, 8, 10, 12, 12.5, 14.98, 15, 20
    // TODO: Triple rates seen in professional gear: 71.9928, 72, 75, 89.91
    // TODO: Adobe Premiere offers 10, 12, 12.5 and 15.
    
    /// 23.98 fps (23.976) progressive.
    case fps23_98p = "23.98p"
    
    /// 24 fps progressive.
    case fps24p = "24p"
    
    /// 25 fps progressive.
    case fps25p = "25p"
    
    /// 25 fps interlaced.
    /// (50 fields producing 25 frames.)
    case fps25i = "25i"
    
    /// 29.97 fps progressive.
    case fps29_97p = "29.97p"
    
    /// 29.97 fps interlaced.
    /// (59.94 fields producing 29.97 frames.)
    case fps29_97i = "29.97i"
    
    /// 30 fps progressive.
    case fps30p = "30p"
    
    /// 47.95 fps (47.952) progressive.
    ///
    /// Supported by Avid.
    case fps47_95p = "47.95p"
    
    /// 48 fps progressive.
    ///
    /// Supported by Avid.
    case fps48p = "48p"
    
    /// 50 fps progressive.
    case fps50p = "50p"
    
    /// 50 fps interlaced.
    /// (100 fields producing 50 frames.)
    case fps50i = "50i"
    
    /// 59.94 fps progressive.
    case fps59_94p = "59.94p"
    
    /// 59.94 fps interlaced.
    /// (119.88 fields producing 59.94 frames.)
    case fps59_94i = "59.94i"
    
    /// 60 fps progressive.
    case fps60p = "60p"
    
    /// 60 fps interlaced.
    /// (120 fields producing 60 frames.)
    case fps60i = "60i"
    
    /// 90 fps progressive.
    case fps90p = "90p"
    
    /// 95.9 fps (95.904) progressive.
    case fps95_9p = "95.9p"
    
    /// 96 fps progressive.
    case fps96p = "96p"
    
    /// 100 fps progressive.
    ///
    /// Supported by Avid. (Not qualified for smooth playback.)
    case fps100p = "100p"
    
    /// 119.88 fps progressive.
    ///
    /// Supported by Avid. (Not qualified for smooth playback.)
    case fps119_88p = "119.88p"
    
    /// 120 fps progressive.
    ///
    /// Supported by Avid. (Not qualified for smooth playback.)
    case fps120p = "120p"
}

extension VideoFrameRate: CaseIterable { }

extension VideoFrameRate: CustomStringConvertible {
    public var description: String {
        stringValue
    }
}

extension VideoFrameRate: Sendable { }

extension VideoFrameRate: Codable { }

@available(macOS 10.15, macCatalyst 13, iOS 11, tvOS 11, watchOS 6, *)
extension VideoFrameRate: Identifiable {
    public var id: Self { self }
}
