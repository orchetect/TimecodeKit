//
//  Timecode Elapsed Frames ExtendedTests.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

@testable import SwiftTimecodeCore
import XCTest

// import XCTestUtils
//
// final class Timecode_ExtendedTests: XCTestCase {
//     func testTimecode_Iterative() {
//         // test conversions from components(of:) and frameCount(of:)
//
//         // ==============================================================================
//         // NOTE:
//         // ==============================================================================
//         // this is a brute-force test not meant to be run frequently,
//         // but as a diagnostic testbed only when major changes are made to the library
//         // to ensure that conversions are accurate
//         // ==============================================================================
//
//         // ======= parameters =======
//
//         let limit: Timecode.UpperLimit =
//             .max24Hours
//         // .max100Days
//
//         let frameRatesToTest: [TimecodeFrameRate] =
//             TimecodeFrameRate.allCases
//         // TimecodeFrameRate.allDrop
//         // TimecodeFrameRate.allNonDrop
//         // [.fps60d, .fps120d]
//
//         // ======= run ==============
//
//         for fr in frameRatesToTest {
//             let tc = Timecode(.zero, at: fr, limit: limit)
//
//             // log status
//             print("Testing all frames in \(tc.upperLimit) at \(fr.stringValue)... ", terminator: "")
//
//             var failures: [(Int, Timecode.Components)] = []
//
//             let ubound = tc.frameRate.maxTotalFrames(in: tc.upperLimit)
//
//             var per = SegmentedProgress(0 ... ubound, segments: 20, roundedToPlaces: 0)
//
//             for i in 0 ... ubound {
//                 let vals = Timecode.components(
//                     of: .init(.frames(i), base: tc.subFramesBase),
//                     at: tc.frameRate
//                 )
//
//                 if i != Timecode.frameCount(
//                     of: vals,
//                     at: tc.frameRate,
//                     base: tc.subFramesBase
//                 ).wholeFrames
//
//                 { failures.append((i, vals)) }
//
//                 // log status
//                 if let percentageToPrint = per.progress(value: i) {
//                     print("\(percentageToPrint) ", terminator: "")
//                 }
//             }
//             print("") // finalize log with newline char
//
//             XCTAssertEqual(
//                 failures.count,
//                 0,
//                 "Failed iterative test for \(fr) with \(failures.count) failures."
//             )
//
//             if !failures.isEmpty {
//                 print(
//                     "First",
//                     fr,
//                     "failure: input elapsed frames",
//                     failures.first!.0,
//                     "converted to components",
//                     failures.first!.1,
//                     "converted back to",
//                     Timecode.frameCount(
//                         of: failures.first!.1,
//                         at: tc.frameRate,
//                         base: tc.subFramesBase
//                     ),
//                     "elapsed frames."
//                 )
//             }
//             if failures.count > 1 {
//                 print(
//                     "Last",
//                     fr,
//                     "failure: input elapsed frames",
//                     failures.last!.0,
//                     "converted to components",
//                     failures.last!.1,
//                     "converted back to",
//                     Timecode.frameCount(
//                         of: failures.last!.1,
//                         at: tc.frameRate,
//                         base: tc.subFramesBase
//                     ),
//                     "elapsed frames."
//                 )
//             }
//         }
//
//         print("Done")
//     }
// }
