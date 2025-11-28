//
//  Components Tests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftTimecodeCore
import XCTest

final class Timecode_Components_Tests: XCTestCase {
    override func setUp() { }
    override func tearDown() { }
    
    fileprivate typealias C = Timecode.Component
    
    // MARK: - Init Dictionary
    
    func testInitDictionaryA() {
        let dict: [Timecode.Component: Int] = [
            .days: 2,
            .hours: 3,
            .minutes: 4,
            .seconds: 5,
            .frames: 6,
            .subFrames: 7
        ]
        
        let components = Timecode.Components(dict)
        
        XCTAssertEqual(components.days, 2)
        XCTAssertEqual(components.hours, 3)
        XCTAssertEqual(components.minutes, 4)
        XCTAssertEqual(components.seconds, 5)
        XCTAssertEqual(components.frames, 6)
        XCTAssertEqual(components.subFrames, 7)
    }
    
    func testInitDictionaryB() {
        let dict: [Timecode.Component: Int] = [
            .hours: 3,
            .minutes: 4,
            .seconds: 5,
            .frames: 6
        ]
        
        let components = Timecode.Components(dict)
        
        XCTAssertEqual(components.days, 0)
        XCTAssertEqual(components.hours, 3)
        XCTAssertEqual(components.minutes, 4)
        XCTAssertEqual(components.seconds, 5)
        XCTAssertEqual(components.frames, 6)
        XCTAssertEqual(components.subFrames, 0)
    }
    
    func testInitDictionaryC() {
        let dict: [Timecode.Component: Int] = [:]
        
        let components = Timecode.Components(dict)
        
        XCTAssertEqual(components.days, 0)
        XCTAssertEqual(components.hours, 0)
        XCTAssertEqual(components.minutes, 0)
        XCTAssertEqual(components.seconds, 0)
        XCTAssertEqual(components.frames, 0)
        XCTAssertEqual(components.subFrames, 0)
    }
    
    // MARK: - Dictionary Property
    
    func testDictionaryA() {
        let components = Timecode.Components(d: 2, h: 3, m: 4, s: 5, f: 6, sf: 7)
        let dict = components.dictionary
        
        XCTAssertEqual(dict[.days], 2)
        XCTAssertEqual(dict[.hours], 3)
        XCTAssertEqual(dict[.minutes], 4)
        XCTAssertEqual(dict[.seconds], 5)
        XCTAssertEqual(dict[.frames], 6)
        XCTAssertEqual(dict[.subFrames], 7)
    }
    
    func testDictionaryB() {
        let components = Timecode.Components(d: 0, h: 3, m: 4, s: 5, f: 6, sf: 0)
        let dict = components.dictionary
        
        XCTAssertEqual(dict[.days], 0)
        XCTAssertEqual(dict[.hours], 3)
        XCTAssertEqual(dict[.minutes], 4)
        XCTAssertEqual(dict[.seconds], 5)
        XCTAssertEqual(dict[.frames], 6)
        XCTAssertEqual(dict[.subFrames], 0)
    }
    
    func testDictionaryC() {
        let components = Timecode.Components.zero
        let dict = components.dictionary
        
        XCTAssertEqual(dict[.days], 0)
        XCTAssertEqual(dict[.hours], 0)
        XCTAssertEqual(dict[.minutes], 0)
        XCTAssertEqual(dict[.seconds], 0)
        XCTAssertEqual(dict[.frames], 0)
        XCTAssertEqual(dict[.subFrames], 0)
    }
    
    // MARK: - Init Array
    
    func testInitArrayA() {
        let array: [(component: Timecode.Component, value: Int)] = [
            (.days, 2),
            (.hours, 3),
            (.minutes, 4),
            (.seconds, 5),
            (.frames, 6),
            (.subFrames, 7)
        ]
        
        let components = Timecode.Components(array)
        
        XCTAssertEqual(components.days, 2)
        XCTAssertEqual(components.hours, 3)
        XCTAssertEqual(components.minutes, 4)
        XCTAssertEqual(components.seconds, 5)
        XCTAssertEqual(components.frames, 6)
        XCTAssertEqual(components.subFrames, 7)
    }
    
    func testInitArrayB() {
        let array: [(component: Timecode.Component, value: Int)] = [
            (.hours, 3),
            (.minutes, 4),
            (.seconds, 5),
            (.frames, 6)
        ]
        
        let components = Timecode.Components(array)
        
        XCTAssertEqual(components.days, 0)
        XCTAssertEqual(components.hours, 3)
        XCTAssertEqual(components.minutes, 4)
        XCTAssertEqual(components.seconds, 5)
        XCTAssertEqual(components.frames, 6)
        XCTAssertEqual(components.subFrames, 0)
    }
    
    func testInitArrayC() {
        let array: [(component: Timecode.Component, value: Int)] = []
        
        let components = Timecode.Components(array)
        
        XCTAssertEqual(components.days, 0)
        XCTAssertEqual(components.hours, 0)
        XCTAssertEqual(components.minutes, 0)
        XCTAssertEqual(components.seconds, 0)
        XCTAssertEqual(components.frames, 0)
        XCTAssertEqual(components.subFrames, 0)
    }
    
    // MARK: - Array Property
    
    func testArrayA() {
        let components = Timecode.Components(d: 2, h: 3, m: 4, s: 5, f: 6, sf: 7)
        let array = components.array
        
        XCTAssertEqual(array.count, 6)
        
        XCTAssertEqual(array[0].component, .days)
        XCTAssertEqual(array[0].value, 2)
        XCTAssertEqual(array[1].component, .hours)
        XCTAssertEqual(array[1].value, 3)
        XCTAssertEqual(array[2].component, .minutes)
        XCTAssertEqual(array[2].value, 4)
        XCTAssertEqual(array[3].component, .seconds)
        XCTAssertEqual(array[3].value, 5)
        XCTAssertEqual(array[4].component, .frames)
        XCTAssertEqual(array[4].value, 6)
        XCTAssertEqual(array[5].component, .subFrames)
        XCTAssertEqual(array[5].value, 7)
    }
    
    func testArrayB() {
        let components = Timecode.Components(d: 0, h: 3, m: 4, s: 5, f: 6, sf: 0)
        let array = components.array
        
        XCTAssertEqual(array.count, 6)
        
        XCTAssertEqual(array[0].component, .days)
        XCTAssertEqual(array[0].value, 0)
        XCTAssertEqual(array[1].component, .hours)
        XCTAssertEqual(array[1].value, 3)
        XCTAssertEqual(array[2].component, .minutes)
        XCTAssertEqual(array[2].value, 4)
        XCTAssertEqual(array[3].component, .seconds)
        XCTAssertEqual(array[3].value, 5)
        XCTAssertEqual(array[4].component, .frames)
        XCTAssertEqual(array[4].value, 6)
        XCTAssertEqual(array[5].component, .subFrames)
        XCTAssertEqual(array[5].value, 0)
    }
    
    func testArrayC() {
        let components = Timecode.Components.zero
        let array = components.array
        
        XCTAssertEqual(array.count, 6)
        
        XCTAssertEqual(array[0].component, .days)
        XCTAssertEqual(array[0].value, 0)
        XCTAssertEqual(array[1].component, .hours)
        XCTAssertEqual(array[1].value, 0)
        XCTAssertEqual(array[2].component, .minutes)
        XCTAssertEqual(array[2].value, 0)
        XCTAssertEqual(array[3].component, .seconds)
        XCTAssertEqual(array[3].value, 0)
        XCTAssertEqual(array[4].component, .frames)
        XCTAssertEqual(array[4].value, 0)
        XCTAssertEqual(array[5].component, .subFrames)
        XCTAssertEqual(array[5].value, 0)
    }
    
    // MARK: - Iterators
    
    func testIteratorA() {
        let components = Timecode.Components(d: 2, h: 3, m: 4, s: 5, f: 6, sf: 7)
        
        let array = Array(components.makeIterator())
        
        XCTAssertEqual(array.count, 6)
        
        XCTAssertEqual(array[0].component, .days)
        XCTAssertEqual(array[0].value, 2)
        XCTAssertEqual(array[1].component, .hours)
        XCTAssertEqual(array[1].value, 3)
        XCTAssertEqual(array[2].component, .minutes)
        XCTAssertEqual(array[2].value, 4)
        XCTAssertEqual(array[3].component, .seconds)
        XCTAssertEqual(array[3].value, 5)
        XCTAssertEqual(array[4].component, .frames)
        XCTAssertEqual(array[4].value, 6)
        XCTAssertEqual(array[5].component, .subFrames)
        XCTAssertEqual(array[5].value, 7)
    }
    
    func testIteratorB() {
        let components = Timecode.Components.zero
        
        let array = Array(components.makeIterator())
        
        XCTAssertEqual(array.count, 6)
        
        XCTAssertEqual(array[0].component, .days)
        XCTAssertEqual(array[0].value, 0)
        XCTAssertEqual(array[1].component, .hours)
        XCTAssertEqual(array[1].value, 0)
        XCTAssertEqual(array[2].component, .minutes)
        XCTAssertEqual(array[2].value, 0)
        XCTAssertEqual(array[3].component, .seconds)
        XCTAssertEqual(array[3].value, 0)
        XCTAssertEqual(array[4].component, .frames)
        XCTAssertEqual(array[4].value, 0)
        XCTAssertEqual(array[5].component, .subFrames)
        XCTAssertEqual(array[5].value, 0)
    }
    
    // MARK: - Validation
    
    /// Baseline test that should be valid at all frame rates and subframes bases.
    func testIsWithinValidDigitCountsA() {
        let components = Timecode.Components(d: 2, h: 3, m: 4, s: 5, f: 6, sf: 7)
        
        for fRate in TimecodeFrameRate.allCases {
            for base in Timecode.SubFramesBase.allCases {
                XCTAssertTrue(components.isWithinValidDigitCounts(at: fRate, base: base))
            }
        }
    }
    
    /// Baseline test that should be valid at all frame rates and subframes bases.
    func testIsWithinValidDigitCountsB() {
        let components = Timecode.Components(d: 99, h: 99, m: 99, s: 99, f: 99, sf: 9)
        
        for fRate in TimecodeFrameRate.allCases {
            for base in Timecode.SubFramesBase.allCases {
                XCTAssertTrue(components.isWithinValidDigitCounts(at: fRate, base: base))
            }
        }
    }
    
    func testIsWithinValidDigitCountsC() {
        let components = Timecode.Components(d: 100)
        
        for fRate in TimecodeFrameRate.allCases {
            for base in Timecode.SubFramesBase.allCases {
                XCTAssertFalse(components.isWithinValidDigitCounts(at: fRate, base: base))
            }
        }
    }
    
    func testIsWithinValidDigitCountsD() {
        let components = Timecode.Components(h: 100)
        
        for fRate in TimecodeFrameRate.allCases {
            for base in Timecode.SubFramesBase.allCases {
                XCTAssertFalse(components.isWithinValidDigitCounts(at: fRate, base: base))
            }
        }
    }
    
    func testIsWithinValidDigitCountsE() {
        let components = Timecode.Components(m: 100)
        
        for fRate in TimecodeFrameRate.allCases {
            for base in Timecode.SubFramesBase.allCases {
                XCTAssertFalse(components.isWithinValidDigitCounts(at: fRate, base: base))
            }
        }
    }
    
    func testIsWithinValidDigitCountsF() {
        let components = Timecode.Components(s: 100)
        
        for fRate in TimecodeFrameRate.allCases {
            for base in Timecode.SubFramesBase.allCases {
                XCTAssertFalse(components.isWithinValidDigitCounts(at: fRate, base: base))
            }
        }
    }
    
    func testIsWithinValidDigitCountsG() {
        do {
            let components = Timecode.Components(f: 100)
            
            for fRate in TimecodeFrameRate.allCases.filter({ $0.numberOfDigits == 2 }) {
                for base in Timecode.SubFramesBase.allCases {
                    XCTAssertFalse(components.isWithinValidDigitCounts(at: fRate, base: base))
                }
            }
        }
        do {
            let components = Timecode.Components(f: 1000)
            
            for fRate in TimecodeFrameRate.allCases.filter({ $0.numberOfDigits == 3 }) {
                for base in Timecode.SubFramesBase.allCases {
                    XCTAssertFalse(components.isWithinValidDigitCounts(at: fRate, base: base))
                }
            }
        }
    }
}
