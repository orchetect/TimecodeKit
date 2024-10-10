//
//  FrameCount.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension Timecode {
    /// Box describing a total elapsed frame count.
    public struct FrameCount {
        // MARK: - Public properties
        
        public var value: Value
        
        public let subFramesBase: SubFramesBase
        
        // MARK: - Inits
        
        public init(_ value: Value, base: SubFramesBase) {
            self.value = value
            subFramesBase = base
        }
        
        // MARK: - Public computed properties
        
        /// Total elapsed frame count, excluding subframes.
        public var wholeFrames: Int {
            switch value {
            case let .frames(frames):
                frames
                
            case let .split(frames, _):
                frames
                
            case let .combined(double):
                Int(double.integral)
                
            case let .splitUnitInterval(frames, _):
                frames
            }
        }
        
        /// Returns the subframes number.
        public var subFrames: Int {
            switch value {
            case .frames:
                // subFramesBase is unused
                return 0
                
            case let .split(_, subFrames):
                // subFramesBase is unused
                return subFrames
                
            case .combined:
                let dec = decimalValue
                let calc = dec.fraction * Decimal(subFramesBase.rawValue)
                
                return Int(truncating: calc as NSDecimalNumber)
                
            case let .splitUnitInterval(_, subFramesUnitInterval):
                return Int(subFramesUnitInterval * Double(subFramesBase.rawValue))
            }
        }
        
        /// Total elapsed frame count expressed as a `Double` where the integer portion is whole frames and the fractional portion is the
        /// subframes unit interval.
        public var doubleValue: Double {
            switch value {
            case let .frames(frames):
                Double(frames)
                
            case let .split(frames, subFrames):
                Double(frames) + (Double(subFrames) / Double(subFramesBase.rawValue))
                
            case let .combined(double):
                double
                
            case let .splitUnitInterval(frames, subFramesUnitInterval):
                Double(frames) + subFramesUnitInterval
            }
        }
        
        /// Total elapsed frame count expressed as a `Decimal` where the integer portion is whole frames and the fractional portion is the
        /// subframes unit interval.
        public var decimalValue: Decimal {
            switch value {
            case let .frames(frames):
                Decimal(frames)
                
            case let .split(frames, subFrames):
                Decimal(frames) + (Decimal(subFrames) / Decimal(subFramesBase.rawValue))
                
            case let .combined(double):
                Decimal(double).truncated(decimalPlaces: 8)
                
            case let .splitUnitInterval(frames, subFramesUnitInterval):
                Decimal(frames) + Decimal(subFramesUnitInterval)
            }
        }
    }
}

// MARK: - Internal inits

extension Timecode.FrameCount {
    init(
        subFrameCount: Int,
        base: Timecode.SubFramesBase
    ) {
        let converted = Timecode.subFramesToFrames(
            subFrameCount,
            base: base
        )
        
        value = .split(
            frames: converted.frames,
            subFrames: converted.subFrames
        )
        subFramesBase = base
    }
}

// MARK: - Equatable / Hashable / Comparable / Identifiable / Sendable

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

@available(macOS 10.15, macCatalyst 13, iOS 11, tvOS 11, watchOS 6, *)
extension Timecode.FrameCount: Identifiable {
    public var id: Self { self }
}

extension Timecode.FrameCount: Sendable { }

extension Timecode.FrameCount: CustomStringConvertible {
    public var description: String {
        switch value {
        case let .frames(frames):
            "\(frames)"
        case .split, .combined, .splitUnitInterval:
            "\(doubleValue)"
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
        
        let newFrames = Timecode.subFramesToFrames(
            resultSubFrameCount,
            base: subFramesBase
        )
        
        return .init(
            .split(frames: newFrames.frames, subFrames: newFrames.subFrames),
            base: subFramesBase
        )
    }
    
    public func subtracting(_ other: Self) -> Self {
        let lhsTotalSubFrames = subFrameCount
        
        let rhsTotalSubFrames = other.subFrameCount
        
        let resultSubFrameCount = lhsTotalSubFrames - rhsTotalSubFrames
        
        let newFrames = Timecode.subFramesToFrames(
            resultSubFrameCount,
            base: subFramesBase
        )
        
        return .init(
            .split(frames: newFrames.frames, subFrames: newFrames.subFrames),
            base: subFramesBase
        )
    }
    
    public func multiplying(by factor: Double) -> Self {
        let lhsTotalSubFrames = subFrameCount
        
        let resultSubFrameCount = Int(Double(lhsTotalSubFrames) * factor)
        
        let newFrames = Timecode.subFramesToFrames(
            resultSubFrameCount,
            base: subFramesBase
        )
        
        return .init(
            .split(frames: newFrames.frames, subFrames: newFrames.subFrames),
            base: subFramesBase
        )
    }
    
    public func dividing(by divisor: Double) -> Self {
        let lhsTotalSubFrames = subFrameCount
        
        let resultSubFrameCount = Int(Double(lhsTotalSubFrames) / divisor)
        
        let newFrames = Timecode.subFramesToFrames(
            resultSubFrameCount,
            base: subFramesBase
        )
        
        return .init(
            .split(frames: newFrames.frames, subFrames: newFrames.subFrames),
            base: subFramesBase
        )
    }
}

extension Timecode.FrameCount {
    /// Returns `true` if the frame count is `< 0`.
    public var isNegative: Bool {
        doubleValue < 0.0
    }
    
    /// Returns `true` if frame count and subframes are `0`.
    public var isZero: Bool {
        value.isZero
    }
}

extension Timecode.FrameCount {
    var subFrameCount: Int {
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
    static func framesToSubFrames(
        frames: Int,
        subFrames: Int,
        base: SubFramesBase
    ) -> Int {
        (frames * base.rawValue) + subFrames
    }
    
    /// Internal utility
    static func subFramesToFrames(
        _ subFrames: Int,
        base: SubFramesBase
    )
    -> (frames: Int, subFrames: Int) {
        let outSubFrames = subFrames % base.rawValue
        let outFrames = (subFrames - outSubFrames) / base.rawValue
        
        return (frames: outFrames, subFrames: outSubFrames)
    }
}
