//
//  Timecode Rational.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// AVAssetReader is unavailable on watchOS so we can't support any AVAsset operations
#if canImport(AVFoundation) && !os(watchOS)

import Foundation
import AVFoundation

// MARK: - Payload

public struct AVAssetPayload {
    public var asset: AVAsset
    public var attribute: RangeAttribute
}

// MARK: - TimecodeSource

extension AVAssetPayload: RichTimecodeSource {
    public func set(
        timecode: inout Timecode,
        overriding properties: Timecode.Properties? = nil
    ) throws -> Timecode.Properties {
        let rate: TimecodeFrameRate? = properties?.frameRate // nil means auto-detect
        
        let base: Timecode.SubFramesBase = properties?.subFramesBase
            ?? timecode.properties.subFramesBase
        
        let limit: Timecode.UpperLimit = properties?.upperLimit
            ?? timecode.properties.upperLimit
        
        switch attribute {
        case .start:
            guard let tc = try asset.startTimecode(
                at: rate,
                base: base,
                limit: limit
            ) else {
                throw Timecode.MediaParseError.unknownTimecode
            }
            timecode = tc
            
        case .end:
            guard let tc = try asset.endTimecode(
                at: rate,
                base: base,
                limit: limit
            ) else {
                throw Timecode.MediaParseError.unknownTimecode
            }
            timecode = tc
            
        case .duration:
            timecode = try asset.durationTimecode(
                at: rate,
                base: base,
                limit: limit
            )
        }
        
        return timecode.properties
    }
}

extension RichTimecodeSource where Self == AVAssetPayload {
    public static func avAsset(
        asset: AVAsset,
        _ attribute: RangeAttribute
    ) -> Self {
        AVAssetPayload(
            asset: asset,
            attribute: attribute
        )
    }
}

#endif
