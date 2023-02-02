//
//  AVAsset Extensions Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import TimecodeKit
import AVFoundation

class AVAssetExtensions_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testReadStartAndEndElapsedFrames1() throws {
        let url = try TestResource.timecodeTrack_23_976_Start_00_00_00_00.url()
        let asset = AVAsset(url: url)
        let startFrames = asset.readStartElapsedFrames()
        
        XCTAssertEqual(startFrames, [0])
    }
    
    func testReadStartAndEndElapsedFrames2() throws {
        let url = try TestResource.timecodeTrack_23_976_Start_00_58_40_00.url()
        let asset = AVAsset(url: url)
        let startFrames = asset.readStartElapsedFrames()
        
        XCTAssertEqual(startFrames, [84480])
    }
    
    func testReadStartTimecode_23_976fps() throws {
        let frameRate: TimecodeFrameRate = ._23_976
        let url = try TestResource.timecodeTrack_23_976_Start_00_58_40_00.url()
        let asset = AVAsset(url: url)
        
        let correctTimecode = try TCC(m: 58, s: 40).toTimecode(at: frameRate)
        
        // auto-detect frame rate
        XCTAssertEqual(asset.startTimecode(), [correctTimecode])
        // manually supply frame rate
        XCTAssertEqual(asset.startTimecode(at: frameRate), [correctTimecode])
    }
    
    func testReadStartTimecode_24fps() throws {
        let frameRate: TimecodeFrameRate = ._24
        let url = try TestResource.timecodeTrack_24_Start_00_58_40_00.url()
        let asset = AVAsset(url: url)
        
        let correctTimecode = try TCC(m: 58, s: 40).toTimecode(at: frameRate)
        
        // auto-detect frame rate
        XCTAssertEqual(asset.startTimecode(), [correctTimecode])
        // manually supply frame rate
        XCTAssertEqual(asset.startTimecode(at: frameRate), [correctTimecode])
    }
    
    func testFrameRate_23_976fps_A() throws {
        let url = try TestResource.timecodeTrack_23_976_Start_00_00_00_00.url()
        let asset = AVAsset(url: url)
        let frameRate = asset.frameRate()
        XCTAssertEqual(frameRate, ._23_976)
    }
    
    func testFrameRate_23_976fps_B() throws {
        let url = try TestResource.timecodeTrack_23_976_Start_00_58_40_00.url()
        let asset = AVAsset(url: url)
        let frameRate = asset.frameRate()
        XCTAssertEqual(frameRate, ._23_976)
    }
    
    func testFrameRate_24fps() throws {
        let url = try TestResource.timecodeTrack_24_Start_00_58_40_00.url()
        let asset = AVAsset(url: url)
        let frameRate = asset.frameRate()
        XCTAssertEqual(frameRate, ._24)
    }
    
    func testFrameRate_29_97dropfps() throws {
        let url = try TestResource.timecodeTrack_29_97d_Start_00_00_00_00.url()
        let asset = AVAsset(url: url)
        let frameRate = asset.frameRate()
        XCTAssertEqual(asset.isDropFrame, true)
        XCTAssertEqual(frameRate, ._29_97_drop)
    }
}

#endif
