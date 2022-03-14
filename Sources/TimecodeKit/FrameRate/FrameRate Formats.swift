//
//  FrameRate Formats.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//

import CoreMedia

extension Timecode.FrameRate {
    
    /// AAF file metadata for the given frame rate.
    ///
    /// Example, for 24 fps:
    ///
    ///     <TimelineTrack>
    ///       ...
    ///       <EditRate>24000/1001</EditRate>
    ///       <TrackSegment>
    ///         <Timecode>
    ///           <DropFrame>false</DropFrame>
    ///           <FramesPerSecond>24</FramesPerSecond>
    ///           ...
    ///         </Timecode>
    ///       </TrackSegment>
    ///       ...
    ///     </TimelineTrack>
    public var aafMetadata: (
        editRate: String,
        dropFrame: String,
        framesPerSecond: String
    ) {
        
        (editRate: "\(fraction.numerator)/\(fraction.denominator)",
         dropFrame: isDrop ? "true" : "false",
         framesPerSecond: "\(maxFrames)")
        
    }
    
    /// Returns a CoreMedia `CMTime` instance representing the duration of 1 frame by way of a value/timescale fraction.
    public var frameDurationCMTime: CMTime {
        
        CMTime(value: CMTimeValue(fraction.denominator),
               timescale: CMTimeScale(fraction.numerator))
        
    }
    
}
