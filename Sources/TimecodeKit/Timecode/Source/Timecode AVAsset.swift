//
//  Timecode Rational.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// AVAssetReader is unavailable on watchOS so we can't support any AVAsset operations
#if canImport(AVFoundation) && !os(watchOS)

import Foundation
import AVFoundation

// MARK: - TimecodeSource

public struct AVAssetTimecodeSource {
    public var asset: AVAsset
    public var attribute: RangeAttribute
}

extension AVAssetTimecodeSource: TimecodeSource {
    public func set(timecode: inout Timecode) throws {
        let rate: TimecodeFrameRate = timecode.properties.frameRate
        let base: Timecode.SubFramesBase = timecode.properties.subFramesBase
        let limit: Timecode.UpperLimit = timecode.properties.upperLimit
        
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
    }
    
    public func set(timecode: inout Timecode, by validation: Timecode.ValidationRule) {
        let rate: TimecodeFrameRate = timecode.properties.frameRate
        let base: Timecode.SubFramesBase = timecode.properties.subFramesBase
        let limit: Timecode.UpperLimit = timecode.properties.upperLimit
        
        func zeroTimecode() -> Timecode {
            Timecode(.zero, using: timecode.properties)
        }
        
        switch attribute {
        case .start:
            timecode = (try? asset.startTimecode(
                at: rate,
                base: base,
                limit: limit
            )) ?? zeroTimecode()
            
        case .end:
            timecode = (try? asset.endTimecode(
                at: rate,
                base: base,
                limit: limit
            )) ?? zeroTimecode()
            
        case .duration:
            timecode = (try? asset.durationTimecode(
                at: rate,
                base: base,
                limit: limit
            )) ?? zeroTimecode()
        }
    }
}

extension TimecodeSource where Self == AVAssetTimecodeSource {
    /// Read start, end or duration of an `AVAsset`.
    /// Frame rate will be overridden by the passed properties, and will not be auto-detected from
    /// the asset.
    public static func avAsset(
        _ asset: AVAsset,
        _ attribute: RangeAttribute
    ) -> Self {
        AVAssetTimecodeSource(
            asset: asset,
            attribute: attribute
        )
    }
}

// MARK: - RichTimecodeSource

public struct AVAssetRichTimecodeSource {
    public var asset: AVAsset
    public var attribute: RangeAttribute
}

extension AVAssetRichTimecodeSource: RichTimecodeSource {
    public func set(
        timecode: inout Timecode
    ) throws -> Timecode.Properties {
        let base: Timecode.SubFramesBase = timecode.properties.subFramesBase
        let limit: Timecode.UpperLimit = timecode.properties.upperLimit
        
        switch attribute {
        case .start:
            guard let tc = try asset.startTimecode(
                at: nil, // auto-detect from asset
                base: base,
                limit: limit
            ) else {
                throw Timecode.MediaParseError.unknownTimecode
            }
            timecode = tc
            
        case .end:
            guard let tc = try asset.endTimecode(
                at: nil, // auto-detect from asset
                base: base,
                limit: limit
            ) else {
                throw Timecode.MediaParseError.unknownTimecode
            }
            timecode = tc
            
        case .duration:
            timecode = try asset.durationTimecode(
                at: nil, // auto-detect from asset
                base: base,
                limit: limit
            )
        }
        
        return timecode.properties
    }
}

extension RichTimecodeSource where Self == AVAssetRichTimecodeSource {
    /// Read start, end or duration of an `AVAsset`.
    /// Frame rate will be automatically detected from the asset if possible.
    public static func avAsset(
        _ asset: AVAsset,
        _ attribute: RangeAttribute
    ) -> Self {
        AVAssetRichTimecodeSource(
            asset: asset,
            attribute: attribute
        )
    }
}

#endif
