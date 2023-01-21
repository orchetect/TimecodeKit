//
//  Timecode Rational.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension Timecode {
    /// Instance from elapsed time expressed as a rational fraction.
    ///
    /// - Note: Some file formats encode video frame rate and/or time locations (timecode) in
    /// rational number notation: a fraction of two whole number integers. (AAF encodes video rate
    /// this way, whereas FCPXML (Final Cut Pro) encodes both video rate and time locations as
    /// fractions.)
    ///
    /// - Note: A negative fraction will throw an error. Use ``TimecodeInterval`` init instead.
    ///
    /// - Throws: ``ValidationError``
    public init(
        _ rational: Fraction,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        frameRate = rate
        upperLimit = limit
        subFramesBase = base
        stringFormat = format
        
        try setTimecode(rational)
    }
    
    /// Instance from elapsed time expressed as a rational fraction, clamping to valid timecode if
    /// necessary.
    ///
    /// - Note: Some file formats encode video frame rate and/or time locations (timecode) in
    /// rational number notation: a fraction of two whole number integers. (AAF encodes video rate
    /// this way, whereas FCPXML (Final Cut Pro) encodes both video rate and time locations as
    /// fractions.)
    public init(
        clamping rational: Fraction,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        frameRate = rate
        upperLimit = limit
        subFramesBase = base
        stringFormat = format
        
        setTimecode(clamping: rational)
    }
    
    /// Instance from elapsed time expressed as a rational fraction, wrapping timecode if necessary.
    ///
    /// - Note: Some file formats encode video frame rate and/or time locations (timecode) in
    /// rational number notation: a fraction of two whole number integers. (AAF encodes video rate
    /// this way, whereas FCPXML (Final Cut Pro) encodes both video rate and time locations as
    /// fractions.)
    public init(
        wrapping rational: Fraction,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        frameRate = rate
        upperLimit = limit
        subFramesBase = base
        stringFormat = format
        
        setTimecode(wrapping: rational)
    }
    
    /// Instance from elapsed time expressed as a rational fraction.
    ///
    /// Allows for invalid raw values (in this case, unbounded Days component).
    ///
    /// - Note: Some file formats encode video frame rate and/or time locations (timecode) in
    /// rational number notation: a fraction of two whole number integers. (AAF encodes video rate
    /// this way, whereas FCPXML (Final Cut Pro) encodes both video rate and time locations as
    /// fractions.)
    public init(
        rawValues rational: Fraction,
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) {
        frameRate = rate
        upperLimit = limit
        subFramesBase = base
        stringFormat = format
        
        setTimecode(rawValues: rational)
    }
}

// MARK: - Get and Set

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
    public mutating func setTimecode(_ rational: Fraction) throws {
        let frameCount = floatingFrameCount(of: rational)
        try setTimecode(exactly: .combined(frames: frameCount))
    }
    
    /// Sets the timecode from elapsed time expressed as a rational fraction.
    ///
    /// Clamps to valid timecode.
    ///
    /// - Note: Some file formats encode video frame rate and/or time locations (timecode) in
    /// rational number notation: a fraction of two whole number integers. (AAF encodes video rate
    /// this way, whereas FCPXML (Final Cut Pro) encodes both video rate and time locations as
    /// fractions.)
    public mutating func setTimecode(clamping rational: Fraction) {
        let frameCount = frameCount(of: rational)
        setTimecode(clamping: .frames(frameCount))
    }
    
    /// Sets the timecode from elapsed time expressed as a rational fraction.
    ///
    /// Wraps timecode if necessary.
    ///
    /// - Note: Some file formats encode video frame rate and/or time locations (timecode) in
    /// rational number notation: a fraction of two whole number integers. (AAF encodes video rate
    /// this way, whereas FCPXML (Final Cut Pro) encodes both video rate and time locations as
    /// fractions.)
    public mutating func setTimecode(wrapping rational: Fraction) {
        let frameCount = frameCount(of: rational)
        setTimecode(wrapping: .frames(frameCount))
    }
    
    /// Sets the timecode from elapsed time expressed as a rational fraction.
    ///
    /// Allows for invalid raw values (in this case, unbounded Days component).
    ///
    /// - Note: Some file formats encode video frame rate and/or time locations (timecode) in
    /// rational number notation: a fraction of two whole number integers. (AAF encodes video rate
    /// this way, whereas FCPXML (Final Cut Pro) encodes both video rate and time locations as
    /// fractions.)
    public mutating func setTimecode(rawValues rational: Fraction) {
        let frameCount = frameCount(of: rational)
        setTimecode(rawValues: .frames(frameCount))
    }
    
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

extension Fraction {
    /// Convenience method to create an `Timecode` struct using the default
    /// `(_ exactly:)` initializer.
    ///
    /// - Note: Some file formats encode video frame rate and/or time locations (timecode) in
    /// rational number notation: a fraction of two whole number integers. (AAF encodes video rate
    /// this way, whereas FCPXML (Final Cut Pro) encodes both video rate and time locations as
    /// fractions.)
    ///
    /// - Note: A negative fraction will throw an error. Use ``TimecodeInterval`` init instead.
    ///
    /// - Throws: ``Timecode/ValidationError``
    public func toTimecode(
        at rate: TimecodeFrameRate,
        limit: Timecode.UpperLimit = ._24hours,
        base: Timecode.SubFramesBase = .default(),
        format: Timecode.StringFormat = .default()
    ) throws -> Timecode {
        try Timecode(
            self,
            at: rate,
            limit: limit,
            base: base,
            format: format
        )
    }
}
