# Rational Numbers & CMTime

Using rational (fractional) time values and `CMTime`.

## Rational Numbers

Video file metadata and timeline interchange files (AAF, Final Cut Pro XML) encode frame rate and timecode as rational numbers (a fraction consisting of two integers - a numerator and a denominator).

``Timecode`` is capable of initializing from an elapsed time expressed as a rational fraction using a `rational` value. The ``Timecode/rationalValue`` property returns the elapsed time expressed as a rational fraction.

```swift
try Timecode(.rational(Fraction(1920919, 30000)), at: .fps29_97)
    .stringValue() // == "00:01:03;29"

try Timecode(.components(h: 00, m: 01, s: 03, f: 29), at: .fps29_97)
    .rationalValue // == Fraction(1920919, 30000)
```

``TimecodeFrameRate`` and ``VideoFrameRate`` are both capable of initializing from a rational fraction, and also provide a `rationalRate` and `rationalFrameDuration` property that provides this fraction.

Since drop-frame (timecode) or interlaced (video) attributes are not encodable in a rational fraction, they must be imperatively supplied.

```swift
// fraction representing the duration of 1 frame
TimecodeFrameRate(frameDuration: Fraction(1001, 30000), drop: false) // == .fps29_97
// fraction representing the fps
TimecodeFrameRate(rate: Fraction(30000, 1001), drop: false) // == .fps29_97

// fraction representing the duration of 1 frame
VideoFrameRate(frameDuration: Fraction(1001, 30000), interlaced: false) // == .fps29_97p
// fraction representing the fps
VideoFrameRate(rate: Fraction(30000, 1001), interlaced: false) // == .fps29_97p
```

## CMTime Conversion

`CMTime` is a type exported by the Core Media framework (and used pervasively in AVFoundation). It represents time as a rational fraction of a `value` in a `timescale`.

``Timecode`` and ``TimecodeInterval``, as well as ``TimecodeFrameRate`` and ``VideoFrameRate`` can convert to/from `CMTime` using the respective inits and properties.

`CMTime` and ``Fraction`` can convert between themselves as well with respective inits and properties.

## Topics

- ``Fraction``

### CMTime Extensions

- ``CoreMedia/CMTime/init(_:)``
- ``CoreMedia/CMTime/fractionValue``

### CMTimeRange Extensions

- ``CoreMedia/CMTimeRange/timecodeRange(at:base:limit:)``
- ``CoreMedia/CMTimeRange/timecodeRange(using:)``
