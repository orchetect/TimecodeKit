//
//  FrameCount Value.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

extension Timecode.FrameCount {
    /// Timecode total elapsed frame count value.
    public enum Value {
        /// Total elapsed whole frames. Subframes = 0.
        case frames(Int)
        
        /// Total elapsed whole frames, and subframes.
        case split(frames: Int, subFrames: Int)
        
        /// Total elapsed frames, expressed as a `Double` where the integer portion is whole frames and the fractional portion is the
        /// subframes unit interval.
        case combined(frames: Double)
        
        /// Total elapsed whole frames, and subframes expressed as a floating-point unit interval (`0.0 ..< 1.0`).
        case splitUnitInterval(frames: Int, subFramesUnitInterval: Double)
    }
}

extension Timecode.FrameCount.Value: Equatable, Hashable {
    // synthesized implementation
}

@available(macOS 10.15, macCatalyst 13, iOS 11, tvOS 11, watchOS 6, *)
extension Timecode.FrameCount.Value: Identifiable {
    public var id: Self { self }
}

extension Timecode.FrameCount.Value: Sendable { }

extension Timecode.FrameCount.Value: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .frames(frames):
            return "\(frames) frames"
            
        case let .split(frames: frames, subFrames: subFrames):
            return "\(frames).\(subFrames) frames"
            
        case let .combined(frames: frames):
            return "\(frames) frames"
            
        case let .splitUnitInterval(frames: frames, subFramesUnitInterval: subFramesUnitInterval):
            return "\(Double(frames) + subFramesUnitInterval) frames"
        }
    }
}

extension Timecode.FrameCount.Value: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case let .frames(frames):
            return ".frames(\(frames))"
            
        case let .split(frames: frames, subFrames: subFrames):
            return ".split(frames: \(frames), subFrames: \(subFrames))"
            
        case let .combined(frames: frames):
            return ".combined(\(frames))"
            
        case let .splitUnitInterval(frames: frames, subFramesUnitInterval: subFramesUnitInterval):
            return ".splitUnitInterval(frames: \(frames), subFramesUnitInterval: \(subFramesUnitInterval))"
        }
    }
}

extension Timecode.FrameCount.Value {
    /// Returns `true` if frame count and subframes are `0`.
    public var isZero: Bool {
        switch self {
        case let .frames(frames):
            return frames == 0
            
        case let .split(frames, subFrames):
            return frames == 0 && subFrames == 0
            
        case let .combined(double):
            return double.isZero
            
        case let .splitUnitInterval(frames, subFramesUnitInterval):
            return frames == 0 && subFramesUnitInterval.isZero
        }
    }
}
