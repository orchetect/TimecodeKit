//
//  AVAsset Timecode Write.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

// AVAssetReader is unavailable on watchOS so we can't support any AVAsset operations
#if canImport(AVFoundation) && !os(watchOS) && !os(visionOS)

import AVFoundation
import Foundation

#if !os(tvOS) // AVMutableMovie not available on tvOS

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
@available(tvOS, unavailable)
extension AVMutableMovie {
    /// Add a timecode track containing one sample (start timecode).
    /// Existing timecode track(s) are left unaltered.
    /// If `duration` is omitted, the video's duration will be used.
    @discardableResult
    public func addTimecodeTrack(
        startTimecode: Timecode,
        duration: Timecode? = nil,
        extensions: CMFormatDescription.Extensions? = nil,
        fileType outputFileType: AVFileType
    ) async throws -> AVAssetTrack {
        // the only way to add a timecode track is to create a new
        // temporary asset and use AVAssetWriter.
        // AVMutableMovie does not provide enough API to author all aspects
        // of a timecode track.
        
        let duration: Timecode = try await {
            if let duration { return duration }
            return try await durationTimecode()
        }()
        
        let newAsset = try AVMutableMovie(
            timecodeTrackStart: startTimecode,
            duration: duration,
            extensions: extensions,
            fileType: outputFileType
        )
        guard let newTimecodeTrack = try? await newAsset.loadTracks(withMediaType: .timecode).first
        else {
            throw Timecode.MediaWriteError.internalError
        }
        
        // copy new track
        let mutableTracks = addMutableTracksCopyingSettings(from: [newTimecodeTrack])
        guard let targetTrack = mutableTracks.first else {
            throw Timecode.MediaWriteError.internalError
        }
        
        // we have to provide on-disk data storage
        targetTrack.mediaDataStorage = try .init(data: Data())
        
        try targetTrack.insertTimeRange(
            newTimecodeTrack.timeRange,
            of: newTimecodeTrack,
            at: .zero,
            copySampleData: true
        )
        
        // associate with all video tracks
        let videoTracks = try? await loadTracks(withMediaType: .video)
        videoTracks?.forEach {
            $0.addTrackAssociation(to: targetTrack, type: .timecode)
        }
        
        return targetTrack
    }
    
    /// Removes timecode track(s) if any exist, and adds a new timecode track containing one sample
    /// (start timecode)
    /// The frame rate is derived from the `timecode` supplied.
    /// If `duration` is omitted, the video's duration will be used.
    @discardableResult
    public func replaceTimecodeTrack(
        startTimecode: Timecode,
        duration: Timecode? = nil,
        extensions: CMFormatDescription.Extensions? = nil,
        fileType outputFileType: AVFileType
    ) async throws -> AVAssetTrack {
        // remove existing timecode tracks
        let existingTimecodeTracks = try await loadTracks(withMediaType: .timecode)
        existingTimecodeTracks.forEach { removeTrack($0) }
        
        let duration: Timecode = try await {
            if let duration { return duration }
            return try await durationTimecode(at: startTimecode.frameRate)
        }()
        
        return try await addTimecodeTrack(
            startTimecode: startTimecode,
            duration: duration,
            extensions: extensions,
            fileType: outputFileType
        )
    }
    
    /// Internal helper.
    /// Returns the format description of the first timecode track.
    private func getTimecodeFormatDescription() async throws -> CMTimeCodeFormatDescription? {
        try await loadTracks(withMediaType: .timecode)
            .first?
            .formatDescriptions
            .first as CMTimeCodeFormatDescription? // just a typealias
    }
    
    /// Internal helper:
    /// Creates a new asset with a timecode track containing one sample (start timecode).
    convenience init(
        timecodeTrackStart: Timecode,
        duration: Timecode,
        extensions: CMFormatDescription.Extensions? = nil,
        fileType outputFileType: AVFileType
    ) throws {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        let writer = try AVAssetWriter(url: url, fileType: outputFileType)
        let input = AVAssetWriterInput(mediaType: .timecode, outputSettings: nil)
        guard writer.canAdd(input) else { throw Timecode.MediaWriteError.internalError }
        writer.add(input)
        guard writer.startWriting() else { throw Timecode.MediaWriteError.internalError }
        writer.startSession(atSourceTime: .zero)
        
        // prep data
        var frames = UInt32(timecodeTrackStart.frameCount.wholeFrames).bigEndian
        
        // write data
        let blockBuffer = try CMBlockBuffer(length: MemoryLayout<UInt32>.size)
        // it's easier to fill empty bytes and then replace them,
        // otherwise we have to use append(buffer:) which is all kinds of scary
        try blockBuffer.fillDataBytes(with: 0x00)
        try withUnsafeBytes(of: &frames) { framesPtr in
            // try blockBuffer.append(buffer: framesPtr) // dealloc crash
            try blockBuffer.replaceDataBytes(with: framesPtr)
        }
        
        let sampleBuffer = try CMSampleBuffer(
            dataBuffer: blockBuffer,
            formatDescription: timecodeTrackStart.cmFormatDescription(extensions: extensions),
            numSamples: 1,
            sampleTimings: [CMSampleTimingInfo(duration: duration.cmTimeValue, presentationTimeStamp: .zero, decodeTimeStamp: .invalid)],
            sampleSizes: [4]
        )
        try sampleBuffer.makeDataReady() // needed? doesn't seem to hurt
        input.append(sampleBuffer)
        input.markAsFinished()
        
        // finish
        writer.endSession(atSourceTime: duration.cmTimeValue)
        let g = DispatchGroup()
        g.enter()
        writer.finishWriting {
            g.leave()
        }
        g.wait()
        
        // init set with data written to disk
        self.init(url: url)
    }
}

#endif

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension Timecode {
    /// Returns a new Core Media format description based on the timecode `frameRate`.
    ///
    /// - Throws: Core Media error.
    public func cmFormatDescription(
        extensions: CMFormatDescription.Extensions? = nil
    ) throws -> CMTimeCodeFormatDescription {
        // this method essentially wraps CMTimeCodeFormatDescriptionCreate,
        // an old crusty Obj-C method. it returned OSStatus so we assume the new
        // 'throws' method might return something related if an error occurs.
        try CMTimeCodeFormatDescription( // typealias of CMFormatDescription
            timeCodeFormatType: .timeCode32, // one that exists in CMTimeCodeFormatType
            frameDuration: frameRate.frameDurationCMTime,
            frameQuanta: frameRate.maxFrames,
            flags: cmFormatDescriptionTimeCodeFlags,
            extensions: extensions
        )
    }
    
    /// Internal:
    /// Assembles timecode flags for use in `CMFormatDescription`
    private var cmFormatDescriptionTimeCodeFlags: CMFormatDescription.TimeCode.Flag {
        var flags: CMFormatDescription.TimeCode.Flag = []
        if upperLimit == .max24Hours { flags.insert(.twentyFourHourMax) }
        if frameRate.isDrop { flags.insert(.dropFrame) }
        return flags
    }
}

#endif
