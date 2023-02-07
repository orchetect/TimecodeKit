//
//  Timecode Rational.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// AVAssetReader is unavailable on watchOS so we can't support any AVAsset operations
#if canImport(AVFoundation) && !os(watchOS)

import Foundation
import AVFoundation

extension Timecode {
    /// Instance from embedded start timecode of an `AVAsset`.
    ///
    /// - Note: Passing a value to `frameRate` will override frame rate detection.
    /// Passing `nil` will detect frame rate from the asset's contents if possible.
    ///
    /// - Throws: ``MediaParseError``
    public init(
        startOf asset: AVAsset,
        at rate: TimecodeFrameRate? = nil,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        guard let tc = try asset.startTimecode(
            at: rate,
            limit: limit,
            base: base,
            format: format
        ) else {
            throw MediaParseError.unknownTimecode
        }
        
        self = tc
    }
    
    /// Instance from embedded end timecode (start + duration) of an `AVAsset`.
    ///
    /// - Note: Passing a value to `frameRate` will override frame rate detection.
    /// Passing `nil` will detect frame rate from the asset's contents if possible.
    ///
    /// - Throws: ``MediaParseError`` or ``ValidationError``
    public init(
        endOf asset: AVAsset,
        at rate: TimecodeFrameRate? = nil,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        guard let tc = try asset.endTimecode(
            at: rate,
            limit: limit,
            base: base,
            format: format
        ) else {
            throw MediaParseError.unknownTimecode
        }
        
        self = tc
    }
    
    /// Instance from embedded duration of an `AVAsset`.
    ///
    /// - Note: Passing a value to `frameRate` will override frame rate detection.
    /// Passing `nil` will detect frame rate from the asset's contents if possible.
    ///
    /// - Throws: ``MediaParseError`` or ``ValidationError``
    public init(
        durationOf asset: AVAsset,
        at rate: TimecodeFrameRate? = nil,
        limit: UpperLimit = ._24hours,
        base: SubFramesBase = .default(),
        format: StringFormat = .default()
    ) throws {
        self = try asset.durationTimecode(
            at: rate,
            limit: limit,
            base: base,
            format: format
        )
    }
}

#endif
