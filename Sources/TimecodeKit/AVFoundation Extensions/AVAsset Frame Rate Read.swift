//
//  AVAsset Frame Rate Read.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

// AVAssetReader is unavailable on watchOS so we can't support any AVAsset operations
#if canImport(AVFoundation) && !os(watchOS) && !os(visionOS)

import AVFoundation
import Foundation

// MARK: - Timecode Frame Rate

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension AVAsset {
    /// Returns the frame rate detected.
    /// Accuracy depends on what type of tracks are contained in the asset.
    /// Returns `nil` if not enough information is present to detect frame rate,
    /// or if the frame rate is non-standard.
    ///
    /// - Parameters:
    ///   - drop: Forces drop-frame status for the frame rate, ignoring any drop-frame information
    ///   that may be contained in the asset. If `nil`, drop-frame information is contained in the
    ///   asset is used, defaulting to `false`.
    ///
    /// - Throws: ``Timecode/MediaParseError``
    @_disfavoredOverload
    public func timecodeFrameRate(drop: Bool? = nil) async throws -> TimecodeFrameRate {
        // a timecode track does not contain frame rate information
        // likewise, a video track does not contain start timecode/offset
        // additionally, drop-frame flag is not readable from video tracks. if present, it will only
        // be in the timecode track.
        
        // use supplied drop-frame status, otherwise auto-detect and default to non-drop
        let drop = try await {
            if let drop { return drop }
            if let drop = try await isTimecodeFrameRateDropFrame { return drop }
            return false
        }()
        
        // first, frame rate can be determined from minimum frame duration
        // only video tracks will contain this value. audio or timecode tracks will be zero.
        let videoTracks = try await loadTracks(withMediaType: .video)
        let validVideoFrameDurations = videoTracks
            .map(\.minFrameDuration)
            .filter(\.isValid)
        if let frameDuration = validVideoFrameDurations.first,
           let tcRate = TimecodeFrameRate(frameDuration: frameDuration, drop: drop)
        {
            return tcRate
        }
        
        // second, frame rate can be determined from timecode track format description
        // it seems only timecode track contains this, but perhaps only when a video track
        // is also present in the asset.
        let timecodeTracks = try await loadTracks(withMediaType: .timecode)
        let timecodeFrameDurations = try await timecodeTracks
            .formatDescriptionsFlatMapped()
            .map(\.frameDuration)
        if let frameDuration = timecodeFrameDurations.first,
           let tcRate = TimecodeFrameRate(frameDuration: frameDuration, drop: drop)
        {
            return tcRate
        }
        
        // third, frame rate can be derived from nominal frame rate.
        // determine video frame rate and attempt to convert it to timecode frame rate
        if let rate = try await videoFrameRate().timecodeFrameRate(drop: drop) {
            return rate
        }
        
        throw Timecode.MediaParseError.missingOrNonStandardFrameRate
    }
    
    /// If drop-frame status is embedded, returns `true` (drop) or `false` (non-drop).
    /// Returns `nil` if drop-frame status is unknown.
    /// Best practise is to default to `false` if `nil` is returned.
    var isTimecodeFrameRateDropFrame: Bool? {
        get async throws {
            let timecodeTracks = try await loadTracks(withMediaType: .timecode)
            let flags = try await timecodeTracks
                .formatDescriptionsFlatMapped()
                .map { $0.timeCodeFlags.contains(.dropFrame) }
            
            // if more than one timecode track exists, check if any contain drop-frame
            return flags.contains(true)
        }
    }
}

// MARK: - Video Frame Rate

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension AVAsset {
    /// Returns the video frame rate for each video track.
    public func videoFrameRate(interlaced: Bool? = nil) async throws -> VideoFrameRate {
        let videoTracks = try await loadTracks(withMediaType: .video)
        
        // Note: only video tracks contain interlaced (field) info
        
        // use supplied interlaced status, otherwise auto-detect and default to non-interlaced
        // (progressive)
        let interlaced: Bool = await {
            if let interlaced { return interlaced }
            return await isVideoInterlaced
        }()
        
        // first, frame rate can be determined from minimum frame duration
        // only video tracks will contain this value. audio or timecode tracks will be zero.
        let validVideoFrameDurations = videoTracks
            .map(\.minFrameDuration)
            .filter(\.isValid)
        if let frameDuration = validVideoFrameDurations.first,
           let rate = VideoFrameRate(frameDuration: frameDuration, interlaced: interlaced)
        {
            return rate
        }
        
        // second, frame rate can be determined from video format description
        // it seems only timecode track contains this, but perhaps only when a video track
        // is also present in the asset.
        let videoFrameDurations = try await videoTracks
            .formatDescriptionsFlatMapped()
            .map(\.frameDuration)
        if let frameDuration = videoFrameDurations.first,
           let tcRate = VideoFrameRate(frameDuration: frameDuration, interlaced: interlaced)
        {
            return tcRate
        }
        
        let timecodeTracks = try await loadTracks(withMediaType: .timecode)
        
        // handle an edge case where an asset has timecode track(s) but no video tracks
        // it seems only timecode track contains this, but perhaps only when a video track
        // is also present in the asset.
        let timecodeFrameDurations = try await timecodeTracks
            .formatDescriptionsFlatMapped()
            .map(\.frameDuration)
        if let frameDuration = timecodeFrameDurations.first,
           let tcRate = VideoFrameRate(frameDuration: frameDuration, interlaced: interlaced)
        {
            return tcRate
        }
        
        // lastly, frame rate can be derived from nominal frame rate
        // but this is not always reliable in some cases, such as some codecs that
        // can encode video in variable frame rate format, or non-standard frame rates
        if let rate = await readNominalVideoFrameRates()
            .compactMap({ VideoFrameRate(fps: $0, interlaced: interlaced) })
            .first
        {
            return rate
        }
        
        throw Timecode.MediaParseError.missingOrNonStandardFrameRate
    }
    
    /// Returns `true` if the first video track is interlaced.
    public var isVideoInterlaced: Bool {
        get async {
            let videoTracks = try? await loadTracks(withMediaType: .video)
            let isVideoTrackInterlaced = await videoTracks?.first?.isVideoInterlaced
            return isVideoTrackInterlaced ?? false
        }
    }
    
    // MARK: - Helpers
    
    /// Returns the nominal frame rate as `Float` for each video track.
    func readNominalVideoFrameRates() async -> [Float] {
        guard let videoTracks = try? await loadTracks(withMediaType: .video) else { return [] }
        return videoTracks.map(\.nominalFrameRate)
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension AVAssetTrack {
    /// Returns `true` if the video track is interlaced.
    /// Not applicable for non-video tracks.
    var isVideoInterlaced: Bool {
        get async {
            // progressive is 1 field, interlaced is 2 fields
            guard let formatDescriptions = try? await formatDescriptions else { return false }
            return formatDescriptions
                .map(\.extensionsDictionary)
                .compactMap { $0["CVFieldCount" as CFString] as? NSNumber }
                .contains(where: { $0.intValue > 1 })
        }
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension AVAsset {
    /// Returns `formatDescriptions` flat-mapped from all tracks of the given type.
    @_disfavoredOverload
    func readFormatDescriptions(
        forTracksWithMediaType mediaType: AVMediaType
    ) async throws -> [CMFormatDescription] {
        let tracks = try await loadTracks(withMediaType: mediaType)
        return try await tracks.formatDescriptionsFlatMapped()
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension Collection where Element: AVAssetTrack {
    /// Returns `formatDescriptions` flat-mapped from all track in the collection.
    func formatDescriptionsFlatMapped() async throws -> [CMFormatDescription] {
        var formatDescriptions: [CMFormatDescription] = []
        
        for track in self {
            let trackFDs = try await track.formatDescriptions
            formatDescriptions.append(contentsOf: trackFDs)
        }
        
        return formatDescriptions
    }
}

#endif
