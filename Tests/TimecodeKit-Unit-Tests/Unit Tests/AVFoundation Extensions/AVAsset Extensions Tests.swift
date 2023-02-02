//
//  AVAsset Extensions Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// AVAssetReader is unavailable on watchOS so we can't support any AVAsset operations
#if shouldTestCurrentPlatform && canImport(AVFoundation) && !os(watchOS)

import XCTest
@testable import TimecodeKit
import AVFoundation

class AVAssetExtensions_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testReadStartElapsedFrames1() throws {
        let url = try TestResource.timecodeTrack_23_976_Start_00_00_00_00.url()
        let asset = AVAsset(url: url)
        let startFrames = asset.readStartElapsedFrames()
        
        XCTAssertEqual(startFrames, [0])
    }
    
    func testReadStartElapsedFrames2() throws {
        let url = try TestResource.timecodeTrack_23_976_Start_00_58_40_00.url()
        let asset = AVAsset(url: url)
        let startFrames = asset.readStartElapsedFrames()
        
        XCTAssertEqual(startFrames, [84480])
    }
    
    func testReadStartTimecode_23_976fps() throws {
        let frameRate: TimecodeFrameRate = ._23_976
        let url = try TestResource.timecodeTrack_23_976_Start_00_58_40_00.url()
        let asset = AVAsset(url: url)
        
        // start
        let correctStart = try TCC(m: 58, s: 40).toTimecode(at: frameRate)
        // auto-detect frame rate
        XCTAssertEqual(try asset.startTimecode(), [correctStart])
        // manually supply frame rate
        XCTAssertEqual(try asset.startTimecode(at: frameRate), [correctStart])
        
        // duration
        let correctDur = try TCC(m: 24, s: 10, f: 19, sf: 03).toTimecode(at: frameRate)
        // auto-detect frame rate
        XCTAssertEqual(try asset.durationTimecode(), correctDur)
        // manually supply frame rate
        XCTAssertEqual(try asset.durationTimecode(at: frameRate), correctDur)
        
        // end
        let correctEnd = try TCC(h: 1, m: 22, s: 50, f: 19, sf: 03)
            .toTimecode(at: frameRate, format: [.showSubFrames])
        // auto-detect frame rate
        XCTAssertEqual(try asset.endTimecode(format: [.showSubFrames]),
                       [correctEnd])
        // manually supply frame rate
        XCTAssertEqual(try asset.endTimecode(at: frameRate, format: [.showSubFrames]),
                       [correctEnd])
    }
    
    func testReadStartTimecode_24fps() throws {
        let frameRate: TimecodeFrameRate = ._24
        let url = try TestResource.timecodeTrack_24_Start_00_58_40_00.url()
        let asset = AVAsset(url: url)
        
        // start
        let correctStart = try TCC(m: 58, s: 40).toTimecode(at: frameRate)
        // auto-detect frame rate
        XCTAssertEqual(try asset.startTimecode(), [correctStart])
        // manually supply frame rate
        XCTAssertEqual(try asset.startTimecode(at: frameRate), [correctStart])
        
        // duration
        let correctDur = try TCC(m: 24, s: 12, f: 05, sf: 85).toTimecode(at: frameRate)
        // auto-detect frame rate
        XCTAssertEqual(try asset.durationTimecode(), correctDur)
        // manually supply frame rate
        XCTAssertEqual(try asset.durationTimecode(at: frameRate), correctDur)
        
        // end
        let correctEnd = try TCC(h: 1, m: 22, s: 52, f: 05, sf: 85)
            .toTimecode(at: frameRate, format: [.showSubFrames])
        // auto-detect frame rate
        XCTAssertEqual(try asset.endTimecode(format: [.showSubFrames]),
                       [correctEnd])
        // manually supply frame rate
        XCTAssertEqual(try asset.endTimecode(at: frameRate, format: [.showSubFrames]),
                       [correctEnd])
    }
    
    func testReadStartAndEndTimecode_29_97fps() throws {
        let frameRate: TimecodeFrameRate = ._29_97
        let url = try TestResource.videoTrack_29_97_Start_00_00_00_00.url()
        let asset = AVAsset(url: url)
        
        // start
        // no start timecode can be derived from this video file
        // auto-detect frame rate
        XCTAssertEqual(try asset.startTimecode(), [])
        // manually supply frame rate
        XCTAssertEqual(try asset.startTimecode(at: frameRate), [])
        
        // duration
        let correctDur = try TCC(s: 10).toTimecode(at: frameRate)
        // auto-detect frame rate
        XCTAssertEqual(try asset.durationTimecode(), correctDur)
        // manually supply frame rate
        XCTAssertEqual(try asset.durationTimecode(at: frameRate), correctDur)
        
        // end
        // no start timecode can be derived from this video file
        // auto-detect frame rate
        XCTAssertEqual(try asset.endTimecode(), [])
        // manually supply frame rate
        XCTAssertEqual(try asset.endTimecode(at: frameRate, format: [.showSubFrames]),
                       [])
    }
    
    func testFrameRate_23_976fps_A() throws {
        let url = try TestResource.timecodeTrack_23_976_Start_00_00_00_00.url()
        let asset = AVAsset(url: url)
        let frameRate = try asset.frameRate()
        XCTAssertEqual(frameRate, ._23_976)
    }
    
    func testFrameRate_23_976fps_B() throws {
        let url = try TestResource.timecodeTrack_23_976_Start_00_58_40_00.url()
        let asset = AVAsset(url: url)
        let frameRate = try asset.frameRate()
        XCTAssertEqual(frameRate, ._23_976)
    }
    
    func testFrameRate_24fps() throws {
        let url = try TestResource.timecodeTrack_24_Start_00_58_40_00.url()
        let asset = AVAsset(url: url)
        let frameRate = try asset.frameRate()
        XCTAssertEqual(frameRate, ._24)
    }
    
    func testFrameRate_29_97dropfps() throws {
        let url = try TestResource.timecodeTrack_29_97d_Start_00_00_00_00.url()
        let asset = AVAsset(url: url)
        let frameRate = try asset.frameRate()
        XCTAssertEqual(asset.isDropFrame, true)
        XCTAssertEqual(frameRate, ._29_97_drop)
    }
    
    func testFrameRate_29_97fps() throws {
        let url = try TestResource.videoTrack_29_97_Start_00_00_00_00.url()
        let asset = AVAsset(url: url)
        let frameRate = try asset.frameRate()
        XCTAssertEqual(asset.isDropFrame, false)
        XCTAssertEqual(frameRate, ._29_97)
    }
}

#endif
