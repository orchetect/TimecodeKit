//
//  AVAsset Frame Rate Read Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// AVAssetReader is unavailable on watchOS so we can't support any AVAsset operations
#if shouldTestCurrentPlatform && canImport(AVFoundation) && !os(watchOS) && !os(xrOS)

import XCTest
@testable import TimecodeKit
import AVFoundation

class AVAsset_FrameRateRead_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    // MARK: - TimecodeFrameRate
    
    func testTimecodeFrameRate_23_976fps_A() throws {
        let url = try TestResource.timecodeTrack_23_976_Start_00_00_00_00.url()
        let asset = AVAsset(url: url)
        let frameRate = try asset.timecodeFrameRate()
        XCTAssertEqual(frameRate, ._23_976)
    }
    
    func testTimecodeFrameRate_23_976fps_B() throws {
        let url = try TestResource.timecodeTrack_23_976_Start_00_58_40_00.url()
        let asset = AVAsset(url: url)
        let frameRate = try asset.timecodeFrameRate()
        XCTAssertEqual(frameRate, ._23_976)
    }
    
    func testTimecodeFrameRate_24fps() throws {
        let url = try TestResource.timecodeTrack_24_Start_00_58_40_00.url()
        let asset = AVAsset(url: url)
        let frameRate = try asset.timecodeFrameRate()
        XCTAssertEqual(frameRate, ._24)
    }
    
    func testTimecodeFrameRate_29_97dropfps() throws {
        let url = try TestResource.timecodeTrack_29_97d_Start_00_00_00_00.url()
        let asset = AVAsset(url: url)
        let frameRate = try asset.timecodeFrameRate()
        XCTAssertEqual(asset.isTimecodeFrameRateDropFrame, true)
        XCTAssertEqual(frameRate, ._29_97_drop)
    }
    
    func testTimecodeFrameRate_29_97fps() throws {
        let url = try TestResource.videoTrack_29_97_Start_00_00_00_00.url()
        let asset = AVAsset(url: url)
        let frameRate = try asset.timecodeFrameRate()
        XCTAssertEqual(asset.isTimecodeFrameRateDropFrame, false)
        XCTAssertEqual(frameRate, ._29_97)
    }
    
    func testTimecodeFrameRate_29_97fps_from2997i() throws {
        let url = try TestResource.videoAndTimecodeTrack_29_97i_Start_00_00_00_00.url()
        let asset = AVAsset(url: url)
        let frameRate = try asset.timecodeFrameRate()
        XCTAssertEqual(asset.isTimecodeFrameRateDropFrame, false)
        XCTAssertEqual(frameRate, ._29_97)
    }
    
    // MARK: - VideoFrameRate
    
    /// Even though file has no video tracks, it infers video frame rate from the timecode track.
    func testVideoFrameRate_23_98p_A() throws {
        let url = try TestResource.timecodeTrack_23_976_Start_00_00_00_00.url()
        let asset = AVAsset(url: url)
        let frameRate = try asset.videoFrameRate()
        XCTAssertEqual(frameRate, ._23_98p)
    }
    
    /// Even though file has no video tracks, it infers video frame rate from the timecode track.
    func testVideoFrameRate_23_98p_B() throws {
        let url = try TestResource.timecodeTrack_23_976_Start_00_58_40_00.url()
        let asset = AVAsset(url: url)
        let frameRate = try asset.videoFrameRate()
        XCTAssertEqual(frameRate, ._23_98p)
    }
    
    /// Even though file has no video tracks, it infers video frame rate from the timecode track.
    func testVideoFrameRate_24p() throws {
        let url = try TestResource.timecodeTrack_24_Start_00_58_40_00.url()
        let asset = AVAsset(url: url)
        let frameRate = try asset.videoFrameRate()
        XCTAssertEqual(frameRate, ._24p)
    }
    
    /// Even though file has no video tracks, it infers video frame rate from the timecode track.
    func testVideoFrameRate_29_97p_fromDrop() throws {
        let url = try TestResource.timecodeTrack_29_97d_Start_00_00_00_00.url()
        let asset = AVAsset(url: url)
        let frameRate = try asset.videoFrameRate()
        XCTAssertEqual(frameRate, ._29_97p)
    }
    
    func testVideoFrameRate_29_97i() throws {
        let url = try TestResource.videoAndTimecodeTrack_29_97i_Start_00_00_00_00.url()
        let asset = AVAsset(url: url)
        let frameRate = try asset.videoFrameRate()
        XCTAssertEqual(frameRate, ._29_97i)
    }
    
    func testVideoFrameRate_29_97p() throws {
        let url = try TestResource.videoTrack_29_97_Start_00_00_00_00.url()
        let asset = AVAsset(url: url)
        let frameRate = try asset.videoFrameRate()
        XCTAssertEqual(frameRate, ._29_97p)
    }
    
    // MARK: - VideoFrameRate (VFR)
    
    func testVideoFrameRate_25p_VFR_A() throws {
        let url = try TestResource.videoTrack_25_VFR_1sec.url()
        let asset = AVAsset(url: url)
        let frameRate = try asset.videoFrameRate()
        XCTAssertEqual(frameRate, ._25p)
    }
    
    func testVideoFrameRate_25p_VFR_B() throws {
        let url = try TestResource.videoTrack_25_VFR_2sec.url()
        let asset = AVAsset(url: url)
        let frameRate = try asset.videoFrameRate()
        XCTAssertEqual(frameRate, ._25p)
    }
}

#endif
