//
//  FrameCount.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//

import Foundation
@_implementationOnly import OTCore

extension Timecode {
    
    /// Box describing a total elapsed frame count.
    public enum FrameCount {
        
        /// Total elapsed whole frames. Subframes = 0.
        case frames(Int)
        
        /// Total elapsed whole frames, and subframes.
        case split(frames: Int, subFrames: Int)
        
        /// Total elapsed frames, expressed as a `Double` where the integer portion is whole frames and the fractional portion is the subframes unit interval.
        case combined(frames: Double)
        
        /// Total elapsed whole frames, and subframes expressed as a floating-point unit interval (`0.0..<1.0`).
        case splitUnitInterval(frames: Int, subFramesUnitInterval: Double)
        
        // MARK: - Properties
        
        /// Total elapsed frame count, excluding subframes.
        public var wholeFrames: Int {
            
            switch self {
            case .frames(let frames):
                return frames
                
            case .split(let frames, _):
                return frames
                
            case .combined(let double):
                return Int(double.integral)
            
            case .splitUnitInterval(let frames, _):
                return frames
            }
            
        }
        
        /// Returns the subframes number.
        public func subFrames(usingSubFramesDivisor: Int) -> Int {
            
            switch self {
            case .frames(_):
                // usingSubFramesDivisor is unused
                return 0
                
            case .split(_, let subFrames):
                // usingSubFramesDivisor is unused
                return subFrames
                
            case .combined(_):
                let dec = decimalValue(usingSubFramesDivisor: usingSubFramesDivisor)
                let calc = dec.fraction * Decimal(usingSubFramesDivisor)
                
                return Int(truncating: calc as NSDecimalNumber)
                
            case .splitUnitInterval(_, let subFramesUnitInterval):
                return Int(subFramesUnitInterval * Double(usingSubFramesDivisor))
            }
            
        }
        
        /// Total elapsed frame count expressed as a `Double` where the integer portion is whole frames and the fractional portion is the subframes unit interval.
        public func doubleValue(usingSubFramesDivisor: Int) -> Double {
            
            switch self {
            case .frames(let frames):
                return Double(frames)
                
            case .split(let frames, let subFrames):
                return Double(frames) + (Double(subFrames) / Double(usingSubFramesDivisor))
                
            case .combined(let double):
                return double
                
            case .splitUnitInterval(let frames, let subFramesUnitInterval):
                return Double(frames) + subFramesUnitInterval
            }
            
        }
        
        /// Total elapsed frame count expressed as a `Decimal` where the integer portion is whole frames and the fractional portion is the subframes unit interval.
        public func decimalValue(usingSubFramesDivisor: Int) -> Decimal {
            
            switch self {
            case .frames(let frames):
                return Decimal(frames)
                
            case .split(let frames, let subFrames):
                return Decimal(frames) + (Decimal(subFrames) / Decimal(usingSubFramesDivisor))
                
            case .combined(let double):
                return Decimal(double).truncated(decimalPlaces: 8)
                
            case .splitUnitInterval(let frames, let subFramesUnitInterval):
                return Decimal(frames) + Decimal(subFramesUnitInterval)
            }
            
        }
        
    }
    
}

extension Timecode.FrameCount {
    
    @usableFromInline
    internal init(totalElapsedSubFrames: Int,
                  usingSubFramesDivisor: Int) {
        
        let converted = Timecode.subFramesToFrames(
            totalSubFrames: totalElapsedSubFrames,
            subFramesDivisor: usingSubFramesDivisor
        )
        
        self = .split(frames: converted.frames,
                      subFrames: converted.subFrames)
        
    }
    
}

extension Timecode.FrameCount: Equatable, Hashable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        
        // the particular subFramesDivisor used is not important as long as it's large enough
        let sfd = 1000
        
        return lhs.totalSubFrames(usingSubFramesDivisor: sfd) == rhs.totalSubFrames(usingSubFramesDivisor: sfd)
        
    }
    
    public func hash(into hasher: inout Hasher) {
        
        // the particular subFramesDivisor used is not important as long as it's large enough
        let sfd = 1000
        
        hasher.combine(doubleValue(usingSubFramesDivisor: sfd))
        
    }
    
}

extension Timecode.FrameCount: Comparable {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        
        // the particular subFramesDivisor used is not important as long as it's large enough
        let sfd = 1000
        
        return lhs.totalSubFrames(usingSubFramesDivisor: sfd) < rhs.totalSubFrames(usingSubFramesDivisor: sfd)
        
    }
    
    public static func > (lhs: Self, rhs: Self) -> Bool {
        
        // the particular subFramesDivisor used is not important as long as it's large enough
        let sfd = 1000
        
        return lhs.totalSubFrames(usingSubFramesDivisor: sfd) > rhs.totalSubFrames(usingSubFramesDivisor: sfd)
        
    }
    
}

extension Timecode.FrameCount {
    
    public func adding(_ other: Self, usingSubFramesDivisor: Int) -> Self {
        
        let lhsTotalSubFrames = totalSubFrames(usingSubFramesDivisor: usingSubFramesDivisor)
        
        let rhsTotalSubFrames = other.totalSubFrames(usingSubFramesDivisor: usingSubFramesDivisor)
        
        let resultTotalSubframes = lhsTotalSubFrames + rhsTotalSubFrames
        
        let newFrames = Timecode.subFramesToFrames(totalSubFrames: resultTotalSubframes,
                                                   subFramesDivisor: usingSubFramesDivisor)
        
        return .split(frames: newFrames.frames, subFrames: newFrames.subFrames)
        
    }
    
    public func subtracting(_ other: Self, usingSubFramesDivisor: Int) -> Self {
        
        let lhsTotalSubFrames = totalSubFrames(usingSubFramesDivisor: usingSubFramesDivisor)
        
        let rhsTotalSubFrames = other.totalSubFrames(usingSubFramesDivisor: usingSubFramesDivisor)
        
        let resultTotalSubframes = lhsTotalSubFrames - rhsTotalSubFrames
        
        let newFrames = Timecode.subFramesToFrames(totalSubFrames: resultTotalSubframes,
                                                   subFramesDivisor: usingSubFramesDivisor)
        
        return .split(frames: newFrames.frames, subFrames: newFrames.subFrames)
        
    }
    
    public func multiplying(by other: Self, usingSubFramesDivisor: Int) -> Self {
        
        let lhsTotalSubFrames = totalSubFrames(usingSubFramesDivisor: usingSubFramesDivisor)
        
        let rhsTotalSubFrames = other.totalSubFrames(usingSubFramesDivisor: usingSubFramesDivisor)
        
        let resultTotalSubframes = lhsTotalSubFrames * rhsTotalSubFrames
        
        let newFrames = Timecode.subFramesToFrames(totalSubFrames: resultTotalSubframes,
                                                   subFramesDivisor: usingSubFramesDivisor)
        
        return .split(frames: newFrames.frames, subFrames: newFrames.subFrames)
        
    }
    
    public func dividing(by other: Self, usingSubFramesDivisor: Int) -> Self {
        
        let lhsTotalSubFrames = totalSubFrames(usingSubFramesDivisor: usingSubFramesDivisor)
        
        let rhsTotalSubFrames = other.totalSubFrames(usingSubFramesDivisor: usingSubFramesDivisor)
        
        let resultTotalSubframes = lhsTotalSubFrames / rhsTotalSubFrames
        
        let newFrames = Timecode.subFramesToFrames(totalSubFrames: resultTotalSubframes,
                                                   subFramesDivisor: usingSubFramesDivisor)
        
        return .split(frames: newFrames.frames, subFrames: newFrames.subFrames)
        
    }
    
}


extension Timecode.FrameCount {
    
    /// Internal utility
    internal func totalSubFrames(usingSubFramesDivisor: Int) -> Int {
        
        Timecode.framesToSubFrames(
            totalFrames: wholeFrames,
            subFrames: subFrames(usingSubFramesDivisor: usingSubFramesDivisor),
            subFramesDivisor: usingSubFramesDivisor
        )
        
    }
    
}

extension Timecode {
    
    /// Internal utility
    internal static func framesToSubFrames(totalFrames: Int,
                                           subFrames: Int,
                                           subFramesDivisor: Int) -> Int {
        
        (totalFrames * subFramesDivisor) + subFrames
        
    }
    
    /// Internal utility
    internal static func subFramesToFrames(totalSubFrames: Int,
                                           subFramesDivisor: Int)
    -> (frames: Int, subFrames: Int) {
        
        let subFrames = totalSubFrames % subFramesDivisor
        let frames = (totalSubFrames - subFrames) / subFramesDivisor
        
        return (frames: frames, subFrames: subFrames)
        
    }
    
}
