//
//  Component Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import TimecodeKit
import XCTest

final class Timecode_Component_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    fileprivate typealias C = Timecode.Component
    
    // MARK: - Next
    
    func testNext_HHMMSSFF() throws {
        XCTAssertEqual(C.days     .next(excluding: [.days, .subFrames]), .hours)
        XCTAssertEqual(C.hours    .next(excluding: [.days, .subFrames]), .minutes)
        XCTAssertEqual(C.minutes  .next(excluding: [.days, .subFrames]), .seconds)
        XCTAssertEqual(C.seconds  .next(excluding: [.days, .subFrames]), .frames)
        XCTAssertEqual(C.frames   .next(excluding: [.days, .subFrames]), .hours)
        XCTAssertEqual(C.subFrames.next(excluding: [.days, .subFrames]), .hours)
    }
    
    func testNext_HHMMSSFFXX() throws {
        XCTAssertEqual(C.days     .next(excluding: [.days]), .hours)
        XCTAssertEqual(C.hours    .next(excluding: [.days]), .minutes)
        XCTAssertEqual(C.minutes  .next(excluding: [.days]), .seconds)
        XCTAssertEqual(C.seconds  .next(excluding: [.days]), .frames)
        XCTAssertEqual(C.frames   .next(excluding: [.days]), .subFrames)
        XCTAssertEqual(C.subFrames.next(excluding: [.days]), .hours)
    }
    
    func testNext_DDHHMMSSFF() throws {
        XCTAssertEqual(C.days     .next(excluding: [.subFrames]), .hours)
        XCTAssertEqual(C.hours    .next(excluding: [.subFrames]), .minutes)
        XCTAssertEqual(C.minutes  .next(excluding: [.subFrames]), .seconds)
        XCTAssertEqual(C.seconds  .next(excluding: [.subFrames]), .frames)
        XCTAssertEqual(C.frames   .next(excluding: [.subFrames]), .days)
        XCTAssertEqual(C.subFrames.next(excluding: [.subFrames]), .days)
    }
    
    func testNext_DDHHMMSSFFXX() throws {
        XCTAssertEqual(C.days     .next(excluding: []), .hours)
        XCTAssertEqual(C.hours    .next(excluding: []), .minutes)
        XCTAssertEqual(C.minutes  .next(excluding: []), .seconds)
        XCTAssertEqual(C.seconds  .next(excluding: []), .frames)
        XCTAssertEqual(C.frames   .next(excluding: []), .subFrames)
        XCTAssertEqual(C.subFrames.next(excluding: []), .days)
    }
    
    // MARK: - Previous
    
    func testPrevious_HHMMSSFF() throws {
        XCTAssertEqual(C.days     .previous(excluding: [.days, .subFrames]), .frames)
        XCTAssertEqual(C.hours    .previous(excluding: [.days, .subFrames]), .frames)
        XCTAssertEqual(C.minutes  .previous(excluding: [.days, .subFrames]), .hours)
        XCTAssertEqual(C.seconds  .previous(excluding: [.days, .subFrames]), .minutes)
        XCTAssertEqual(C.frames   .previous(excluding: [.days, .subFrames]), .seconds)
        XCTAssertEqual(C.subFrames.previous(excluding: [.days, .subFrames]), .frames)
    }
    
    func testPrevious_HHMMSSFFXX() throws {
        XCTAssertEqual(C.days     .previous(excluding: [.days]), .subFrames)
        XCTAssertEqual(C.hours    .previous(excluding: [.days]), .subFrames)
        XCTAssertEqual(C.minutes  .previous(excluding: [.days]), .hours)
        XCTAssertEqual(C.seconds  .previous(excluding: [.days]), .minutes)
        XCTAssertEqual(C.frames   .previous(excluding: [.days]), .seconds)
        XCTAssertEqual(C.subFrames.previous(excluding: [.days]), .frames)
    }
    
    func testPrevious_DDHHMMSSFF() throws {
        XCTAssertEqual(C.days     .previous(excluding: [.subFrames]), .frames)
        XCTAssertEqual(C.hours    .previous(excluding: [.subFrames]), .days)
        XCTAssertEqual(C.minutes  .previous(excluding: [.subFrames]), .hours)
        XCTAssertEqual(C.seconds  .previous(excluding: [.subFrames]), .minutes)
        XCTAssertEqual(C.frames   .previous(excluding: [.subFrames]), .seconds)
        XCTAssertEqual(C.subFrames.previous(excluding: [.subFrames]), .frames)
    }
    
    func testPrevious_DDHHMMSSFFXX() throws {
        XCTAssertEqual(C.days     .previous(excluding: []), .subFrames)
        XCTAssertEqual(C.hours    .previous(excluding: []), .days)
        XCTAssertEqual(C.minutes  .previous(excluding: []), .hours)
        XCTAssertEqual(C.seconds  .previous(excluding: []), .minutes)
        XCTAssertEqual(C.frames   .previous(excluding: []), .seconds)
        XCTAssertEqual(C.subFrames.previous(excluding: []), .frames)
    }
}

#endif
