//
//  Codable Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//

#if shouldTestCurrentPlatform

import XCTest
@testable import TimecodeKit

class Timecode_UT_Codable_Tests: XCTestCase {
    
    override func setUp() { }
    override func tearDown() { }
    
    func testTimecode_Codable() throws {
        
        // set up JSON coders with default settings
        
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        try Timecode.FrameRate.allCases.forEach {
            
            // set up a timecode object that has all non-defaults
            
            let tc = try "1 12:34:56:11.85"
                .toTimecode(at: $0,
                            limit: ._100days,
                            base: ._100SubFrames,
                            format: [.showSubFrames])
            
            // encode
            
            let encoded = try encoder.encode(tc)
            
            // decode
            
            let decoded = try decoder.decode(Timecode.self, from: encoded)
            
            // compare original to reconstructed
            
            XCTAssertEqual(tc, decoded)
            
            XCTAssertEqual(tc.days, decoded.days)
            XCTAssertEqual(tc.hours, decoded.hours)
            XCTAssertEqual(tc.minutes, decoded.minutes)
            XCTAssertEqual(tc.seconds, decoded.seconds)
            XCTAssertEqual(tc.frames, decoded.frames)
            XCTAssertEqual(tc.frameRate, decoded.frameRate)
            XCTAssertEqual(tc.upperLimit, decoded.upperLimit)
            XCTAssertEqual(tc.subFramesBase, decoded.subFramesBase)
            XCTAssertEqual(tc.stringFormat, decoded.stringFormat)
            
        }
        
    }
    
}

#endif
