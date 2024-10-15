//
//  VideoFrameRate Conversions.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

// AVAssetReader is unavailable on watchOS so we can't support any AVAsset operations
#if canImport(AVFoundation) && !os(watchOS) && !os(visionOS)

import AVFoundation

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension VideoFrameRate {
    /// Initialize from embedded frame rate information in an `AVAsset`.
    public init(asset: AVAsset) async throws {
        self = try await asset.videoFrameRate()
    }
}

#endif
