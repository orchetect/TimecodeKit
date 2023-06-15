//
//  AVFoundation Utils.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// AVAssetReader is unavailable on watchOS so we can't support any AVAsset operations
#if canImport(AVFoundation) && !os(watchOS)

import Foundation
import AVFoundation

extension CMFormatDescription {
    /// Returns extensions as a dictionary.
    ///
    /// Extensions dictionaries are valid property list objects.
    /// This means that dictionary keys are all CFStrings, and the values are all either CFNumber, CFString, CFBoolean, CFArray, CFDictionary, CFDate, or CFData
    ///
    /// You can subscript the dictionary using global AVFoundation key constants beginning with `kCMFormatDescriptionExtension_`
    internal var extensionsDictionary: [CFString: Any] {
        let nsDict = CMFormatDescriptionGetExtensions(self) as NSDictionary?
        let dict = nsDict as? [CFString: Any]
        return dict ?? [:]
    }
}

extension AVAssetTrack {
    /// Returns `formatDescriptions` cast as `[CMFormatDescription]`
    internal var formatDescriptionsTyped: [CMFormatDescription] {
        formatDescriptions as? [CMFormatDescription]
        ?? []
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
        limit: Timecode.UpperLimit = ._24hours
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
    convenience init(data: Data, options: [String : Any]? = nil) throws {
        let url = try URL(temporaryFileWithData: data)
        self.init(url: url, options: options)
    }
}

#endif

#endif
