//
//  Codable Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import TimecodeKitCore // do NOT import as @testable in this file
import XCTest

final class Timecode_Codable_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testTimecode_Codable() throws {
        // set up JSON coders with default settings
        
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        for item in TimecodeFrameRate.allCases {
            // set up a timecode object that has all non-defaults
            
            let tc = try Timecode(
                .string("1 12:34:56:11.85"),
                at: item,
                base: .max100SubFrames,
                limit: .max100Days
            )
            
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
