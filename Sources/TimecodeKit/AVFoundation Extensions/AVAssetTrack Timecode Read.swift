//
//  AVAssetTrack Timecode Read.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// AVAssetReader is unavailable on watchOS so we can't support any AVAsset operations
#if canImport(AVFoundation) && !os(watchOS)

import Foundation
import AVFoundation

// MARK: - Helper methods

extension AVAssetTrack {
    /// Returns the start frame number from a timecode track.
    /// Returns `nil` if the track is not a timecode track.
    internal func readTimecodeSamples(
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
            let bufferSamples = try? Self.readTimecodeSamples(sampleBuffer: sampleBuffer)
            samples.append(contentsOf: bufferSamples ?? [])
        }
        
        return samples
    }
    
    private static func readTimecodeSamples(sampleBuffer: CMSampleBuffer) throws -> [CMTimeCode] {
        // FYI: on macOS 10.15/iOS 13 and later, you can use
        // sampleBuffer.formatDescription instead of CMSampleBufferGetFormatDescription
        guard let blockBuffer = CMSampleBufferGetDataBuffer(sampleBuffer),
              let formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer)
        else {
            // not an error condition; this routine will be called many times
            // and only some times will contain the data we need
            return []
        }
        
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
            guard sampleBuffer.totalSampleSize > 0 else {
                return []
            }
        }
        
        // FYI: on macOS 10.15/iOS 13 and later, you can use
        // formatDescription.mediaSubType instead of CMFormatDescriptionGetMediaSubType
        let type = CMFormatDescriptionGetMediaSubType(formatDescription)
        
        var offset: Int = 0
        
        switch type {
        case kCMTimeCodeFormatType_TimeCode32:
            var samples: [CMTimeCode32] = []
            while let tc = readTimecode32Sample(blockBuffer: blockBuffer, offset: offset) {
                samples.append(tc)
                offset += CMTimeCode32.byteLength
            }
            return samples
            
        case kCMTimeCodeFormatType_TimeCode64:
            var samples: [CMTimeCode64] = []
            while let tc = readTimecode64Sample(blockBuffer: blockBuffer, offset: offset) {
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
    private static func readTimecode32Sample(
        blockBuffer: CMBlockBuffer,
        offset: Int
    ) -> CMTimeCode32? {
        var rawData: UnsafeMutablePointer<CChar>? // CChar == Int8
        var length: Int = 0
        
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
    private static func readTimecode64Sample(
        blockBuffer: CMBlockBuffer,
        offset: Int
    ) -> CMTimeCode64? {
        var rawData: UnsafeMutablePointer<CChar>? // CChar == Int8
        var length: Int = 0
        
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
