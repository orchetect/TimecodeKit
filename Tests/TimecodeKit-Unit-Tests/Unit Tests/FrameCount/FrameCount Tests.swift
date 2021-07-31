//
//  FrameCount Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//

#if !os(watchOS)

import XCTest
@testable import TimecodeKit

class Timecode_FrameCount_SubframesTests: XCTestCase {
    
    func testInit_frameCount() {
        
        let subFramesDivisor = 80
        
        let fc = Timecode.FrameCount(totalElapsedSubFrames: 40002,
                                     usingSubFramesDivisor: subFramesDivisor)
        
        XCTAssertEqual(fc.wholeFrames, 500)
        XCTAssertEqual(fc.subFrames(usingSubFramesDivisor: subFramesDivisor), 2)
        XCTAssertEqual(fc.doubleValue(usingSubFramesDivisor: subFramesDivisor), 500.025)
        XCTAssertEqual(fc.totalSubFrames(usingSubFramesDivisor: subFramesDivisor), 40002)
        
    }
    
    func testEquatable() {
        
        // .frames
        
        XCTAssert(
            Timecode.FrameCount.frames(500)
                ==
                Timecode.FrameCount.frames(500)
        )
        
        XCTAssert(
            Timecode.FrameCount.frames(500)
                !=
                Timecode.FrameCount.frames(501)
        )
        
        // .split
        
        XCTAssert(
            Timecode.FrameCount.split(frames: 500, subFrames: 2)
                ==
                Timecode.FrameCount.split(frames: 500, subFrames: 2)
        )
        
        XCTAssert(
            Timecode.FrameCount.split(frames: 500, subFrames: 2)
                !=
                Timecode.FrameCount.split(frames: 500, subFrames: 3)
        )
        
        // .combined
        
        XCTAssert(
            Timecode.FrameCount.combined(frames: 500.025)
                ==
                Timecode.FrameCount.combined(frames: 500.025)
        )
        
        XCTAssert(
            Timecode.FrameCount.combined(frames: 500.025)
                !=
                Timecode.FrameCount.combined(frames: 500.5)
        )
        
        // .splitUnitInterval
        
        XCTAssert(
            Timecode.FrameCount.splitUnitInterval(frames: 500, subFramesUnitInterval: 0.025)
                ==
                Timecode.FrameCount.splitUnitInterval(frames: 500, subFramesUnitInterval: 0.025)
        )
        
        XCTAssert(
            Timecode.FrameCount.splitUnitInterval(frames: 500, subFramesUnitInterval: 0.025)
                ==
                Timecode.FrameCount.combined(frames: 500.025)
        )
        
        XCTAssert(
            Timecode.FrameCount.splitUnitInterval(frames: 500, subFramesUnitInterval: 0.025)
                !=
                Timecode.FrameCount.splitUnitInterval(frames: 500, subFramesUnitInterval: 0.5)
        )
        
        XCTAssert(
            Timecode.FrameCount.splitUnitInterval(frames: 500, subFramesUnitInterval: 0.025)
                !=
                Timecode.FrameCount.combined(frames: 500.5)
        )
        
    }
    
    func testTimecode_framesToSubFrames() {
        
        XCTAssertEqual(
            Timecode.framesToSubFrames(totalFrames: 500, subFrames: 2, subFramesDivisor: 80),
            40002
        )
        
    }
    
    func testTimecode_subFramesToFrames() {
        
        let converted = Timecode.subFramesToFrames(totalSubFrames: 40002, subFramesDivisor: 80)
        
        XCTAssertEqual(converted.frames, 500)
        XCTAssertEqual(converted.subFrames, 2)
        
    }
    
    func testEdgeCases() {
        
        let totalFramesin24Hr = 2589408
        let totalSubFramesin24Hr = 207152640
        
        XCTAssertEqual(
            Timecode(.frames(totalFramesin24Hr - 1),
                     at: ._29_97_drop,
                     limit: ._24hours,
                     subFramesDivisor: 80,
                     displaySubFrames: true)?.components,
            TCC(d: 0, h: 23, m: 59, s: 59, f: 29, sf: 0)
        )
        
        XCTAssertEqual(
            Timecode(.split(frames: totalFramesin24Hr - 1, subFrames: 79),
                     at: ._29_97_drop,
                     limit: ._24hours,
                     subFramesDivisor: 80,
                     displaySubFrames: true)?.components,
            TCC(d: 0, h: 23, m: 59, s: 59, f: 29, sf: 79)
        )
        
        XCTAssertEqual(
            Timecode(.split(frames: totalFramesin24Hr - 1, subFrames: 79),
                     at: ._29_97_drop,
                     limit: ._24hours,
                     subFramesDivisor: 80,
                     displaySubFrames: true)?
                .frameCount
                .totalSubFrames(usingSubFramesDivisor: 80),
            totalSubFramesin24Hr - 1
        )
        
    }
    
}
#endif
