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
        rational: (numerator: Int, denominator: Int),
        at rate: TimecodeFrameRate,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        frameRate = rate
        upperLimit = limit
        subFramesBase = base
        stringFormat = format
        
        let frFrac = rate.rationalFrameDuration
        let frameCount = (rational.numerator * frFrac.denominator) / (rational.denominator * frFrac.numerator)
        try setTimecode(exactly: .frames(frameCount))
    }
    
    // TODO: add additional inits for clamping/wrapping/rawValues
    
    /// Returns the time location as a rational fraction.
    ///
    /// Coincidentally, evaluating the fraction produces elapsed seconds.
    /// However if the goal is to produce elapsed seconds, access the
    /// ``realTimeValue`` property instead.
    public var rationalValue: (numerator: Int, denominator: Int) {
        let frFrac = frameRate.rationalFrameDuration
        let n = frFrac.numerator * frameCount.wholeFrames
        let d = frFrac.denominator
        
        return simplify(fraction: (n, d))
    }
}
