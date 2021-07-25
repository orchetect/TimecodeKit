//
//  Timecode Samples Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//

#if !os(watchOS)

import XCTest
@testable import TimecodeKit

class Timecode_UT_DI_Samples_Tests: XCTestCase {
    
    override func setUp() { }
    override func tearDown() { }
    
    func testSamplesGetSet_48KHz() {
        
        // pre-computed constants
        
        let samplesIn1DayTC_ShrunkFrameRates = 4151347200.0
        let samplesIn1DayTC_BaseFrameRates = 4147200000.0
        let samplesIn1DayTC_DropFrameRates = 4147195853.0
        
        // confirmed correct in PT and Cubase
        let samplesIn1DayTC_30DF = 4143052800.0
        
        // allow for the over-estimate padding value that gets added in the TC->samples method
        let accuracy = 0.001
        
        // 48KHz ___________________________________
        
        Timecode.FrameRate.allCases.forEach {
            
            let sRate = 48000
            var tc = Timecode(at: $0, limit: ._100days)
            
            switch $0 {
            case ._23_976,
                 ._24_98,
                 ._29_97,
                 ._47_952,
                 ._59_94,
                 ._119_88:
                
                // get
                tc.setTimecode(exactly: TCC(d: 1))
                XCTAssertEqual(tc.samplesValue(atSampleRate: sRate),
                               samplesIn1DayTC_ShrunkFrameRates,
                               accuracy: accuracy,
                               "at \($0)")
                
                // set
                tc.setTimecode(fromSamplesValue: samplesIn1DayTC_ShrunkFrameRates,
                               atSampleRate: sRate)
                XCTAssertEqual(tc.components,
                               TCC(d: 1),
                               "at \($0)")
                
            case ._24,
                 ._25,
                 ._30,
                 ._48,
                 ._50,
                 ._60,
                 ._100,
                 ._120:
                
                // get
                tc.setTimecode(exactly: TCC(d: 1))
                XCTAssertEqual(tc.samplesValue(atSampleRate: sRate),
                               samplesIn1DayTC_BaseFrameRates,
                               accuracy: accuracy,
                               "at \($0)")
                
                // set
                tc.setTimecode(fromSamplesValue: samplesIn1DayTC_BaseFrameRates,
                               atSampleRate: sRate)
                XCTAssertEqual(tc.components,
                               TCC(d: 1),
                               "at \($0)")
                
            case ._29_97_drop,
                 ._59_94_drop,
                 ._119_88_drop:
                
                // Cubase reports 4147195853 @ 1 day - there may be rounding happening in Cubase
                // Pro Tools reports 2073597926 @ 12 hours; double this would technically be 4147195854 but Cubase shows 1 frame less
                
                // get
                tc.setTimecode(exactly: TCC(d: 1))
                XCTAssertEqual(tc.samplesValue(atSampleRate: sRate).rounded(), // add rounding for dropframe; DAWs seem to round using standard rounding rules (?)
                               samplesIn1DayTC_DropFrameRates,
                               "at \($0)")
                
                // set
                tc.setTimecode(fromSamplesValue: samplesIn1DayTC_DropFrameRates,
                               atSampleRate: sRate)
                XCTAssertEqual(tc.components, TCC(d: 1),
                               "at \($0)")
                
            case ._30_drop,
                 ._60_drop,
                 ._120_drop:
                
                // get
                tc.setTimecode(exactly: TCC(d: 1))
                XCTAssertEqual(tc.samplesValue(atSampleRate: sRate),
                               samplesIn1DayTC_30DF,
                               accuracy: accuracy,
                               "at \($0)")
                
                // set
                tc.setTimecode(fromSamplesValue: samplesIn1DayTC_30DF,
                               atSampleRate: sRate)
                XCTAssertEqual(tc.components,
                               TCC(d: 1),
                               "at \($0)")
                
            }
            
        }
        
    }
    
    func testTimecode_Samples_SubFrames() {
        
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
                
                let sRate = 48000
                
                // timecode to samples
                
                let samples = tc.samplesValue(atSampleRate: sRate)
                
                // samples to timecode
                
                XCTAssertTrue(tc.setTimecode(fromSamplesValue: samples,
                                             atSampleRate: sRate),
                              "at: \($0) subframe: \(subFrame)")
                
                XCTAssertEqual(tc.components,
                               tcc,
                               "at: \($0) subframe: \(subFrame)")
                
            }
            
        }
        
    }
    
}

#endif
