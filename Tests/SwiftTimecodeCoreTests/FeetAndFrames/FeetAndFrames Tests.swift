//
//  FeetAndFrames Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftTimecodeCore
import XCTest

final class FeetAndFrames_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testInitString() throws {
        // expected formatting
        
        XCTAssertEqual(try FeetAndFrames("0+00").stringValue, "0+00")
        XCTAssertEqual(try FeetAndFrames("0+01").stringValue, "0+01")
        XCTAssertEqual(try FeetAndFrames("1+00").stringValue, "1+00")
        XCTAssertEqual(try FeetAndFrames("10+00").stringValue, "10+00")
        XCTAssertEqual(try FeetAndFrames("100+14").stringValue, "100+14")
        XCTAssertEqual(try FeetAndFrames("100+150").stringValue, "100+150")
        
        XCTAssertEqual(try FeetAndFrames("0+00.00").stringValueVerbose, "0+00.00")
        XCTAssertEqual(try FeetAndFrames("0+01.00").stringValueVerbose, "0+01.00")
        XCTAssertEqual(try FeetAndFrames("1+00.00").stringValueVerbose, "1+00.00")
        XCTAssertEqual(try FeetAndFrames("10+00.00").stringValueVerbose, "10+00.00")
        XCTAssertEqual(try FeetAndFrames("100+14.00").stringValueVerbose, "100+14.00")
        XCTAssertEqual(try FeetAndFrames("0+00.01").stringValueVerbose, "0+00.01")
        XCTAssertEqual(try FeetAndFrames("0+01.01").stringValueVerbose, "0+01.01")
        XCTAssertEqual(try FeetAndFrames("1+00.01").stringValueVerbose, "1+00.01")
        XCTAssertEqual(try FeetAndFrames("10+00.24").stringValueVerbose, "10+00.24")
        XCTAssertEqual(try FeetAndFrames("100+14.150").stringValueVerbose, "100+14.150")
        
        // loose formatting
        
        XCTAssertEqual(try FeetAndFrames("1+2").stringValue, "1+02")
        XCTAssertEqual(try FeetAndFrames("01+2").stringValue, "1+02")
        XCTAssertEqual(try FeetAndFrames("1+02").stringValue, "1+02")
        XCTAssertEqual(try FeetAndFrames("01+02").stringValue, "1+02")
        XCTAssertEqual(try FeetAndFrames("001+002").stringValue, "1+02")
        
        // edge cases
        
        XCTAssertThrowsError(try FeetAndFrames("+"))
        XCTAssertThrowsError(try FeetAndFrames("0+"))
        XCTAssertThrowsError(try FeetAndFrames("+0"))
        XCTAssertThrowsError(try FeetAndFrames("0++0"))
        XCTAssertThrowsError(try FeetAndFrames("0++00"))
        XCTAssertThrowsError(try FeetAndFrames("0+00."))
        XCTAssertThrowsError(try FeetAndFrames("0+."))
        XCTAssertThrowsError(try FeetAndFrames("0+.0"))
        XCTAssertThrowsError(try FeetAndFrames("+.0"))
        XCTAssertThrowsError(try FeetAndFrames("Z+ZZ"))
        XCTAssertThrowsError(try FeetAndFrames("Z+ZZ.ZZ"))
        XCTAssertThrowsError(try FeetAndFrames("1+ZZ"))
        XCTAssertThrowsError(try FeetAndFrames("Z+02"))
        XCTAssertThrowsError(try FeetAndFrames("1+ZZ.ZZ"))
        XCTAssertThrowsError(try FeetAndFrames("Z+02.ZZ"))
    }
    
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
        for frate in TimecodeFrameRate.allCases {
            let tc10Hours = try Timecode(.components(h: 10), at: frate)
            let ff = tc10Hours.feetAndFramesValue
            XCTAssertEqual(ff.frameCount, tc10Hours.frameCount)
        }
    }
}
