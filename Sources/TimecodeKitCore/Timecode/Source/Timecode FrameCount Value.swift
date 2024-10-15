//
//  Timecode FrameCount Value.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - TimecodeSource

extension Timecode.FrameCount.Value: _TimecodeSource {
    package func set(timecode: inout Timecode) throws {
        try timecode._setTimecode(exactly: self)
    }
    
    package func set(timecode: inout Timecode, by validation: Timecode.ValidationRule) {
        switch validation {
        case .clamping, .clampingComponents:
            timecode._setTimecode(clamping: self)
        case .wrapping:
            timecode._setTimecode(wrapping: self)
        case .allowingInvalid:
            timecode._setTimecode(rawValues: self)
        }
    }
}

// MARK: - Static Constructors

extension TimecodeSourceValue {
    /// Total elapsed frames count.
    public static func frames(_ source: Timecode.FrameCount.Value) -> Self {
        .init(value: source)
    }
    
    /// Total elapsed frames count, and optional subframes count.
    /// (Same as ``Timecode/FrameCount-swift.struct/Value-swift.enum/split(frames:subFrames:)``.)
    public static func frames(_ frames: Int, subFrames: Int = 0) -> Self {
        if subFrames == 0 {
            .init(value: Timecode.FrameCount.Value.frames(frames))
        } else {
            .init(value: Timecode.FrameCount.Value.split(frames: frames, subFrames: subFrames))
        }
    }
    
    /// Total elapsed frames, expressed as a `Double` where the integer portion is whole frames and the fractional portion is the subframes
    /// unit interval.
    /// (Same as ``Timecode/FrameCount-swift.struct/Value-swift.enum/combined(frames:)``.)
    public static func frames(_ frames: Double) -> Self {
        .init(value: Timecode.FrameCount.Value.combined(frames: frames))
    }
    
    /// Total elapsed whole frames, and subframes expressed as a floating-point unit interval (`0.0..<1.0`).
    /// (Same as ``Timecode/FrameCount-swift.struct/Value-swift.enum/splitUnitInterval(frames:subFramesUnitInterval:)``.)
    public static func frames(_ frames: Int, subFramesUnitInterval: Double) -> Self {
        .init(value: Timecode.FrameCount.Value.splitUnitInterval(
            frames: frames,
            subFramesUnitInterval: subFramesUnitInterval
        ))
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
    mutating func _setTimecode(exactly frameCountValue: FrameCount.Value) throws {
        components = try components(exactly: frameCountValue)
    }
    
    /// Set timecode from total elapsed frames ("frame number").
    ///
    /// Clamps to valid timecode.
    ///
    /// Subframes are represented by the fractional portion of the number.
    mutating func _setTimecode(clamping source: FrameCount.Value) {
        let convertedComponents = components(rawValues: source)
        _setTimecode(clamping: convertedComponents)
    }
    
    /// Set timecode from total elapsed frames ("frame number").
    ///
    /// Timecode will be wrapped around the timecode clock if out-of-bounds.
    ///
    /// Subframes are represented by the fractional portion of the number.
    mutating func _setTimecode(wrapping source: FrameCount.Value) {
        let convertedComponents = components(rawValues: source)
        _setTimecode(wrapping: convertedComponents)
    }
    
    /// Set timecode from total elapsed frames ("frame number").
    ///
    /// Allows for invalid raw values (in this case, unbounded Days component).
    ///
    /// Subframes are represented by the fractional portion of the number.
    mutating func _setTimecode(rawValues source: FrameCount.Value) {
        let convertedComponents = components(rawValues: source)
        _setTimecode(rawValues: convertedComponents)
    }
    
    // MARK: Helper Methods
    
    /// Internal:
    /// Returns frame count value converted to components using the instance's
    /// frame rate and subframes base.
    ///
    /// - Throws: ``ValidationError``
    func components(exactly source: FrameCount.Value) throws -> Components {
        let fc = FrameCount(source, base: subFramesBase)
        
        guard fc.subFrameCount >= 0,
              fc <= maxFrameCountExpressible
        else { throw ValidationError.outOfBounds }
        
        return Self.components(
            of: fc,
            at: frameRate
        )
    }
    
    /// Internal:
    /// Returns frame count value converted to components using the instance's
    /// frame rate and subframes base.
    func components(rawValues source: FrameCount.Value) -> Components {
        let fc = FrameCount(source, base: subFramesBase)
        
        return Self.components(
            of: fc,
            at: frameRate
        )
    }
}
