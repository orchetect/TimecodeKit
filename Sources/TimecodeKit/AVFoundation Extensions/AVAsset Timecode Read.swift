//
//  AVAsset Timecode Read.swift
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
        using frameRate: TimecodeFrameRate? = nil,
        base: Timecode.SubFramesBase = .default(),
        limit: Timecode.UpperLimit = ._24hours
    ) throws -> Timecode? {
        try timecodes(
            using: frameRate,
            base: base,
            limit: limit
        )
        .compactMap(\.first) // first element of each track
        .first // first track
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
        using frameRate: TimecodeFrameRate? = nil,
        base: Timecode.SubFramesBase = .default(),
        limit: Timecode.UpperLimit = ._24hours
    ) throws -> Timecode? {
        let frameRate = try frameRate ?? self.timecodeFrameRate()
        guard let start = try startTimecode(
            using: frameRate,
            base: base,
            limit: limit
        ) else { return nil }
        
        return try start + durationTimecode(
            using: frameRate,
            base: base,
            limit: limit
        )
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
        using frameRate: TimecodeFrameRate? = nil,
        base: Timecode.SubFramesBase = .default(),
        limit: Timecode.UpperLimit = ._24hours
    ) throws -> Timecode {
        let frameRate = try frameRate ?? self.timecodeFrameRate()
        return try Timecode(
            duration,
            using: frameRate,
            base: base,
            limit: limit
        )
    }
    
    /// Returns timecodes contained in the asset.
    /// Returns an array representing tracks, each an array representing timecode samples in the track.
    ///
    /// Passing a value to `frameRate` will override frame rate detection.
    /// Passing `nil` will detect frame rate from the asset's contents if possible.
    ///
    /// - Throws: ``Timecode/MediaParseError``
    @_disfavoredOverload
    public func timecodes(
        using frameRate: TimecodeFrameRate? = nil,
        base: Timecode.SubFramesBase = .default(),
        limit: Timecode.UpperLimit = ._24hours
    ) throws -> [[Timecode]] {
        let frameRate = try frameRate ?? self.timecodeFrameRate()
        
        let samples = try tracks(withMediaType: .timecode)
            .map { try $0.readTimecodeSamples(context: self) }
        
        let timecodes = try samples.map {
            try $0.mapToTimecode(
                using: frameRate,
                base: base,
                limit: limit
            )
        }
        
        return timecodes
    }
    
    // MARK: - Helpers
    
    @_disfavoredOverload
    internal func readTimecodeSamples() throws -> [[CMTimeCode]] {
        try tracks(withMediaType: .timecode)
            .map {
                try $0.readTimecodeSamples(context: self)
            }
    }
}

#endif
