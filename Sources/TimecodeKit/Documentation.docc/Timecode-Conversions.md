# Conversions

Converting various time values to/from timecode.

## Convert to Another Frame Rate

```swift
// convert between frame rates
let tc = try "01:00:00;00"
    .timecode(at: ._29_97_drop)
    .converted(to: ._29_97) // == 00:59:56:12
```

## Total Frame Count

```swift
// timecode → frame count
try Timecode(.components(h: 1), at: ._23_976)
    .frameCount // == 86400
```

```swift
// frame number → timecode
try Timecode(.frames(86400), at: ._23_976)
// frame number + subframes → timecode
try Timecode(.frames(86400, subFrames: 25), at: ._23_976)
// frame number + subframes unit interval as Double → timecode
try Timecode(.frames(86400.25), at: ._23_976)
// frame number + subframes unit interval → timecode
try Timecode(.frames(86400, subFramesUnitInterval: 0.25), at: ._23_976)
``` 
Useful `.frameCount` properties are also available. See ``Timecode/FrameCount-swift.struct`` for more details.

## String

```swift
// timecode → string
try Timecode(.components(h: 1), at: ._23_976)
    .stringValue() // == "01:00:00:00"
```

```swift
// string → timecode
try Timecode(.string("01:00:00:00"), at: ._23_976)
```

See <doc:Timecode-String> for more details.

## Real Time

```swift
// timecode → elapsed real-world wall time in seconds
try "01:00:00:00"
    .timecode(at: ._23_976)
    .realTimeValue // == 3603.6 as TimeInterval (Double)
```

```swift
// elapsed real-world wall time → timecode
try Timecode(.realTime(seconds: 3603.6), at: ._23_976)
```

## Audio Samples

```swift
// timecode → elapsed audio samples
try "01:00:00:00"
    .timecode(at: ._24)
    .samplesValue(sampleRate: 48000) // == 172800000
```

```swift
// elapsed audio samples → timecode
try Timecode(.samples(172800000, sampleRate: 48000), at: ._24)
```

## Rational Fraction / CMTime

See <doc:Rational-Numbers-and-CMTime> for more details.

## Feet+Frames

```swift
// timecode → feet+frames
try "01:00:00:00"
    .timecode(at: ._23_976)
    .feetAndFramesValue // 5400+00
```

```swift
// feet+frames components → timecode
try Timecode(.feetAndFrames(feet: 5400, frames: 0), at: ._23_976)
// feet+frames string → timecode
try Timecode(.feetAndFrames("5400+00"), at: ._23_976)
```
