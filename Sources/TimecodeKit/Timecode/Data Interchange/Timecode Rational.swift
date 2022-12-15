//
//  Timecode Rational.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension Timecode {
    /// Instance from elapsed time expressed as a rational fraction.
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
        
        let frFrac = rate.frameDuration
        let frameCount = (rational.numerator * frFrac.denominator) / (rational.denominator * frFrac.numerator)
        try setTimecode(exactly: .frames(frameCount))
    }
    
    // TODO: add additional inits for clamping/wrapping/rawValues
    
    /// Returns the time location as a rational fraction.
    ///
    /// Coincidentally, evaluating the fraction produces elapsed seconds.
    /// However if the goal is to produce elapsed seconds, access the
    /// ``realTimeValue`` property instead.
    public var rationalValue: Fraction {
        let frFrac = frameRate.frameDuration
        let n = frFrac.numerator * frameCount.wholeFrames
        let d = frFrac.denominator
        
        return Fraction(n, d).reduced()
    }
}
