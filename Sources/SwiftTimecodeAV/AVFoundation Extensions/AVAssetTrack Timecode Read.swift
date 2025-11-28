//
//  AVAssetTrack Timecode Read.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

// AVAssetReader is unavailable on watchOS so we can't support any AVAsset operations
#if canImport(AVFoundation) && !os(watchOS) && !os(visionOS)

import AVFoundation
import Foundation

// MARK: - Helper methods

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension AVAssetTrack {
    /// Returns the track duration expressed as timecode.
    ///
    /// Passing a value to `frameRate` will override frame rate detection.
    /// Passing `nil` will detect frame rate from the asset's contents if possible.
    ///
    /// - Throws: ``SwiftTimecodeCore/Timecode/MediaParseError`` or `Timecode.ValidationError`
    @_disfavoredOverload
    public func durationTimecode(
        at frameRate: TimecodeFrameRate? = nil,
        limit: Timecode.UpperLimit = .max24Hours,
        base: Timecode.SubFramesBase = .default()
    ) async throws -> Timecode {
        guard let frameRate = try await {
            if let frameRate { return frameRate }
            return try await asset?.timecodeFrameRate()
        }()
        else {
            throw Timecode.MediaParseError.missingOrNonStandardFrameRate
        }
        
        let range = try await timecodeRange(
            at: frameRate,
            limit: limit,
            base: base
        )
        
        return range.upperBound - range.lowerBound
    }
    
    // MARK: - Helpers
    
    // Note:
    // This shouldn't be public because it's not terribly useful and might be misleading.
    // For example, if used on a timecode track ("tmcd"), this will often return a range
    // that starts from 0 and ends with the duration, instead of providing the actual timecode track's
    // start and end timecode. This is because it references the `timeRange` property.
    //
    /// Returns the track `timeRange` as a range of timecode.
    ///
    /// Passing a value to `frameRate` will override frame rate detection.
    /// Passing `nil` will detect frame rate from the asset's contents if possible.
    ///
    /// - Throws: ``SwiftTimecodeCore/Timecode/MediaParseError``
    @_disfavoredOverload
    func timecodeRange(
        at frameRate: TimecodeFrameRate? = nil,
        limit: Timecode.UpperLimit = .max24Hours,
        base: Timecode.SubFramesBase = .default()
    ) async throws -> ClosedRange<Timecode> {
        guard let frameRate = try await {
            if let frameRate { return frameRate }
            return try await asset?.timecodeFrameRate()
        }()
        else {
            throw Timecode.MediaParseError.missingOrNonStandardFrameRate
        }
        
        return try timeRange.timecodeRange(
            at: frameRate,
            base: base,
            limit: limit
        )
    }
    
    /// Returns the start frame number from a timecode track.
    /// Returns `nil` if the track is not a timecode track.
    func readTimecodeSamples(
        context: AVAsset
    ) throws -> [CMTimeCode] {
        let assetReader = try AVAssetReader(asset: context)
        let readerOutput = AVAssetReaderTrackOutput(track: self, outputSettings: nil)
        assetReader.add(readerOutput)
        guard assetReader.startReading() else {
            throw Timecode.MediaParseError.internalError
        }
        
        // QuickTime timecode track is either 4 or 8 bytes long (UInt32 or UInt64)
        // representing the frame number
        var samples: [CMTimeCode] = []
        while let sampleBuffer = readerOutput.copyNextSampleBuffer() {
            let bufferSamples = try? Self._readTimecodeSamples(sampleBuffer: sampleBuffer)
            samples.append(contentsOf: bufferSamples ?? [])
        }
        
        return samples
    }
    
    private static func _readTimecodeSamples(sampleBuffer: CMSampleBuffer) throws -> [CMTimeCode] {
        // FYI: on macOS 10.15/iOS 13 and later, you can use
        // sampleBuffer.formatDescription instead of CMSampleBufferGetFormatDescription
        guard let blockBuffer = CMSampleBufferGetDataBuffer(sampleBuffer),
              let formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer)
        else {
            // not an error condition; this routine will be called many times
            // and only some times will contain the data we need
            return []
        }
        
        guard sampleBuffer.totalSampleSize > 0 else {
            return []
        }
        
        // on macOS 10.15/iOS 13 and later, you can use
        // formatDescription.mediaSubType instead of CMFormatDescriptionGetMediaSubType
        let type = formatDescription.mediaSubType
        
        var offset = 0
        
        switch type {
        case .timeCode32: // kCMTimeCodeFormatType_TimeCode32
            var samples: [CMTimeCode32] = []
            while let tc = _readTimecode32Sample(blockBuffer: blockBuffer, offset: offset) {
                samples.append(tc)
                offset += CMTimeCode32.byteLength
            }
            return samples
            
        case .timeCode64: // kCMTimeCodeFormatType_TimeCode64
            var samples: [CMTimeCode64] = []
            while let tc = _readTimecode64Sample(blockBuffer: blockBuffer, offset: offset) {
                samples.append(tc)
                offset += CMTimeCode64.byteLength
            }
            return samples
            
        default:
            // TODO: this may happen if Counter mode is used, in which case it should be parsed
            throw Timecode.MediaParseError.unknownTimecode
        }
    }
    
    /// Timecode32 is a single number representing the frame number.
    private static func _readTimecode32Sample(
        blockBuffer: CMBlockBuffer,
        offset: Int
    ) -> CMTimeCode32? {
        var rawData: UnsafeMutablePointer<CChar>? // CChar == Int8
        var length = 0
        
        let status = CMBlockBufferGetDataPointer(
            blockBuffer,
            atOffset: offset,
            lengthAtOffsetOut: &length,
            totalLengthOut: nil,
            dataPointerOut: &rawData
        )
        
        guard status == kCMBlockBufferNoErr else { return nil }
        
        guard length >= MemoryLayout<UInt32>.size,
              let frame = rawData?.withMemoryRebound(
                  to: UInt32.self,
                  capacity: 1,
                  { CFSwapInt32BigToHost($0.pointee) }
              )
        else { return nil }
        
        return CMTimeCode32(frameNumber: frame)
    }
    
    /// Timecode64 is big-endian SInt64 encoding 4 x 16-bit integers for h, m, s, f.
    private static func _readTimecode64Sample(
        blockBuffer: CMBlockBuffer,
        offset: Int
    ) -> CMTimeCode64? {
        var rawData: UnsafeMutablePointer<CChar>? // CChar == Int8
        var length = 0
        
        let status = CMBlockBufferGetDataPointer(
            blockBuffer,
            atOffset: offset,
            lengthAtOffsetOut: &length,
            totalLengthOut: nil,
            dataPointerOut: &rawData
        )
        
        guard status == kCMBlockBufferNoErr else { return nil }
        
        guard length >= MemoryLayout<UInt64>.size,
              let rawValue = rawData?.withMemoryRebound(
                  to: UInt64.self,
                  capacity: 1,
                  { CFSwapInt64BigToHost($0.pointee) }
              )
        else { return nil }
        
        return CMTimeCode64(uInt64: rawValue)
    }
}

#endif
