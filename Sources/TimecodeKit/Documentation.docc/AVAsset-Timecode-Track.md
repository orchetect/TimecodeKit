# AVAsset Timecode Track Read/Write

Manipulating timecode track(s) for movie assets in AVFoundation.

## Read Timecode from QuickTime Movie

Simple methods to read start timecode and duration from `AVAsset` and its subclasses (`AVMovie`) as well as `AVAssetTrack` are provided by TimecodeKit. The methods are throwing since timecode information is not guaranteed to be present inside movie files.

```swift
let asset = AVAsset( ... )

// auto-detect frame rate if it's embedded in the file
let frameRate = try asset.timecodeFrameRate() // ie: ._29_97

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
> As of iOS 17, Apple appears to have introduced a regression when using `AVAssetExportSession` to save a QuickTime movie file when using a physical iOS device (simulator works fine). A radar has been filed with Apple (FB12986599). This is not an issue with TimecodeKit itself. However, until Apple fixes this bug it will affect saving a movie file after performing timecode track modifications. See [this thread](https://github.com/orchetect/TimecodeKit/discussions/63) for details.
