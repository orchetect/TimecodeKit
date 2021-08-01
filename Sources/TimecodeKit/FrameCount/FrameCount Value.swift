//
//  FrameCount Value.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//

extension Timecode.FrameCount {
    
    public enum Value {
        
        /// Total elapsed whole frames. Subframes = 0.
        case frames(Int)
        
        /// Total elapsed whole frames, and subframes.
        case split(frames: Int, subFrames: Int)
        
        /// Total elapsed frames, expressed as a `Double` where the integer portion is whole frames and the fractional portion is the subframes unit interval.
        case combined(frames: Double)
        
        /// Total elapsed whole frames, and subframes expressed as a floating-point unit interval (`0.0..<1.0`).
        case splitUnitInterval(frames: Int, subFramesUnitInterval: Double)
        
    }
    
}

extension Timecode.FrameCount.Value: Equatable, Hashable {
    
}

extension Timecode.FrameCount.Value: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
        case .frames(let frames):
            return "\(frames) frames"
            
        case .split(frames: let frames, subFrames: let subFrames):
            return "\(frames).\(subFrames) frames"
            
        case .combined(frames: let frames):
            return "\(frames) frames"
            
        case .splitUnitInterval(frames: let frames, subFramesUnitInterval: let subFramesUnitInterval):
            return "\(Double(frames) + subFramesUnitInterval) frames"
            
        }
        
    }
    
}

extension Timecode.FrameCount.Value: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        
        switch self {
        case .frames(let frames):
            return ".frames(\(frames))"
            
        case .split(frames: let frames, subFrames: let subFrames):
            return ".split(frames: \(frames), subFrames: \(subFrames))"
            
        case .combined(frames: let frames):
            return ".combined(\(frames))"
            
        case .splitUnitInterval(frames: let frames, subFramesUnitInterval: let subFramesUnitInterval):
            return ".splitUnitInterval(frames: \(frames), subFramesUnitInterval: \(subFramesUnitInterval))"
            
        }
        
    }
    
}
