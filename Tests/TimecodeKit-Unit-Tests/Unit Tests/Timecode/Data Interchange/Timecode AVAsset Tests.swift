//
//  Timecode AVAsset Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// AVAssetReader is unavailable on watchOS so we can't support any AVAsset operations
#if shouldTestCurrentPlatform && canImport(AVFoundation) && !os(watchOS)

import XCTest
@testable import TimecodeKit
import AVFoundation

class Timecode_AVAsset_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    // NOTE:
    // These tests are just to verify baseline results using this API on `Timecode`.
    // More extensive AVAsset parsing tests are in AVAsset Extensions Tests.swift
    
    func testTimecode_init_startOfAsset() throws {
        let url = try TestResource.timecodeTrack_23_976_Start_00_58_40_00.url()
        let asset = AVAsset(url: url)
        
        let timecode = try Timecode(startOf: asset, format: [.showSubFrames])
        XCTAssertEqual(timecode.components, TCC(m: 58, s: 40))
        XCTAssertEqual(timecode.frameRate, ._23_976)
    }
    
    func testTimecode_init_durationOfAsset() throws {
        let url = try TestResource.timecodeTrack_23_976_Start_00_58_40_00.url()
        let asset = AVAsset(url: url)
        
        let timecode = try Timecode(durationOf: asset, format: [.showSubFrames])
        XCTAssertEqual(timecode.components, TCC(m: 24, s: 10, f: 19, sf: 03))
        XCTAssertEqual(timecode.frameRate, ._23_976)
    }
    
    func testTimecode_init_endOfAsset() throws {
        let url = try TestResource.timecodeTrack_23_976_Start_00_58_40_00.url()
        let asset = AVAsset(url: url)
        
        let timecode = try Timecode(endOf: asset, format: [.showSubFrames])
        XCTAssertEqual(timecode.components, TCC(h: 1, m: 22, s: 50, f: 19, sf: 03))
        XCTAssertEqual(timecode.frameRate, ._23_976)
    }
}

#endif
