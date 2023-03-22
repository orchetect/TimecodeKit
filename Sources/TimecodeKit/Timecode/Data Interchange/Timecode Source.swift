//
//  Timecode Source.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2023 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// A protocol for timecode time value sources that do not supply their own frame
/// rate information.
public protocol TimecodeSource {
    func set(timecode: inout Timecode) throws
    func set(timecode: inout Timecode, by validation: Timecode.Validation)
}

/// A protocol for timecode time value sources that are able to supply frame rate information.
public protocol RichTimecodeSource {
    func set(
        timecode: inout Timecode,
        overriding properties: Timecode.Properties?
    ) throws -> Timecode.Properties
}

//extension Timecode {
//    /// Source value that can be converted to ``Timecode``.
//    public enum Source {
//        case components(Timecode.Components)
//        case component(Timecode.Component, Int)
//        case frameCount(FrameCount)
//        case frameCountValue(FrameCount.Value)
//        case rational(Fraction)
//        case realTime(TimeInterval)
//        case samples(Int, sampleRate: Int)
//        case samplesFloat(Double, sampleRate: Int)
//        case string(String)
//        case feetAndFrames(FeetAndFrames)
//    }
//}

//extension Timecode.Source {
    /// An individual time attribute of a time range.
    public enum RangeAttribute {
        case start
        case end
        case duration
    }
//}

// TODO: refactor into individual files
//extension Timecode.Source {
//    public static func frames(_ frames: Int) -> Self {
//        .frameCountValue(.frames(frames))
//    }
//
//    public static var zero: Self {
//        .components(.zero)
//    }
//}

//#if canImport(AVFoundation) && !os(watchOS)
//import AVFoundation
//
//// TODO: deal with these
//extension Timecode.Source {
//    public static func avAsset(AVAsset, RangeAttribute) -> Self
//    public static func cmTime(CMTime, RangeAttribute) -> Self
//}
//
//#endif
