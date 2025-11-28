//
//  AVAssetTrack Timecode Read Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

// AVAssetReader is unavailable on watchOS so we can't support any AVAsset operations
#if canImport(AVFoundation) && !os(watchOS) && !os(visionOS)

import AVFoundation
@testable import SwiftTimecodeAV
import XCTest

final class AVAssetTrack_TimecodeRead_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    // MARK: - Start/Duration/End Timecode
    
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    func testReadTimecodeRange_23_976fps() async throws {
        let frameRate: TimecodeFrameRate = .fps23_976
        let url = try TestResource.timecodeTrack_23_976_Start_00_58_40_00.url()
        let asset = AVAsset(url: url)
        let loadTrack = try await getFirstTrack(of: asset)
        let track = try XCTUnwrap(loadTrack)
        
        let correctStart = Timecode(.zero, at: frameRate)
        let correctEnd = try Timecode(.components(m: 24, s: 10, f: 19, sf: 03), at: frameRate)
        
        // even though it's a timecode track, its timeRange property relates to overall timeline of the asset,
        // so its start is 0.
        
        // auto-detect frame rate
        do {
            let tcRange = try await track.timecodeRange()
            XCTAssertEqual(tcRange.lowerBound, correctStart)
            XCTAssertEqual(tcRange.upperBound, correctEnd)
        }
        
        // manually supply frame rate
        do {
            let tcRange = try await track.timecodeRange(at: frameRate)
            XCTAssertEqual(tcRange.lowerBound, correctStart)
            XCTAssertEqual(tcRange.upperBound, correctEnd)
        }
    }
    
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    func testReadDurationTimecode_23_976fps() async throws {
        let frameRate: TimecodeFrameRate = .fps23_976
        let url = try TestResource.timecodeTrack_23_976_Start_00_58_40_00.url()
        let asset = AVAsset(url: url)
        let loadTrack = try await getFirstTrack(of: asset)
        let track = try XCTUnwrap(loadTrack)
        
        // duration
        let correctDur = try Timecode(.components(m: 24, s: 10, f: 19, sf: 03), at: frameRate)
        
        // auto-detect frame rate
        let durationTimecode = try await track.durationTimecode()
        XCTAssertEqual(durationTimecode, correctDur)
        // manually supply frame rate
        let durationTimecodeAtFR = try await track.durationTimecode(at: frameRate)
        XCTAssertEqual(durationTimecodeAtFR, correctDur)
    }
    
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    func testReadDurationTimecode_29_97fps() async throws {
        let frameRate: TimecodeFrameRate = .fps29_97
        let url = try TestResource.videoTrack_29_97_Start_00_00_00_00.url()
        let asset = AVAsset(url: url)
        let loadTrack = try await getFirstTrack(of: asset)
        let track = try XCTUnwrap(loadTrack)
        
        // duration
        let correctDur = try Timecode(.components(s: 10), at: frameRate)
        
        // auto-detect frame rate
        let durationTimecode = try await track.durationTimecode()
        XCTAssertEqual(durationTimecode, correctDur)
        // manually supply frame rate
        let durationTimecodeAtFR = try await track.durationTimecode(at: frameRate)
        XCTAssertEqual(durationTimecodeAtFR, correctDur)
    }
}

// MARK: - Utils

extension AVAssetTrack_TimecodeRead_Tests {
    // /// Wrapper to load asset's first track depending on OS version.
    // @available(macOS 10.15, iOS 13, *)
    // func getFirstTrack(of asset: AVAsset) async throws -> AVAssetTrack {
    //     let maybeTrack = try await {
    //         if #available(macOS 12, iOS 15, tvOS 15, watchOS 8, *) {
    //             return try await asset.load(.tracks).first
    //         } else {
    //             return asset.tracks.first
    //         }
    //     }()
    //     return try XCTUnwrap(maybeTrack)
    // }
    
    /// Wrapper to load asset's first track depending on OS version.
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    func getFirstTrack(of asset: AVAsset) async throws -> AVAssetTrack {
        let tracks = try await asset.load(.tracks)
        let track = try XCTUnwrap(tracks.first)
        return track
    }
}
#endif
