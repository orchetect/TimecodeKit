# AVAsset Timecode Track

Manipulating timecode track(s) for movie assets in AVFoundation.

TimecodeKit provides a full suite of methods to read and write timecode track(s) in a QuickTime movie file when working with AVFoundation.

## Read Timecode from QuickTime Movie

Simple methods to read start timecode and duration from `AVAsset` and its subclasses (`AVMovie`) as well as `AVAssetTrack` are provided by TimecodeKit.
The methods are throwing since timecode information is not guaranteed to be present inside movie files.

```swift
let asset = AVAsset( ... )
```

Auto-detect the movie's frame rate (if it's embedded in the file) and return it if desired.
If frame rate information is not available in the video file, this method will throw an error.

```swift
let frameRate = try asset.timecodeFrameRate() // ie: ._29_97
```

Read the start timecode, duration expressed as elapsed timecode, and end timecode.

If a known frame rate is not passed to the methods, the frame rate will be auto-detected.
If frame rate information is not available in the video file, these methods will throw an error.

```swift
// read start timecode, auto-detecting frame rate
let startTimecode = try asset.startTimecode()
// read start timecode, forcing a known frame rate
let startTimecode = try asset.startTimecode(at: ._29_97)

// read video duration expressed as timecode
let durationTimecode = try asset.durationTimecode()
// read video duration expressed as timecode, forcing a known frame rate
let durationTimecode = try asset.durationTimecode(at: ._29_97)

// read end timecode, auto-detecting frame rate
let endTimecode = try asset.endTimecode()
// read end timecode, forcing a known frame rate
let endTimecode = try asset.endTimecode(at: ._29_97)
```

## Add or Replace Timecode Track in a QuickTime Movie

Currently timecode tracks can be modified on `AVMutableMovie`.

This is one way to make an `AVMovie` into a mutable `AVMutableMovie` if needed.

```swift
let movie = AVMovie( ... )
guard let mutableMovie = movie.mutableCopy() as? AVMutableMovie else { ... }
```

Then add/replace the timecode track.

```swift
// replace existing timecode track if it exists, otherwise add a new timecode track
try mutableMovie.replaceTimecodeTrack(
    startTimecode: Timecode(.components(h: 0, m: 59, s: 58, f: 00), at: ._29_97),
    fileType: .mov
)
```

Finally, the new file can be saved back to disk using `AVAssetExportSession`. There are other ways of course but this is the vanilla method.

```swift
let export = AVAssetExportSession(
    asset: mutableMovie,
    presetName: AVAssetExportPresetPassthrough
)
export.outputFileType = .mov
export.outputURL = // new file URL on disk
export.exportAsynchronously {
    // completion handler
}
```

> Warning:
>
> As of iOS 17, Apple appears to have introduced a regression when using `AVAssetExportSession` to save a QuickTime movie file when using a physical iOS device (simulator works fine).
> A radar has been filed with Apple (FB12986599). This is not an issue with TimecodeKit itself.
> However, until Apple fixes this bug it will affect saving a movie file after performing timecode track modifications.
> See [this thread](https://github.com/orchetect/TimecodeKit/discussions/63) for details.

## Topics

### AVAsset Extensions

- ``AVFoundation/AVAsset/startTimecode(at:base:limit:)``
- ``AVFoundation/AVAsset/durationTimecode(at:base:limit:)``
- ``AVFoundation/AVAsset/endTimecode(at:base:limit:)``
- ``AVFoundation/AVAsset/timecodes(at:base:limit:)``
- ``AVFoundation/AVAsset/timecodeFrameRate(drop:)``
- ``AVFoundation/AVAsset/videoFrameRate(interlaced:)``
- ``AVFoundation/AVAsset/isVideoInterlaced``

### AVAssetTrack Extensions

- ``AVFoundation/AVAssetTrack/durationTimecode(at:limit:base:)``

### AVMutableMovie Extensions

- ``AVFoundation/AVMutableMovie/addTimecodeTrack(startTimecode:duration:extensions:fileType:)``
- ``AVFoundation/AVMutableMovie/replaceTimecodeTrack(startTimecode:duration:extensions:fileType:)``
