# SubFrames Component

Using the SubFrames timecode component.

Subframes represent a fraction (subdivision) of a single frame.

Subframes are only used by some software and hardware, and since there are no industry standards, each manufacturer can decide how they want to implement subframes. Subframes are frame rate agnostic, meaning the subframe base (divisor) is mutually exclusive of frame rate.

For example:

- *Cubase/Nuendo* and *Logic Pro* globally use 80 subframes per frame (0 ... 79) regardless of frame rate
- *Pro Tools* uses 100 subframes (0 ... 99) globally regardless of frame rate

Timecode supports subframes throughout. However, by default subframes are not displayed in ``Timecode/stringValue(format:)``. You can enable them:

```swift
var tc = try "01:12:20:05.62"
    .timecode(at: ._24, base: ._80SubFrames)

// string with default formatting
tc.stringValue() // == "01:12:20:05"
tc.subFrames     // == 62 (subframes are preserved even though not displayed in stringValue)

// string with subframes shown
tc.stringValue(format: .showSubFrames) // == "01:12:20:05.62"
```

Subframes are always calculated when performing operations on the ``Timecode`` instance, even if they are not expressed in the timecode string when not displaying subframes.

```swift
var tc = try "00:00:00:00.40"
    .timecode(at: ._24, base: ._80SubFrames)

tc.stringValue() // == "00:00:00:00"
tc.stringValue(format: .showSubFrames) // == "00:00:00:00.40"

// multiply timecode by 2.
// 40 subframes is half of a frame at 80 subframes per frame
(tc * 2).stringValue(format: .showSubFrames) // == "00:00:00:01.00"
```
