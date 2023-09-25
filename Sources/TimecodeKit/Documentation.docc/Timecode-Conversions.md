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

// frame count → timecode
try Timecode(.frames(86400), at: ._23_976)
``` 

The following static constructors are available:

- term `.frames(Int)`: Whole frame count as `Int` (as seen in the example)
- term `.frames(Int, subFrames: Int)`: Whole frame count and subframes as `Int`
- term `.frames(Double)`: Frame count, combining subframes unit interval, as `Double`
- term `.frames(Int, subFramesUnitInterval: Double)`: Whole frame count and subframes as a unit interval.

Useful `.frameCount` properties are also available. See ``Timecode/FrameCount-swift.struct`` for more details.

## String

```swift
// timecode → string
try Timecode(.components(h: 1), at: ._23_976)
    .stringValue() // == "01:00:00:00"

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

// elapsed real-world wall time → timecode
try Timecode(.realTime(seconds: 3603.6), at: ._23_976)
```

## Audio Samples

```swift
// timecode → elapsed audio samples
try "01:00:00:00"
    .timecode(at: ._24)
    .samplesValue(sampleRate: 48000) // == 172800000

// elapsed audio samples → timecode
try Timecode(.samples(172800000, sampleRate: 48000), at: ._24)
```

## Rational Fraction / CMTime

See <doc:Rational-Numbers-and-CMTime> for more details.
