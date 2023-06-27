//
//  AVFoundation Utils Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2023 Steffan Andrews • Licensed under MIT License
//

// AVAssetReader is unavailable on watchOS so we can't support any AVAsset operations
#if shouldTestCurrentPlatform && canImport(AVFoundation) && !os(watchOS) && !os(xrOS)

import XCTest
@testable import TimecodeKit
import AVFoundation

class AVFoundationUtils_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testCMTimeRange_timecodeRange() throws {
        let s10 = CMTime(seconds: 10, preferredTimescale: 600)
        let s9 = CMTime(seconds: 9, preferredTimescale: 600)
        
        // valid
        
        XCTAssertEqual(
            try CMTimeRange(start: s10, end: s10).timecodeRange(at: ._30),
            try Timecode(.components(s: 10), at: ._30) ... Timecode(.components(s: 10), at: ._30)
        )
        
        XCTAssertEqual(
            try CMTimeRange(start: s10, duration: s10).timecodeRange(at: ._30),
            try Timecode(.components(s: 10), at: ._30) ... Timecode(.components(s: 20), at: ._30)
        )
        
        // invalid
        
        XCTAssertThrowsError(
            try CMTimeRange(start: s10, end: s9).timecodeRange(at: ._30)
        )
    }
}

#endif
