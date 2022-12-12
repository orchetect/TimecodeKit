//
//  TimecodeFrameRate Formats.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

extension TimecodeFrameRate {
    /// AAF file metadata for the given frame rate.
    ///
    /// AAF encodes _video frame rate_ as a rational fraction of frames-per-second.
    ///
    /// Example, for 23.976 fps:
    ///
    /// Note `<EditRate>`, `<DropFrame>` and `<FramesPerSecond>`.
    ///
    /// ```xml
    /// <TimelineTrack>
    ///   ...
    ///   <EditRate>24000/1001</EditRate>
    ///   <TrackSegment>
    ///     <Timecode>
    ///       <DropFrame>false</DropFrame>
    ///       <FramesPerSecond>24</FramesPerSecond>
    ///       ...
    ///     </Timecode>
    ///   </TrackSegment>
    ///   ...
    /// </TimelineTrack>
    /// ```
    public var aafMetadata: (
        editRate: String,
        dropFrame: String,
        framesPerSecond: String
    ) {
        (
            editRate: "\(rationalRate.numerator)/\(rationalRate.denominator)",
            dropFrame: isDrop ? "true" : "false",
            framesPerSecond: "\(maxFrames)"
        )
    }
    
    /// Final Cut Pro XML file metadata for the given frame rate.
    ///
    /// FCP XML encodes _video frame rate_ as a rational fraction of the duration of one frame.
    /// It encodes timecode as a rational fraction of seconds along with a boolean flag for drop or
    /// non-drop.
    ///
    /// Example, for 24 fps:
    ///
    /// Note `frameDuration` and `tcFormat`.
    ///
    /// ```xml
    /// <fcpxml version="1.9">
    ///   <resources>
    ///     <format id="r1" name="FFVideoFormat1080p24" frameDuration="100/2400s" width="1920" height="1080" colorSpace="1-1-1 (Rec. 709)"/>
    ///   </resources>
    ///   <library location="file:///Users/user/Movies/Untitled.fcpbundle/">
    ///     <event name="2022-06-24" uid="BB995477-20D4-45DF-9204-1B1AA44BE054">
    ///       <project name="My Project">
    ///         <sequence format="r1" duration="167500/12000s" tcStart="0s" tcFormat="NDF">
    ///           // etc...
    ///         </sequence>
    ///       </project>
    ///     </event>
    ///   </library>
    /// </fcpxml>
    /// ```
    public var fcpXMLMetadata: (frameDuration: String, tcFormat: String) {
        (
            frameDuration: "\(rationalFrameDuration.numerator)/\(rationalFrameDuration.denominator)",
            tcFormat: isDrop ? "DF" : "NDF"
        )
    }
}
