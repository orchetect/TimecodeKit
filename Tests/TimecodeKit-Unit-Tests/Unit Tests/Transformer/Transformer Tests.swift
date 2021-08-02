//
//  Transformer Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//

#if !os(watchOS)

import XCTest
@testable import TimecodeKit
import OTCore

class Timecode_UT_Transformer_Tests: XCTestCase {
    
    override func setUp() { }
    override func tearDown() { }
    
    func testTransformer_None() throws {
        
        // .none
        
        let transformer = Timecode.Transformer(.none)
        
        XCTAssertEqual(
            transformer.transform(try Timecode(TCC(h: 1), at: ._24)),
            try Timecode(TCC(h: 01, m: 00, s: 00, f: 00), at: ._24)
        )
        
    }
    
    func testTransformer_Offset() throws {
        
        // .offset()
        
        let deltaTC = try Timecode(TCC(m: 1), at: ._24)
        let delta = Timecode.Delta(deltaTC, .positive)
        
        var transformer = Timecode.Transformer(.offset(by: delta))
        
        // disabled
        
        transformer.enabled = false
        
        XCTAssertEqual(
            transformer.transform(try Timecode(TCC(h: 1), at: ._24)),
            try Timecode(TCC(h: 01, m: 00, s: 00, f: 00), at: ._24)
        )
        
        // enabled
        
        transformer.enabled = true
        
        XCTAssertEqual(
            transformer.transform(try Timecode(TCC(h: 1), at: ._24)),
            try Timecode(TCC(h: 01, m: 01, s: 00, f: 00), at: ._24)
        )
        
    }
    
    func testTransformer_Custom() throws {
        
        // .custom()
        
        let transformer = Timecode.Transformer(.custom({ //inputTC -> Timecode in
            $0.adding(wrapping: TCC(m: 1))
        }))
        
        XCTAssertEqual(
            transformer.transform(try Timecode(TCC(h: 1), at: ._24)),
            try Timecode(TCC(h: 01, m: 01, s: 00, f: 00), at: ._24)
        )
        
    }
    
}

#endif
