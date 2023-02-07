//
//  AVAsset Frame Rate Read.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// AVAssetReader is unavailable on watchOS so we can't support any AVAsset operations
#if canImport(AVFoundation) && !os(watchOS)

import Foundation
import AVFoundation

// MARK: - Timecode Frame Rate

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
    public func timecodeFrameRate(drop: Bool? = nil) throws -> TimecodeFrameRate {
        // a timecode track does not contain frame rate information
        // likewise, a video track does not contain start timecode/offset
        // additionally, drop-frame flag is not readable from video tracks. if present, it will only
        // be in the timecode track.
        
        // use supplied drop-frame status, otherwise auto-detect and default to non-drop
        let drop = drop ?? isTimecodeFrameRateDropFrame ?? false
        
        // first, frame rate can be determined from minimum frame duration
        // only video tracks will contain this value. audio or timecode tracks will be zero.
        let validVideoFrameDurations = tracks(withMediaType: .video)
            .map(\.minFrameDuration)
            .filter(\.isValid)
        if let frameDuration = validVideoFrameDurations.first,
           let tcRate = TimecodeFrameRate(frameDuration: frameDuration, drop: drop)
        {
            return tcRate
        }
        
        // second, frame rate can be determined from timecode track format description
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
            // it seems only timecode track contains this, but perhaps only when a video track
            // is also present in the asset.
            let frameDurations = tracks(withMediaType: .timecode)
                .flatMap(\.formatDescriptionsTyped)
                .map { $0.frameDuration }
            if let frameDuration = frameDurations.first,
               let tcRate = TimecodeFrameRate(frameDuration: frameDuration, drop: drop)
            {
                return tcRate
            }
        }
        
        // third, frame rate can be derived from nominal frame rate.
        // determine video frame rate and attempt to convert it to timecode frame rate
        if let rate = try videoFrameRate().timecodeFrameRate(drop: drop) {
            return rate
        }
        
        throw Timecode.MediaParseError.missingOrNonStandardFrameRate
    }
    
    /// If drop-frame status is embedded, returns `true` (drop) or `false` (non-drop).
    /// Returns `nil` if drop-frame status is unknown.
    /// Best practise is to default to `false` if `nil` is returned.
    internal var isTimecodeFrameRateDropFrame: Bool? {
        guard #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
        else { return nil }
        
        let flags = tracks(withMediaType: .timecode)
            .flatMap {
                // force-downcast is recommended by Apple docs
                $0.formatDescriptions as! [CMFormatDescription]
            }
            .map { $0.timeCodeFlags.contains(.dropFrame) }
        
        // if more than one timecode track exists, check if any contain drop-frame
        return flags.contains(true)
    }
}

// MARK: - Video Frame Rate

extension AVAsset {
    /// Returns the video frame rate for each video track.
    public func videoFrameRate(interlaced: Bool? = nil) throws -> VideoFrameRate {
        // only video tracks contain interlaced (field) info
        
        // use supplied interlaced status, otherwise auto-detect and default to non-interlaced (progressive)
        let interlaced = interlaced ?? isVideoInterlaced
        
        // first, frame rate can be determined from minimum frame duration
        // only video tracks will contain this value. audio or timecode tracks will be zero.
        let validVideoFrameDurations = tracks(withMediaType: .video)
            .map(\.minFrameDuration)
            .filter(\.isValid)
        if let frameDuration = validVideoFrameDurations.first,
           let rate = VideoFrameRate(frameDuration: frameDuration, interlaced: interlaced)
        {
            return rate
        }
        
        // second, frame rate can be determined from video format description
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
            // it seems only timecode track contains this, but perhaps only when a video track
            // is also present in the asset.
            let frameDurations = tracks(withMediaType: .video)
                .flatMap(\.formatDescriptionsTyped)
                .map(\.frameDuration)
            if let frameDuration = frameDurations.first,
               let tcRate = VideoFrameRate(frameDuration: frameDuration, interlaced: interlaced)
            {
                return tcRate
            }
        }
        
        // handle an edge case where an asset has timecode track(s) but no video tracks
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
            // it seems only timecode track contains this, but perhaps only when a video track
            // is also present in the asset.
            let frameDurations = tracks(withMediaType: .timecode)
                .flatMap {
                    // force-downcast is recommended by Apple docs
                    $0.formatDescriptions as! [CMFormatDescription]
                }
                .map { $0.frameDuration }
            if let frameDuration = frameDurations.first,
               let tcRate = VideoFrameRate(frameDuration: frameDuration, interlaced: interlaced)
            {
                return tcRate
            }
        }
        
        // lastly, frame rate can be derived from nominal frame rate
        // but this is not always reliable in some cases, such as some codecs that
        // can encode video in variable frame rate format, or non-standard frame rates
        if let rate = readNominalVideoFrameRates()
            .compactMap({ VideoFrameRate(fps: $0, interlaced: interlaced) })
            .first
        {
            return rate
        }
        
        throw Timecode.MediaParseError.missingOrNonStandardFrameRate
    }
    
    /// Returns `true` if the first video track is interlaced.
    public var isVideoInterlaced: Bool {
        tracks(withMediaType: .video)
            .first?.isVideoInterlaced ?? false
    }
    
    // MARK: - Helpers
    
    /// Returns the nominal frame rate as `Float` for each video track.
    internal func readNominalVideoFrameRates() -> [Float] {
        tracks(withMediaType: .video)
            .map(\.nominalFrameRate)
    }
}

extension AVAssetTrack {
    /// Returns `true` if the video track is interlaced.
    /// Not applicable for non-video tracks.
    internal var isVideoInterlaced: Bool {
        // progressive is 1 field, interlaced is 2 fields
        formatDescriptionsTyped
            .map(\.extensionsDictionary)
            .compactMap { $0["CVFieldCount" as CFString] as? NSNumber }
            .contains(where: { $0.intValue > 1 })
    }
}

#endif
