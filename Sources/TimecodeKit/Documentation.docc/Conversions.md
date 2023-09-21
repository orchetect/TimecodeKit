# Conversions

Converting various time values to/from timecode.

## To another frame rate

```swift
// convert between frame rates
try "01:00:00;00"
    .timecode(at: ._29_97_drop)
    .converted(to: ._29_97)
    .stringValue() // == "00:59:56:12"
```

## Real Time

```swift
// timecode to real-world time in seconds
let tc = try "01:00:00:00"
    .timecode(at: ._23_976)
    .realTimeValue // == 3603.6 as TimeInterval (Double)

// real-world time to timecode
try Timecode(.realTime(seconds: 3603.6), at: ._23_976)
    .stringValue() // == "01:00:00:00"
```

## Audio Samples

```swift
// timecode to elapsed audio samples
let tc = try "01:00:00:00"
    .timecode(at: ._24)
    .samplesValue(sampleRate: 48000) // == 172800000

// elapsed audio samples to timecode
try Timecode(.samples(172800000, sampleRate: 48000), at: ._24)
    .stringValue() // == "01:00:00:00"
```
