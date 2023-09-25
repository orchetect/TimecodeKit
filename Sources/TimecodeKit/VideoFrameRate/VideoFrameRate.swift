//
//  VideoFrameRate.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Industry-standard video frame rates.
/// Certain rates may be progressive or interleaved.
///
/// Timecode is way of encoding a frame number, therefore _timecode frame rate_ may be independent of _video frame rate_.
///
/// For example, 24p video typically uses 24 fps timecode rate.
/// However, 29.97p video (30/1.001) may use 29.97 or 29.97-drop fps timecode rate depending on post-production facility requirements.
///
/// Some video rates may correspond (or generally be compatible with) certain timecode rates and vice-versa.
/// To return a video rate's corresponding timecode rate, see ``timecodeFrameRate(drop:)``.
///
/// ## Supported Timecode (Display) Frame Rates
///
/// - `_23_976`
/// - `_24`
/// - `_24_98`
/// - `_25`
/// - `_29_97`
/// - `_29_97_drop`
/// - `_30`
/// - `_30_drop`
/// - `_47_952`
/// - `_48`
/// - `_50`
/// - `_59_94`
/// - `_59_94_drop`
/// - `_60`
/// - `_60_drop`
/// - `_95_904`
/// - `_96`
/// - `_100`
/// - `_119_88`
/// - `_119_88_drop`
/// - `_120`
/// - `_120_drop`
///
/// > Note:
/// >
/// > `TimecodeFrameRate` enum cases all begin with an underscore.
/// >
/// > Due to a limitation of how DocC documentation renders, symbols prefixed with an underscore (`_`) will not show up in documentation as they are assumed to be private by the doc generator.
/// > This limitation may change in future DocC rendering. Therefore documentation may be limited. See inline documentation for these enum cases for more info.
///
/// ## Topics
///
/// ### String Extensions
///
/// - ``Swift/String/videoFrameRate``
public enum VideoFrameRate: String, FrameRateProtocol {
    // TODO: Seen in professional gear: 1, 2, 3, 4, 5, 6, 8, 10, 12, 12.5, 14.98, 15, 20
    // TODO: Triple rates seen in professional gear: 71.9928, 72, 75, 89.91, 90
    // TODO: Adobe Premiere offers 10, 12, 12.5 and 15.
    
    /// 23.98 fps (23.976) progressive.
    case _23_98p = "23.98p"
    
    /// 24 fps progressive.
    case _24p = "24p"
    
    /// 25 fps progressive.
    case _25p = "25p"
    
    /// 25 fps interlaced.
    /// (50 fields producing 25 frames.)
    case _25i = "25i"
    
    /// 29.97 fps progressive.
    case _29_97p = "29.97p"
    
    /// 29.97 fps interlaced.
    /// (59.94 fields producing 29.97 frames.)
    case _29_97i = "29.97i"
    
    /// 30 fps progressive.
    case _30p = "30p"
    
    /// 47.95 fps (47.952) progressive.
    ///
    /// Supported by Avid.
    case _47_95p = "47.95p"
    
    /// 48 fps progressive.
    ///
    /// Supported by Avid.
    case _48p = "48p"
    
    /// 50 fps progressive.
    case _50p = "50p"
    
    /// 50 fps interlaced.
    /// (100 fields producing 50 frames.)
    case _50i = "50i"
    
    /// 59.94 fps progressive.
    case _59_94p = "59.94p"
    
    /// 59.94 fps interlaced.
    /// (119.88 fields producing 59.94 frames.)
    case _59_94i = "59.94i"
    
    /// 60 fps progressive.
    case _60p = "60p"
    
    /// 60 fps interlaced.
    /// (120 fields producing 60 frames.)
    case _60i = "60i"
    
    /// 95.9 fps (95.904) progressive.
    case _95_9p = "95.9p"
    
    /// 96 fps progressive.
    case _96p = "96p"
    
    /// 100 fps progressive.
    ///
    /// Supported by Avid. (Not qualified for smooth playback)
    case _100p = "100p"
    
    /// 119.88 fps progressive.
    ///
    /// Supported by Avid. (Not qualified for smooth playback)
    case _119_88p = "119.88p"
    
    /// 120 fps progressive.
    ///
    /// Supported by Avid. (Not qualified for smooth playback)
    case _120p = "120p"
}

extension VideoFrameRate: CaseIterable { }

extension VideoFrameRate: CustomStringConvertible {
    public var description: String {
        stringValue
    }
}

extension VideoFrameRate: Codable { }

@available(macOS 10.15, macCatalyst 13, iOS 11, *)
extension VideoFrameRate: Identifiable {
    public var id: String {
        rawValue
    }
}
