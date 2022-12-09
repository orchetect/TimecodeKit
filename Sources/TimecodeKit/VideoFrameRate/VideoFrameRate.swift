//
//  VideoFrameRate.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Industry-standard video frame rates.
public enum VideoFrameRate {
    // TODO: Adobe Premiere offers 10, 12, 12.5 and 15 as well.
    
    /// 23.98 fps (23.976) progressive.
    case _23_98p
    
    /// 24 fps progressive.
    case _24p
    
    /// 25 fps progressive.
    case _25p
    
    /// 25 fps interlaced.
    /// (50 fields producing 25 frames.)
    case _25i
    
    /// 29.97 fps progressive.
    case _29_97p
    
    /// 29.97 fps interlaced.
    /// (59.94 fields producing 29.97 frames.)
    case _29_97i
    
    /// 30 fps progressive.
    case _30p
    
    /// 50 fps progressive.
    case _50p
    
    /// 50 fps interlaced.
    /// (100 fields producing 50 frames.)
    case _50i
    
    /// 59.94 fps progressive.
    case _59_94p
    
    /// 60 fps progressive.
    case _60p
    
    /// 60 fps interlaced.
    /// (120 fields producing 60 frames.)
    case _60i
}

extension VideoFrameRate {
    /// Returns the corresponding ``Timecode``.``Timecode/FrameRate-swift.enum`` case.
    ///
    /// - Parameters:
    ///   - drop: Whether timecode frame rate is drop or non-drop.
    public func timecodeFrameRate(drop: Bool) -> Timecode.FrameRate? {
        switch self {
        case ._23_98p: return drop ? nil          : ._23_976
        case ._24p:    return drop ? nil          : ._24
        case ._25p:    return drop ? nil          : ._25
        case ._25i:    return drop ? nil          : ._25
        case ._29_97p: return drop ? ._29_97_drop : ._29_97
        case ._29_97i: return drop ? ._29_97_drop : ._29_97
        case ._30p:    return drop ? ._30_drop    : ._30
        case ._50p:    return drop ? nil          : ._50
        case ._50i:    return drop ? nil          : ._50
        case ._59_94p: return drop ? ._59_94_drop : ._59_94
        case ._60p:    return drop ? ._60_drop    : ._60
        case ._60i:    return drop ? nil          : ._60
        }
    }
    
    /// Returns the duration of 1 frame as a rational number (fraction).
    ///
    /// - Note: Since drop rate is not embeddable in a fraction, the ``isDrop`` flag must be
    /// preserved whenever this information is encoded elsewhere.
    ///
    /// - Note: Compatible with FCP XML v1.6 - 1.9.
    ///         Potentially compatible outside of that range but untested.
    public var rationalFrameDuration: (numerator: Int, denominator: Int) {
        switch self {
        case ._23_98p: return (numerator: 1001, denominator: 24000) // confirmed in FCP XML
        case ._24p:    return (numerator: 100,  denominator: 2400)  // confirmed in FCP XML
        case ._25p:    return (numerator: 100,  denominator: 2500)  // confirmed in FCP XML
        case ._25i:    return (numerator: 200,  denominator: 5000)  // confirmed in FCP XML
        case ._29_97p: return (numerator: 1001, denominator: 30000) // confirmed in FCP XML
        case ._29_97i: return (numerator: 2002, denominator: 60000) // confirmed in FCP XML
        case ._30p:    return (numerator: 100,  denominator: 3000)  // confirmed in FCP XML
        case ._50p:    return (numerator: 100,  denominator: 5000)  // confirmed in FCP XML
        case ._50i:    return (numerator: 200,  denominator: 10000) // inferred
        case ._59_94p: return (numerator: 1001, denominator: 60000) // confirmed in FCP XML
        case ._60p:    return (numerator: 100,  denominator: 6000)  // confirmed in FCP XML
        case ._60i:    return (numerator: 200,  denominator: 12000) // inferred
        }
    }
}

#if canImport(CoreMedia)
import CoreMedia

extension VideoFrameRate {
    /// Returns the duration of 1 frame as a rational number (fraction)
    /// as a CoreMedia `CMTime` instance.
    @available(macOS 10.7, iOS 4.0, tvOS 9.0, watchOS 6.0, *)
    public var rationalFrameDurationCMTime: CMTime {
        CMTime(
            value: CMTimeValue(rationalFrameDuration.numerator),
            timescale: CMTimeScale(rationalFrameDuration.denominator)
        )
    }
}
#endif
