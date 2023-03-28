//
//  Codable Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import TimecodeKit

class Timecode_Codable_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testTimecode_Codable() throws {
        // set up JSON coders with default settings
        
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        try TimecodeFrameRate.allCases.forEach {
            // set up a timecode object that has all non-defaults
            
            let tc = try "1 12:34:56:11.85".timecode(using: .init(
                rate: $0,
                base: ._100SubFrames,
                limit: ._100days
            ))
            
            // encode
            
            let encoded = try encoder.encode(tc)
            
            // decode
            
            let decoded = try decoder.decode(Timecode.self, from: encoded)
            
            // compare original to reconstructed
            
            XCTAssertEqual(tc, decoded)
            
            XCTAssertEqual(tc.components, decoded.components)
            XCTAssertEqual(tc.properties, decoded.properties)
            // XCTAssertEqual(tc.stringFormat, decoded.stringFormat) // deprecated in TimecodeKit 2.0
        }
    }
}

#endif
