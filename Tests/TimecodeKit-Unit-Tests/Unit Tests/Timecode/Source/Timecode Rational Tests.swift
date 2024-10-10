//
//  Timecode Rational Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

@testable import TimecodeKit
import XCTest

final class Timecode_Rational_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testTimecode_init_Rational_Exactly() throws {
        try TimecodeFrameRate.allCases.forEach {
            let tc = try Timecode(
                .rational(Fraction(10, 1)),
                at: $0
            )
            
            // don't imperatively check each result, just make sure that a value was set;
            // setter logic is unit-tested elsewhere, we just want to check the Timecode.init interface here.
            XCTAssertNotEqual(tc.seconds, 0, "for \($0)")
        }
    }
    
    func testTimecode_init_Rational() throws {
        // these rational fractions and timecodes are taken from actual FCP XML files as known truth
        
        try TimecodeFrameRate.allCases.forEach { fRate in
            switch fRate {
            case .fps23_976:
                XCTAssertEqual(
                    try Timecode(.rational(Fraction(335335, 24000)), at: fRate).components,
                    Timecode.Components(h: 00, m: 00, s: 13, f: 23)
                )
            case .fps24:
                XCTAssertEqual(
                    try Timecode(.rational(Fraction(167500, 12000)), at: fRate).components,
                    Timecode.Components(h: 00, m: 00, s: 13, f: 23)
                )
            case .fps24_98:
                break // TODO: finish this
            case .fps25: // same fraction is found in FCP XML for 25p and 25i video rates
                XCTAssertEqual(
                    try Timecode(.rational(Fraction(34900, 2500)), at: fRate).components,
                    Timecode.Components(h: 00, m: 00, s: 13, f: 24)
                )
            case .fps29_97: // same fraction is found in FCP XML for 29.97p and 29.97i video rates
                XCTAssertEqual(
                    try Timecode(.rational(Fraction(838838, 60000)), at: fRate).components,
                    Timecode.Components(h: 00, m: 00, s: 13, f: 29)
                )
                XCTAssertEqual(
                    try Timecode(.rational(Fraction(1920919, 30000)), at: fRate).components,
                    Timecode.Components(h: 00, m: 01, s: 03, f: 29)
                )
            case .fps29_97d:
                XCTAssertEqual(
                    try Timecode(.rational(Fraction(419419, 30000)), at: fRate).components,
                    Timecode.Components(h: 00, m: 00, s: 13, f: 29)
                )
                XCTAssertEqual(
                    try Timecode(.rational(Fraction(1918917, 30000)), at: fRate).components,
                    Timecode.Components(h: 00, m: 01, s: 03, f: 29)
                )
            case .fps30:
                XCTAssertEqual(
                    try Timecode(.rational(Fraction(83800, 6000)), at: fRate).components,
                    Timecode.Components(h: 00, m: 00, s: 13, f: 29)
                )
            case .fps30d:
                break // TODO: finish this
            case .fps47_952:
                break // TODO: finish this
            case .fps48:
                break // TODO: finish this
            case .fps50:
                XCTAssertEqual(
                    try Timecode(.rational(Fraction(69900, 5000)), at: fRate).components,
                    Timecode.Components(h: 00, m: 00, s: 13, f: 49)
                )
            case .fps59_94:
                XCTAssertEqual(
                    try Timecode(.rational(Fraction(839839, 60000)), at: fRate).components,
                    Timecode.Components(h: 00, m: 00, s: 13, f: 59)
                )
            case .fps59_94d:
                break // TODO: finish this
            case .fps60:
                XCTAssertEqual(
                    try Timecode(.rational(Fraction(83900, 6000)), at: fRate).components,
                    Timecode.Components(h: 00, m: 00, s: 13, f: 59)
                )
            case .fps60d:
                break // TODO: finish this
            case .fps95_904:
                break // TODO: finish this
            case .fps96:
                break // TODO: finish this
            case .fps100:
                break // TODO: finish this
            case .fps119_88:
                break // TODO: finish this
            case .fps119_88d:
                break // TODO: finish this
            case .fps120:
                break // TODO: finish this
            case .fps120d:
                break // TODO: finish this
            }
        }
    }
    
    func testTimecode_init_Rational_Clamping() {
        let tc = Timecode(
            .rational(Fraction(86400 + 3600, 1)), // 25 hours @ 24fps
            at: .fps24,
            by: .clamping
        )
        
        XCTAssertEqual(
            tc.components,
            Timecode.Components(h: 23, m: 59, s: 59, f: 23, sf: tc.subFramesBase.rawValue - 1)
        )
    }
    
    func testTimecode_init_Rational_Clamping_Negative() {
        let tc = Timecode(
            .rational(Fraction(-2, 1)),
            at: .fps24,
            by: .clamping
        )
        
        XCTAssertEqual(
            tc.components,
            Timecode.Components(h: 00, m: 00, s: 00, f: 00)
        )
    }
    
    func testTimecode_init_Rational_Wrapping() {
        let tc = Timecode(
            .rational(Fraction(86400 + 3600, 1)), // 25 hours @ 24fps
            at: .fps24,
            by: .wrapping
        )
        
        XCTAssertEqual(
            tc.components,
            Timecode.Components(d: 00, h: 01, m: 00, s: 00, f: 00, sf: 00)
        )
    }
    
    func testTimecode_init_Rational_Wrapping_Negative() {
        let tc = Timecode(
            .rational(Fraction(-2, 1)),
            at: .fps24,
            by: .wrapping
        )
        
        XCTAssertEqual(
            tc.components,
            Timecode.Components(d: 00, h: 23, m: 59, s: 58, f: 00, sf: 00)
        )
    }
    
    func testTimecode_init_Rational_RawValues() {
        let tc = Timecode(
            .rational(Fraction((86400 * 2) + 3600, 1)), // 2 days + 1 hour @ 24fps
            at: .fps24,
            by: .allowingInvalid
        )
        
        XCTAssertEqual(
            tc.components,
            Timecode.Components(d: 02, h: 01, m: 00, s: 00, f: 00, sf: 00)
        )
    }
    
    func testTimecode_init_Rational_RawValues_Negative() {
        let tc = Timecode(
            .rational(Fraction(-(3600 + 60 + 5), 1)),
            at: .fps24,
            by: .allowingInvalid
        )
        
        // Negates only the largest non-zero component if input is negative
        XCTAssertEqual(
            tc.components,
            Timecode.Components(d: 00, h: -01, m: 01, s: 05, f: 00, sf: 00)
        )
    }
    
    func testTimecode_rationalValue() throws {
        // test a small range of timecodes at each frame rate
        // and ensure the fraction can re-form the same timecode
        try TimecodeFrameRate.allCases.forEach { fRate in
            let s = try Timecode(.components(m: 8, f: 20), at: fRate)
            let e = try Timecode(.components(m: 10, f: 5), at: fRate)
            
            try (s ... e).forEach { tc in
                let f = tc.rationalValue
                let reformedTC = try Timecode(.rational(f), at: fRate)
                XCTAssertEqual(tc, reformedTC)
            }
        }
    }
    
    func testTimecode_RationalValue_SpotCheck() throws {
        let tc = try Timecode(.components(h: 00, m: 00, s: 13, f: 29), at: .fps29_97d)
        XCTAssertEqual(tc.rationalValue.numerator, 419419)
        XCTAssertEqual(tc.rationalValue.denominator, 30000)
    }
    
    func testTimecode_RationalValue_Subframes() throws {
        let tc = try Timecode(
            .components(h: 00, m: 00, s: 01, f: 11, sf: 56),
            at: .fps25,
            base: .max80SubFrames
        )
        XCTAssertEqual(tc.rationalValue, Fraction(367, 250))
    }
    
    func testTimecode_RationalSubframes() throws {
        // 00:00:01:11.56 @ 25i fps, 80sf base
        // this fraction is actually a little past 56 subframes
        // because it was from FCPXML where it was not on an exact subframe
        // FYI: when we convert it back to a fraction from timecode,
        // the fraction ends up 367/250
        let frac = Fraction(11011, 7500)
        let tc = try Timecode(.rational(frac), at: .fps25, base: .max80SubFrames)
        XCTAssertEqual(tc.components, Timecode.Components(h: 00, m: 00, s: 01, f: 11, sf: 56))
        XCTAssertEqual(tc.rationalValue, Fraction(367, 250))
    }
    
    func testTimecode_FrameCountOfRational() throws {
        // 00:00:01:11.56 @ 25i fps, 80sf base
        // this fraction is actually a little past 56 subframes
        // because it was from FCPXML where it was not on an exact subframe
        // FYI: when we convert it back to a fraction from timecode,
        // the fraction ends up 367/250
        let frac = Fraction(11011, 7500)
        let tc = try Timecode(.rational(frac), at: .fps25, base: .max80SubFrames)
        let int = tc.frameCount(of: frac)
        XCTAssertEqual(int, 36)
    }
    
    func testTimecode_FloatingFrameCountOfRational() throws {
        // 00:00:01:11.56 @ 25i fps, 80sf base
        // this fraction is actually a little past 56 subframes
        // because it was from FCPXML where it was not on an exact subframe
        // FYI: when we convert it back to a fraction from timecode,
        // the fraction ends up 367/250
        let frac = Fraction(11011, 7500)
        let tc = try Timecode(.rational(frac), at: .fps25, base: .max80SubFrames)
        let float = tc.floatingFrameCount(of: frac)
        XCTAssertEqual(float, 36.70333333333333)
    }
}
