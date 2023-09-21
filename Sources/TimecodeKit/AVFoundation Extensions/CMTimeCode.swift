//
//  CMTimeCode.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

// AVAssetReader is unavailable on watchOS so we can't support any AVAsset operations
#if canImport(AVFoundation) && !os(watchOS) && !os(xrOS)

import AVFoundation
import Foundation

protocol CMTimeCode {
    static var byteLength: Int { get }
}

extension Collection where Element == CMTimeCode {
    func mapToTimecode(
        at frameRate: TimecodeFrameRate,
        base: Timecode.SubFramesBase = .default(),
        limit: Timecode.UpperLimit = ._24Hours
    ) throws -> [Timecode] {
        let properties = Timecode.Properties(rate: frameRate, base: base, limit: limit)
        return try mapToTimecode(using: properties)
    }
    
    func mapToTimecode(
        using properties: Timecode.Properties
    ) throws -> [Timecode] {
        try compactMap { sample in
            switch sample {
            case let timecode32 as CMTimeCode32:
                return try Timecode(
                    .frames(Int(timecode32.frameNumber)),
                    using: properties
                )
            case let timecode64 as CMTimeCode64:
                let tcc = Timecode.Components(
                    h: Int(timecode64.h),
                    m: Int(timecode64.m),
                    s: Int(timecode64.s),
                    f: Int(timecode64.f)
                )
                return try Timecode(
                    .components(tcc),
                    using: properties
                )
            default:
                return nil
            }
        }
    }
}

/// `CMTimeCodeFormatType_TimeCode32` ('tmcd') Timecode Sample Data Format.
///
/// The timecode media sample data format is a big-endian signed 32-bit integer.
struct CMTimeCode32: CMTimeCode, Equatable, Hashable {
    static let byteLength = MemoryLayout<UInt32>.size
    
    var frameNumber: UInt32
    
    init(frameNumber: UInt32) {
        self.frameNumber = frameNumber
    }
}

/// The `kCMTimeCodeFormatType_TimeCode64` ('tc64') format is recommended when building AVFoundation
/// based media application, while use of the `kCMTimeCodeFormatType_TimeCode32` format should be
/// considered as a solution for applications having specific interoperability requirements with
/// older legacy QuickTime based media applications that may only support the 'tmcd' timecode sample
/// format.
///
/// A `kCMTimeCodeFormatType_TimeCode64` format media sample is stored as a Big-Endian `SInt64`.
///
/// > `CMTimeCodeFormatType_TimeCode64` ('tc64') Timecode Sample Data Format.
/// >
/// > The timecode media sample data format is a big-endian signed 64-bit integer representing a
/// > frame number that is typically converted to and from SMPTE timecodes representing hours,
/// > minutes, seconds, and frames, according to information carried in the format description.
/// >
/// > Converting to and from the frame number stored as media sample data and a CVSMPTETime
/// > structure is performed using simple modular arithmetic with the expected adjustments for drop
/// > frame timecode performed using information in the format description such as the frame quanta
/// > and the drop frame flag.
/// >
/// > The frame number value may be interpreted into a timecode value as follows:
/// >
/// > Hours
/// > A 16-bit signed integer that indicates the starting number of hours.
/// >
/// > Minutes
/// > A 16-bit signed integer that contains the starting number of minutes.
/// >
/// > Seconds
/// > A 16-bit signed integer indicating the starting number of seconds.
/// >
/// > Frames
/// > A 16-bit signed integer that specifies the starting number of frames. This field’s value
/// > cannot exceed the value of the frame quanta value in the timecode format description.
struct CMTimeCode64: CMTimeCode, Equatable, Hashable {
    static let byteLength = MemoryLayout<UInt64>.size
    
    var uInt64: UInt64
    
    init(uInt64: UInt64) {
        self.uInt64 = uInt64
    }
    
    init(h: UInt16, m: UInt16, s: UInt16, f: UInt16) {
        uInt64 = ((UInt64(h) & 0xFFFF) << 48)
            + ((UInt64(m) & 0xFFFF) << 32)
            + ((UInt64(s) & 0xFFFF) << 16)
            + (UInt64(f) & 0xFFFF)
    }
    
    var h: UInt16 { UInt16((uInt64 >> 48) & 0xFFFF) }
    var m: UInt16 { UInt16((uInt64 >> 32) & 0xFFFF) }
    var s: UInt16 { UInt16((uInt64 >> 16) & 0xFFFF) }
    var f: UInt16 { UInt16(uInt64 & 0xFFFF) }
}

#endif
