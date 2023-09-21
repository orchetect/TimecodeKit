//
//  Timecode FrameCount Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

@testable import TimecodeKit
import XCTest

class Timecode_FrameCount_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    func testTimecode_init_FrameCount_Exactly() throws {
        let tc = try Timecode(
            .frames(Timecode.FrameCount(.frames(670_907), base: ._80SubFrames)),
            at: ._30
        )
        
        XCTAssertEqual(tc.components, Timecode.Components(d: 00, h: 06, m: 12, s: 43, f: 17, sf: 00))
    }
    
    func testTimecode_init_FrameCount_Clamping() {
        let tc = Timecode(
            .frames(Timecode.FrameCount(
                .frames(2_073_600 + 86400), // 25 hours @ 24fps
                base: ._80SubFrames
            )),
            at: ._24,
            by: .clamping
        )
        
        XCTAssertEqual(
            tc.components,
            Timecode.Components(h: 23, m: 59, s: 59, f: 23, sf: tc.subFramesBase.rawValue - 1)
        )
    }
    
    func testTimecode_init_FrameCount_Wrapping() {
        let tc = Timecode(
            .frames(Timecode.FrameCount(
                .frames(2073600 + 86400), // 25 hours @ 24fps
                base: ._80SubFrames
            )),
            at: ._24,
            by: .wrapping
        )
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 01))
    }
    
    func testTimecode_init_FrameCount_RawValues() {
        let tc = Timecode(
            .frames(Timecode.FrameCount(
                .frames((2073600 * 2) + 86400), // 2 days + 1 hour @ 24fps
                base: ._80SubFrames
            )),
            at: ._24,
            by: .allowingInvalid
        )
        
        XCTAssertEqual(tc.components, Timecode.Components(d: 2, h: 01))
    }
    
    func testAllFrameRates_ElapsedFrames() {
        // duration of 24 hours elapsed, rolling over to 1 day
        
        // also helps ensure Strideable .distance(to:) returns the correct values
        
        TimecodeFrameRate.allCases.forEach {
            // max frames in 24 hours
            
            var maxFramesIn24hours: Int
            
            switch $0 {
            case ._23_976: maxFramesIn24hours = 2_073_600
            case ._24: maxFramesIn24hours = 2_073_600
            case ._24_98: maxFramesIn24hours = 2_160_000
            case ._25: maxFramesIn24hours = 2_160_000
            case ._29_97: maxFramesIn24hours = 2_592_000
            case ._29_97_drop: maxFramesIn24hours = 2_589_408
            case ._30: maxFramesIn24hours = 2_592_000
            case ._30_drop: maxFramesIn24hours = 2_589_408
            case ._47_952: maxFramesIn24hours = 4_147_200
            case ._48: maxFramesIn24hours = 4_147_200
            case ._50: maxFramesIn24hours = 4_320_000
            case ._59_94: maxFramesIn24hours = 5_184_000
            case ._59_94_drop: maxFramesIn24hours = 5_178_816
            case ._60: maxFramesIn24hours = 5_184_000
            case ._60_drop: maxFramesIn24hours = 5_178_816
            case ._95_904: maxFramesIn24hours = 8_294_400
            case ._96: maxFramesIn24hours = 8_294_400
            case ._100: maxFramesIn24hours = 8_640_000
            case ._119_88: maxFramesIn24hours = 10_368_000
            case ._119_88_drop: maxFramesIn24hours = 10_357_632
            case ._120: maxFramesIn24hours = 10_368_000
            case ._120_drop: maxFramesIn24hours = 10_357_632
            }
            
            XCTAssertEqual(
                $0.maxTotalFrames(in: ._24hours),
                maxFramesIn24hours,
                "for \($0)"
            )
        }
        
        // number of total elapsed frames in (24 hours - 1 frame), or essentially the maximum timecode expressible for each frame rate
        
        TimecodeFrameRate.allCases.forEach {
            // max frames in 24 hours - 1
            
            var maxFramesExpressibleIn24hours: Int
            
            switch $0 {
            case ._23_976: maxFramesExpressibleIn24hours = 2_073_600 - 1
            case ._24: maxFramesExpressibleIn24hours = 2_073_600 - 1
            case ._24_98: maxFramesExpressibleIn24hours = 2_160_000 - 1
            case ._25: maxFramesExpressibleIn24hours = 2_160_000 - 1
            case ._29_97: maxFramesExpressibleIn24hours = 2_592_000 - 1
            case ._29_97_drop: maxFramesExpressibleIn24hours = 2_589_408 - 1
            case ._30: maxFramesExpressibleIn24hours = 2_592_000 - 1
            case ._30_drop: maxFramesExpressibleIn24hours = 2_589_408 - 1
            case ._47_952: maxFramesExpressibleIn24hours = 4_147_200 - 1
            case ._48: maxFramesExpressibleIn24hours = 4_147_200 - 1
            case ._50: maxFramesExpressibleIn24hours = 4_320_000 - 1
            case ._59_94: maxFramesExpressibleIn24hours = 5_184_000 - 1
            case ._59_94_drop: maxFramesExpressibleIn24hours = 5_178_816 - 1
            case ._60: maxFramesExpressibleIn24hours = 5_184_000 - 1
            case ._60_drop: maxFramesExpressibleIn24hours = 5_178_816 - 1
            case ._95_904: maxFramesExpressibleIn24hours = 8_294_400 - 1
            case ._96: maxFramesExpressibleIn24hours = 8_294_400 - 1
            case ._100: maxFramesExpressibleIn24hours = 8_640_000 - 1
            case ._119_88: maxFramesExpressibleIn24hours = 10_368_000 - 1
            case ._119_88_drop: maxFramesExpressibleIn24hours = 10_357_632 - 1
            case ._120: maxFramesExpressibleIn24hours = 10_368_000 - 1
            case ._120_drop: maxFramesExpressibleIn24hours = 10_357_632 - 1
            }
            
            XCTAssertEqual(
                $0.maxTotalFramesExpressible(in: ._24hours),
                maxFramesExpressibleIn24hours,
                "for \($0)"
            )
        }
    }
    
    func testSetTimecodeExactly() throws {
        // this is not meant to test the underlying logic, simply that .setTimecode produces the intended outcome
        
        var tc = Timecode(.zero, at: ._30, base: ._80SubFrames)
        
        try tc.set(Timecode.FrameCount(
            .frames(670_907),
            base: ._80SubFrames
        ))
        
        XCTAssertEqual(tc.components, Timecode.Components(d: 00, h: 06, m: 12, s: 43, f: 17, sf: 00))
    }
    
    func testSetTimecodeFrameCount_Clamping() {
        var tc = Timecode(.zero, at: ._24, base: ._80SubFrames)
        
        tc.set(
            Timecode.FrameCount(
                .frames(2_073_600 + 86400), // 25 hours @ 24fps
                base: ._80SubFrames
            ),
            by: .clamping
        )

        XCTAssertEqual(
            tc.components,
            Timecode.Components(h: 23, m: 59, s: 59, f: 23, sf: tc.subFramesBase.rawValue - 1)
        )
    }

    func testSetTimecodeFrameCount_Wrapping() {
        var tc = Timecode(.zero, at: ._24, base: ._80SubFrames)
        
        tc.set(
            Timecode.FrameCount(
                .frames(2073600 + 86400), // 25 hours @ 24fps
                base: ._80SubFrames
            ),
            by: .wrapping
        )
        
        XCTAssertEqual(tc.components, Timecode.Components(h: 01))
    }

    func testSetTimecodeFrameCount_RawValues() {
        var tc = Timecode(.zero, at: ._24, base: ._80SubFrames)
        
        tc.set(
            Timecode.FrameCount(
                .frames((2073600 * 2) + 86400), // 2 days + 1 hour @ 24fps
                base: ._80SubFrames
            ),
            by: .allowingInvalid
        )

        XCTAssertEqual(tc.components, Timecode.Components(d: 2, h: 01))
    }
    
    func testStatic_componentsOfFrameCount_2997d() {
        // edge cases
        
        let totalFramesIn24Hr = 2_589_408
        // let totalSubFramesIn24Hr = 207152640
        
        let tcc = Timecode.components(
            of: Timecode.FrameCount(
                .split(frames: totalFramesIn24Hr - 1, subFrames: 79),
                base: ._80SubFrames
            ),
            at: ._29_97_drop
        )
        
        XCTAssertEqual(tcc, Timecode.Components(d: 0, h: 23, m: 59, s: 59, f: 29, sf: 79))
    }
    
    func testIsZero() {
        // true
        
        // frames
        XCTAssertTrue(Timecode.FrameCount(.frames(0), base: ._80SubFrames).isZero)
        // split
        XCTAssertTrue(Timecode.FrameCount(.split(frames: 0, subFrames: 0), base: ._80SubFrames).isZero)
        // combined
        XCTAssertTrue(Timecode.FrameCount(.combined(frames: 0.0), base: ._80SubFrames).isZero)
        // split unitinterval
        XCTAssertTrue(Timecode.FrameCount(.splitUnitInterval(frames: 0, subFramesUnitInterval: 0.0), base: ._80SubFrames).isZero)
        
        // false
        
        // frames
        XCTAssertFalse(Timecode.FrameCount(.frames(1), base: ._80SubFrames).isZero)
        XCTAssertFalse(Timecode.FrameCount(.frames(-1), base: ._80SubFrames).isZero)
        // split
        XCTAssertFalse(Timecode.FrameCount(.split(frames: 0, subFrames: 1), base: ._80SubFrames).isZero)
        XCTAssertFalse(Timecode.FrameCount(.split(frames: 1, subFrames: 0), base: ._80SubFrames).isZero)
        XCTAssertFalse(Timecode.FrameCount(.split(frames: 1, subFrames: 1), base: ._80SubFrames).isZero)
        XCTAssertFalse(Timecode.FrameCount(.split(frames: 0, subFrames: -1), base: ._80SubFrames).isZero)
        XCTAssertFalse(Timecode.FrameCount(.split(frames: -1, subFrames: 0), base: ._80SubFrames).isZero)
        XCTAssertFalse(Timecode.FrameCount(.split(frames: -1, subFrames: -1), base: ._80SubFrames).isZero)
        // combined
        XCTAssertFalse(Timecode.FrameCount(.combined(frames: 0.1), base: ._80SubFrames).isZero)
        XCTAssertFalse(Timecode.FrameCount(.combined(frames: 1.0), base: ._80SubFrames).isZero)
        XCTAssertFalse(Timecode.FrameCount(.combined(frames: -0.1), base: ._80SubFrames).isZero)
        XCTAssertFalse(Timecode.FrameCount(.combined(frames: -1.0), base: ._80SubFrames).isZero)
        // split unitinterval
        XCTAssertFalse(Timecode.FrameCount(.splitUnitInterval(frames: 0, subFramesUnitInterval: 0.1), base: ._80SubFrames).isZero)
        XCTAssertFalse(Timecode.FrameCount(.splitUnitInterval(frames: 1, subFramesUnitInterval: 0.0), base: ._80SubFrames).isZero)
        XCTAssertFalse(Timecode.FrameCount(.splitUnitInterval(frames: 1, subFramesUnitInterval: 0.1), base: ._80SubFrames).isZero)
        XCTAssertFalse(Timecode.FrameCount(.splitUnitInterval(frames: 0, subFramesUnitInterval: -0.1), base: ._80SubFrames).isZero)
        XCTAssertFalse(Timecode.FrameCount(.splitUnitInterval(frames: -1, subFramesUnitInterval: 0.0), base: ._80SubFrames).isZero)
        XCTAssertFalse(Timecode.FrameCount(.splitUnitInterval(frames: -1, subFramesUnitInterval: -0.1), base: ._80SubFrames).isZero)
    }
}

#endif
