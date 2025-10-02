//
//  Model.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

@preconcurrency import AVFoundation
import Observation
import TimecodeKit

extension Model {
    struct Movie: Equatable, Hashable, Sendable {
        let avMovie: AVMovie
        let url: URL?
        
        // cached metadata
        let frameRate: TimecodeFrameRate?
        let timecodeStart: Timecode?
        let containsTimecodeTrack: Bool
        
        init(
            url: URL,
            frameRate: TimecodeFrameRate?,
            timecodeStart: Timecode?,
            containsTimecodeTrack: Bool
        ) {
            avMovie = AVMovie(url: url)
            self.url = url
            self.frameRate = frameRate
            self.timecodeStart = timecodeStart
            self.containsTimecodeTrack = containsTimecodeTrack
        }
        
        init(
            avMovie: AVMovie,
            frameRate: TimecodeFrameRate?,
            timecodeStart: Timecode?,
            containsTimecodeTrack: Bool
        ) {
            self.avMovie = avMovie
            url = avMovie.url
            self.frameRate = frameRate
            self.timecodeStart = timecodeStart
            self.containsTimecodeTrack = containsTimecodeTrack
        }
    }
}

extension Model.Movie {
    enum ExportAction {
        case removeTimecodeTrack
        case replaceTimecodeTrack(startTimecode: Timecode)
    }
    
    /// Creates a copy of the movie, performs the operation, exports to a new file,
    /// and optionally reveals the new file in the Finder (macOS only).
    func export(
        action: ExportAction,
        to url: URL,
        revealInFinderOnCompletion: Bool
    ) async throws(ModelError) {
        do {
            let mutableMovie = try getMutableMovieCopy()
            
            switch action {
            case .removeTimecodeTrack:
                try await mutableMovie.removeTimecodeTracks()
            case .replaceTimecodeTrack(let startTimecode):
                try await mutableMovie.replaceTimecodeTrack(startTimecode: startTimecode, fileType: .mov)
            }
            
            try await mutableMovie.export(to: url)

            #if os(macOS)
            if revealInFinderOnCompletion {
                try url.revealInFinder()
            }
            #endif
        } catch let err as ModelError {
            throw err
        } catch let err {
            throw .exportError(err)
        }
    }
    
    /// Produces a mutable copy of the loaded movie.
    fileprivate func getMutableMovieCopy() throws(ModelError) -> AVMutableMovie {
        guard let mutableMovie = avMovie.mutableCopy() as? AVMutableMovie else {
            throw .errorCreatingMutableMovieCopy
        }
        return mutableMovie
    }
}
