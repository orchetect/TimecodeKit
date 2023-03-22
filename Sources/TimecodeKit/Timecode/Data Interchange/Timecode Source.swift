//
//  Timecode Source.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2023 Steffan Andrews • Licensed under MIT License
//

import Foundation

//protocol TimecodeValue {
//    func convertToComponents(
//        using properties: Timecode.Properties
//    ) throws -> Timecode.Components
//
//    func convertToComponents(
//        using properties: Timecode.Properties,
//        by validation: Timecode.Validation
//    ) -> Timecode.Components
//}

extension Timecode {
    /// Source value that can be converted to ``Timecode``.
    public enum Source {
        case components(Timecode.Components)
        case component(Timecode.Component, Int)
        case frameCount(FrameCount)
        case frameCountValue(FrameCount.Value)
        case rational(Fraction)
        case realTime(TimeInterval)
        case samples(Int, sampleRate: Int)
        case samplesFloat(Double, sampleRate: Int)
        case string(String)
        case feetAndFrames(FeetAndFrames)
    }
}

extension Timecode.Source {
    /// An individual time attribute of a time range.
    public enum RangeAttribute {
        case start
        case end
        case duration
    }
}

extension Timecode.Source {
    public static func components(d: Int = 0, h: Int, m: Int, s: Int, f: Int, sf: Int = 0) -> Self {
        .components(Timecode.Components(d: d, h: h, m: m, s: s, f: f, sf: sf))
    }
    
    public static func frames(_ frames: Int) -> Self {
        .frameCountValue(.frames(frames))
    }
    
    public static var zero: Self {
        .components(.zero)
    }
}

// TODO: deal with these
//extension Timecode.Source {
//    public static func avAsset(AVAsset, RangeAttribute) -> Self
//    public static func cmTime(CMTime, RangeAttribute) -> Self
//}

