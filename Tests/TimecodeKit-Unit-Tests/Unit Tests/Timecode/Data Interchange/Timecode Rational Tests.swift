//
//  Timecode Rational Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import TimecodeKit

class Timecode_UT_DI_Rational_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testTimecode_init_Rational_Exactly() throws {
        try TimecodeFrameRate.allCases.forEach {
            let tc = try Timecode(
                rational: (10, 1),
                at: $0,
                limit: ._24hours
            )
            
            // don't imperatively check each result, just make sure that a value was set;
            // samples setter logic is unit-tested elsewhere, we just want to check the Timecode.init interface here.
            XCTAssertNotEqual(tc.seconds, 0, "for \($0)")
        }
    }
    
    // TODO: add additional tests for clamping/wrapping/rawValues when inits are added
    
    func testTimecode_init_Rational() throws {
        // these rational fractions and timecodes are taken from actual FCP XML files as known truth
        
        try TimecodeFrameRate.allCases.forEach { fRate in
            switch fRate {
            case ._23_976:
                XCTAssertEqual(
                    try Timecode(rational: (335335, 24000), at: fRate).components,
                    TCC(h: 00, m: 00, s: 13, f: 23)
                )
            case ._24:
                XCTAssertEqual(
                    try Timecode(rational: (167500, 12000), at: fRate).components,
                    TCC(h: 00, m: 00, s: 13, f: 23)
                )
            case ._24_98:
                break // TODO: finish this
            case ._25: // same fraction is found in FCP XML for 25p and 25i video rates
                XCTAssertEqual(
                    try Timecode(rational: (34900, 2500), at: fRate).components,
                    TCC(h: 00, m: 00, s: 13, f: 24)
                )
            case ._29_97: // same fraction is found in FCP XML for 29.97p and 29.97i video rates
                XCTAssertEqual(
                    try Timecode(rational: (838838, 60000), at: fRate).components,
                    TCC(h: 00, m: 00, s: 13, f: 29)
                )
                XCTAssertEqual(
                    try Timecode(rational: (1920919, 30000), at: fRate).components,
                    TCC(h: 00, m: 01, s: 03, f: 29)
                )
            case ._29_97_drop:
                XCTAssertEqual(
                    try Timecode(rational: (419419, 30000), at: fRate).components,
                    TCC(h: 00, m: 00, s: 13, f: 29)
                )
                XCTAssertEqual(
                    try Timecode(rational: (1918917, 30000), at: fRate).components,
                    TCC(h: 00, m: 01, s: 03, f: 29)
                )
            case ._30:
                XCTAssertEqual(
                    try Timecode(rational: (83800, 6000), at: fRate).components,
                    TCC(h: 00, m: 00, s: 13, f: 29)
                )
            case ._30_drop:
                break // TODO: finish this
            case ._47_952:
                break // TODO: finish this
            case ._48:
                break // TODO: finish this
            case ._50:
                XCTAssertEqual(
                    try Timecode(rational: (69900, 5000), at: fRate).components,
                    TCC(h: 00, m: 00, s: 13, f: 49)
                )
            case ._59_94:
                XCTAssertEqual(
                    try Timecode(rational: (839839, 60000), at: fRate).components,
                    TCC(h: 00, m: 00, s: 13, f: 59)
                )
            case ._59_94_drop:
                break // TODO: finish this
            case ._60:
                XCTAssertEqual(
                    try Timecode(rational: (83900, 6000), at: fRate).components,
                    TCC(h: 00, m: 00, s: 13, f: 59)
                )
            case ._60_drop:
                break // TODO: finish this
            case ._100:
                break // TODO: finish this
            case ._119_88:
                break // TODO: finish this
            case ._119_88_drop:
                break // TODO: finish this
            case ._120:
                break // TODO: finish this
            case ._120_drop:
                break // TODO: finish this
            }
        }
    }
    
    func testDouble_Rational() throws {
        // test a small range of timecodes at each frame rate
        // and ensure the fraction can re-form the same timecode
        try TimecodeFrameRate.allCases.forEach { fRate in
            let s = try TCC(m: 8, f: 20).toTimecode(at: fRate)
            let e = try TCC(m: 10, f: 5).toTimecode(at: fRate)
            
            try (s ... e).forEach { tc in
                let f = tc.rationalValue
                let reformedTC = try Timecode(rational: f, at: fRate)
                XCTAssertEqual(tc, reformedTC)
            }
        }
    }
    
    func testDouble_Rational_SpotCheck() throws {
        let tc = try TCC(h: 00, m: 00, s: 13, f: 29).toTimecode(at: ._29_97_drop)
        XCTAssertEqual(tc.rationalValue.numerator, 419419)
        XCTAssertEqual(tc.rationalValue.denominator, 30000)
    }
}

#endif
