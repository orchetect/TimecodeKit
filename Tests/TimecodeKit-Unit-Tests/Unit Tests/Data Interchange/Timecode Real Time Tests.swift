//
//  Timecode Real Time Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//

#if !os(watchOS)

import XCTest
@testable import TimecodeKit

class Timecode_UT_DI_Real_Time_Tests: XCTestCase {
    
    // pre-computed constants
    
    let secInTC10Days_ShrunkFrameRates = 864864.000
    let secInTC10Days_BaseFrameRates = 864000.000
    let secInTC10Days_DropFrameRates = 863999.136
    
    override func setUp() { }
    override func tearDown() { }
    
    func testTimecode_RealTimeValue() {
        
        // get real time
        
        // set up a reasonable accuracy to account for floating-point precision/rounding
        let accuracy = 0.000000001
        
        Timecode.FrameRate.allCases.forEach {
            
            let tc = Timecode(TCC(d: 10), at: $0, limit: ._100days)!
            
            switch $0 {
            case ._23_976,
                 ._24_98,
                 ._29_97,
                 ._47_952,
                 ._59_94,
                 ._119_88:
                
                XCTAssertEqual(tc.realTimeValue,
                               secInTC10Days_ShrunkFrameRates,
                               accuracy: accuracy,
                               "at: \($0)")
                
            case ._24,
                 ._25,
                 ._30,
                 ._48,
                 ._50,
                 ._60,
                 ._100,
                 ._120:
                
                XCTAssertEqual(tc.realTimeValue,
                               secInTC10Days_BaseFrameRates,
                               accuracy: accuracy,
                               "at: \($0)")
                
            case ._29_97_drop,
                 ._30_drop,
                 ._59_94_drop,
                 ._60_drop,
                 ._119_88_drop,
                 ._120_drop:
                
                XCTAssertEqual(tc.realTimeValue,
                               secInTC10Days_DropFrameRates,
                               accuracy: accuracy,
                               "at: \($0)")
                
            }
        }
        
        // set timecode from real time
        
        let tcc = TCC(d: 10)
        
        Timecode.FrameRate.allCases.forEach {
            
            var tc = Timecode(tcc, at: $0, limit: ._100days)!
            
            switch $0 {
            case ._23_976,
                 ._24_98,
                 ._29_97,
                 ._47_952,
                 ._59_94,
                 ._119_88:
                
                XCTAssertTrue(tc.setTimecode(fromRealTimeValue: secInTC10Days_ShrunkFrameRates), "at: \($0)")
                XCTAssertEqual(tc.components, tcc, "at: \($0)")
                
            case ._24,
                 ._25,
                 ._30,
                 ._48,
                 ._50,
                 ._60,
                 ._100,
                 ._120:
                
                XCTAssertTrue(tc.setTimecode(fromRealTimeValue: secInTC10Days_BaseFrameRates), "at: \($0)")
                XCTAssertEqual(tc.components, tcc, "at: \($0)")
                
            case ._29_97_drop,
                 ._30_drop,
                 ._59_94_drop,
                 ._60_drop,
                 ._119_88_drop,
                 ._120_drop:
                
                XCTAssertTrue(tc.setTimecode(fromRealTimeValue: secInTC10Days_DropFrameRates), "at: \($0)")
                XCTAssertEqual(tc.components, tcc, "at: \($0)")
                
            }
            
        }
        
    }
    
    func testTimecode_RealTimeValue_SubFrames() {
        
        // ensure subframes are calculated correctly
        
        // test for precision and rounding issues by iterating every subframe for each frame rate
        
        let subFramesDivisor = 80
        
        for subFrame in 0..<subFramesDivisor {
            
            let tcc = TCC(d: 99, h: 23, sf: subFrame)
            
            Timecode.FrameRate.allCases.forEach {
                
                var tc = Timecode(tcc,
                                  at: $0,
                                  limit: ._100days,
                                  subFramesDivisor: subFramesDivisor)!
                
                // timecode to samples
                
                let realTime = tc.realTimeValue
                
                // samples to timecode
                
                XCTAssertTrue(tc.setTimecode(fromRealTimeValue: realTime),
                              "at: \($0) subframe: \(subFrame)")
                
                XCTAssertEqual(tc.components,
                               tcc,
                               "at: \($0) subframe: \(subFrame)")
                
            }
            
        }
        
    }
    
    func testTimecode_RealTimeValue_RealWorld_SubFrames() {
        
        // test against real-world values extracted from DAWs
        
        // Cubase 11 XML file output (high resolution floating-point times in seconds)
        
        // the timecodes in the constant variable names are the timecodes as seen in Cubase
        // the float-point number constant values are extracted from a Track Archive XML file exported from the Cubase project which outputs very high precision float-point numbers in seconds to define many attributes such as the project start time, and event start times and lengths on tracks which are in absolute time mode (not musical bars/beats mode which gets stored as PPQ values in the XML file instead of float-point seconds)
        
        
        // 23.976fps, 80 subframe divisor
        
        //  _HH_MM_SS_FF_SF
        
        // session start timecode
        let _00_49_27_15_00 = 2970.5926250000002255546860396862030029296875
        
        // events: delta times from session start time
        let _00_49_29_17_00_delta = 2.0854162836310767836778268247144296765327453613281
        let _00_49_31_09_00_delta = 3.7537499627098442900319241744000464677810668945312
        let _00_49_33_21_79_delta = 6.297436893962323978257700218819081783294677734375
        let _00_49_38_01_79_delta = 10.468270548180987233877203834708780050277709960938
        
        // test timecode formation from real time
        
        let start = Timecode(realTimeValue: _00_49_27_15_00,
                             at: ._23_976)!
        XCTAssertEqual(start.components,
                       TCC(h: 00, m: 49, s: 27, f: 15, sf: 00))
        
        let event1 = Timecode(realTimeValue: _00_49_27_15_00 + _00_49_29_17_00_delta,
                              at: ._23_976)!
        XCTAssertEqual(event1.components,
                       TCC(h: 00, m: 49, s: 29, f: 17, sf: 00))
        
        let event2 = Timecode(realTimeValue: _00_49_27_15_00 + _00_49_31_09_00_delta,
                              at: ._23_976)!
        XCTAssertEqual(event2.components,
                       TCC(h: 00, m: 49, s: 31, f: 09, sf: 00))
        
        let event3 = Timecode(realTimeValue: _00_49_27_15_00 + _00_49_33_21_79_delta,
                              at: ._23_976)!
        XCTAssertEqual(event3.components,
                       TCC(h: 00, m: 49, s: 33, f: 21, sf: 79))
        
        let event4 = Timecode(realTimeValue: _00_49_27_15_00 + _00_49_38_01_79_delta,
                              at: ._23_976)!
        XCTAssertEqual(event4.components,
                       TCC(h: 00, m: 49, s: 38, f: 01, sf: 79))
        
        // test real time matching the seconds constants
        
        // start
        XCTAssertEqual(
            TCC(h: 00, m: 49, s: 27, f: 15, sf: 00)
                .toTimecode(at: ._23_976)!
                .realTimeValue,
            _00_49_27_15_00
        )
        
        // event1
        XCTAssertEqual(
            TCC(h: 00, m: 49, s: 29, f: 17, sf: 00)
                .toTimecode(at: ._23_976)!
                .realTimeValue,
            _00_49_27_15_00 + _00_49_29_17_00_delta,
            accuracy: 0.0000005
        )
        
        // event2
        XCTAssertEqual(
            TCC(h: 00, m: 49, s: 31, f: 09, sf: 00)
                .toTimecode(at: ._23_976)!
                .realTimeValue,
            _00_49_27_15_00 + _00_49_31_09_00_delta,
            accuracy: 0.0000005
        )
        
        // event3
        XCTAssertEqual(
            TCC(h: 00, m: 49, s: 33, f: 21, sf: 79)
                .toTimecode(at: ._23_976)!
                .realTimeValue,
            _00_49_27_15_00 + _00_49_33_21_79_delta,
            accuracy: 0.0000005
        )
        
        // event4
        XCTAssertEqual(
            TCC(h: 00, m: 49, s: 38, f: 01, sf: 79)
                .toTimecode(at: ._23_976)!
                .realTimeValue,
            _00_49_27_15_00 + _00_49_38_01_79_delta,
            accuracy: 0.0000005
        )
        
    }
    
    // extension TimeInterval
    
    func testTCC_toTimecode() {
        
        // toTimecode(rawValuesAt:)
        
        XCTAssertEqual(
            TCC(h: 1, m: 5, s: 20, f: 14)
                .toTimecode(at: ._23_976),
            Timecode(TCC(h: 1, m: 5, s: 20, f: 14),
                     at: ._23_976)
        )
        
        // toTimecode(rawValuesAt:) with subframes
        
        let tcWithSubFrames = TCC(h: 1, m: 5, s: 20, f: 14, sf: 94)
            .toTimecode(at: ._23_976,
                        subFramesDivisor: 100,
                        displaySubFrames: true)
        XCTAssertEqual(
            tcWithSubFrames,
            Timecode(TCC(h: 1, m: 5, s: 20, f: 14, sf: 94),
                     at: ._23_976,
                     subFramesDivisor: 100,
                     displaySubFrames: true)
        )
        XCTAssertEqual(
            tcWithSubFrames?.stringValue,
            "01:05:20:14.94"
        )
        
    }
    
    func testTimeInterval_toTimeCode_at() {
        
        // toTimecode(at:)
        
        XCTAssertEqual(TimeInterval(secInTC10Days_BaseFrameRates)
                        .toTimecode(at: ._24, limit: ._100days)?
                        .components,
                       TCC(d: 10))
        
        // toTimecode(at:) with subframes
        
        let tcWithSubFrames = TimeInterval(3600.0)
            .toTimecode(at: ._24,
                        subFramesDivisor: 100,
                        displaySubFrames: true)
        XCTAssertEqual(
            tcWithSubFrames,
            Timecode(TCC(h: 1),
                     at: ._24,
                     subFramesDivisor: 100,
                     displaySubFrames: true)
        )
        XCTAssertEqual(
            tcWithSubFrames?.stringValue,
            "01:00:00:00.00"
        )
        
    }
    
}

#endif
