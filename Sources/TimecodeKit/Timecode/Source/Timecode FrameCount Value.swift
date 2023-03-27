//
//  Timecode FrameCount Value.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - TimecodeSource

extension Timecode.FrameCount.Value: TimecodeSource {
    public func set(timecode: inout Timecode) throws {
        try timecode.setTimecode(exactly: self)
    }
    
    public func set(timecode: inout Timecode, by validation: Timecode.Validation) {
        switch validation {
        case .clamping, .clampingEach:
            timecode.setTimecode(clamping: self)
        case .wrapping:
            timecode.setTimecode(wrapping: self)
        case .allowingInvalidComponents:
            timecode.setTimecode(rawValues: self)
        }
    }
}

extension TimecodeSource where Self == Timecode.FrameCount.Value {
    /// Total elapsed frames count.
    /// (Same as ``Timecode/FrameCount-swift.struct/Value-swift.enum/frames(_:)``.)
    @_disfavoredOverload
    public static func frames(_ source: Int) -> Self {
        Timecode.FrameCount.Value.frames(source)
    }
}

// MARK: - Set

extension Timecode {
    /// Set timecode from total elapsed frames ("frame number").
    ///
    /// Subframes are represented by the fractional portion of the number.
    /// Timecode is updated as long as the value passed is in valid range.
    /// (Validation is based on the frame rate and `upperLimit` property.)
    ///
    /// - Throws: ``ValidationError``
    internal mutating func setTimecode(exactly frameCountValue: FrameCount.Value) throws {
        components = try components(exactly: frameCountValue)
    }
    
    /// Set timecode from total elapsed frames ("frame number").
    ///
    /// Clamps to valid timecode.
    ///
    /// Subframes are represented by the fractional portion of the number.
    internal mutating func setTimecode(clamping source: FrameCount.Value) {
        let convertedComponents = components(rawValues: source)
        setTimecode(clamping: convertedComponents)
    }
    
    /// Set timecode from total elapsed frames ("frame number").
    ///
    /// Timecode will be wrapped around the timecode clock if out-of-bounds.
    ///
    /// Subframes are represented by the fractional portion of the number.
    internal mutating func setTimecode(wrapping source: FrameCount.Value) {
        let convertedComponents = components(rawValues: source)
        setTimecode(wrapping: convertedComponents)
    }
    
    /// Set timecode from total elapsed frames ("frame number").
    ///
    /// Allows for invalid raw values (in this case, unbounded Days component).
    ///
    /// Subframes are represented by the fractional portion of the number.
    internal mutating func setTimecode(rawValues source: FrameCount.Value) {
        let convertedComponents = components(rawValues: source)
        setTimecode(rawValues: convertedComponents)
    }
    
    // MARK: Helper Methods
    
    /// Internal:
    /// Returns frame count value converted to components using the instance's
    /// frame rate and subframes base.
    ///
    /// - Throws: ``ValidationError``
    internal func components(exactly source: FrameCount.Value) throws -> Components {
        let fc = FrameCount(source, base: properties.subFramesBase)
        
        guard fc.subFrameCount >= 0,
              fc <= maxFrameCountExpressible
        else { throw ValidationError.outOfBounds }
        
        return Self.components(
            of: fc,
            at: properties.frameRate
        )
    }
    
    /// Internal:
    /// Returns frame count value converted to components using the instance's
    /// frame rate and subframes base.
    internal func components(rawValues source: FrameCount.Value) -> Components {
        let fc = FrameCount(source, base: properties.subFramesBase)
        
        return Self.components(
            of: fc,
            at: properties.frameRate
        )
    }
}
