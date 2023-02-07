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
        at frameRate: TimecodeFrameRate? = nil,
        limit: Timecode.UpperLimit = ._24hours,
        base: Timecode.SubFramesBase = .default(),
        format: Timecode.StringFormat = .default()
    ) throws -> [Timecode] {
        let frameRate = try frameRate ?? self.timecodeFrameRate()
        let timecodes = readStartElapsedFrames()
            .compactMap {
                // ignore errors here to prevent one error from failing to return all found
                try? Timecode(
                    .frames(Int($0)),
                    at: frameRate,
                    limit: limit,
                    base: base,
                    format: format
                )
            }
        
        //if timecodes.isEmpty, allowDefault {
        //    let zeroTimecode = Timecode(
        //        at: frameRate,
        //        limit: limit,
        //        base: base,
        //        format: format
        //    )
        //    timecodes.append(zeroTimecode)
        //}
        
        return timecodes
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
        at frameRate: TimecodeFrameRate? = nil,
        limit: Timecode.UpperLimit = ._24hours,
        base: Timecode.SubFramesBase = .default(),
        format: Timecode.StringFormat = .default()
    ) throws -> [Timecode] {
        let frameRate = try frameRate ?? self.timecodeFrameRate()
        return try startTimecode(
            at: frameRate,
            limit: limit,
            base: base,
            format: format
        )
        .compactMap {
            $0 + (try durationTimecode(
                at: frameRate,
                limit: limit,
                base: base,
                format: format
            ))
        }
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
        at frameRate: TimecodeFrameRate? = nil,
        limit: Timecode.UpperLimit = ._24hours,
        base: Timecode.SubFramesBase = .default(),
        format: Timecode.StringFormat = .default()
    ) throws -> Timecode {
        let frameRate = try frameRate ?? self.timecodeFrameRate()
        return try Timecode(
            duration,
            at: frameRate,
            limit: limit,
            base: base,
            format: format
        )
    }
    
    // MARK: - Helpers
    
    @_disfavoredOverload
    internal func readStartElapsedFrames() -> [UInt32] {
        tracks(withMediaType: .timecode)
            .compactMap {
                $0.readStartTimecodeElapsedFrames(context: self)
            }
    }
}

#endif
