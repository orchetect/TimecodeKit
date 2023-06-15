//
//  Timecode Rational.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - TimecodeSource

extension Fraction: TimecodeSource {
    public func set(timecode: inout Timecode) throws {
        try timecode._setTimecode(exactly: self)
    }
    
    public func set(timecode: inout Timecode, by validation: Timecode.ValidationRule) {
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

extension TimecodeSource where Self == Fraction {
    /// Numerical fraction containing a numerator and a denominator.
    public static func rational(_ source: Fraction) -> Self {
        source
    }
}

// MARK: - Get

extension Timecode {
    /// Returns the time location as a rational fraction.
    ///
    /// - Note: Some file formats encode video frame rate and/or time locations (timecode) in
    /// rational number notation: a fraction of two whole number integers. (AAF encodes video rate
    /// this way, whereas FCPXML (Final Cut Pro) encodes both video rate and time locations as
    /// fractions.)
    public var rationalValue: Fraction {
        let frFrac = frameRate.frameDuration
        let n = frFrac.numerator * frameCount.subFrameCount
        let d = frFrac.denominator * subFramesBase.rawValue
        
        return Fraction(n, d).reduced()
    }
}

// MARK: - Set

extension Timecode {
    /// Sets the timecode from elapsed time expressed as a rational fraction.
    ///
    /// - Note: Some file formats encode video frame rate and/or time locations (timecode) in
    /// rational number notation: a fraction of two whole number integers. (AAF encodes video rate
    /// this way, whereas FCPXML (Final Cut Pro) encodes both video rate and time locations as
    /// fractions.)
    ///
    /// - Note: A negative fraction will throw an error. Use ``TimecodeInterval`` init instead.
    ///
    /// - Throws: ``ValidationError``
    internal mutating func _setTimecode(exactly rational: Fraction) throws {
        let frameCount = floatingFrameCount(of: rational)
        try _setTimecode(exactly: .combined(frames: frameCount))
    }
    
    /// Sets the timecode from elapsed time expressed as a rational fraction.
    ///
    /// Clamps to valid timecode.
    ///
    /// - Note: Some file formats encode video frame rate and/or time locations (timecode) in
    /// rational number notation: a fraction of two whole number integers. (AAF encodes video rate
    /// this way, whereas FCPXML (Final Cut Pro) encodes both video rate and time locations as
    /// fractions.)
    internal mutating func _setTimecode(clamping rational: Fraction) {
        let frameCount = frameCount(of: rational)
        _setTimecode(clamping: .frames(frameCount))
    }
    
    /// Sets the timecode from elapsed time expressed as a rational fraction.
    ///
    /// Wraps timecode if necessary.
    ///
    /// - Note: Some file formats encode video frame rate and/or time locations (timecode) in
    /// rational number notation: a fraction of two whole number integers. (AAF encodes video rate
    /// this way, whereas FCPXML (Final Cut Pro) encodes both video rate and time locations as
    /// fractions.)
    internal mutating func _setTimecode(wrapping rational: Fraction) {
        let frameCount = frameCount(of: rational)
        _setTimecode(wrapping: .frames(frameCount))
    }
    
    /// Sets the timecode from elapsed time expressed as a rational fraction.
    ///
    /// Allows for invalid raw values (in this case, unbounded Days component).
    ///
    /// - Note: Some file formats encode video frame rate and/or time locations (timecode) in
    /// rational number notation: a fraction of two whole number integers. (AAF encodes video rate
    /// this way, whereas FCPXML (Final Cut Pro) encodes both video rate and time locations as
    /// fractions.)
    internal mutating func _setTimecode(rawValues rational: Fraction) {
        let frameCount = frameCount(of: rational)
        _setTimecode(rawValues: .frames(frameCount))
    }
    
    // MARK: Helper Methods
    
    /// Internal:
    /// Returns frame count of the rational fraction at current frame rate.
    /// Truncates subframes if present.
    internal func frameCount(of rational: Fraction) -> Int {
        let frFrac = frameRate.frameDuration
        let frameCount = (rational.numerator * frFrac.denominator) /
        (rational.denominator * frFrac.numerator)
        return frameCount
    }
    
    /// Internal:
    /// Returns frame count of the rational fraction at current frame rate.
    /// Preserves subframes as floating-point potion of a frame.
    internal func floatingFrameCount(of rational: Fraction) -> Double {
        let frFrac = frameRate.frameDuration
        let frameCount = (Double(rational.numerator) * Double(frFrac.denominator)) /
        (Double(rational.denominator) * Double(frFrac.numerator))
        return frameCount
    }
}
