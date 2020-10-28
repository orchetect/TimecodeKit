# TimecodeKit

<p>
<a href="https://developer.apple.com/swift">
<img src="https://img.shields.io/badge/Swift%205.3-compatible-orange.svg?style=flat"
     alt="Swift 5.3 compatible" /></a>
<a href="#installation">
<img src="https://img.shields.io/badge/SPM-compatible-orange.svg?style=flat"
     alt="Swift Package Manager (SPM) compatible" /></a>
<a href="https://developer.apple.com/swift">
<img src="https://img.shields.io/badge/platform-macOS%20|%20iOS%20|%20tvOS%20|%20watchOS-green.svg?style=flat"
     alt="Platform - macOS | iOS | tvOS | watchOS" /></a>
<a href="#contributions">
<img src="https://img.shields.io/badge/Linux-not%20tested-black.svg?style=flat"
     alt="Linux - not tested" /></a>
<a href="https://github.com/orchetect/TimecodeKit/blob/main/LICENSE">
<img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat"
     alt="License: MIT" /></a>
</p>


A robust multiplatform Swift library for working with SMPTE timecode supporting 20 industry frame rates, and including methods to convert to/from timecode strings and perform calculations.

## Supported Frame Rates

| NTSC      | PAL  | HD / Film | Other  |
| --------- | ---- | --------- | ------ |
| 29.97     | 25   | 23.976    | 30     |
| 29.97 DF  | 50   | 24        | 30 DF  |
| 59.94     | 100  | 24.98     | 60     |
| 59.94 DF  |      | 47.952    | 60 DF  |
| 119.88    |      | 48        | 120    |
| 119.88 DF |      |           | 120 DF |

## Core Features

- Convert timecode to string, or a timecode string to values
- Convert timecode to real wall-clock time, and vice-versa
- Convert timecode to # of samples at any audio sample-rate, and vice-versa
- Granular timecode validation
- A Formatter object that can format timecode and also provide an NSAttributedString showing invalid timecode components in an alternate color (such as red)
- Support for Days as a timecode component (which Cubase supports as part of its timecode format)
- Support for sub-frames
- Common math operations between timecodes: add, subtract, multiply, divide
- Exhaustive unit tests ensuring accuracy

## Installation

### Swift Package Manager (SPM)

To add SwiftRadix to your Xcode project:

1. Select File → Swift Packages → Add Package Depedancy
2. Add package using  `https://github.com/orchetect/TimecodeKit` as the URL.

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
  - [Timecode Component Validtion](#Timecode-Component-Validation)
  - [NSAttributedString](#Timecode-Validation-NSAttributedString)
  - [NSFormatter](#Timecode-Validation-NSFormatter)
- [Advanced](#Advanced)
  - [Days Component](#Days-Component)
  - [Subframes Component](#Subframes-Component)
  - [Comparable](#Comparable)
  - [Range, Strideable](#Range-Strideable)

### Initialization

Using `(_ exaclty:, ...)` by default:

```swift
// from Int timecode component values
Timecode(TCC(h: 01, m: 00, s: 00, f: 00), at: ._23_976)
TCC(h: 01, m: 00, s: 00, f: 00).toTimecode(at: ._23_976) // alternate method

// from timecode string
Timecode("01:00:00:00", at: ._23_976)
"01:00:00:00".toTimecode(at: ._23_976) // alternate method

// from real time (wall clock) elapsed
Timecode(TimeValue(seconds: 4723.241579), at: ._23_976)
TimeValue(seconds: 4723.241579).toTimecode(at: ._23_976) // alternate method

// from elapsed number of audio samples at a given sample rate
Timecode(samples: 123456789, sampleRate: 48000, at: ._23_976)
```

Using `(clamping:, ...)`:

```swift
// clamps individual timecode component values to valid values if the are out-of-bounds

Timecode(clamping: "01:00:85:50", at: ._24)?
    .stringValue // == "01:00:59:23"

Timecode(clamping: "26:00:00:00", at: ._24)?
    .stringValue // == "23:59:59:23"
```

Using `(wrapping:, ...)`:

```swift
// wraps around clock continuously if entire timecode overflows or underflows

Timecode(wrapping: "26:00:00:00", at: ._24)?
    .stringValue // == "02:00:00:00"

Timecode(wrapping: "23:59:59:24", at: ._24)?
    .stringValue // == "00:00:00:00"
```

### Properties

Timecode components can be get or set directly as instance properties.

```swift
let tc = "01:12:20:05"
    .toTimecode(at: ._23_976)

// get
tc?.days        // == 0
tc?.hours       // == 1
tc?.minutes     // == 12
tc?.seconds     // == 20
tc?.frames      // == 5
tc?.subFrames   // == 0

// set
tc?.hours = 5
tc?.stringValue // == "05:12:20:05"
```

### Components

In order to help facilitate defining a set of timecode component values, a simple `Components` struct is implemented. This struct can be passed into many methods and initializers.

```swift
// a global typealias is exposed to shorten the syntax when constructing
public typealias TCC = Timecode.Components

// ie:
Timecode(TCC(h: 1))
// is the same as:
Timecode(Timecode.Components(h: 1))
```

```swift
let cmp = "01:12:20:05"
    .toTimecode(at: ._23_976)?
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
TCC(h: 01, m: 00, s: 00, f: 00)
    .toTimecode(at: ._29_97_drop)?
    .stringValue // == "01:00:00;00"
```

### Math

Using operators:

```swift
guard let tc1 = "01:00:00:00".toTimecode(at: ._23_976) else { return }
guard let tc2 = "00:00:02:00".toTimecode(at: ._23_976) else { return }

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

Non-mutating methods that produce a new `Timecode` instance:

- `.adding()`
- `.subtracting()`
- `.multiplying()`
- `.dividing()`

### Conversions

#### To another frame rate

```swift
// convert between frame rates
"01:00:00;00"
    .toTimecode(at: ._29_97_drop)?
    .converted(to: ._29_97)?
    .stringValue ?? "" // == "00:59:56:12"
```

#### Real Time

```swift
// timecode to real-world time
let tc = "01:00:00:00"
    .toTimecode(at: ._23_976)?
    .realTimeValue // == TimeValue()

tc?.seconds // == 3603.6
tc?.ms      // == 3603600.0

// real-world time to timecode
TimeValue(seconds: 3603.6)
    .toTimecode(at: ._23_976)?
    .stringValue // == "01:00:00:00"
```

#### Audio Samples

```swift
// timecode to elapsed audio samples
let tc = "01:00:00:00"
    .toTimecode(at: ._24)?
    .samplesValue(atSampleRate: 48000) // == 172800000

// elapsed audio samples to timecode
Timecode(samples: 172800000, sampleRate: 48000, at: ._24)?
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
TCC(h: 1, m: 20, s: 75, f: 60)
    .toTimecode(at: ._23_976) // == nil, because it cannot form a valid timecode

// granular validation
TCC(h: 1, m: 20, s: 75, f: 60)
    .toTimecode(rawValuesAt: ._23_976)? // rawValues methods allow invalid values to be set
    .invalidComponents // == [.seconds, .frames]
```

#### Timecode Validation: NSAttributedString

This method can produce an `NSAttributedString` highlighting individual invalid timecode components with a specified set of attributes.

```swift
TCC(h: 1, m: 20, s: 75, f: 60)
    .toTimecode(rawValuesAt: ._23_976)?
    .stringValueValidated
```

The invalid formatting attributes defaults to applying `[ .foregroundColor : NSColor.red ]` to invalid components. You can alternatively supply your own invalid attributes by setting the `invalidAttributes` argument.

You can also supply a set of default attributes to set as the baseline attributes for the entire string.

```swift
// set text's background color to red instead of its foreground color
let invalidAttr: [NSAttributedString.Key : Any] =
    [ .backgroundColor : NSColor.red ]

// set custom font and font size for the entire string
let defaultAttr: [NSAttributedString.Key : Any] =
    [ .font : NSFont.systemFont(ofSize: 16) ]

TCC(h: 1, m: 20, s: 75, f: 60)
    .toTimecode(rawValuesAt: ._23_976)?
    .stringValueValidated(invalidAttributes: invalidAttr,
                          withDefaultAttributes: defaultAttr)
```

#### Timecode Validation: NSFormatter

A special string `Formatter` (`NSFormatter`) subclass can

- process user-entered timecode strings and format them in realtime in a TextField
- optionally highlight individual invalid timecode components with a specified set of attributes (defaults to red foreground color)

The invalid formatting attributes defaults to applying `[ .foregroundColor : NSColor.red ]` to invalid components. You can alternatively supply your own invalid attributes by setting the `validationAttributes` property on the formatter.

```swift
// set up formatter
let tcFormatter = 
    Timecode.TextFormatter(frameRate: ._23_976,
                           limit: ._24hours,
                           displaySubFrames: false,
                           subFramesDivisor: 80,
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

Subframes are supported by some software and hardware, and since there are no industry standards, each manufacturer can decide how they want to implement subframes. Subframes are frame rate agnostic, meaning the subframe divisor is set independently from frame rate and is not dependent on frame rate or vice-versa.

For example: Cubase/Nuendo and Logic Pro use 80 subframes per frame, whereas Pro Tools uses 100 subframes.

Timecode supports subframes throughout. However, by default subframes are not displayed in `stringValue`. You can enable them:

```swift
var tc = "01:12:20:05.62"
    .toTimecode(at: ._24, subFramesDivisor: 80)

tc?.stringValue // == "01:12:20:05"
tc?.subFrames   // == 62 (subframes are preserved even though not displayed in stringValue)

tc?.displaySubFrames = true // default: false

tc?.stringValue // == "01:12:20:05.62"
```

Subframes are always calculated when performing operations on the `Timecode` instance, regardless whether `displaySubFrames` set or not.

```swift
var tc = "00:00:00:00.40"
    .toTimecode(at: ._24, subFramesDivisor: 80)

tc?.displaySubFrames = true

// multiply timecode by 2. 40 subframes is half of a frame at 80 subframes per frame
(tc * 2).stringValue // == "00:00:00:01.00"
```

#### Comparable

Two `Timecode` instances can be compared linearly.

```swift
"01:00:00:00".toTimecode(at: ._24) == "01:00:00:00".toTimecode(at: ._24) // == true

"00:59:50:00".toTimecode(at: ._24) < "01:00:00:00".toTimecode(at: ._24) // == true

"00:59:50:00".toTimecode(at: ._24) > "01:00:00:00".toTimecode(at: ._24) // == false
```

#### Range, Strideable

A `Stride` or `Range` can be formed between two `Timecode` instances.

```swift
let startTC = "01:00:00:00".toTimecode(at: ._24)!
let endTC   = "01:00:01:00".toTimecode(at: ._24)!
```

Range:

```swift
// check if a timecode is contained within the range

(startTC...endTC).contains("01:00:00:05".toTimecode(at: ._24)!) // == true
(startTC...endTC).contains("01:05:00:00".toTimecode(at: ._24)!) // == false
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
01:00:00:11
01:00:00:12
01:00:00:13
01:00:00:14
01:00:00:15
01:00:00:16
01:00:00:17
01:00:00:18
01:00:00:19
01:00:00:20
01:00:00:21
01:00:00:22
01:00:00:23
01:00:01:00
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
01:00:00:15
01:00:00:20
```

## Known Issues

- The Dev Tests are not meant to be run as routine unit tests, but are designed as a test harness to be used only when altering critical parts of the library to ensure stability of internal calculations.
- Unit Tests won't build/run for watchOS Simulator because XCTest does not work on watchOS
  - Workaround: Don't run unit tests for a watchOS target. Using macOS or iOS as a unit test target should be sufficient enough. If anyone runs into issues with the library on watchOS, feel free to contribute a solution or fix anything that requires fixing.

## Author

Coded by a bunch of 🐹 hamsters in a trenchcoat that calls itself [@orchetect](https://github.com/orchetect).

## License

Licensed under the MIT license. See [LICENSE](https://github.com/orchetect/TimecodeKit/blob/master/LICENSE) for details.

## Contributions

Contributions are welcome. Feel free to post an Issue to discuss.
