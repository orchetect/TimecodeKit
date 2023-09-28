//
//  Timecode FeetAndFrames Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

@testable import TimecodeKit
import XCTest

class Timecode_FeetAndFrames_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testTimecode_23_976fps_zero() throws {
        let ff = Timecode(.zero, at: .fps23_976).feetAndFramesValue
        XCTAssertEqual(ff.feet, 0)
        XCTAssertEqual(ff.frames, 0)
    }
    
    func testTimecode_23_976fps_1min() throws {
        let ff = try Timecode.Components(m: 1).timecode(at: .fps23_976).feetAndFramesValue
        XCTAssertEqual(ff.feet, 90)
        XCTAssertEqual(ff.frames, 0)
    }
    
    func testTimecode_24fps_zero() throws {
        let ff = Timecode(.zero, at: .fps24).feetAndFramesValue
        XCTAssertEqual(ff.feet, 0)
        XCTAssertEqual(ff.frames, 0)
    }
    
    func testTimecode_24fps_1min() throws {
        let ff = try Timecode.Components(m: 1).timecode(at: .fps24).feetAndFramesValue
        XCTAssertEqual(ff.feet, 90)
        XCTAssertEqual(ff.frames, 0)
    }
    
    func testTimecode_allRates_complex() throws {
        try TimecodeFrameRate.allCases.forEach { frate in
            let ff = try Timecode.Components(h: 1, m: 2, s: 3, f: 4)
                .timecode(at: frate).feetAndFramesValue
            
            // TimecodeFrameRate.maxTotalFrames is a good reference for groupings
            // which shows frame rates with the same frame counts over time
            switch frate {
            case .fps23_976, .fps24:
                XCTAssertEqual(ff.feet, 5584, "\(frate)")
                XCTAssertEqual(ff.frames, 12, "\(frate)")
            case .fps24_98, .fps25:
                XCTAssertEqual(ff.feet, 5817, "\(frate)")
                XCTAssertEqual(ff.frames, 07, "\(frate)")
            case .fps29_97, .fps30:
                XCTAssertEqual(ff.feet, 6980, "\(frate)")
                XCTAssertEqual(ff.frames, 14, "\(frate)")
            case .fps29_97d, .fps30d:
                XCTAssertEqual(ff.feet, 6973, "\(frate)")
                XCTAssertEqual(ff.frames, 14, "\(frate)")
            case .fps47_952, .fps48:
                XCTAssertEqual(ff.feet, 11169, "\(frate)")
                XCTAssertEqual(ff.frames, 04, "\(frate)")
            case .fps50:
                XCTAssertEqual(ff.feet, 11634, "\(frate)")
                XCTAssertEqual(ff.frames, 10, "\(frate)")
            case .fps59_94, .fps60:
                XCTAssertEqual(ff.feet, 13961, "\(frate)")
                XCTAssertEqual(ff.frames, 08, "\(frate)")
            case .fps59_94d, .fps60d:
                XCTAssertEqual(ff.feet, 13947, "\(frate)")
                XCTAssertEqual(ff.frames, 08, "\(frate)")
            case .fps95_904, .fps96:
                XCTAssertEqual(ff.feet, 22338, "\(frate)")
                XCTAssertEqual(ff.frames, 04, "\(frate)")
            case .fps100:
                XCTAssertEqual(ff.feet, 23269, "\(frate)")
                XCTAssertEqual(ff.frames, 00, "\(frate)")
            case .fps119_88, .fps120:
                XCTAssertEqual(ff.feet, 27922, "\(frate)")
                XCTAssertEqual(ff.frames, 12, "\(frate)")
            case .fps119_88d, .fps120d:
                XCTAssertEqual(ff.feet, 27894, "\(frate)")
                XCTAssertEqual(ff.frames, 12, "\(frate)")
            }
            
            XCTAssertEqual(ff.subFrames, 0, "\(frate)")
        }
    }
    
    /// Ensure subFrames are correct when set.
    func testTimecode_allRates_subFrames() throws {
        try TimecodeFrameRate.allCases.forEach { frate in
            let ff = try Timecode.Components(h: 1, m: 2, s: 3, f: 4, sf: 24)
                .timecode(at: frate).feetAndFramesValue
            
            XCTAssertEqual(ff.subFrames, 24, "\(frate)")
        }
    }
}

#endif
