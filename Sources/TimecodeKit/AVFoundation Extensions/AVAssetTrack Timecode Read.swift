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
    internal func readStartFrameNumber(
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
        
        // FYI: on macOS 10.15/iOS 13 and later, you can use
        // formatDescription.mediaSubType instead of this
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

#endif
