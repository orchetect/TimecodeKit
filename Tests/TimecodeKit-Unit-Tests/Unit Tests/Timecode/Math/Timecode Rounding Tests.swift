//
//  Timecode Rounding Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import TimecodeKit

class Timecode_Rounding_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    // MARK: - Rounding
    
    func testRoundedUpToNextWholeFrame() throws {
        XCTAssertEqual(
            try Timecode(at: ._23_976).roundedUpToNextWholeFrame()
                .components,
            TCC()
        )
        
        XCTAssertEqual(
            try Timecode(TCC(sf: 1), at: ._23_976).roundedUpToNextWholeFrame()
                .components,
            TCC(f: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(f: 1), at: ._23_976).roundedUpToNextWholeFrame()
                .components,
            TCC(f: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(f: 1, sf: 1), at: ._23_976).roundedUpToNextWholeFrame()
                .components,
            TCC(f: 2)
        )
    }
    
    func testRoundedUpToNextWholeFrame_EdgeCases() throws {
        XCTAssertEqual(
            try Timecode(TCC(h: 23, m: 59, s: 59, f: 23, sf: 0), at: ._24)
                .roundedUpToNextWholeFrame()
                .components,
            TCC(h: 23, m: 59, s: 59, f: 23, sf: 0)
        )
        
        // 'exactly' throws error because result would be 24:00:00:00
        XCTAssertThrowsError(
            try Timecode(TCC(h: 23, m: 59, s: 59, f: 23, sf: 1), at: ._24)
                .roundedUpToNextWholeFrame()
        )
    }
    
    // MARK: - Truncate Subframes
    
    func testTruncatingSubFrames() throws {
        XCTAssertEqual(
            Timecode(at: ._23_976).truncatingSubFrames()
                .components,
            TCC()
        )
        
        XCTAssertEqual(
            try Timecode(TCC(sf: 1), at: ._23_976).truncatingSubFrames()
                .components,
            TCC()
        )
        
        XCTAssertEqual(
            try Timecode(TCC(f: 1), at: ._23_976).truncatingSubFrames()
                .components,
            TCC(f: 1)
        )
        
        XCTAssertEqual(
            try Timecode(TCC(f: 1, sf: 1), at: ._23_976).truncatingSubFrames()
                .components,
            TCC(f: 1)
        )
    }
}

#endif
