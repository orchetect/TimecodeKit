//
//  Timecode Track Write Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

@testable import TimecodeKit
import XCTest
import AVFoundation

// final class TimecodeTrackWriteTests: XCTestCase {
//     func testReplaceTimecodeTrack() async throws {
//         // parameters
//         let inputURL = FileManager.default.homeDirectoryForCurrentUser
//             .appendingPathComponent("Desktop")
//             .appendingPathComponent("Movie.mov")
//         let outputURL = FileManager.default.homeDirectoryForCurrentUser
//             .appendingPathComponent("Desktop")
//             .appendingPathComponent("Movie-Processed.mov")
//
//         // load movie off disk
//
//         print("Loading movie from disk...")
//
//         let movie = AVMovie(url: inputURL)
//
//         guard let mutableMovie = movie.mutableCopy() as? AVMutableMovie
//         else { XCTFail(); return }
//
//         print("Adding timecode track to movie...")
//
//         // replace existing timecode track if it exists, otherwise add a new timecode track
//         try mutableMovie.replaceTimecodeTrack(
//             startTimecode: Timecode(.components(h: 0, m: 59, s: 59, f: 00), at: .fps24),
//             fileType: .mov
//         )
//
//         print("Exporting movie to disk...")
//
//         // export
//         guard let export = AVAssetExportSession(
//             asset: mutableMovie,
//             presetName: AVAssetExportPresetPassthrough
//         ) else { XCTFail(); return }
//
//         export.outputFileType = .mov
//         export.outputURL = outputURL
//
//         // wait for export synchronously
//         let exporter = ObservableExporter(
//             session: export,
//             pollingInterval: 1.0,
//             progress: Binding<Double>(
//                 get: { 0 },
//                 set: { prog, _ in
//                     let percentString = String(format: "%.0f", prog * 100) + "%"
//                     print(percentString)
//                 }
//             )
//         )
//         let status = try await exporter.export()
//         print("100%")
//         print("Done, status:", status.rawValue)
//     }
// }
//
// import SwiftUI
//
// /// Wrapper for `AVAssetExportSession` to update Combine/SwiftUI binding with progress
// /// at a specified interval.
// class ObservableExporter {
//     var progressTimer: Timer?
//     let session: AVAssetExportSession
//     public let pollingInterval: TimeInterval
//     public let progress: Binding<Double>
//     public private(set) var duration: TimeInterval?
//
//     init(session: AVAssetExportSession,
//          pollingInterval: TimeInterval = 0.1,
//          progress: Binding<Double>) {
//         self.session = session
//         self.pollingInterval = pollingInterval
//         self.progress = progress
//     }
//
//     func export() async throws -> AVAssetExportSession.Status {
//         progressTimer = Timer(timeInterval: pollingInterval, repeats: true) { timer in
//             self.progress.wrappedValue = Double(self.session.progress)
//         }
//         RunLoop.main.add(progressTimer!, forMode: .common)
//         let startDate = Date()
//         await session.export()
//         progressTimer?.invalidate()
//         let endDate = Date()
//         duration = endDate.timeIntervalSince(startDate)
//         if let error = session.error {
//             throw error
//         } else {
//             return session.status
//         }
//     }
// }
