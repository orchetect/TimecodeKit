//
//  VideoFrameRate.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Industry-standard video frame rates.
public enum VideoFrameRate: String, FrameRateProtocol {
    // TODO: Adobe Premiere offers 10, 12, 12.5 and 15 as well.
    
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
    
    /// 47.952 fps progressive.
    ///
    /// Supported by Avid.
    case _47_592p = "47.592p"
    
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
    
    /// 60 fps progressive.
    case _60p = "60p"
    
    /// 60 fps interlaced.
    /// (120 fields producing 60 frames.)
    case _60i = "60i"
    
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
