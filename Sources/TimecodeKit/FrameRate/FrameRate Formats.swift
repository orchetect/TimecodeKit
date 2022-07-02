//
//  FrameRate Formats.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//

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
    
}

#if canImport(CoreMedia)
import CoreMedia

extension Timecode.FrameRate {
    
    /// Returns a CoreMedia `CMTime` instance representing the duration of 1 frame by way of a value/timescale fraction.
    @available(macOS 10.7, iOS 4.0, tvOS 9.0, watchOS 6.0, *)
    public var frameDurationCMTime: CMTime {
        
        CMTime(value: CMTimeValue(fraction.denominator),
               timescale: CMTimeScale(fraction.numerator))
        
    }
    
}

#endif