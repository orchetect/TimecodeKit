//
//  Timecode AVAsset.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

// AVAssetReader is unavailable on watchOS so we can't support any AVAsset operations
#if canImport(AVFoundation) && !os(watchOS) && !os(visionOS)

@preconcurrency import AVFoundation
import Foundation

// MARK: - AVAssetTimecodeSource

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
struct AVAssetTimecodeSource {
    let asset: AVAsset
    let attribute: RangeAttribute
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension AVAssetTimecodeSource: _AsyncTimecodeSource {
    func set(timecode: inout Timecode) async throws {
        let rate: TimecodeFrameRate = timecode.frameRate
        let base: Timecode.SubFramesBase = timecode.subFramesBase
        let limit: Timecode.UpperLimit = timecode.upperLimit
        
        switch attribute {
        case .start:
            guard let tc = try await asset.startTimecode(
                at: rate,
                base: base,
                limit: limit
            ) else {
                throw Timecode.MediaParseError.unknownTimecode
            }
            timecode = tc
            
        case .end:
            guard let tc = try await asset.endTimecode(
                at: rate,
                base: base,
                limit: limit
            ) else {
                throw Timecode.MediaParseError.unknownTimecode
            }
            timecode = tc
            
        case .duration:
            timecode = try await asset.durationTimecode(
                at: rate,
                base: base,
                limit: limit
            )
        }
    }
    
    func set(timecode: inout Timecode, by validation: Timecode.ValidationRule) async {
        let rate: TimecodeFrameRate = timecode.frameRate
        let base: Timecode.SubFramesBase = timecode.subFramesBase
        let limit: Timecode.UpperLimit = timecode.upperLimit
        
        func zeroTimecode() -> Timecode {
            Timecode(.zero, using: timecode.properties)
        }
        
        switch attribute {
        case .start:
            timecode = await (try? asset.startTimecode(
                at: rate,
                base: base,
                limit: limit
            )) ?? zeroTimecode()
            
        case .end:
            timecode = await (try? asset.endTimecode(
                at: rate,
                base: base,
                limit: limit
            )) ?? zeroTimecode()
            
        case .duration:
            timecode = await (try? asset.durationTimecode(
                at: rate,
                base: base,
                limit: limit
            )) ?? zeroTimecode()
        }
    }
}

// MARK: - Static Constructors

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension AsyncTimecodeSourceValue {
    /// Read start, end or duration of an `AVAsset`.
    /// Frame rate will be overridden by the passed properties, and will not be auto-detected from
    /// the asset.
    public static func avAsset(
        _ asset: AVAsset,
        _ attribute: RangeAttribute
    ) -> Self {
        .init(value: AVAssetTimecodeSource(
            asset: asset,
            attribute: attribute
        ))
    }
}

// MARK: - AVAssetRichTimecodeSource

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
struct AVAssetRichTimecodeSource {
    let asset: AVAsset
    let attribute: RangeAttribute
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension AVAssetRichTimecodeSource: _AsyncRichTimecodeSource {
    func set(
        timecode: inout Timecode
    ) async throws -> Timecode.Properties {
        let base: Timecode.SubFramesBase = timecode.subFramesBase
        let limit: Timecode.UpperLimit = timecode.upperLimit
        
        switch attribute {
        case .start:
            guard let tc = try await asset.startTimecode(
                at: nil, // auto-detect from asset
                base: base,
                limit: limit
            ) else {
                throw Timecode.MediaParseError.unknownTimecode
            }
            timecode = tc
            
        case .end:
            guard let tc = try await asset.endTimecode(
                at: nil, // auto-detect from asset
                base: base,
                limit: limit
            ) else {
                throw Timecode.MediaParseError.unknownTimecode
            }
            timecode = tc
            
        case .duration:
            timecode = try await asset.durationTimecode(
                at: nil, // auto-detect from asset
                base: base,
                limit: limit
            )
        }
        
        return timecode.properties
    }
}

// MARK: - Static Constructors

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension AsyncRichTimecodeSourceValue {
    /// Read start, end or duration of an `AVAsset`.
    /// Frame rate will be automatically detected from the asset if possible.
    public static func avAsset(
        _ asset: AVAsset,
        _ attribute: RangeAttribute
    ) -> Self {
        .init(value: AVAssetRichTimecodeSource(
            asset: asset,
            attribute: attribute
        ))
    }
}

#endif
