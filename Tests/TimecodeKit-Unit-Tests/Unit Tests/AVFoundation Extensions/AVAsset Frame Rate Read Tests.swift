//
//  AVAsset Frame Rate Read Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

// AVAssetReader is unavailable on watchOS so we can't support any AVAsset operations
#if canImport(AVFoundation) && !os(watchOS) && !os(visionOS)

import AVFoundation
@testable import TimecodeKit
import XCTest

final class AVAsset_FrameRateRead_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    // MARK: - TimecodeFrameRate
    
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    func testTimecodeFrameRate_23_976fps_A() async throws {
        let url = try TestResource.timecodeTrack_23_976_Start_00_00_00_00.url()
        let asset = AVAsset(url: url)
        let frameRate = try await asset.timecodeFrameRate()
        XCTAssertEqual(frameRate, .fps23_976)
    }
    
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    func testTimecodeFrameRate_23_976fps_B() async throws {
        let url = try TestResource.timecodeTrack_23_976_Start_00_58_40_00.url()
        let asset = AVAsset(url: url)
        let frameRate = try await asset.timecodeFrameRate()
        XCTAssertEqual(frameRate, .fps23_976)
    }
    
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    func testTimecodeFrameRate_24fps() async throws {
        let url = try TestResource.timecodeTrack_24_Start_00_58_40_00.url()
        let asset = AVAsset(url: url)
        let frameRate = try await asset.timecodeFrameRate()
        XCTAssertEqual(frameRate, .fps24)
    }
    
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    func testTimecodeFrameRate_29_97dropfps() async throws {
        let url = try TestResource.timecodeTrack_29_97d_Start_00_00_00_00.url()
        let asset = AVAsset(url: url)
        let frameRate = try await asset.timecodeFrameRate()
        
        let isTimecodeFrameRateDropFrame = try await asset.isTimecodeFrameRateDropFrame
        XCTAssert(isTimecodeFrameRateDropFrame == true)
        
        XCTAssertEqual(frameRate, .fps29_97d)
    }
    
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    func testTimecodeFrameRate_29_97fps() async throws {
        let url = try TestResource.videoTrack_29_97_Start_00_00_00_00.url()
        let asset = AVAsset(url: url)
        let frameRate = try await asset.timecodeFrameRate()
        
        let isTimecodeFrameRateDropFrame = try await asset.isTimecodeFrameRateDropFrame
        XCTAssertEqual(isTimecodeFrameRateDropFrame, false)
        
        XCTAssertEqual(frameRate, .fps29_97)
    }
    
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    func testTimecodeFrameRate_29_97fps_from2997i() async throws {
        let url = try TestResource.videoAndTimecodeTrack_29_97i_Start_00_00_00_00.url()
        let asset = AVAsset(url: url)
        let frameRate = try await asset.timecodeFrameRate()
        
        let isTimecodeFrameRateDropFrame = try await asset.isTimecodeFrameRateDropFrame
        XCTAssertEqual(isTimecodeFrameRateDropFrame, false)
        
        XCTAssertEqual(frameRate, .fps29_97)
    }
    
    // MARK: - VideoFrameRate
    
    /// Even though file has no video tracks, it infers video frame rate from the timecode track.
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    func testVideoFrameRate_23_98p_A() async throws {
        let url = try TestResource.timecodeTrack_23_976_Start_00_00_00_00.url()
        let asset = AVAsset(url: url)
        let frameRate = try await asset.videoFrameRate()
        XCTAssertEqual(frameRate, .fps23_98p)
    }
    
    /// Even though file has no video tracks, it infers video frame rate from the timecode track.
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    func testVideoFrameRate_23_98p_B() async throws {
        let url = try TestResource.timecodeTrack_23_976_Start_00_58_40_00.url()
        let asset = AVAsset(url: url)
        let frameRate = try await asset.videoFrameRate()
        XCTAssertEqual(frameRate, .fps23_98p)
    }
    
    /// Even though file has no video tracks, it infers video frame rate from the timecode track.
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    func testVideoFrameRate_24p() async throws {
        let url = try TestResource.timecodeTrack_24_Start_00_58_40_00.url()
        let asset = AVAsset(url: url)
        let frameRate = try await asset.videoFrameRate()
        XCTAssertEqual(frameRate, .fps24p)
    }
    
    /// Even though file has no video tracks, it infers video frame rate from the timecode track.
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    func testVideoFrameRate_29_97p_fromDrop() async throws {
        let url = try TestResource.timecodeTrack_29_97d_Start_00_00_00_00.url()
        let asset = AVAsset(url: url)
        let frameRate = try await asset.videoFrameRate()
        XCTAssertEqual(frameRate, .fps29_97p)
    }
    
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    func testVideoFrameRate_29_97i() async throws {
        let url = try TestResource.videoAndTimecodeTrack_29_97i_Start_00_00_00_00.url()
        let asset = AVAsset(url: url)
        let frameRate = try await asset.videoFrameRate()
        XCTAssertEqual(frameRate, .fps29_97i)
    }
    
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    func testVideoFrameRate_29_97p() async throws {
        let url = try TestResource.videoTrack_29_97_Start_00_00_00_00.url()
        let asset = AVAsset(url: url)
        let frameRate = try await asset.videoFrameRate()
        XCTAssertEqual(frameRate, .fps29_97p)
    }
    
    // MARK: - VideoFrameRate (VFR)
    
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    func testVideoFrameRate_25p_VFR_A() async throws {
        let url = try TestResource.videoTrack_25_VFR_1sec.url()
        let asset = AVAsset(url: url)
        let frameRate = try await asset.videoFrameRate()
        XCTAssertEqual(frameRate, .fps25p)
    }
    
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    func testVideoFrameRate_25p_VFR_B() async throws {
        let url = try TestResource.videoTrack_25_VFR_2sec.url()
        let asset = AVAsset(url: url)
        let frameRate = try await asset.videoFrameRate()
        XCTAssertEqual(frameRate, .fps25p)
    }
}

#endif
