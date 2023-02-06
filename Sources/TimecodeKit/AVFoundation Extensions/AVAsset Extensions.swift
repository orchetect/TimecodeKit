//
//  AVAsset Extensions.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// AVAssetReader is unavailable on watchOS so we can't support any AVAsset operations
#if canImport(AVFoundation) && !os(watchOS)

import Foundation
import AVFoundation

// MARK: - Start Timecode

extension AVAsset {
    /// Returns the start timecode.
    /// Returns an array because more than one track in an asset may contain this information.
    /// Generally using the first array element is sufficient.
    ///
    /// Passing a value to `frameRate` will override frame rate detection.
    /// Passing `nil` will detect frame rate from the asset's contents if possible.
    ///
    /// - Throws: ``Timecode/MediaParseError``
    @_disfavoredOverload
    public func startTimecode(
        at frameRate: TimecodeFrameRate? = nil,
        limit: Timecode.UpperLimit = ._24hours,
        base: Timecode.SubFramesBase = .default(),
        format: Timecode.StringFormat = .default()
    ) throws -> [Timecode] {
        let frameRate = try frameRate ?? self.timecodeFrameRate()
        let timecodes = readStartElapsedFrames()
            .compactMap {
                // ignore errors here to prevent one error from failing to return all found
                try? Timecode(
                    .frames(Int($0)),
                    at: frameRate,
                    limit: limit,
                    base: base,
                    format: format
                )
            }
        
        //if timecodes.isEmpty, allowDefault {
        //    let zeroTimecode = Timecode(
        //        at: frameRate,
        //        limit: limit,
        //        base: base,
        //        format: format
        //    )
        //    timecodes.append(zeroTimecode)
        //}
        
        return timecodes
    }
    
    /// Returns the end timecode (start + duration).
    /// Returns an array because more than one track in an asset may contain this information.
    /// Generally using the first array element is sufficient.
    ///
    /// Passing a value to `frameRate` will override frame rate detection.
    /// Passing `nil` will detect frame rate from the asset's contents if possible.
    ///
    /// - Throws: ``Timecode/MediaParseError`` or ``Timecode/ValidationError``
    @_disfavoredOverload
    public func endTimecode(
        at frameRate: TimecodeFrameRate? = nil,
        limit: Timecode.UpperLimit = ._24hours,
        base: Timecode.SubFramesBase = .default(),
        format: Timecode.StringFormat = .default()
    ) throws -> [Timecode] {
        let frameRate = try frameRate ?? self.timecodeFrameRate()
        return try startTimecode(
            at: frameRate,
            limit: limit,
            base: base,
            format: format
        )
        .compactMap {
            $0 + (try durationTimecode(
                at: frameRate,
                limit: limit,
                base: base,
                format: format
            ))
        }
    }
    
    /// Returns the duration expressed as timecode.
    /// Returns an array because more than one track in an asset may contain this information.
    /// Generally using the first array element is sufficient.
    ///
    /// Passing a value to `frameRate` will override frame rate detection.
    /// Passing `nil` will detect frame rate from the asset's contents if possible.
    ///
    /// - Throws: ``Timecode/MediaParseError`` or ``Timecode/ValidationError``
    @_disfavoredOverload
    public func durationTimecode(
        at frameRate: TimecodeFrameRate? = nil,
        limit: Timecode.UpperLimit = ._24hours,
        base: Timecode.SubFramesBase = .default(),
        format: Timecode.StringFormat = .default()
    ) throws -> Timecode {
        let frameRate = try frameRate ?? self.timecodeFrameRate()
        return try Timecode(
            duration,
            at: frameRate,
            limit: limit,
            base: base,
            format: format
        )
    }
    
    // MARK: - Helpers
    
    @_disfavoredOverload
    internal func readStartElapsedFrames() -> [UInt32] {
        timecodeTracks.compactMap { $0.readStartTimecodeElapsedFrames(context: self) }
    }
    
    private var timecodeTracks: [AVAssetTrack] {
        tracks(withMediaType: .timecode)
    }
}

extension AVAssetTrack {
    // MARK: - Helper methods
    
    /// Returns the start timecode expressed as total elapsed frames.
    /// Returns `nil` if the track is not a timecode track.
    internal func readStartTimecodeElapsedFrames(
        context: AVAsset
    ) -> UInt32? {
        guard let assetReader = try? AVAssetReader(asset: context) else {
            return nil
        }
        
        let readerOutput = AVAssetReaderTrackOutput(track: self, outputSettings: nil)
        assetReader.add(readerOutput)
        guard assetReader.startReading() else { return nil }
        
        // QuickTime timecode track is either 4 or 8 bytes long (UInt32 or UInt64)
        // representing the frame number
        while let sampleBuffer = readerOutput.copyNextSampleBuffer() {
            if let frame = Self.readStartFrameNumber(sampleBuffer: sampleBuffer) {
                return frame
            }
        }
        
        return nil
    }
    
    private static func readStartFrameNumber(sampleBuffer: CMSampleBuffer) -> UInt32? {
        guard let blockBuffer = CMSampleBufferGetDataBuffer(sampleBuffer),
              let formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer)
        else { return nil }
        
        var rawData: UnsafeMutablePointer<CChar>? // CChar == Int8
        var length: Int = 0
        var totalLength: Int = 0
        
        let status = CMBlockBufferGetDataPointer(
            blockBuffer,
            atOffset: 0,
            lengthAtOffsetOut: &length,
            totalLengthOut: &totalLength,
            dataPointerOut: &rawData
        )
        
        guard status == kCMBlockBufferNoErr else { return nil }
        
        let type = CMFormatDescriptionGetMediaSubType(formatDescription)
        
        switch type {
        case kCMTimeCodeFormatType_TimeCode32:
            if length >= MemoryLayout<UInt32>.size,
               let frames = rawData?.withMemoryRebound(
                   to: UInt32.self,
                   capacity: 1,
                   { CFSwapInt32BigToHost($0.pointee) }
               )
            {
                return frames
            }
            
        case kCMTimeCodeFormatType_TimeCode64:
            // not sure when 64-bit frame number would be used?
            // UInt32.max can fit approx 207 days @ 240fps which would never happen
            // unless 64-bit timecode encodes different information in the additional 4 bytes?
            if length >= MemoryLayout<UInt64>.size,
               let frames = rawData?.withMemoryRebound(
                   to: UInt64.self,
                   capacity: 1,
                   { CFSwapInt64BigToHost($0.pointee) }
               )
            {
                return UInt32(exactly: frames)
            }
            
        default:
            break
        }
        
        return nil
    }
}

// MARK: - Frame Rate

extension AVAsset {
    // MARK: - Timecode Frame Rate
    
    /// Returns the frame rate detected.
    /// Accuracy depends on what type of tracks are contained in the asset.
    /// Returns `nil` if not enough information is present to detect frame rate,
    /// or if the frame rate is non-standard.
    ///
    /// - Parameters:
    /// - drop: Forces drop-frame status for the frame rate, ignoring any drop-frame information
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
        let validVideoFrameDurations = videoTracks.map(\.minFrameDuration).filter(\.isValid)
        if let frameDuration = validVideoFrameDurations.first,
           let tcRate = TimecodeFrameRate(frameDuration: frameDuration, drop: drop)
        {
            return tcRate
        }
        
        // second, frame rate can be determined from timecode track format description
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
            // it seems only timecode track contains this, but perhaps only when a video track
            // is also present in the asset.
            let frameDurations = timecodeTracks
                .flatMap {
                    // force-downcast is recommended by Apple docs
                    $0.formatDescriptions as! [CMFormatDescription]
                }
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
        
        let flags = timecodeTracks
            .flatMap {
                // force-downcast is recommended by Apple docs
                $0.formatDescriptions as! [CMFormatDescription]
            }
            .map { $0.timeCodeFlags.contains(.dropFrame) }
        
        return flags.contains(true)
    }
    
    // MARK: - Video Frame Rate
    
    /// Returns the video frame rate for each video track.
    public func videoFrameRate(interlaced: Bool? = nil) throws -> VideoFrameRate {
        // only video tracks contain interlaced (field) info
        
        // use supplied interlaced status, otherwise auto-detect and default to non-interlaced (progressive)
        let interlaced = interlaced ?? isVideoInterlaced ?? false
        
        // first, frame rate can be determined from minimum frame duration
        // only video tracks will contain this value. audio or timecode tracks will be zero.
        let validVideoFrameDurations = videoTracks.map(\.minFrameDuration).filter(\.isValid)
        if let frameDuration = validVideoFrameDurations.first,
           let rate = VideoFrameRate(frameDuration: frameDuration, interlaced: interlaced)
        {
            return rate
        }
        
        // second, frame rate can be determined from video format description
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
            // it seems only timecode track contains this, but perhaps only when a video track
            // is also present in the asset.
            let frameDurations = videoTracks
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
        
        // handle an edge case where an asset has timecode track(s) but no video tracks
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
            // it seems only timecode track contains this, but perhaps only when a video track
            // is also present in the asset.
            let frameDurations = timecodeTracks
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
    
    internal var isVideoInterlaced: Bool? {
        guard #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
        else { return nil }
        
        let extDicts = tracks(withMediaType: .video)
            .flatMap {
                // force-downcast is recommended by Apple docs
                $0.formatDescriptions as! [CMFormatDescription]
            }
            .map { $0.extensionsDictionary }
        
        let fieldCounts = extDicts.compactMap { $0["CVFieldCount" as CFString] as? NSNumber }
        
        // progressive is 1 field, interlaced is 2 fields
        return fieldCounts.contains(where: { $0.intValue > 1 })
    }
    
    // MARK: - Helpers
    
    /// Returns the nominal frame rate as `Float` for each video track.
    internal func readNominalVideoFrameRates() -> [Float] {
        let rates = videoTracks.map(\.nominalFrameRate)
        return rates
    }
    
    private var videoTracks: [AVAssetTrack] {
        tracks(withMediaType: .video)
    }
}

// MARK: - Utils

extension CMFormatDescription {
    /// Returns extensions as a dictionary.
    ///
    /// Extensions dictionaries are valid property list objects.
    /// This means that dictionary keys are all CFStrings, and the values are all either CFNumber, CFString, CFBoolean, CFArray, CFDictionary, CFDate, or CFData
    ///
    /// You can subscript the dictionary using global AVFoundation key constants beginning with `kCMFormatDescriptionExtension_`
    internal var extensionsDictionary: [CFString: Any] {
        let nsDict = CMFormatDescriptionGetExtensions(self) as NSDictionary?
        let dict = nsDict as? [CFString: Any]
        return dict ?? [:]
    }
}

#endif
