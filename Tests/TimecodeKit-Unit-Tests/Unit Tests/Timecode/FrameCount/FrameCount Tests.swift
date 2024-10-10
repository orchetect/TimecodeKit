//
//  FrameCount Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

@testable import TimecodeKit
import XCTest

final class FrameCount_Tests: XCTestCase {
    func testInit_frameCount() {
        let subFramesBase: Timecode.SubFramesBase = .max80SubFrames
        
        let fc = Timecode.FrameCount(
            subFrameCount: 40002,
            base: subFramesBase
        )
        
        XCTAssertEqual(fc.wholeFrames, 500)
        XCTAssertEqual(fc.subFrames, 2)
        XCTAssertEqual(fc.doubleValue, 500.025)
        XCTAssertEqual(fc.subFrameCount, 40002)
    }
    
    func testEquatable() {
        // .frames
        
        XCTAssert(
            Timecode.FrameCount(.frames(500), base: .max100SubFrames)
                ==
                Timecode.FrameCount(.frames(500), base: .max100SubFrames)
        )
        
        XCTAssert(
            Timecode.FrameCount(.frames(500), base: .max100SubFrames)
                !=
                Timecode.FrameCount(.frames(501), base: .max100SubFrames)
        )
        
        // .split
        
        XCTAssert(
            Timecode.FrameCount(.split(frames: 500, subFrames: 2), base: .max100SubFrames)
                ==
                Timecode.FrameCount(.split(frames: 500, subFrames: 2), base: .max100SubFrames)
        )
        
        XCTAssert(
            Timecode.FrameCount(.split(frames: 500, subFrames: 2), base: .max100SubFrames)
                !=
                Timecode.FrameCount(.split(frames: 500, subFrames: 3), base: .max100SubFrames)
        )
        
        // .combined
        
        XCTAssert(
            Timecode.FrameCount(.combined(frames: 500.025), base: .max100SubFrames)
                ==
                Timecode.FrameCount(.combined(frames: 500.025), base: .max100SubFrames)
        )
        
        XCTAssert(
            Timecode.FrameCount(.combined(frames: 500.025), base: .max100SubFrames)
                !=
                Timecode.FrameCount(.combined(frames: 500.5), base: .max100SubFrames)
        )
        
        // .splitUnitInterval
        
        XCTAssert(
            Timecode.FrameCount(
                .splitUnitInterval(frames: 500, subFramesUnitInterval: 0.025),
                base: .max100SubFrames
            )
                ==
                Timecode.FrameCount(
                    .splitUnitInterval(frames: 500, subFramesUnitInterval: 0.025),
                    base: .max100SubFrames
                )
        )
        
        XCTAssert(
            Timecode.FrameCount(
                .splitUnitInterval(frames: 500, subFramesUnitInterval: 0.025),
                base: .max100SubFrames
            )
                ==
                Timecode.FrameCount(.combined(frames: 500.025), base: .max100SubFrames)
        )
        
        XCTAssert(
            Timecode.FrameCount(
                .splitUnitInterval(frames: 500, subFramesUnitInterval: 0.025),
                base: .max100SubFrames
            )
                !=
                Timecode.FrameCount(
                    .splitUnitInterval(frames: 500, subFramesUnitInterval: 0.5),
                    base: .max100SubFrames
                )
        )
        
        XCTAssert(
            Timecode.FrameCount(
                .splitUnitInterval(frames: 500, subFramesUnitInterval: 0.025),
                base: .max100SubFrames
            )
                !=
                Timecode.FrameCount(.combined(frames: 500.5), base: .max100SubFrames)
        )
    }
    
    func testOperators() {
        XCTAssertEqual(
            Timecode.FrameCount(.frames(200), base: .max100SubFrames)
                +
                Timecode.FrameCount(.frames(200), base: .max100SubFrames),
            Timecode.FrameCount(.frames(400), base: .max100SubFrames)
        )
        
        XCTAssertEqual(
            Timecode.FrameCount(.frames(400), base: .max100SubFrames)
                -
                Timecode.FrameCount(.frames(200), base: .max100SubFrames),
            Timecode.FrameCount(.frames(200), base: .max100SubFrames)
        )
        
        XCTAssertEqual(
            Timecode.FrameCount(.frames(200), base: .max100SubFrames)
                * 2,
            Timecode.FrameCount(.frames(400), base: .max100SubFrames)
        )
        
        XCTAssertEqual(
            Timecode.FrameCount(.frames(400), base: .max100SubFrames)
                / 2,
            Timecode.FrameCount(.frames(200), base: .max100SubFrames)
        )
    }
    
    func testIsNegative() {
        XCTAssertFalse(Timecode.FrameCount(.frames(0), base: .max100SubFrames).isNegative)
        XCTAssertFalse(Timecode.FrameCount(.frames(-0), base: .max100SubFrames).isNegative)
        
        XCTAssertFalse(Timecode.FrameCount(.frames(1), base: .max100SubFrames).isNegative)
        XCTAssertTrue(Timecode.FrameCount(.frames(-1), base: .max100SubFrames).isNegative)
    }
    
    func testTimecode_framesToSubFrames() {
        XCTAssertEqual(
            Timecode.framesToSubFrames(frames: 500, subFrames: 2, base: .max80SubFrames),
            40002
        )
    }
    
    func testTimecode_subFramesToFrames() {
        let converted = Timecode.subFramesToFrames(40002, base: .max80SubFrames)
        
        XCTAssertEqual(converted.frames, 500)
        XCTAssertEqual(converted.subFrames, 2)
    }
    
    func testEdgeCases_2997d() throws {
        let totalFramesin24Hr = 2_589_408
        let totalSubFramesin24Hr = 207_152_640
        
        XCTAssertEqual(
            try Timecode(
                .frames(totalFramesin24Hr - 1),
                at: .fps29_97d,
                base: .max80SubFrames,
                limit: .max24Hours
            ).components,
            Timecode.Components(d: 0, h: 23, m: 59, s: 59, f: 29, sf: 0)
        )
        
        XCTAssertEqual(
            try Timecode(
                .frames(totalFramesin24Hr - 1, subFrames: 79),
                at: .fps29_97d,
                base: .max80SubFrames,
                limit: .max24Hours
            ).components,
            Timecode.Components(d: 0, h: 23, m: 59, s: 59, f: 29, sf: 79)
        )
        
        XCTAssertEqual(
            try Timecode(
                .frames(totalFramesin24Hr - 1, subFrames: 79),
                at: .fps29_97d,
                base: .max80SubFrames,
                limit: .max24Hours
            )
            .frameCount
            .subFrameCount,
            totalSubFramesin24Hr - 1
        )
    }
    
    func testEdgeCases_30d() throws {
        let totalFramesin24Hr = 2_589_408
        
        XCTAssertEqual(
            try Timecode(
                .frames(totalFramesin24Hr),
                at: .fps30d,
                limit: .max100Days
            ).components,
            Timecode.Components(d: 1)
        )
    }
}
