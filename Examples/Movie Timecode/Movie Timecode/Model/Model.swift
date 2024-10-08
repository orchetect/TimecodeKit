//
//  Model.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import AVFoundation
import Observation
import TimecodeKit

@Observable class Model {
    private(set) var movie: Movie?
    var error: ModelError?
}

extension Model {
    struct Movie {
        private(set) var avMovie: AVMovie
        private(set) var frameRate: TimecodeFrameRate?
        private(set) var timecodeStart: Timecode?
        private(set) var containsTimecodeTrack: Bool = false
    }
}

// MARK: - Handlers

extension Model {
    func handleFileImport(result: Result<URL, any Error>) {
        switch result {
        case let .success(url):
            Task {
                movie = nil // forces views to update
                await updateMetadata(newMovie: AVMovie(url: url))
                error = nil
            }
        case let .failure(err):
            error = .fileImportError(err)
        }
    }
    
    /// Updates cached values in the model.
    func updateMetadata(newMovie: AVMovie) async {
        let frameRate = try? await newMovie.timecodeFrameRate()
        async let timecodeStart = try? newMovie.startTimecode()
        async let timecodeTracks = (try? newMovie.loadTracks(withMediaType: .timecode)) ?? []
        
        movie = await Movie(
            avMovie: newMovie,
            frameRate: frameRate,
            timecodeStart: timecodeStart,
            containsTimecodeTrack: !timecodeTracks.isEmpty
        )
    }
}

// MARK: - View Model

extension Model {
    var movieURL: URL? {
        movie?.avMovie.url
    }
    
    var movieFileName: String? {
        movie?.avMovie.url?.lastPathComponent
    }
    
    var movieContainingFolder: URL? {
        movie?.avMovie.url?.deletingLastPathComponent()
    }
    
    var movieFrameRate: TimecodeFrameRate? {
        movie?.frameRate
    }
    
    var movieFrameRateString: String {
        guard movie != nil else { return "-" }
        guard let movieFrameRate else { return "Could not detect." }
        return movieFrameRate.stringValueVerbose
    }
    
    var movieStartTimecode: Timecode? {
        movie?.timecodeStart
    }
    
    var movieStartTimecodeString: String {
        guard movie != nil else { return "-" }
        guard let movieStartTimecode else { return "Missing or invalid." }
        return movieStartTimecode .stringValue(format: [.showSubFrames])
    }
    
    var containsTimecodeTrack: Bool? {
        movie?.containsTimecodeTrack
    }
    
    var containsTimecodeTrackString: String {
        guard movie != nil else { return "-" }
        guard let containsTimecodeTrack else { return "-" }
        return containsTimecodeTrack ? "Yes" : "No"
    }
    
    func defaultExportFileName(disambiguation: String? = nil) -> String {
        let base = movieURL?.deletingPathExtension().lastPathComponent ?? "Movie"
        let suffix = "-Exported"
        let disamb = (disambiguation != nil ? "-" : "") + (disambiguation ?? "")
        let ext = UTType.quickTimeMovie.preferredFilenameExtension ?? "mov"
        
        return base + suffix + disamb + "." + ext
    }
    
    /// Forms a file URL ensuring it is unique and does not exist.
    func uniqueExportURL(folder folderURL: URL) -> URL? {
        do {
            return try _uniqueExportURL(folder: folderURL)
        } catch let err as ModelError {
            error = err
        } catch let err {
            error = .exportError(err)
        }
        
        return nil
    }
    
    /// Forms a file URL ensuring it is unique and does not exist.
    private func _uniqueExportURL(folder folderURL: URL) throws -> URL {
        var isDirectory: ObjCBool = false
        let isExists = FileManager.default.fileExists(atPath: folderURL.path(percentEncoded: false), isDirectory: &isDirectory)
        
        guard isExists else {
            throw ModelError.pathDoesNotExist
        }
        
        guard isDirectory.boolValue else {
            throw ModelError.pathIsNotFolder
        }
        
        var fileURL = folderURL.appending(component: defaultExportFileName())
        
        // disambiguate if file exists
        var index = 1
        while FileManager.default.fileExists(atPath: fileURL.path(percentEncoded: false)) {
            fileURL = folderURL.appending(component: defaultExportFileName(disambiguation: "\(index)"))
            index += 1
        }
        
        return fileURL
    }
    
    var defaultFolder: URL {
        #if os(macOS)
        movieContainingFolder ?? URL.desktopDirectory
        #else
        URL.documentsDirectory
        #endif
    }
    
    var defaultTimecode: Timecode {
        Timecode(.zero, at: movieFrameRate ?? .fps24)
    }
}

// MARK: - Movie Mutation and Export

extension Model {
    func exportReplacingTimecodeTrack(
        startTimecode: Timecode,
        to url: URL,
        revealInFinderOnCompletion: Bool
    ) async {
        await export(
            to: url,
            revealInFinderOnCompletion: revealInFinderOnCompletion
        ) { mutableMovie in
            try await mutableMovie.replaceTimecodeTrack(startTimecode: startTimecode, fileType: .mov)
        }
    }
    
    func exportRemovingTimecodeTrack(
        to url: URL,
        revealInFinderOnCompletion: Bool
    ) async {
        await export(
            to: url,
            revealInFinderOnCompletion: revealInFinderOnCompletion
        ) { mutableMovie in
            try await mutableMovie.removeTimecodeTracks()
        }
    }
    
    /// Creates a copy of the movie, performs the operation, exports to a new file,
    /// and optionally reveals the new file in the Finder (macOS only).
    private func export(
        to url: URL,
        revealInFinderOnCompletion: Bool,
        _ mutation: (_ mutableMovie: AVMutableMovie) async throws -> Void
    ) async {
        do {
            let mutableMovie = try getMutableCopy()
            try await mutation(mutableMovie)
            try await mutableMovie.export(to: url)
            
            #if os(macOS)
            if revealInFinderOnCompletion {
                try url.revealInFinder()
            }
            #endif
        } catch let err as ModelError {
            error = err
        } catch let err {
            error = .exportError(err)
        }
    }
    
    /// Produces a mutable copy of the loaded movie.
    private func getMutableCopy() throws -> AVMutableMovie {
        guard let movie else {
            throw ModelError.noMovieLoaded
        }
        guard let mutableMovie = movie.avMovie.mutableCopy() as? AVMutableMovie else {
            throw ModelError.errorCreatingMutableMovieCopy
        }
        return mutableMovie
    }
}
