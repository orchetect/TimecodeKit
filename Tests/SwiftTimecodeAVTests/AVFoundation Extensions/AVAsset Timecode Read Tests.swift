//
//  AVAsset Timecode Read Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

// AVAssetReader is unavailable on watchOS so we can't support any AVAsset operations
#if canImport(AVFoundation) && !os(watchOS) && !os(visionOS)

import AVFoundation
@testable import SwiftTimecodeAV
import XCTest

final class AVAsset_TimecodeRead_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    // MARK: - Start Elapsed Frames
    
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    func testReadTimecodeSamples_23_976_A() async throws {
        let url = try TestResource.timecodeTrack_23_976_Start_00_00_00_00.url()
        let asset = AVAsset(url: url)
        let startFrames = try await asset.readTimecodeSamples() as! [[CMTimeCode32]]
        
        XCTAssertEqual(startFrames, [[CMTimeCode32(frameNumber: 0)]])
    }
    
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    func testReadTimecodeSamples_23_976_B() async throws {
        let url = try TestResource.timecodeTrack_23_976_Start_00_58_40_00.url()
        let asset = AVAsset(url: url)
        let startFrames = try await asset.readTimecodeSamples() as! [[CMTimeCode32]]
        
        XCTAssertEqual(startFrames, [[CMTimeCode32(frameNumber: 84480)]])
    }
    
    // MARK: - Start/Duration/End Timecode
    
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    func testReadTimecodes_23_976fps() async throws {
        let frameRate: TimecodeFrameRate = .fps23_976
        let url = try TestResource.timecodeTrack_23_976_Start_00_58_40_00.url()
        let asset = AVAsset(url: url)
        
        // start
        let correctStart = try Timecode(.components(m: 58, s: 40), at: frameRate)
        // auto-detect frame rate
        let startTimecode = try await asset.startTimecode()
        XCTAssertEqual(startTimecode, correctStart)
        // manually supply frame rate
        let startTimecodeAtFR = try await asset.startTimecode(at: frameRate)
        XCTAssertEqual(startTimecodeAtFR, correctStart)
        
        // duration
        let correctDur = try Timecode(.components(m: 24, s: 10, f: 19, sf: 03), at: frameRate)
        // auto-detect frame rate
        let durationTimecode = try await asset.durationTimecode()
        XCTAssertEqual(durationTimecode, correctDur)
        // manually supply frame rate
        let durationTimecodeAtFR = try await asset.durationTimecode(at: frameRate)
        XCTAssertEqual(durationTimecodeAtFR, correctDur)
        
        // end
        let correctEnd = try Timecode(.components(h: 1, m: 22, s: 50, f: 19, sf: 03), at: frameRate)
        // auto-detect frame rate
        let endTimecode = try await asset.endTimecode()
        XCTAssertEqual(endTimecode, correctEnd)
        // manually supply frame rate
        let endTimecodeAtFR = try await asset.endTimecode(at: frameRate)
        XCTAssertEqual(endTimecodeAtFR, correctEnd)
    }
    
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    func testReadTimecodes_24fps() async throws {
        let frameRate: TimecodeFrameRate = .fps24
        let url = try TestResource.timecodeTrack_24_Start_00_58_40_00.url()
        let asset = AVAsset(url: url)
        
        // start
        let correctStart = try Timecode(.components(m: 58, s: 40), at: frameRate)
        // auto-detect frame rate
        let startTimecode = try await asset.startTimecode()
        XCTAssertEqual(startTimecode, correctStart)
        // manually supply frame rate
        let startTimecodeAtFR = try await asset.startTimecode(at: frameRate)
        XCTAssertEqual(startTimecodeAtFR, correctStart)
        
        // duration
        let correctDur = try Timecode(.components(m: 24, s: 12, f: 05, sf: 85), at: frameRate)
        // auto-detect frame rate
        let durationTimecode = try await asset.durationTimecode()
        XCTAssertEqual(durationTimecode, correctDur)
        // manually supply frame rate
        let durationTimecodeAtFR = try await asset.durationTimecode(at: frameRate)
        XCTAssertEqual(durationTimecodeAtFR, correctDur)
        
        // end
        let correctEnd = try Timecode(.components(h: 1, m: 22, s: 52, f: 05, sf: 85), at: frameRate)
        // auto-detect frame rate
        let endTimecode = try await asset.endTimecode()
        XCTAssertEqual(endTimecode, correctEnd)
        // manually supply frame rate
        let endTimecodeAtFR = try await asset.endTimecode(at: frameRate)
        XCTAssertEqual(endTimecodeAtFR, correctEnd)
    }
    
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    func testReadTimecodes_29_97fps() async throws {
        let frameRate: TimecodeFrameRate = .fps29_97
        let url = try TestResource.videoTrack_29_97_Start_00_00_00_00.url()
        let asset = AVAsset(url: url)
        
        // start
        // no start timecode can be derived from this video file
        // auto-detect frame rate
        let startTimecode = try await asset.startTimecode()
        XCTAssertEqual(startTimecode, nil)
        // manually supply frame rate
        let startTimecodeAtFR = try await asset.startTimecode(at: frameRate)
        XCTAssertEqual(startTimecodeAtFR, nil)
        
        // duration
        let correctDur = try Timecode(.components(s: 10), at: frameRate)
        // auto-detect frame rate
        let durationTimecode = try await asset.durationTimecode()
        XCTAssertEqual(durationTimecode, correctDur)
        // manually supply frame rate
        let durationTimecodeAtFR = try await asset.durationTimecode(at: frameRate)
        XCTAssertEqual(durationTimecodeAtFR, correctDur)
        
        // end
        // no start timecode can be derived from this video file
        // auto-detect frame rate
        let endTimecode = try await asset.endTimecode()
        XCTAssertEqual(endTimecode, nil)
        // manually supply frame rate
        let endTimecodeAtFR = try await asset.endTimecode(at: frameRate)
        XCTAssertEqual(endTimecodeAtFR, nil)
    }
}

#endif
