//
//  FeetAndFrames Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

@testable import TimecodeKit
import XCTest

class FeetAndFrames_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testStringValue() {
        XCTAssertEqual(FeetAndFrames(feet: 0, frames: 0).stringValue, "0+00")
        XCTAssertEqual(FeetAndFrames(feet: 0, frames: 1).stringValue, "0+01")
        XCTAssertEqual(FeetAndFrames(feet: 1, frames: 0).stringValue, "1+00")
        XCTAssertEqual(FeetAndFrames(feet: 10, frames: 0).stringValue, "10+00")
        XCTAssertEqual(FeetAndFrames(feet: 100, frames: 14).stringValue, "100+14")
        
        // edge cases
        XCTAssertEqual(FeetAndFrames(feet: 100, frames: 150).stringValue, "100+150")
    }
    
    func testStringValueVerbose() {
        XCTAssertEqual(FeetAndFrames(feet: 0, frames: 0).stringValueVerbose, "0+00.00")
        XCTAssertEqual(FeetAndFrames(feet: 0, frames: 1).stringValueVerbose, "0+01.00")
        XCTAssertEqual(FeetAndFrames(feet: 1, frames: 0).stringValueVerbose, "1+00.00")
        XCTAssertEqual(FeetAndFrames(feet: 10, frames: 0).stringValueVerbose, "10+00.00")
        XCTAssertEqual(FeetAndFrames(feet: 100, frames: 14).stringValueVerbose, "100+14.00")
        
        XCTAssertEqual(FeetAndFrames(feet: 0, frames: 0, subFrames: 1).stringValueVerbose, "0+00.01")
        XCTAssertEqual(FeetAndFrames(feet: 0, frames: 1, subFrames: 1).stringValueVerbose, "0+01.01")
        XCTAssertEqual(FeetAndFrames(feet: 1, frames: 0, subFrames: 1).stringValueVerbose, "1+00.01")
        XCTAssertEqual(FeetAndFrames(feet: 10, frames: 0, subFrames: 24).stringValueVerbose, "10+00.24")
        
        // edge cases
        XCTAssertEqual(FeetAndFrames(feet: 100, frames: 14, subFrames: 150).stringValueVerbose, "100+14.150")
    }
    
    func testFrameCount() throws {
        try TimecodeFrameRate.allCases.forEach { frate in
            let tc10Hours = try Timecode(.components(h: 10), at: frate)
            let ff = tc10Hours.feetAndFramesValue
            XCTAssertEqual(ff.frameCount, tc10Hours.frameCount)
        }
    }
}

#endif
