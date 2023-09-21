![TimecodeKit](Images/timecodekit-banner.png)

# TimecodeKit

[![CI Build Status](https://github.com/orchetect/TimecodeKit/actions/workflows/build.yml/badge.svg)](https://github.com/orchetect/TimecodeKit/actions/workflows/build.yml) [![Platforms - macOS 10.12 | iOS 9 | tvOS 9 | watchOS 2](https://img.shields.io/badge/Platforms-macOS%2010.12%20|%20iOS%209%20|%20tvOS%209%20|%20watchOS%202-lightgrey.svg?style=flat)](https://developer.apple.com/swift) ![Swift 5.5-5.9](https://img.shields.io/badge/Swift-5.5–5.9-orange.svg?style=flat) [![Xcode 13-15](https://img.shields.io/badge/Xcode-13–15-blue.svg?style=flat)](https://developer.apple.com/swift) [![License: MIT](http://img.shields.io/badge/License-MIT-lightgrey.svg?style=flat)](https://github.com/orchetect/TimecodeKit/blob/main/LICENSE)

The most robust, precise and complete Swift library for working with SMPTE timecode. Supports 22 industry timecode frame rates, with a suite of conversions, calculations and integrations with Apple AV frameworks.

Timecode is a broadcast and post-production standard for addressing video frames. It is used for video burn-in timecode (BITC), and display in a DAW (Digital Audio Workstation) or video playback/editing applications.

> **Note**: See the TimecodeKit 1.x → 2.x [Migration Guide](TimecodeKit-2-Migration-Guide.md) if you are upgrading a project that was using TimecodeKit 1.x.

## Supported Timecode Frame Rates

The following timecode rates and formats are supported.

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

The following video frame rates are supported. (Video rates)

| Film / HD | PAL       | NTSC            |
| --------- | --------- | --------------- |
| 23.98p    | 25p / 25i | 29.97p / 29.97i |
| 24p       | 50p / 50i | 30p             |
| 47.95p    | 100p      | 59.94p / 59.94i |
| 48p       |           | 60p / 60i       |
| 95.9p     |           | 119.88p         |
| 96p       |           | 120p            |

## Core Features

- Convert timecode between:
  - timecode display string
  - total elapsed frame count
  - real wall-clock time
  - elapsed audio samples at given audio sample-rate
  - rational time notation (such as `CMTime` or Final Cut Pro XML and AAF encoding)
  - feet + frames
- Convert timecode and/or frame rate to a rational fraction, and vice-versa (including `CMTime`)
- Support for Subframes
- Support for Days as a timecode component (some DAWs including Cubase support > 24 hour timecode)
- Math operations: add, subtract, multiply, divide
- Granular timecode validation
- Form a `Range` or `Stride` between two timecodes
- Conforms to `Codable`
- A `Formatter` object that can format timecode and also provide an `NSAttributedString` showing invalid timecode components using alternate attributes (such as red text color)
- A SwiftUI `Text` object showing invalid timecode components using alternate attributes (such as red text color)
- `AVAsset` video file utilities to easily read/write timecode tracks and locate `AVPlayer` to timecode locations
- Exhaustive unit tests ensuring accuracy

## Installation

### Swift Package Manager (SPM)

1. Add TimecodeKit as a dependency using Swift Package Manager.
   - In an app project or framework, in Xcode:
     - Select the menu: **File → Swift Packages → Add Package Dependency...**
     - Enter this URL: `https://github.com/orchetect/TimecodeKit`
   - In a Swift Package, add it to the Package.swift dependencies:

     ```swift
     .package(url: "https://github.com/orchetect/TimecodeKit", from: "2.0.0")
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
  - [AVAsset Timecode Track Read/Write](#AVAsset-Timecode-Track-ReadWrite)

### Initialization

TimecodeKit is designed to work with Xcode's autocomplete fluidly. Beginning a `Timecode` initializer with a period will produce a list of all available source time value types.

![Timecode init](Images/timecode-init.png)

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

If additional properties need to be specified, supply a `Properties` struct with the `using:` overload.

```swift
let tcProperties = Timecode.Properties(
    rate: ._23_976,
    base: ._100SubFrames,
    limit: ._100days
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

### Properties

Timecode components can be get or set directly as instance properties.

```swift
let tc = try "01:12:20:05".timecode(at: ._23_976)

// get
tc.days          // == 0
tc.hours         // == 1
tc.minutes       // == 12
tc.seconds       // == 20
tc.frames        // == 5
tc.subFrames     // == 0

// set
tc.hours = 5
tc.stringValue() // == "05:12:20:05"
```

### Components

In order to help facilitate defining a set of timecode component values, a simple `Components` struct is implemented. This struct can be passed into many methods and initializers.

```swift
let tcc = Timecode.Components(h: 1)
Timecode(.components(tcc), at: ._23_976)

// is the same as using the shorthand:
Timecode(.components(h: 1), at: ._23_976)
```

```swift
let cmp = try "01:12:20:05"
    .timecode(at: ._23_976)
    .components // Timecode.Components

cmp.days      // == 0
cmp.hours     // == 1
cmp.minutes   // == 12
cmp.seconds   // == 20
cmp.frames    // == 5
cmp.subFrames // == 0
```

### Timecode Display String

```swift
try Timecode(.components(h: 01, m: 00, s: 00, f: 00), at: ._29_97_drop)
    .stringValue() // == "01:00:00;00"
```

### Math

Math operations are possible by either methods or operators.

Addition and subtraction may be performed using two timecode operands to produce a timecode result.

- `Timecode` + `Timecode` = `Timecode`
- `Timecode` - `Timecode` = `Timecode`

Multiplication and division may be performed using one timecode operand and one floating-point number operand. This forms a calculation of timecode (position or duration) against a number of iterations or subdivisions.

Multiplying timecode against timecode in order to produce a timecode result is not possible since it is ambiguous and considered undefined behavior.

- `Timecode` * `Double` = `Timecode`
- `Timecode` * `Timecode` is undefined and therefore not implemented
- `Timecode` / `Double` = `Timecode`
- `Timecode` / `Timecode` = `Double`

#### Arithmetic Methods

Arithmetic methods follow the same behavior as `Timecode` initializers whereby the operation can be completed either using validation with a throwing call, or by using validation rules to constrain the result such as `clamping` or `wrapping`.

The right-hand operand may be a `Timecode` instance, a `Timecode.Components` instance, or a time source value.

- `add()` / `adding()`
- `subtract()` / `subtracting()`
- `multiply()` / `multiplying()`
- `divide()` / `dividing()`

```swift
var tc1 = try "01:00:00:00".timecode(at: ._23_976)
var tc2 = try "00:00:02:00".timecode(at: ._23_976)

// in-place mutation
try tc1.add(tc2)
try tc1.add(tc2, by: wrapping) // using result validation rule

// return a new instance
let tc3 = try tc1.adding(tc2)
let tc3 = try tc1.adding(tc2, by: wrapping) // using result validation rule
```

#### Arithmetic Operators

Arithmetic operators are provided for convenience. These operators employ the `wrapping` validation rule in the event of underflows or overflows.

```swift
let tc1 = try "01:00:00:00".timecode(at: ._23_976)
let tc2 = try "00:02:00:00".timecode(at: ._23_976)

(tc1 + tc2).stringValue() // == "01:02:00:00"
(tc1 - tc2).stringValue() // == "00:58:00:00"
(tc1 * 2.0).stringValue() // == "02:00:00:00"
(tc1 / 2.0).stringValue() // == "00:30:00:00"
tc1 / tc2 // == 30.0
```

### Conversions

#### To another frame rate

```swift
// convert between frame rates
try "01:00:00;00"
    .timecode(at: ._29_97_drop)
    .converted(to: ._29_97)
    .stringValue() // == "00:59:56:12"
```

#### Real Time

```swift
// timecode to real-world time in seconds
let tc = try "01:00:00:00"
    .timecode(at: ._23_976)
    .realTimeValue // == 3603.6 as TimeInterval (Double)

// real-world time to timecode
try Timecode(.realTime(seconds: 3603.6), at: ._23_976)
    .stringValue() // == "01:00:00:00"
```

#### Audio Samples

```swift
// timecode to elapsed audio samples
let tc = try "01:00:00:00"
    .timecode(at: ._24)
    .samplesValue(sampleRate: 48000) // == 172800000

// elapsed audio samples to timecode
try Timecode(.samples(172800000, sampleRate: 48000), at: ._24)
    .stringValue() // == "01:00:00:00"
```

### Validation

#### Timecode Component Validation

Timecode validation can be helpful and powerful, for example, when parsing timecode strings read from an external data file or received as user-input in a text field.

Timecode can be tested as:

- valid or invalid as a whole, by catching an error when using the default throwing initializers or `set()` methods, or
- granularly to test validity of individual timecode components

```swift
// example:
// 1 hour and 20 minutes ARE valid at 23.976 fps,
// but 75 seconds and 60 frames are NOT valid

// non-granular validation
try Timecode(.components(h: 1, m: 20, s: 75, f: 60), at: ._23_976)
// == throws error; cannot form a valid timecode

// granular validation
// allowingInvalid allows invalid values; does not throw errors so 'try' is not needed
Timecode(.components(h: 1, m: 20, s: 75, f: 60), at: ._23_976, by: .allowingInvalid)
    .invalidComponents // == [.seconds, .frames]
```

#### Timecode Validation: NSAttributedString

This method can produce an `NSAttributedString` highlighting individual invalid timecode components with a specified set of attributes.

```swift
Timecode(.components(h: 1, m: 20, s: 75, f: 60), at: ._23_976, by: .allowingInvalid)
    .stringValueValidated()
```

The invalid formatting attributes defaults to applying `[.foregroundColor: NSColor.red]` to invalid components. You can alternatively supply your own invalid attributes by setting the `invalidAttributes` argument.

You can also supply a set of default attributes to set as the baseline attributes for the entire string.

```swift
// set text's background color to red instead of its foreground color
let invalidAttr: [NSAttributedString.Key: Any] = [
    .backgroundColor: NSColor.red
]

// set custom font and font size for the entire string
let defaultAttr: [NSAttributedString.Key: Any] = [
    .font: NSFont.systemFont(ofSize: 16)
]

Timecode(.components(h: 1, m: 20, s: 75, f: 60), at: ._23_976, by: .allowingInvalid)
    .stringValueValidated(invalidAttributes: invalidAttr,
                          withDefaultAttributes: defaultAttr)
```

#### Timecode Validation: SwiftUI Text

This method can produce a SwiftUI `Text` view highlighting individual invalid timecode components with a specified set of modifiers.

```swift
Timecode(.components(h: 1, m: 20, s: 75, f: 60), at: ._23_976, by: .allowingInvalid)
    .stringValueValidatedText()
```

The invalid formatting attributes defaults to applying `.foregroundColor(Color.red)` to invalid components. You can alternatively supply your own invalid modifiers by setting the `invalidModifiers` argument.

```swift
Timecode(.components(h: 1, m: 20, s: 75, f: 60), at: ._23_976, by: .allowingInvalid)
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
let formatter = Timecode.TextFormatter(
    using: .init(
        rate: ._23_976,
        base: ._80SubFrames,
        limit: ._24hours
    )
    stringFormat: [.showSubFrames],
    showsValidation: true,     // enable invalid component highlighting
    validationAttributes: nil // if nil, defaults to red foreground color
)

// assign formatter to a TextField UI object, for example
let textField = NSTextField()
textField.formatter = formatter
```

### Advanced

#### Days Component

Although not covered by SMPTE spec, some DAWs (digital audio workstation) such as Cubase support the use of the Days timecode component for timelines longer than (or outside of) 24 hours.

By default, `Timecode` is constructed with an `upperLimit` of 24-hour maximum expression (`._24hours`) which suppresses the ability to use Days. To enable Days, set the limit to `._100days`.

The limit setting naturally affects internal timecode validation routines, as well as clamping and wrapping.

```swift
// valid timecode range at 24 fps, with 24 hours limit
"00:00:00:00" ... "23:59:59:23"

// valid timecode range at 24 fps, with 100 days limit
"00:00:00:00" ... "99 23:59:59:23"
```

#### Subframes Component

Subframes represent a fraction (subdivision) of a single frame.

Subframes are only used by some software and hardware, and since there are no industry standards, each manufacturer can decide how they want to implement subframes. Subframes are frame rate agnostic, meaning the subframe base (divisor) is mutually exclusive of frame rate.

For example:

- *Cubase/Nuendo* and *Logic Pro* globally use 80 subframes per frame (0...79) regardless of frame rate
- *Pro Tools* uses 100 subframes (0...99) globally regardless of frame rate

Timecode supports subframes throughout. However, by default subframes are not displayed in `stringValue()`. You can enable them:

```swift
var tc = try "01:12:20:05.62"
    .timecode(at: ._24, base: ._80SubFrames)

// string with default formatting
tc.stringValue() // == "01:12:20:05"
tc.subFrames     // == 62 (subframes are preserved even though not displayed in stringValue)

// string with subframes shown
tc.stringValue(format: .showSubFrames) // == "01:12:20:05.62"
```

Subframes are always calculated when performing operations on the `Timecode` instance, regardless whether `displaySubFrames` set or not.

```swift
var tc = try "00:00:00:00.40"
    .timecode(at: ._24, base: ._80SubFrames)

tc.stringValue() // == "00:00:00:00"
tc.stringValue(format: .showSubFrames) // == "00:00:00:00.40"

// multiply timecode by 2. 40 subframes is half of a frame at 80 subframes per frame
(tc * 2).stringValue(format: .showSubFrames) // == "00:00:00:01.00"
```

#### Comparable

Two `Timecode` instances can be compared linearly using common comparison operators.

```swift
try "01:00:00:00".timecode(at: ._24) 
    == try "01:00:00:00".timecode(at: ._24) // == true

try "00:59:50:00".timecode(at: ._24) 
    < "01:00:00:00".timecode(at: ._24) // == true

try "00:59:50:00".timecode(at: ._24) 
    > "01:00:00:00".timecode(at: ._24) // == false
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
let start = try "01:00:00:00".timecode(at: ._24)
let sorted: [Timecode] = timeline.sorted(timelineStart: start) // ascending
let sorted: [Timecode] = timeline.sorted(order: .reverse, timelineStart: start) // descending
```

These collections can also be tested for sort order:

```swift
let timeline: [Timecode] = [ ... ]
let start = try "01:00:00:00".timecode(at: ._24)
let isSorted: Bool = timeline.isSorted(timelineStart: start) // ascending
let isSorted: Bool = timeline.isSorted(order: .reverse, timelineStart: start) // descending
```

On newer systems, a `SortComparator` called `TimecodeSortComparator` is available as well.

```swift
let start = try "01:00:00:00".timecode(at: ._24)
let comparator = TimecodeSortComparator(timelineStart: start) // ascending
let comparator = TimecodeSortComparator(order: .reverse, timelineStart: start) // descending

let timeline: [Timecode] = [ ... ]
let sorted: [Timecode] = timeline.sorted(using: comparator)
```

#### Range, Strideable

A `Stride` or `Range` can be formed between two `Timecode` instances.

```swift
let startTC = try "01:00:00:00".timecode(at: ._24)
let endTC   = try "01:00:00:10".timecode(at: ._24)
```

Range:

```swift
// check if a timecode is contained within the range

(startTC...endTC).contains(try "01:00:00:05".timecode(at: ._24)) // == true
(startTC...endTC).contains(try "01:05:00:00".timecode(at: ._24)) // == false
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
try Timecode(.rational(Fraction(1920919, 30000)), at: ._29_97)
    .stringValue() // == "00:01:03;29"

try Timecode(.components(h: 00, m: 01, s: 03, f: 29), at: ._29_97)
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
let tc = try Timecode(.components(h: 1), at: ._24)
let interval = TimecodeInterval(tc, .negative)

// construct with Timecode instance method:
let tc = try Timecode(.components(h: 1), at: ._24)
let interval = tc.interval(.negative)

// construct with - or + unary operator:
let interval = try -Timecode(.components(h: 1), at: ._24) // negative
let interval = try +Timecode(.components(h: 1), at: ._24) // positive

// construct between two Timecode instances
let interval = timecode1.interval(to: timecode2)
```

The absolute interval can be returned.

```swift
let tc = try Timecode(.components(h: 1), at: ._24)

let interval = TimecodeInterval(tc, .positive) // 01:00:00:00
interval.absoluteInterval // 01:00:00:00

let interval = TimecodeInterval(tc, .negative) // -01:00:00:00
interval.absoluteInterval // 01:00:00:00
```

The interval can be flattened by wrapping it around the upper limit if necessary, which is 24 hours in timecode by default.

```swift
let tc = try Timecode(.components(h: 1), at: ._24)

let interval = TimecodeInterval(tc, .positive) // 01:00:00:00
interval.flattened() // 01:00:00:00

let interval = TimecodeInterval(tc, .negative) // -01:00:00:00
interval.flattened() // 23:00:00:00
```

#### Timecode Transformer

`TimecodeTransformer` is a mechanism that can define one or more timecode transforms in series. It can then be used to transform a `Timecode` instance.

#### Feet+Frames

`FeetAndFrames` is a type used to convert feet+frames. Initializers and properties on `Timecode` are also available.

#### AVAsset Timecode Track Read/Write

##### Read Timecode from QuickTime Movie

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

##### Add or Replace Timecode Track in a QuickTime Movie

Currently timecode tracks can be modified on `AVMutableMovie`.

This is one way to make an `AVMovie` into a mutable `AVMutableMovie` if needed.

```swift
let movie = AVMovie( ... )
let mutableMovie = movie.mutableCopy() as! AVMutableMovie
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

## Known Issues

- As of iOS 17, Apple appears to have introduced a regression when using `AVAssetExportSession` to save a QuickTime movie file when using a physical iOS device (simulator works fine). A radar has been filed with Apple (FB12986599). This is not an issue with TimecodeKit itself, but is just to make developers aware that until Apple fixes this bug it will affect saving a movie file after performing timecode track modifications. See [this thread](https://github.com/orchetect/TimecodeKit/discussions/63) for details.

## References

- Wikipedia: [SMPTE Timecode](https://en.wikipedia.org/wiki/SMPTE_timecode)

## Author

Coded by a bunch of 🐹 hamsters in a trenchcoat that calls itself [@orchetect](https://github.com/orchetect).

## License

Licensed under the MIT license. See [LICENSE](https://github.com/orchetect/TimecodeKit/blob/master/LICENSE) for details.

## Sponsoring

If you enjoy using TimecodeKit and want to contribute to open-source financially, GitHub sponsorship is much appreciated. Feedback and code contributions are also welcome.

## Community & Support

Please do not email maintainers for technical support. Several options are available for questions and feature ideas:

- Questions and feature ideas can be posted to [Discussions](https://github.com/orchetect/TimecodeKit/discussions).
- If an issue is a verifiable bug with reproducible steps it may be posted in [Issues](https://github.com/orchetect/TimecodeKit/issues).

## Contributions

Contributions are welcome. Feel free to post an Issue to discuss.
