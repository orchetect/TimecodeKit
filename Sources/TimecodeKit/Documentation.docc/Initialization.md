# Initialization

Basic initialization of a ``Timecode`` struct.

TimecodeKit is designed to work with Xcode's autocomplete fluidly. Beginning a ``Timecode`` initializer with a period will produce a list of all available source time value types.

![Timecode init](timecode-init.png)

Timecode can be formed by providing discrete values.

```swift
// zero timecode (00:00:00:00)
.zero

// timecode component values
.components(h: 01, m: 00, s: 00, f: 00)
.components(d: 00, h: 01, m: 00, s: 00, f: 00, sf: 00) // days and subframes allowed
.components(Timecode.Components(h: 1)) // also accepts struct instance
```

Timecode can be formed by converting from a variety of common time values.

```swift
// frame number (total elapsed frames)
.frames(10000) // whole frames
.frames(10000, subFrames: 20) // whole frames + subframes
.frames(10000.25) // (Double) whole frames + float subframes
.frames(10000, subFramesUnitInterval: 0.25) // whole frames + float subframes
.frames(Timecode.FrameCount(...)) // also accepts struct instance

// timecode string
.string("01:00:00:00")
.string("2 01:00:00:00.00") // days and subframes allowed

// real time (wall clock) elapsed in seconds
.realTime(seconds: 4723.241579)

// elapsed audio samples at a given sample rate in Hz
.samples(123456789, sampleRate: 48000)

// AVFoundation AVAsset: read .start, .end or .duration timecode of a movie
.avAsset(AVAsset(...), .start)

// AVFoundation CMTime
.cmTime(CMTime(value: 1920919, timescale: 30000))

// rational time fraction (ie: Final Cut Pro XML, or AAF)
.rational(1920919, 30000)
.rational(Fraction(1920919, 30000)) // also accepts struct instance

// legacy Feet+Frames designation
.feetAndFrames(feet: 60, frames: 10)
.feetAndFrames(FeetAndFrames(feet: 60, frames: 10)) // also accepts struct instance
```

The frame rate must also be supplied. This can be done easily with the `at:` overload.

```swift
let tc = try Timecode(.string("01:00:00:00"), at: ._23_976)
```

If additional properties need to be specified, supply a ``Timecode/Properties`` struct with the `using:` overload.

```swift
let tcProperties = Timecode.Properties(
    rate: ._23_976,
    base: ._100SubFrames,
    limit: ._100Days
)
let tc = try Timecode(.string("01:00:00:00"), using: tcProperties)
```

It is possible to clamp to valid timecode using a non-throwing init.

```swift
// clamp full timecode to valid range
Timecode(.components(h: 26, m: 00, s: 00, f: 00), at: ._24, by: .clamping)
    .stringValue() // == "23:59:59:23"

// clamp individual timecode component values to valid values if they are out-of-bounds
Timecode(.components(h: 01, m: 00, s: 85, f: 50), at: ._24, by: .clampingEach)
    .stringValue() // == "01:00:59:23"
```

It is also possible to wrap to valid timecode using a non-throwing init.

```swift
// wrap around clock continuously if entire timecode overflows or underflows

Timecode(.components(h: 26, m: 00, s: 00, f: 00), at: ._24, by: .wrapping)
    .stringValue() // == "02:00:00:00"

Timecode(.components(h: 23, m: 59, s: 59, f: 24), at: ._24, by: .wrapping)
    .stringValue() // == "00:00:00:00"
```