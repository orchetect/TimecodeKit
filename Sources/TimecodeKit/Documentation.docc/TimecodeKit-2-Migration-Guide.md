# TimecodeKit 2 Migration Guide

API changes from TimecodeKit version 1 to version 2.

This guide is designed to assist in migrating projects currently using TimecodeKit 1.x to version 2.x. While not exhaustive, this guide covers the major API and workflow changes. 

## Timecode Time Value Types

In order to simplify initialization API and make time value types more easily discoverable, time values are now passed in as static wrappers to Timecode inits.

![Timecode init](timecode-init.png)

For example:

```swift
// 1.x API
Timecode("01:00:00:00", at: ._24)
// 2.x API
Timecode(.string("01:00:00:00"), at: ._24)
```

Full list of corresponding time value enum cases:

| 1.x API                                                      | 2.x API                                                      |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| `Timecode(TCC(), at: ._24)`                                  | `Timecode(.zero, at: ._24)`                                  |
| `Timecode(TCC(h: 1, m: 0, s: 0, f: 0), at: ._24)`            | `Timecode(.components(h: 1, m: 0, s: 0, f: 0), at: ._24)`    |
| `Timecode(.frames(1234), at: ._24)`                          | `Timecode(.frames(1234), at: ._24)`                          |
| `Timecode(.combined(frames: 123.5), at: ._24)`               | `Timecode(.frames(123.5), at: ._24)`                         |
| `Timecode(.split(frames: 123, subFrames: 50), at: ._24)`     | `Timecode(.frames(123, subFrames: 50), at: ._24)`            |
| `Timecode(.splitUnitInterval(frames: 123, subFramesUnitInterval: 0.5), at: ._24)` | `Timecode(.frames(123, subFramesUnitInterval: 0.5), at: ._24)` |
| `Timecode("01:00:00:00", at: ._24)`                          | `Timecode(.string("01:00:00:00"), at: ._24)`                 |
| `Timecode(realTime: 123.0, at: ._24)`                        | `Timecode(.realTime(seconds: 123.0), at: ._24)`              |
| `Timecode(samples: 123.0, sampleRate: 48000, at: ._24)`      | `Timecode(.samples(123.0, sampleRate: 48000), at: ._24)`     |
| `Timecode(startOf: AVAsset(), at: ._24)`                     | `Timecode(.avAsset(AVAsset(), .start), at: ._24)`            |
| `Timecode(durationOf: AVAsset(), at: ._24)`                  | `Timecode(.avAsset(AVAsset(), .duration), at: ._24)`         |
| `Timecode(endOf: AVAsset(), at: ._24)`                       | `Timecode(.avAsset(AVAsset(), .end), at: ._24)`              |
| `Timecode(CMTime(), at: ._24)`                               | `Timecode(.cmTime(CMTime()), at: ._24)`                      |
| `Timecode(Fraction(60, 1), at: ._24)`                        | `Timecode(.rational(60, 1), at: ._24)`                       |
| `Timecode(FeetAndFrames(feet: 60, frames: 10), at: ._24)`    | `Timecode(.feetAndFrames(feet: 60, frames: 10), at: ._24)`   |
| `Timecode(flattening: TimecodeInterval())`                   | `Timecode(.interval(flattening: TimecodeInterval()))`        |

## Timecode Validation

Time value validation has changed from parameter labels to a new `by:` parameter.

```swift
// "exactly" was denoted by an empty parameter label, and is a throwing init
// 1.x API
try Timecode("01:00:00:00", at: ._24)
// 2.x API
try Timecode(.string("01:00:00:00"), at: ._24)

// "clamping"
// 1.x API
Timecode(clamping: "01:00:00:00", at: ._24)
// 2.x API
Timecode(.string("01:00:00:00"), at: ._24, by: .clamping)

// "wrapping"
// 1.x API
Timecode(wrapping: "01:00:00:00", at: ._24)
// 2.x API
Timecode(.string("01:00:00:00"), at: ._24, by: .wrapping)

// "rawValues"
// 1.x API
Timecode(rawValues: "01:00:00:00", at: ._24)
// 2.x API
Timecode(.string("01:00:00:00"), at: ._24, by: .allowingInvalid)
```

## Timecode String Value

- The `stringValue` property is now the ``Timecode/stringValue(format:)`` method.
- The Timecode struct no longer stores string formatting properties. Instead, formatting options are now optionally passed when calling ``Timecode/stringValue(format:)``.

```swift
// 1.x API
let timecode = try Timecode(TCC(h: 1, m: 0, s: 0, f: 0, sf: 50), at: ._24)
timecode.stringValue // "01:00:00:00"
timecode.stringFormat = [.showSubFrames]
timecode.stringValue // "01:00:00:00.50"
// 2.x API
let timecode = try Timecode(.components(h: 1, m: 0, s: 0, f: 0, sf: 50), at: ._24)
timecode.stringValue() // "01:00:00:00"
timecode.stringValue(format: [.showSubFrames]) // "01:00:00:00.50"
```

- The `stringValueFileNameCompatible` property has been removed and is now a format option.

```swift
timecode.stringValue(format: [.filenameCompatible])
```

## Timecode Properties

Timecode metadata can now be constructed and passed around using a new ``Timecode/Properties-swift.struct`` struct. It contains:

- `frameRate`
- `subFramesBase`
- `upperLimit`

```swift
// construct a Timecode.Properties instance
// and pass it to a new Timecode instance
let properties = Timecode.Properties(
    rate: ._24,
    base: ._80SubFrames,
    limit: ._100Days
)
let timecode = Timecode(
    .components(h: 1, m: 0, s: 0, f: 0),
    using: properties
)

// it can also be fetched using the `properties` property and used to
// construct a new Timecode with the same properties
let newTimecode = Timecode(
    .components(h: 2, m: 0, s: 0, f: 0),
    using: timecode.properties
)
```

It is still possible to pass properties directly as initializer parameters if desired:

```swift
let timecode = try Timecode(
    .components(h: 1, m: 0, s: 0, f: 0), 
    at: ._24,
    base: ._80SubFrames,
    limit: ._100Days
)
```

## Set Timecode on an Existing Timecode Instance

Previous `Timecode` `setTimecode()` methods have been refactored to use a more consistent `set()` methods, with overloads similar to the new `Timecode` initializers. This allows set methods to take the same value sources and validation rules by using the same API as the initializers.

For example:

```swift
var timecode = Timecode(.zero, at: ._24)
try timecode.set(.realTime(seconds: 123.0))
timecode.set(.frames(1234), by: .wrapping)
```

For value type reference, see the [Timecode Time Value Types](#Timecode-Time-Value-Types) section above.

For timecode validation rules reference, see the [Timecode Validation](#Timecode-Validation) section above.

## Functional Shorthand

The time value category method `toTimecode(...)` has been renamed to `timecode(...)`.

For example:

```swift
// 1.x API
try "01:00:00:00".toTimecode(at: ._24)
// 2.x API
try "01:00:00:00".timecode(at: ._24)
```

## Enum Case Respellings

Some enum cases have been renamed to conform to lowerCamelCase.

- ``Timecode/UpperLimit-swift.enum`` cases have been renamed.
- ``TimecodeFrameRate/CompatibleGroup-swift.enum`` cases have been renamed.
