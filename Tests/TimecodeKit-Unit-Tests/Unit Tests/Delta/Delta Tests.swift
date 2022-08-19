//
//  Delta Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import TimecodeKit

class Timecode_UT_Delta_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testInitA() throws {
        // positive
        
        let deltaTC = try Timecode(TCC(m: 1), at: ._24)
        
        let delta = Timecode.Delta(deltaTC)
        
        XCTAssertEqual(delta.delta, deltaTC)
        XCTAssertEqual(delta.sign, .positive)
    }
    
    func testInitB() throws {
        // negative
        
        let deltaTC = try Timecode(TCC(m: 1), at: ._24)
        
        let delta = Timecode.Delta(deltaTC, .negative)
        
        XCTAssertEqual(delta.delta, deltaTC)
        XCTAssertEqual(delta.sign, .negative)
    }
    
    func testInitC() {
        // TCC can contain negative values;
        // this should not alter the Delta sign however
        
        let deltaTC = Timecode(rawValues: TCC(m: -1), at: ._24)
        
        let delta = Timecode.Delta(deltaTC)
        
        XCTAssertEqual(delta.delta, deltaTC)
        XCTAssertEqual(delta.sign, .positive)
    }
    
    func testIsNegative() {
        XCTAssertEqual(
            Timecode.Delta(.init(at: ._24))
                .isNegative,
            false
        )
        
        XCTAssertEqual(
            Timecode.Delta(.init(at: ._24), .negative)
                .isNegative,
            true
        )
    }
    
    func testTimecodeA() throws {
        // positive
        
        let deltaTC = try Timecode(TCC(m: 1), at: ._24)
        
        let delta = Timecode.Delta(deltaTC)
        
        XCTAssertEqual(delta.timecode, deltaTC)
    }
    
    func testTimecodeB() throws {
        // negative, wrapping
        
        let deltaTC = try Timecode(TCC(m: 1), at: ._24)
        
        let delta = Timecode.Delta(deltaTC, .negative)
        
        XCTAssertEqual(
            delta.timecode,
            try Timecode(TCC(h: 23, m: 59, s: 00, f: 00), at: ._24)
        )
    }
    
    func testTimecodeC() throws {
        // positive, wrapping
        
        let deltaTC = Timecode(rawValues: TCC(h: 26), at: ._24)
        
        let delta = Timecode.Delta(deltaTC)
        
        XCTAssertEqual(
            delta.timecode,
            try Timecode(TCC(h: 02, m: 00, s: 00, f: 00), at: ._24)
        )
    }
    
    func testTimecodeOffsettingA() throws {
        // positive
        
        let deltaTC = Timecode(rawValues: TCC(m: 1), at: ._24)
        
        let delta = Timecode.Delta(deltaTC)
        
        XCTAssertEqual(
            delta.timecode(offsetting: try Timecode(TCC(h: 1), at: ._24)),
            try Timecode(TCC(h: 01, m: 01, s: 00, f: 00), at: ._24)
        )
    }
    
    func testTimecodeOffsettingB() throws {
        // negative
        
        let deltaTC = Timecode(rawValues: TCC(m: 1), at: ._24)
        
        let delta = Timecode.Delta(deltaTC, .negative)
        
        XCTAssertEqual(
            delta.timecode(offsetting: try Timecode(TCC(h: 1), at: ._24)),
            try Timecode(TCC(h: 00, m: 59, s: 00, f: 00), at: ._24)
        )
    }
    
    func testRealTimeValueA() throws {
        // positive
        
        let deltaTC = try Timecode(TCC(h: 1), at: ._24)
        
        let delta = Timecode.Delta(deltaTC)
        
        XCTAssertEqual(delta.realTimeValue, deltaTC.realTimeValue)
    }
    
    func testRealTimeValueB() throws {
        // negative
        
        let deltaTC = try Timecode(TCC(h: 1), at: ._24)
        
        let delta = Timecode.Delta(deltaTC, .negative)
        
        XCTAssertEqual(delta.realTimeValue, -deltaTC.realTimeValue)
    }
}

#endif
