![TimecodeKit](Images/timecodekit-banner.png)

# TimecodeKit

[![CI Build Status](https://github.com/orchetect/TimecodeKit/actions/workflows/build.yml/badge.svg)](https://github.com/orchetect/TimecodeKit/actions/workflows/build.yml) [![Platforms - macOS 10.12 | iOS 9 | tvOS 9 | watchOS 2](https://img.shields.io/badge/platforms-macOS%2010.12%20|%20iOS%209%20|%20tvOS%209%20|%20watchOS%202-lightgrey.svg?style=flat)](https://developer.apple.com/swift) ![Swift 5.5-5.7](https://img.shields.io/badge/Swift-5.5–5.7-orange.svg?style=flat) [![Xcode 13-14](https://img.shields.io/badge/Xcode-13–14-blue.svg?style=flat)](https://developer.apple.com/swift) [![License: MIT](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](https://github.com/orchetect/TimecodeKit/blob/main/LICENSE)

The most robust, precise and complete Swift library for working with SMPTE timecode. Supports 22 industry timecode frame rates, including conversions to/from timecode strings and offering timecode-based calculations.

Timecode is a standard for representing video frames and used for video burn-in timecode (BITC), or display in a DAW (Digital Audio Workstation) or video playback/NLE applications.

## Supported Timecode Frame Rates

The following timecode frame rates are supported. These are display rates.

| Film / ATSC / HD | PAL / SECAM / DVB / ATSC | NTSC / ATSC / PAL-M | NTSC Non-Standard | ATSC |
| ---------------- | ------------------------ | ------------------- | ----------------- | ---- |
| 23.976           | 25                       | 29.97               | 30 DF             | 30   |
| 24               | 50                       | 29.97 DF            | 60 DF             | 60   |
| 24.98            | 100                      | 59.94               | 120 DF            | 120  |
| 47.952           |                          | 59.94 DF            |                   |      |
| 48               |                          | 119.88              |                   |      |
| 95.904           |                          | 119.88 DF           |                   |      |
| 96               |                          |                     |                   |      |

## Supported Video Frame Rates

The following video frame rates are supported. These are actual video rates.

| Film / HD | PAL       | NTSC            |
| --------- | --------- | --------------- |
| 23.98p    | 25p / 25i | 29.97p / 29.97i |
| 24p       | 50p / 50i | 30p             |
| 47.95p    | 100p      | 59.94p / 59.94i |
| 48p       |           | 60p / 60i       |
| 95.9p     |           | 119.88p         |
| 96p       |           | 120p            |

## Core Features

- Convert timecode values to timecode display string, and vice-versa
- Convert timecode values to real wall-clock time, and vice-versa
- Convert timecode to # of samples at any audio sample-rate, and vice-versa
- Convert timecode and/or frame rate to a rational fraction, and vice-versa (including `CMTime`)
- Support for Subframes
- Support for Days as a timecode component (some DAWs including Cubase support > 24 hour timecode)
- Common math operations between timecodes: add, subtract, multiply, divide
- Granular timecode validation
- Form a `Range` or `Stride` between two timecodes
- Conforms to `Codable`
- A `Formatter` object that can format timecode and also provide an `NSAttributedString` showing invalid timecode components using alternate attributes (such as red text color)
- A SwiftUI `Text` object showing invalid timecode components using alternate attributes (such as red text color)
- `AVAsset` video file utilities to easily read/write timecode and locate `AVPlayer` to timecode locations
- Exhaustive unit tests ensuring accuracy

## Installation

### Swift Package Manager (SPM)

1. Add TimecodeKit as a dependency using Swift Package Manager.

   - In an app project or framework, in Xcode:

     - Select the menu: **File → Swift Packages → Add Package Dependency...**
     - Enter this URL: `https://github.com/orchetect/TimecodeKit`

   - In a Swift Package, add it to the Package.swift dependencies:

     ```swift
     .package(url: "https://github.com/orchetect/TimecodeKit", from: "1.6.0")
     ```

2. Import the library:

   ```swift
   import TimecodeKit
   ```

## Documentation

Note: This documentation does not cover every property and initializer available but covers most typical use cases.

### Table of Contents

- [Initialization](#Initialization)
- [Properties](#Properties)
- [Components](#Components)
- [Timecode Display String](#Timecode-Display-String)
- [Math](#Math)
- [Conversions](#Conversions)
  - [To another frame rate](#to-another-frame-rate)
  - [Real Time](#Real-Time)
  - [Audio Samples](#Audio-Samples)
- [Validation](#Validation)
  - [Timecode Component Validation](#Timecode-Component-Validation)
  - [NSAttributedString](#Timecode-Validation-NSAttributedString)
  - [SwiftUI Text](#Timecode-Validation-SwiftUI-Text)
  - [NSFormatter](#Timecode-Validation-NSFormatter)
- [Advanced](#Advanced)
  - [Days Component](#Days-Component)
  - [Subframes Component](#Subframes-Component)
  - [Comparable](#Comparable)
  - [Range, Strideable](#Range-Strideable)
  - [Rational Number Expression](#Rational-Number-Expression)
  - [CMTime Conversion](#CMTime-Conversion)
  - [Timecode Intervals](#Timecode-Intervals)
  - [Timecode Transformer](#Timecode-Transformer)
  - [Feet+Frames](#Feet-Frames)

### Initialization

Using `(_ exactly:)` by default:

```swift
// from Int timecode component values
try Timecode(TCC(h: 01, m: 00, s: 00, f: 00), at: ._23_976)
try TCC(h: 01, m: 00, s: 00, f: 00).toTimecode(at: ._23_976) // alternate method

// from frame number (total elapsed frames)
try Timecode(.frames(40000), at: ._23_976)

// from timecode string
try Timecode("01:00:00:00", at: ._23_976)
try "01:00:00:00".toTimecode(at: ._23_976) // alternate method

// from real time (wall clock) elapsed in seconds
try Timecode(realTime: 4723.241579, at: ._23_976)
try (4723.241579).toTimecode(at: ._23_976) // alternate method on TimeInterval

// from elapsed number of audio samples at a given sample rate
try Timecode(samples: 123456789, sampleRate: 48000, at: ._23_976)
```

Using `(clamping:, ...)` and `(clampingEach:, ...)`:

```swift
// clamp full timecode to valid range
try Timecode(clamping: "26:00:00:00", at: ._24)
    .stringValue // == "23:59:59:23"

// clamp individual timecode component values to valid values if they are out-of-bounds
try Timecode(clampingEach: "01:00:85:50", at: ._24)
    .stringValue // == "01:00:59:23"
```

Using `(wrapping:, ...)`:

```swift
// wrap around clock continuously if entire timecode overflows or underflows

try Timecode(wrapping: "26:00:00:00", at: ._24)
    .stringValue // == "02:00:00:00"

try Timecode(wrapping: "23:59:59:24", at: ._24)
    .stringValue // == "00:00:00:00"
```

### Properties

Timecode components can be get or set directly as instance properties.

```swift
let tc = try "01:12:20:05".toTimecode(at: ._23_976)

// get
tc.days        // == 0
tc.hours       // == 1
tc.minutes     // == 12
tc.seconds     // == 20
tc.frames      // == 5
tc.subFrames   // == 0

// set
tc.hours = 5
tc.stringValue // == "05:12:20:05"
```

### Components

In order to help facilitate defining a set of timecode component values, a simple `Components` struct is implemented. This struct can be passed into many methods and initializers.

```swift
// a global typealias is exposed to shorten the syntax when constructing
public typealias TCC = Timecode.Components

// ie:
Timecode(TCC(h: 1), at: ._23_976)
// is the same as:
Timecode(Timecode.Components(h: 1), at: ._23_976)
```

```swift
let cmp = try "01:12:20:05"
    .toTimecode(at: ._23_976)
    .components // Timecode.Components(), aka TCC()

cmp.d  // == 0   (days)
cmp.h  // == 1   (hours)
cmp.m  // == 12  (minutes)
cmp.s  // == 20  (seconds)
cmp.f  // == 5   (frames)
cmp.sf // == 0   (subframes)
```

### Timecode Display String

```swift
try TCC(h: 01, m: 00, s: 00, f: 00)
    .toTimecode(at: ._29_97_drop)
    .stringValue // == "01:00:00;00"
```

### Math

Using operators (which use `wrapping:` internally if the result underflows or overflows timecode bounds):

```swift
let tc1 = try "01:00:00:00".toTimecode(at: ._23_976)
let tc2 = try "00:00:02:00".toTimecode(at: ._23_976)

(tc1 + tc2).stringValue // == "01:00:02:00"
(tc1 - tc2).stringValue // == "00:00:58:00"
(tc1 * 2.0).stringValue // == "02:00:00:00"
(tc1 / 2.0).stringValue // == "00:30:00:00"
```

Methods also exist to achieve the same results.

Mutating methods:

- `.add()`
- `.subtract()`
- `.multiply()`
- `.divide()`
- `.offset()`

Non-mutating methods that produce a new `Timecode` instance:

- `.adding()`
- `.subtracting()`
- `.multiplying()`
- `.dividing()`
- `.offsetting()`

### Conversions

#### To another frame rate

```swift
// convert between frame rates
try "01:00:00;00"
    .toTimecode(at: ._29_97_drop)
    .converted(to: ._29_97)
    .stringValue // == "00:59:56:12"
```

#### Real Time

```swift
// timecode to real-world time in seconds
let tc = try "01:00:00:00"
    .toTimecode(at: ._23_976)
    .realTimeValue // == 3603.6 as TimeInterval (Double)

// real-world time to timecode
try (3603.6) // TimeInterval, aka Double
    .toTimecode(at: ._23_976)
    .stringValue // == "01:00:00:00"
```

#### Audio Samples

```swift
// timecode to elapsed audio samples
let tc = try "01:00:00:00"
    .toTimecode(at: ._24)
    .samplesValue(sampleRate: 48000) // == 172800000

// elapsed audio samples to timecode
try Timecode(samples: 172800000, sampleRate: 48000, at: ._24)
    .stringValue // == "01:00:00:00"
```

### Validation

#### Timecode Component Validation

Timecode validation can be helpful and powerful, for example, when parsing timecode strings read from an external data file or received as user-input in a text field.

Timecode can be tested as:

- valid or invalid as a whole, by testing for `nil` when using the default `exactly:` failable initializers or instance `set...` methods, or
- granularly to test validity of individual timecode components

```swift
// example:
// 1 hour and 20 minutes ARE valid at 23.976 fps,
// but 75 seconds and 60 frames are NOT valid

// non-granular validation
try TCC(h: 1, m: 20, s: 75, f: 60)
    .toTimecode(at: ._23_976) // == throws error; cannot form a valid timecode

// granular validation
// rawValues allow invalid values; does not throw errors so 'try' is not needed
TCC(h: 1, m: 20, s: 75, f: 60)
    .toTimecode(rawValuesAt: ._23_976) 
    .invalidComponents // == [.seconds, .frames]
```

#### Timecode Validation: NSAttributedString

This method can produce an `NSAttributedString` highlighting individual invalid timecode components with a specified set of attributes.

```swift
TCC(h: 1, m: 20, s: 75, f: 60)
    .toTimecode(rawValuesAt: ._23_976)
    .stringValueValidated
```

The invalid formatting attributes defaults to applying `[.foregroundColor: NSColor.red]` to invalid components. You can alternatively supply your own invalid attributes by setting the `invalidAttributes` argument.

You can also supply a set of default attributes to set as the baseline attributes for the entire string.

```swift
// set text's background color to red instead of its foreground color
let invalidAttr: [NSAttributedString.Key: Any] =
    [.backgroundColor: NSColor.red]

// set custom font and font size for the entire string
let defaultAttr: [NSAttributedString.Key: Any] =
    [.font: NSFont.systemFont(ofSize: 16)]

TCC(h: 1, m: 20, s: 75, f: 60)
    .toTimecode(rawValuesAt: ._23_976)
    .stringValueValidated(invalidAttributes: invalidAttr,
                          withDefaultAttributes: defaultAttr)
```

#### Timecode Validation: SwiftUI Text

This method can produce a SwiftUI `Text` view highlighting individual invalid timecode components with a specified set of modifiers.

```swift
TCC(h: 1, m: 20, s: 75, f: 60)
    .toTimecode(rawValuesAt: ._23_976)
    .stringValueValidatedText()
```

The invalid formatting attributes defaults to applying `.foregroundColor(Color.red)` to invalid components. You can alternatively supply your own invalid modifiers by setting the `invalidModifiers` argument.

```swift
TCC(h: 1, m: 20, s: 75, f: 60)
    .toTimecode(rawValuesAt: ._23_976)
    .stringValueValidatedText(
        invalidModifiers: {
            $0.foregroundColor(.blue)
        }, withDefaultModifiers: {
            $0.foregroundColor(.black)
        }
    )
```

#### Timecode Validation: NSFormatter

A special string `Formatter` (`NSFormatter`) subclass can

- process user-entered timecode strings and format them in realtime in a TextField
- optionally highlight individual invalid timecode components with a specified set of attributes (defaults to red foreground color)

The invalid formatting attributes defaults to applying `[.foregroundColor: NSColor.red]` to invalid components. You can alternatively supply your own invalid attributes by setting the `validationAttributes` property on the formatter.

```swift
// set up formatter
let tcFormatter = 
    Timecode.TextFormatter(frameRate: ._23_976,
                           limit: ._24hours,
                           stringFormat: [.showSubFrames],
                           subFramesBase: ._80SubFrames,
                           showsValidation: true,     // enable invalid component highlighting
                           validationAttributes: nil) // if nil, defaults to red foreground color

// assign formatter to a TextField UI object, for example
let textField = NSTextField()
textField.formatter = tcFormatter
```

### Advanced

#### Days Component

Some DAWs (digital audio workstation) such as Cubase supports the use of the Days timecode component when deemed appropriate.

By default, `Timecode` is constructed with an `upperLimit` of 24-hour maximum expression (`._24hours`) which suppresses the ability to use Days. To enable Days, set the limit to `._100days`.

The limit setting naturally affects internal timecode validation routines, as well as clamping and wrapping.

```swift
// valid timecode range at 24 fps, ._24hours
"00:00:00:00" ... "23:59:59:23"

// valid timecode range at 24 fps, ._100days
"00:00:00:00" ... "99 23:59:59:23"
```

#### Subframes Component

Subframes represent a fraction (subdivision) of a single frame.

Subframes are only used by some software and hardware, and since there are no industry standards, each manufacturer can decide how they want to implement subframes. Subframes are frame rate agnostic, meaning the subframe base (divisor) is mutually exclusive of frame rate.

For example:

- *Cubase/Nuendo* and *Logic Pro* globally use 80 subframes per frame (0...79) regardless of frame rate
- *Pro Tools* uses 100 subframes (0...99) globally regardless of frame rate

Timecode supports subframes throughout. However, by default subframes are not displayed in `stringValue`. You can enable them:

```swift
var tc = try "01:12:20:05.62"
    .toTimecode(at: ._24, base: ._80SubFrames)

tc.stringValue // == "01:12:20:05"
tc.subFrames   // == 62 (subframes are preserved even though not displayed in stringValue)

tc.stringFormat.showSubFrames = true // default: false

tc.stringValue // == "01:12:20:05.62"
```

Subframes are always calculated when performing operations on the `Timecode` instance, regardless whether `displaySubFrames` set or not.

```swift
var tc = try "00:00:00:00.40"
    .toTimecode(at: ._24, base: ._80SubFrames)

tc.stringValue // == "00:00:00:00"

tc.stringFormat.showSubFrames = true // default: false
tc.stringValue // == "00:00:00:00.40"

// multiply timecode by 2. 40 subframes is half of a frame at 80 subframes per frame
(tc * 2).stringValue // == "00:00:00:01.00"
```

It is also possible to set this flag during construction.

```swift
var tc = try "01:12:20:05.62"
    .toTimecode(at: ._24, base: ._80SubFrames, format: [.showSubFrames])

tc.stringValue // == "01:12:20:05.62"
```

#### Comparable

Two `Timecode` instances can be compared linearly using common comparison operators.

```swift
try "01:00:00:00".toTimecode(at: ._24) 
    == try "01:00:00:00".toTimecode(at: ._24) // == true

try "00:59:50:00".toTimecode(at: ._24) 
    < "01:00:00:00".toTimecode(at: ._24) // == true

try "00:59:50:00".toTimecode(at: ._24) 
    > "01:00:00:00".toTimecode(at: ._24) // == false
```

#### Compare using Timeline Context

Sometimes a timeline does not have a zero start time (00:00:00:00). For example, many DAW applications such as Pro Tools allow a project start time to be set to any timecode. Its timeline then extends for 24 hours from that timecode, wrapping over 00:00:00:00 at some point along the timeline.

For example, given a 24 hour limit:

- A timeline start of 00:00:00:00 @ 24fps:

  24 hours elapses from 00:00:00:00 → 23:59:59:23

- A timeline start of 20:00:00:00 @ 24fps:

  24 hours elapses from 20:00:00:00 → 00:00:00:00 → 19:59:59:23

  This would mean for example, that 21:00:00:00 is < 00:00:00:00 since it is earlier in the wrapping timeline, and 18:00:00:00 is > 21:00:00:00 since it is later in the wrapping timeline.

Methods to sort and test sort order of `Timecode` collections are provided.

Note that passing `timelineStart` of `nil` or zero (00:00:00:00) is the same as using the standard  `<`, `==`, or  `>` operators as a sort comparator.

```swift
let timecode1: Timecode
let timecode2: Timecode
let start: Timecode
let result = timecode1.compare(to: timecode2, timelineStart: start)
// result is a ComparisonResult of orderedAscending, orderedSame, or orderedDescending
```

#### Sorting

Collections of `Timecode` can be sorted ascending or descending.

```swift
let timeline: [Timecode] = [ ... ]
let sorted: [Timecode] = timeline.sorted() // ascending
let sorted: [Timecode] = timeline.sorted(ascending: false) // descending
```

These collections can also be tested for sort order:

```swift
let timeline: [Timecode] = [ ... ]
let isSorted: Bool = timeline.isSorted() // ascending
let isSorted: Bool = timeline.isSorted(ascending: false) // descending
```

On newer systems, a `SortComparator` called `TimecodeSortComparator` is available as well.

```swift
let comparator = TimecodeSortComparator() // ascending
let comparator = TimecodeSortComparator(order: .reverse) // descending

let timeline: [Timecode] = [ ... ]
let sorted: [Timecode] = timeline.sorted(using: comparator)
```

#### Sorting using Timeline Context

For an explanation of timeline context, see the [Compare using Timeline Context](#Compare-using-Timeline-Context) section above.

Collections of `Timecode` can be sorted ascending or descending.

```swift
let timeline: [Timecode] = [ ... ]
let start = try "01:00:00:00".toTimecode(at: ._24)
let sorted: [Timecode] = timeline.sorted(timelineStart: start) // ascending
let sorted: [Timecode] = timeline.sorted(order: .reverse, timelineStart: start) // descending
```

These collections can also be tested for sort order:

```swift
let timeline: [Timecode] = [ ... ]
let start = try "01:00:00:00".toTimecode(at: ._24)
let isSorted: Bool = timeline.isSorted(timelineStart: start) // ascending
let isSorted: Bool = timeline.isSorted(order: .reverse, timelineStart: start) // descending
```

On newer systems, a `SortComparator` called `TimecodeSortComparator` is available as well.

```swift
let start = try "01:00:00:00".toTimecode(at: ._24)
let comparator = TimecodeSortComparator(timelineStart: start) // ascending
let comparator = TimecodeSortComparator(order: .reverse, timelineStart: start) // descending

let timeline: [Timecode] = [ ... ]
let sorted: [Timecode] = timeline.sorted(using: comparator)
```

#### Range, Strideable

A `Stride` or `Range` can be formed between two `Timecode` instances.

```swift
let startTC = try "01:00:00:00".toTimecode(at: ._24)
let endTC   = try "01:00:00:10".toTimecode(at: ._24)
```

Range:

```swift
// check if a timecode is contained within the range

(startTC...endTC).contains(try "01:00:00:05".toTimecode(at: ._24)) // == true
(startTC...endTC).contains(try "01:05:00:00".toTimecode(at: ._24)) // == false
```

```swift
// iterate on each frame of the range

for tc in startTC...endTC {
    print(tc)
}

// prints:
01:00:00:00
01:00:00:01
01:00:00:02
01:00:00:03
01:00:00:04
01:00:00:05
01:00:00:06
01:00:00:07
01:00:00:08
01:00:00:09
01:00:00:10
```

Stride:

```swift
// iterate on every 5 frames of the range by using a stride

for tc in stride(from: startTC, to: endTC, by: 5) {
    print(tc)
}

// prints:
01:00:00:00
01:00:00:05
01:00:00:10
```

#### Rational Number Expression

Video file metadata and timeline interchange files (AAF, Final Cut Pro XML) encode frame rate and timecode as rational numbers (a fraction consisting of two integers - a numerator and a denominator).

`Timecode` is capable of initializing from an elapsed time expressed as a rational fraction using the `init?(rational:)` initializer. The `rationalValue` property returns the `Timecode`'s elapsed time expressed as a rational fraction.

```swift
try Timecode(Fraction(1920919, 30000), at: ._29_97)
    .stringValue // == "00:01:03;29"

try Timecode(TCC(h: 00, m: 01, s: 03, f: 29), at: ._29_97)
    .rationalValue // == Fraction(1920919, 30000)
```

`TimecodeFrameRate` and `VideoFrameRate` are both capable of initializing from a rational fraction, and also provide a `rationalRate` and `rationalFrameDuration` property that provides this fraction.

Since drop-frame (timecode) or interlaced (video) attributes are not encodable in a rational fraction, they must be imperatively supplied.

```swift
// fraction representing the duration of 1 frame
TimecodeFrameRate(frameDuration: Fraction(1001, 30000), drop: false) // == ._29_97
// fraction representing the fps
TimecodeFrameRate(rate: Fraction(30000, 1001), drop: false) // == ._29_97

// fraction representing the duration of 1 frame
VideoFrameRate(frameDuration: Fraction(1001, 30000), interlaced: false) // == ._29_97p
// fraction representing the fps
VideoFrameRate(rate: Fraction(30000, 1001), interlaced: false) // == ._29_97p
```

#### CMTime Conversion

`CMTime` is a type exported by the Core Media framework (and used pervasively in AVFoundation). It represents time as a rational fraction of a `value` in a `timescale`.

`Timecode` and `TimecodeInterval`, as well as `TimecodeFrameRate` and `VideoFrameRate` can convert to/from `CMTime` using the respective inits and properties.

`CMTime` and `Fraction` can convert between themselves as well with respective inits and properties.

#### Timecode Intervals

The `TimecodeInterval` struct wraps a `Timecode` instance and adds a sign (positive of negative).

It serves to represent an absolute interval of timecode accompanied by a sign (+ / -) to establish the intent of the interval being *additive* or *subtractive* when passed into methods that accept a `TimecodeInterval` instance.

`TimecodeInterval` also accepts intervals larger than 24 hours and works well with raw timecode values.

On the whole, timecode itself is the expression of an absolute video timestamp, or used as a duration of video frames. The concept of a 'negative' timecode is antithetical; timecode is not meant to be expressed or displayed on-screen to the user using a negative sign. In practise, timecode wraps around the clock forwards and backwards: typically around a 24 hour clock but `Timecode` can be set to 100 day wrapping for unique cases. This means that, at 24 fps:

- `00:00:00:00` minus 1 frame is `23:59:59:23` (and not `-00:00:00:01`)
- `23:59:59:23` plus 1 frame is `00:00:00:00`

However, to meet the demand of some timecode calculations (such as offset transforms, theoretical calculations involving raw timecode values, or aggregate operations that may have otherwise resulted in wrapping the clock one or more times) `TimecodeInterval` is provided.

```swift
// construct directly:
let tc = try Timecode(TCC(h: 01), at: ._24)
let interval = TimecodeInterval(tc, .negative)

// construct with Timecode method:
let interval = try Timecode(TCC(h: 01), at: ._24)
let interval = tc.interval(.negative)

// construct with - or + unary operator:
let interval = try -Timecode(TCC(h: 01), at: ._24) // negative
let interval = try +Timecode(TCC(h: 01), at: ._24) // positive

// construct between two Timecode instances
let interval = timecode1.interval(to: timecode2)
```

The absolute interval can be returned.

```swift
let tc = try Timecode(TCC(h: 01), at: ._24)

let interval = TimecodeInterval(tc, .positive) // 01:00:00:00
interval.absoluteInterval // 01:00:00:00

let interval = TimecodeInterval(tc, .negative) // -01:00:00:00
interval.absoluteInterval // 01:00:00:00
```

The interval can be flattened by wrapping it around the upper limit if necessary, which is 24 hours in timecode by default.

```swift
let tc = try Timecode(TCC(h: 01), at: ._24)

let interval = TimecodeInterval(tc, .positive) // 01:00:00:00
interval.flattened() // 01:00:00:00

let interval = TimecodeInterval(tc, .negative) // -01:00:00:00
interval.flattened() // 23:00:00:00
```

#### Timecode Transformer

`TimecodeTransformer` is a mechanism that can define one or more timecode transforms in series. It can then be used to transform a ` Timecode` instance.

#### Feet+Frames

`FeedAndFrames` is a type used to convert feed+frames. Initializers and properties on `Timecode` are also available.

## References

- Wikipedia: [SMPTE Timecode](https://en.wikipedia.org/wiki/SMPTE_timecode)

## Author

Coded by a bunch of 🐹 hamsters in a trenchcoat that calls itself [@orchetect](https://github.com/orchetect).

## License

Licensed under the MIT license. See [LICENSE](https://github.com/orchetect/TimecodeKit/blob/master/LICENSE) for details.

## Contributions

Contributions are welcome. Feel free to post an Issue to discuss.
