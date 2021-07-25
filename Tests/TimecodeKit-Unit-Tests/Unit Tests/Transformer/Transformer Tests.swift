//
//  Transformer Tests.swift
//  TimecodeKitTests
//
//  Created by Steffan Andrews on 2021-04-23.
//  Copyright © 2021 Steffan Andrews. All rights reserved.
//

#if !os(watchOS)

import XCTest
@testable import TimecodeKit
import OTCore

class Timecode_UT_Transformer_TransformerTests: XCTestCase {
    
    override func setUp() { }
    override func tearDown() { }
    
    func testTransformer_None() {
        
        // .none
        
        let transformer = Timecode.Transformer(.none)
        
        XCTAssertEqual(
            transformer.transform(Timecode(TCC(h: 1), at: ._24)!),
            Timecode(TCC(h: 01, m: 00, s: 00, f: 00), at: ._24)!
        )
        
    }
    
    func testTransformer_Offset() {
        
        // .offset()
        
        let deltaTC = Timecode(TCC(m: 1), at: ._24)!
        let delta = Timecode.Delta(deltaTC, .positive)
        
        var transformer = Timecode.Transformer(.offset(by: delta))
        
        // disabled
        
        transformer.enabled = false
        
        XCTAssertEqual(
            transformer.transform(Timecode(TCC(h: 1), at: ._24)!),
            Timecode(TCC(h: 01, m: 00, s: 00, f: 00), at: ._24)!
        )
        
        // enabled
        
        transformer.enabled = true
        
        XCTAssertEqual(
            transformer.transform(Timecode(TCC(h: 1), at: ._24)!),
            Timecode(TCC(h: 01, m: 01, s: 00, f: 00), at: ._24)!
        )
        
    }
    
    func testTransformer_Custom() {
        
        // .custom()
        
        let transformer = Timecode.Transformer(.custom({ //inputTC -> Timecode in
            $0.adding(wrapping: TCC(m: 1))
        }))
        
        XCTAssertEqual(
            transformer.transform(Timecode(TCC(h: 1), at: ._24)!),
            Timecode(TCC(h: 01, m: 01, s: 00, f: 00), at: ._24)!
        )
        
    }
    
}

#endif
