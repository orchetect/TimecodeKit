//
//  FrameCount.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//

import Foundation
@_implementationOnly import OTCore

extension Timecode {
    
    /// Box describing a total elapsed frame count.
    public struct FrameCount {
        
        // MARK: - Public properties
        
        public var value: Value
        
        public let subFramesBase: SubFramesBase
        
        // MARK: - Inits
        
        public init(_ value: Value, base: SubFramesBase) {
            self.value = value
            self.subFramesBase = base
        }
        
        // MARK: - Public computed properties
        
        /// Total elapsed frame count, excluding subframes.
        public var wholeFrames: Int {
            
            switch value {
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
        public var subFrames: Int {
            
            switch value {
            case .frames(_):
                // subFramesBase is unused
                return 0
                
            case .split(_, let subFrames):
                // subFramesBase is unused
                return subFrames
                
            case .combined(_):
                let dec = decimalValue
                let calc = dec.fraction * Decimal(subFramesBase.rawValue)
                
                return Int(truncating: calc as NSDecimalNumber)
                
            case .splitUnitInterval(_, let subFramesUnitInterval):
                return Int(subFramesUnitInterval * Double(subFramesBase.rawValue))
            }
            
        }
        
        /// Total elapsed frame count expressed as a `Double` where the integer portion is whole frames and the fractional portion is the subframes unit interval.
        public var doubleValue: Double {
            
            switch value {
            case .frames(let frames):
                return Double(frames)
                
            case .split(let frames, let subFrames):
                return Double(frames) + (Double(subFrames) / Double(subFramesBase.rawValue))
                
            case .combined(let double):
                return double
                
            case .splitUnitInterval(let frames, let subFramesUnitInterval):
                return Double(frames) + subFramesUnitInterval
            }
            
        }
        
        /// Total elapsed frame count expressed as a `Decimal` where the integer portion is whole frames and the fractional portion is the subframes unit interval.
        public var decimalValue: Decimal {
            
            switch value {
            case .frames(let frames):
                return Decimal(frames)
                
            case .split(let frames, let subFrames):
                return Decimal(frames) + (Decimal(subFrames) / Decimal(subFramesBase.rawValue))
                
            case .combined(let double):
                return Decimal(double).truncated(decimalPlaces: 8)
                
            case .splitUnitInterval(let frames, let subFramesUnitInterval):
                return Decimal(frames) + Decimal(subFramesUnitInterval)
            }
            
        }
        
    }
    
}

// MARK: - Internal inits

extension Timecode.FrameCount {
    
    @usableFromInline
    internal init(subFrameCount: Int,
                  base: Timecode.SubFramesBase) {
        
        let converted = Timecode.subFramesToFrames(
            subFrameCount,
            base: base
        )
        
        value = .split(frames: converted.frames,
                       subFrames: converted.subFrames)
        subFramesBase = base
        
    }
    
}

// MARK: - Equatable / Hashable / Comparable

extension Timecode.FrameCount: Equatable, Hashable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        
        lhs.subFrameCount == rhs.subFrameCount
        
    }
    
    public func hash(into hasher: inout Hasher) {
        
        hasher.combine(subFrameCount)
        
    }
    
}

extension Timecode.FrameCount: Comparable {
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        
        lhs.subFrameCount < rhs.subFrameCount
        
    }
    
    public static func > (lhs: Self, rhs: Self) -> Bool {
        
        lhs.subFrameCount > rhs.subFrameCount
        
    }
    
}

extension Timecode.FrameCount: CustomStringConvertible {
    
    public var description: String {
        
        switch value {
        case .frames(let frames):
            return "\(frames)"
            
        case .split, .combined, .splitUnitInterval:
            return "\(doubleValue)"
            
        }
        
    }
    
}


// MARK: - Operators

extension Timecode.FrameCount {
    
    public static func + (lhs: Self, rhs: Self) -> Self {
        
        lhs.adding(rhs)
        
    }
    
    public static func - (lhs: Self, rhs: Self) -> Self {
        
        lhs.subtracting(rhs)
        
    }
    
    public static func * (lhs: Self, rhs: Double) -> Self {
        
        lhs.multiplying(by: rhs)
        
    }
    
    public static func / (lhs: Self, rhs: Double) -> Self {
        
        lhs.dividing(by: rhs)
        
    }
    
}

// MARK: - Math

extension Timecode.FrameCount {
    
    public func adding(_ other: Self) -> Self {
        
        let lhsTotalSubFrames = subFrameCount
        
        let rhsTotalSubFrames = other.subFrameCount
        
        let resultSubFrameCount = lhsTotalSubFrames + rhsTotalSubFrames
        
        let newFrames = Timecode.subFramesToFrames(resultSubFrameCount,
                                                   base: subFramesBase)
        
        return .init(.split(frames: newFrames.frames, subFrames: newFrames.subFrames),
                     base: subFramesBase)
        
    }
    
    public func subtracting(_ other: Self) -> Self {
        
        let lhsTotalSubFrames = subFrameCount
        
        let rhsTotalSubFrames = other.subFrameCount
        
        let resultSubFrameCount = lhsTotalSubFrames - rhsTotalSubFrames
        
        let newFrames = Timecode.subFramesToFrames(resultSubFrameCount,
                                                   base: subFramesBase)
        
        return .init(.split(frames: newFrames.frames, subFrames: newFrames.subFrames),
                     base: subFramesBase)
        
    }
    
    public func multiplying(by factor: Double) -> Self {
        
        let lhsTotalSubFrames = subFrameCount
        
        let resultSubFrameCount = Int(Double(lhsTotalSubFrames) * factor)
        
        let newFrames = Timecode.subFramesToFrames(resultSubFrameCount,
                                                   base: subFramesBase)
        
        return .init(.split(frames: newFrames.frames, subFrames: newFrames.subFrames),
                     base: subFramesBase)
        
    }
    
    public func dividing(by divisor: Double) -> Self {
        
        let lhsTotalSubFrames = subFrameCount
        
        let resultSubFrameCount = Int(Double(lhsTotalSubFrames) / divisor)
        
        let newFrames = Timecode.subFramesToFrames(resultSubFrameCount,
                                                   base: subFramesBase)
        
        return .init(.split(frames: newFrames.frames, subFrames: newFrames.subFrames),
                     base: subFramesBase)
        
    }
    
}


extension Timecode.FrameCount {
    
    @usableFromInline
    internal var subFrameCount: Int {
        
        Timecode.framesToSubFrames(
            frames: wholeFrames,
            subFrames: subFrames,
            base: subFramesBase
        )
        
    }
    
}

// MARK: - Utilities

extension Timecode {
    
    /// Internal utility
    internal static func framesToSubFrames(frames: Int,
                                           subFrames: Int,
                                           base: SubFramesBase) -> Int {
        
        (frames * base.rawValue) + subFrames
        
    }
    
    /// Internal utility
    internal static func subFramesToFrames(_ subFrames: Int,
                                           base: SubFramesBase)
    -> (frames: Int, subFrames: Int) {
        
        let outSubFrames = subFrames % base.rawValue
        let outFrames = (subFrames - outSubFrames) / base.rawValue
        
        return (frames: outFrames, subFrames: outSubFrames)
        
    }
    
}
