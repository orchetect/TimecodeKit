//
//  AVMutableMovie Extensions.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import AVFoundation

extension AVMutableMovie {
    /// Removes all timecode tracks from the movie if any are present.
    ///
    /// - Returns: The mutable movie with timecode tracks removed.
    @discardableResult
    func removeTimecodeTracks() async throws -> AVMutableMovie {
        let tracks = try await loadTracks(withMediaType: .timecode)
        // it's rare that there would be more than one timecode track, but not impossible
        for track in tracks {
            removeTrack(track)
        }
        
        return self
    }
    
    func export(
        to url: URL,
        _ configuration: ((AVAssetExportSession) -> Void)? = nil
    ) async throws {
        guard let exportSession = AVAssetExportSession(
            asset: self,
            presetName: AVAssetExportPresetPassthrough
        ) else {
            throw ModelError.exportError(nil)
        }
        
        configuration?(exportSession)
        
        try await exportSession.export(to: url, as: .mov)
    }
}
