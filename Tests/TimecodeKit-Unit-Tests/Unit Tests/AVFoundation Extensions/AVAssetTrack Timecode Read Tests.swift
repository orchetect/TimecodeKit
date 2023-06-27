//
//  AVAssetTrack Timecode Read Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// AVAssetReader is unavailable on watchOS so we can't support any AVAsset operations
#if shouldTestCurrentPlatform && canImport(AVFoundation) && !os(watchOS) && !os(xrOS)

import XCTest
@testable import TimecodeKit
import AVFoundation

class AVAssetTrack_TimecodeRead_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    // MARK: - Start/Duration/End Timecode
    
    func testReadTimecodeRange_23_976fps() throws {
        let frameRate: TimecodeFrameRate = ._23_976
        let url = try TestResource.timecodeTrack_23_976_Start_00_58_40_00.url()
        let asset = AVAsset(url: url)
        let track = try XCTUnwrap(asset.tracks.first)
        
        let correctStart = try TCC().toTimecode(at: frameRate)
        let correctEnd = try TCC(m: 24, s: 10, f: 19, sf: 03)
            .toTimecode(at: frameRate, format: [.showSubFrames])
        
        // even though it's a timecode track, its timeRange property relates to overall timeline of the asset,
        // so its start is 0.
        
        // auto-detect frame rate
        do {
            let tcRange = try track.timecodeRange()
            XCTAssertEqual(tcRange.lowerBound, correctStart)
            XCTAssertEqual(tcRange.upperBound, correctEnd)
        }
        
        // manually supply frame rate
        do {
            let tcRange = try track.timecodeRange(at: frameRate)
            XCTAssertEqual(tcRange.lowerBound, correctStart)
            XCTAssertEqual(tcRange.upperBound, correctEnd)
        }
    }
    
    func testReadDurationTimecode_23_976fps() throws {
        let frameRate: TimecodeFrameRate = ._23_976
        let url = try TestResource.timecodeTrack_23_976_Start_00_58_40_00.url()
        let asset = AVAsset(url: url)
        let track = try XCTUnwrap(asset.tracks.first)
        
        // duration
        let correctDur = try TCC(m: 24, s: 10, f: 19, sf: 03)
            .toTimecode(at: frameRate, format: [.showSubFrames])
        
        // auto-detect frame rate
        XCTAssertEqual(try track.durationTimecode(), correctDur)
        // manually supply frame rate
        XCTAssertEqual(try track.durationTimecode(at: frameRate), correctDur)
    }
    
    func testReadDurationTimecode_29_97fps() throws {
        let frameRate: TimecodeFrameRate = ._29_97
        let url = try TestResource.videoTrack_29_97_Start_00_00_00_00.url()
        let asset = AVAsset(url: url)
        let track = try XCTUnwrap(asset.tracks.first)
        
        // duration
        let correctDur = try TCC(s: 10)
            .toTimecode(at: frameRate, format: [.showSubFrames])
        
        // auto-detect frame rate
        XCTAssertEqual(try track.durationTimecode(), correctDur)
        // manually supply frame rate
        XCTAssertEqual(try track.durationTimecode(at: frameRate), correctDur)
    }
}

#endif
