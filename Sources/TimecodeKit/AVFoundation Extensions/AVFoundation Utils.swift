//
//  AVFoundation Utils.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

// AVAssetReader is unavailable on watchOS so we can't support any AVAsset operations
#if canImport(AVFoundation) && !os(watchOS) && !os(visionOS)

import AVFoundation
import Foundation

extension CMFormatDescription {
    /// Returns extensions as a dictionary.
    ///
    /// Extensions dictionaries are valid property list objects.
    /// This means that dictionary keys are all CFStrings, and the values are all either CFNumber, CFString, CFBoolean, CFArray,
    /// CFDictionary, CFDate, or CFData
    ///
    /// You can subscript the dictionary using global AVFoundation key constants beginning with `kCMFormatDescriptionExtension_`
    var extensionsDictionary: [CFString: Any] {
        let nsDict = CMFormatDescriptionGetExtensions(self) as NSDictionary?
        let dict = nsDict as? [CFString: Any]
        return dict ?? [:]
    }
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension AVAssetTrack {
    /// Returns `formatDescriptions` cast as `[CMFormatDescription]`.
    @_disfavoredOverload
    var formatDescriptions: [CMFormatDescription] {
        get async throws {
            try await load(.formatDescriptions)
        }
    }
}

extension CMTimeRange {
    /// Returns the time range as a timecode range.
    ///
    /// Throws an error if the range is invalid or if one or both of the times cannot be converted
    /// to valid timecode.
    ///
    /// - Throws: ``Timecode/MediaParseError``
    public func timecodeRange(
        at frameRate: TimecodeFrameRate,
        base: Timecode.SubFramesBase = .default(),
        limit: Timecode.UpperLimit = .max24Hours
    ) throws -> ClosedRange<Timecode> {
        let properties = Timecode.Properties(rate: frameRate, base: base, limit: limit)
        return try timecodeRange(using: properties)
    }
    
    /// Returns the time range as a timecode range.
    ///
    /// Throws an error if the range is invalid or if one or both of the times cannot be converted
    /// to valid timecode.
    ///
    /// - Throws: ``Timecode/MediaParseError``
    public func timecodeRange(
        using properties: Timecode.Properties
    ) throws -> ClosedRange<Timecode> {
        guard isValid, start <= end else {
            throw Timecode.MediaParseError.unknownTimecode
        }
        
        let timecodes = try [start, end]
            .map {
                try Timecode(.cmTime($0), using: properties)
            }
        
        return timecodes[0] ... timecodes[1]
    }
}

#if !os(tvOS) // AVMediaDataStorage not available on tvOS

@available(macOS 10.11, iOS 13.0, watchOS 6, *)
@available(tvOS, unavailable)
extension AVMediaDataStorage {
    /// Initializes by writing data to a temporary file.
    @_disfavoredOverload
    convenience init(data: Data, options: [String: Any]? = nil) throws {
        let url = try URL(temporaryFileWithData: data)
        self.init(url: url, options: options)
    }
}

#endif

#endif
