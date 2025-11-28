//
//  Component Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftTimecodeCore
import XCTest

final class Timecode_Component_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    fileprivate typealias C = Timecode.Component
    
    // MARK: - Comparable
    
    func testComparable() {
        // baseline
        
        XCTAssertTrue(C.days < C.hours)
        XCTAssertTrue(C.hours < C.minutes)
        XCTAssertTrue(C.minutes < C.seconds)
        XCTAssertTrue(C.seconds < C.frames)
        XCTAssertTrue(C.frames < C.subFrames)
        
        XCTAssertTrue(C.hours > C.days)
        XCTAssertTrue(C.minutes > C.hours)
        XCTAssertTrue(C.seconds > C.minutes)
        XCTAssertTrue(C.frames > C.seconds)
        XCTAssertTrue(C.subFrames > C.frames)
        
        // exhaustive
        
        XCTAssertFalse(C.days < C.days)
        XCTAssertTrue(C.days < C.hours)
        XCTAssertTrue(C.days < C.minutes)
        XCTAssertTrue(C.days < C.seconds)
        XCTAssertTrue(C.days < C.frames)
        XCTAssertTrue(C.days < C.subFrames)
        
        XCTAssertFalse(C.hours < C.days)
        XCTAssertFalse(C.hours < C.hours)
        XCTAssertTrue(C.hours < C.minutes)
        XCTAssertTrue(C.hours < C.seconds)
        XCTAssertTrue(C.hours < C.frames)
        XCTAssertTrue(C.hours < C.subFrames)
        
        XCTAssertFalse(C.minutes < C.days)
        XCTAssertFalse(C.minutes < C.hours)
        XCTAssertFalse(C.minutes < C.minutes)
        XCTAssertTrue(C.minutes < C.seconds)
        XCTAssertTrue(C.minutes < C.frames)
        XCTAssertTrue(C.minutes < C.subFrames)
        
        XCTAssertFalse(C.seconds < C.days)
        XCTAssertFalse(C.seconds < C.hours)
        XCTAssertFalse(C.seconds < C.minutes)
        XCTAssertFalse(C.seconds < C.seconds)
        XCTAssertTrue(C.seconds < C.frames)
        XCTAssertTrue(C.seconds < C.subFrames)
        
        XCTAssertFalse(C.frames < C.days)
        XCTAssertFalse(C.frames < C.hours)
        XCTAssertFalse(C.frames < C.minutes)
        XCTAssertFalse(C.frames < C.seconds)
        XCTAssertFalse(C.frames < C.frames)
        XCTAssertTrue(C.frames < C.subFrames)
        
        XCTAssertFalse(C.subFrames < C.days)
        XCTAssertFalse(C.subFrames < C.hours)
        XCTAssertFalse(C.subFrames < C.minutes)
        XCTAssertFalse(C.subFrames < C.seconds)
        XCTAssertFalse(C.subFrames < C.frames)
        XCTAssertFalse(C.subFrames < C.subFrames)
    }
    
    // MARK: - Next
    
    func testNext_HHMMSSFF() throws {
        XCTAssertEqual(C.days.next(excluding: [.days, .subFrames]), .hours)
        XCTAssertEqual(C.hours.next(excluding: [.days, .subFrames]), .minutes)
        XCTAssertEqual(C.minutes.next(excluding: [.days, .subFrames]), .seconds)
        XCTAssertEqual(C.seconds.next(excluding: [.days, .subFrames]), .frames)
        XCTAssertEqual(C.frames.next(excluding: [.days, .subFrames]), .hours)
        XCTAssertEqual(C.subFrames.next(excluding: [.days, .subFrames]), .hours)
    }
    
    func testNext_HHMMSSFFXX() throws {
        XCTAssertEqual(C.days.next(excluding: [.days]), .hours)
        XCTAssertEqual(C.hours.next(excluding: [.days]), .minutes)
        XCTAssertEqual(C.minutes.next(excluding: [.days]), .seconds)
        XCTAssertEqual(C.seconds.next(excluding: [.days]), .frames)
        XCTAssertEqual(C.frames.next(excluding: [.days]), .subFrames)
        XCTAssertEqual(C.subFrames.next(excluding: [.days]), .hours)
    }
    
    func testNext_DDHHMMSSFF() throws {
        XCTAssertEqual(C.days.next(excluding: [.subFrames]), .hours)
        XCTAssertEqual(C.hours.next(excluding: [.subFrames]), .minutes)
        XCTAssertEqual(C.minutes.next(excluding: [.subFrames]), .seconds)
        XCTAssertEqual(C.seconds.next(excluding: [.subFrames]), .frames)
        XCTAssertEqual(C.frames.next(excluding: [.subFrames]), .days)
        XCTAssertEqual(C.subFrames.next(excluding: [.subFrames]), .days)
    }
    
    func testNext_DDHHMMSSFFXX() throws {
        XCTAssertEqual(C.days.next(excluding: []), .hours)
        XCTAssertEqual(C.hours.next(excluding: []), .minutes)
        XCTAssertEqual(C.minutes.next(excluding: []), .seconds)
        XCTAssertEqual(C.seconds.next(excluding: []), .frames)
        XCTAssertEqual(C.frames.next(excluding: []), .subFrames)
        XCTAssertEqual(C.subFrames.next(excluding: []), .days)
    }
    
    // MARK: - Previous
    
    func testPrevious_HHMMSSFF() throws {
        XCTAssertEqual(C.days.previous(excluding: [.days, .subFrames]), .frames)
        XCTAssertEqual(C.hours.previous(excluding: [.days, .subFrames]), .frames)
        XCTAssertEqual(C.minutes.previous(excluding: [.days, .subFrames]), .hours)
        XCTAssertEqual(C.seconds.previous(excluding: [.days, .subFrames]), .minutes)
        XCTAssertEqual(C.frames.previous(excluding: [.days, .subFrames]), .seconds)
        XCTAssertEqual(C.subFrames.previous(excluding: [.days, .subFrames]), .frames)
    }
    
    func testPrevious_HHMMSSFFXX() throws {
        XCTAssertEqual(C.days.previous(excluding: [.days]), .subFrames)
        XCTAssertEqual(C.hours.previous(excluding: [.days]), .subFrames)
        XCTAssertEqual(C.minutes.previous(excluding: [.days]), .hours)
        XCTAssertEqual(C.seconds.previous(excluding: [.days]), .minutes)
        XCTAssertEqual(C.frames.previous(excluding: [.days]), .seconds)
        XCTAssertEqual(C.subFrames.previous(excluding: [.days]), .frames)
    }
    
    func testPrevious_DDHHMMSSFF() throws {
        XCTAssertEqual(C.days.previous(excluding: [.subFrames]), .frames)
        XCTAssertEqual(C.hours.previous(excluding: [.subFrames]), .days)
        XCTAssertEqual(C.minutes.previous(excluding: [.subFrames]), .hours)
        XCTAssertEqual(C.seconds.previous(excluding: [.subFrames]), .minutes)
        XCTAssertEqual(C.frames.previous(excluding: [.subFrames]), .seconds)
        XCTAssertEqual(C.subFrames.previous(excluding: [.subFrames]), .frames)
    }
    
    func testPrevious_DDHHMMSSFFXX() throws {
        XCTAssertEqual(C.days.previous(excluding: []), .subFrames)
        XCTAssertEqual(C.hours.previous(excluding: []), .days)
        XCTAssertEqual(C.minutes.previous(excluding: []), .hours)
        XCTAssertEqual(C.seconds.previous(excluding: []), .minutes)
        XCTAssertEqual(C.frames.previous(excluding: []), .seconds)
        XCTAssertEqual(C.subFrames.previous(excluding: []), .frames)
    }
}
