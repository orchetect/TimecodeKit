//
//  Timecode Rational CMTime Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import CoreMedia
import TimecodeKitCore // do NOT import as @testable in this file
import XCTest

final class Timecode_Source_Rational_CMTime_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testTimecode_init_CMTime_Exactly() throws {
        for item in TimecodeFrameRate.allCases {
            let tc = try Timecode(
                .cmTime(CMTime(value: 10, timescale: 1)),
                at: item,
                limit: .max24Hours
            )
            
            // don't imperatively check each result, just make sure that a value was set;
            // setter logic is unit-tested elsewhere, we just want to check the Timecode.init interface here.
            XCTAssertNotEqual(tc.seconds, 0, "for \(item)")
        }
    }
    
    func testTimecode_init_CMTime() throws {
        // these rational fractions and timecodes are taken from actual FCP XML files as known truth
        
        for fRate in TimecodeFrameRate.allCases {
            switch fRate {
            case .fps23_976:
                XCTAssertEqual(
                    try Timecode(.cmTime(CMTime(value: 335335, timescale: 24000)), at: fRate).components,
                    Timecode.Components(h: 00, m: 00, s: 13, f: 23)
                )
            case .fps24:
                XCTAssertEqual(
                    try Timecode(.cmTime(CMTime(value: 167500, timescale: 12000)), at: fRate).components,
                    Timecode.Components(h: 00, m: 00, s: 13, f: 23)
                )
            case .fps24_98:
                break // TODO: finish this
            case .fps25: // same fraction is found in FCP XML for 25p and 25i video rates
                XCTAssertEqual(
                    try Timecode(.cmTime(CMTime(value: 34900, timescale: 2500)), at: fRate).components,
                    Timecode.Components(h: 00, m: 00, s: 13, f: 24)
                )
            case .fps29_97: // same fraction is found in FCP XML for 29.97p and 29.97i video rates
                XCTAssertEqual(
                    try Timecode(.cmTime(CMTime(value: 838838, timescale: 60000)), at: fRate).components,
                    Timecode.Components(h: 00, m: 00, s: 13, f: 29)
                )
                XCTAssertEqual(
                    try Timecode(.cmTime(CMTime(value: 1920919, timescale: 30000)), at: fRate).components,
                    Timecode.Components(h: 00, m: 01, s: 03, f: 29)
                )
            case .fps29_97d:
                XCTAssertEqual(
                    try Timecode(.cmTime(CMTime(value: 419419, timescale: 30000)), at: fRate).components,
                    Timecode.Components(h: 00, m: 00, s: 13, f: 29)
                )
                XCTAssertEqual(
                    try Timecode(.cmTime(CMTime(value: 1918917, timescale: 30000)), at: fRate).components,
                    Timecode.Components(h: 00, m: 01, s: 03, f: 29)
                )
            case .fps30:
                XCTAssertEqual(
                    try Timecode(.cmTime(CMTime(value: 83800, timescale: 6000)), at: fRate).components,
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
                    try Timecode(.cmTime(CMTime(value: 69900, timescale: 5000)), at: fRate).components,
                    Timecode.Components(h: 00, m: 00, s: 13, f: 49)
                )
            case .fps59_94:
                XCTAssertEqual(
                    try Timecode(.cmTime(CMTime(value: 839839, timescale: 60000)), at: fRate).components,
                    Timecode.Components(h: 00, m: 00, s: 13, f: 59)
                )
            case .fps59_94d:
                break // TODO: finish this
            case .fps60:
                XCTAssertEqual(
                    try Timecode(.cmTime(CMTime(value: 83900, timescale: 6000)), at: fRate).components,
                    Timecode.Components(h: 00, m: 00, s: 13, f: 59)
                )
            case .fps60d:
                break // TODO: finish this
            case .fps90:
                XCTAssertEqual(
                    try Timecode(.cmTime(CMTime(value: 90000, timescale: 9000)), at: fRate).components,
                    Timecode.Components(h: 00, m: 00, s: 10, f: 00)
                )
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
    
    func testTimecode_init_CMTime_Clamping() {
        let tc = Timecode(
            .cmTime(CMTime(value: 86400 + 3600, timescale: 1)), // 25 hours @ 24fps
            at: .fps24,
            limit: .max24Hours,
            by: .clamping
        )
        
        XCTAssertEqual(
            tc.components,
            Timecode.Components(h: 23, m: 59, s: 59, f: 23, sf: tc.subFramesBase.rawValue - 1)
        )
    }
    
    func testTimecode_init_CMTime_Wrapping() {
        let tc = Timecode(
            .cmTime(CMTime(value: 86400 + 3600, timescale: 1)), // 25 hours @ 24fps
            at: .fps24,
            limit: .max24Hours,
            by: .wrapping
        )
        
        XCTAssertEqual(tc.days, 0)
        XCTAssertEqual(tc.hours, 1)
        XCTAssertEqual(tc.minutes, 0)
        XCTAssertEqual(tc.seconds, 0)
        XCTAssertEqual(tc.frames, 0)
        XCTAssertEqual(tc.subFrames, 0)
    }
    
    func testTimecode_init_CMTime_RawValues() {
        let tc = Timecode(
            .cmTime(CMTime(value: (86400 * 2) + 3600, timescale: 1)), // 2 days + 1 hour @ 24fps
            at: .fps24,
            limit: .max24Hours,
            by: .allowingInvalid
        )
        
        XCTAssertEqual(tc.days, 2)
        XCTAssertEqual(tc.hours, 1)
        XCTAssertEqual(tc.minutes, 0)
        XCTAssertEqual(tc.seconds, 0)
        XCTAssertEqual(tc.frames, 0)
        XCTAssertEqual(tc.subFrames, 0)
    }
    
    func testTimecode_cmTimeValue() async throws {
        // test a small range of timecodes at each frame rate
        // and ensure the fraction can re-form the same timecode
        
        // since this test can take a long time, parallelize using a task group
        // which will use 100% of all available CPU cores
        await withThrowingTaskGroup(of: Void.self, returning: Void.self) { taskGroup in
            for fRate in TimecodeFrameRate.allCases {
                taskGroup.addTask {
                    print("Starting \(fRate.stringValue) task")
                    
                    let s = try Timecode(.components(m: 8, f: 20), at: fRate)
                    let e = try Timecode(.components(m: 10, f: 5), at: fRate)
                    
                    try (s ... e).forEach { tc in
                        let f = tc.cmTimeValue
                        let reformedTC = try Timecode(.cmTime(f), at: fRate)
                        XCTAssertEqual(tc, reformedTC)
                    }
                    
                    print("Done \(fRate.stringValue) task")
                }
            }
        }
    }
    
    func testTimecode_cmTimeValue_SpotCheck() throws {
        let tc = try Timecode(.components(h: 00, m: 00, s: 13, f: 29), at: .fps29_97d)
        XCTAssertEqual(tc.cmTimeValue.value, 419419)
        XCTAssertEqual(tc.cmTimeValue.timescale, 30000)
    }
}
