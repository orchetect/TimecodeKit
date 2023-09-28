# Timecode Interval

Working with intervals between two timecodes.

The ``TimecodeInterval`` struct wraps a ``Timecode`` instance and adds a sign (positive of negative).

It serves to represent an absolute interval of timecode accompanied by a sign (+ / -) to establish the intent of the interval being *additive* or *subtractive* when passed into methods that accept a ``TimecodeInterval`` instance.

``TimecodeInterval`` also accepts intervals larger than 24 hours and works well with raw timecode values.

On the whole, timecode itself is the expression of an absolute video timestamp, or used as a duration of video frames. The concept of a 'negative' timecode is antithetical; timecode is not meant to be expressed or displayed on-screen to the user using a negative sign. In practise, timecode wraps around the clock forwards and backwards: typically around a 24 hour clock but ``Timecode`` can be set to 100 day wrapping for unique cases. This means that, at 24 fps:

- `00:00:00:00` minus 1 frame is `23:59:59:23` (not `-00:00:00:01`)
- `23:59:59:23` plus 1 frame is `00:00:00:00`

However, to meet the demand of some timecode calculations (such as offset transforms, theoretical calculations involving raw timecode values, or aggregate operations that may have otherwise resulted in wrapping the clock one or more times) ``TimecodeInterval`` is provided.

```swift
// construct directly:
let tc = try Timecode(.components(h: 1), at: .fps24)
let interval = TimecodeInterval(tc, .negative)

// construct with Timecode instance method:
let tc = try Timecode(.components(h: 1), at: .fps24)
let interval = tc.interval(.negative)

// construct with - or + unary operator:
let interval = try -Timecode(.components(h: 1), at: .fps24) // negative
let interval = try +Timecode(.components(h: 1), at: .fps24) // positive

// construct between two Timecode instances
let interval = timecode1.interval(to: timecode2)
```

The absolute interval can be returned.

```swift
let tc = try Timecode(.components(h: 1), at: .fps24)

let interval = TimecodeInterval(tc, .positive) // 01:00:00:00
interval.absoluteInterval // 01:00:00:00

let interval = TimecodeInterval(tc, .negative) // -01:00:00:00
interval.absoluteInterval // 01:00:00:00
```

The interval can be flattened by wrapping it around the upper limit if necessary, which is 24 hours in timecode by default.

```swift
let tc = try Timecode(.components(h: 1), at: .fps24)

let interval = TimecodeInterval(tc, .positive) // 01:00:00:00
interval.flattened() // 01:00:00:00

let interval = TimecodeInterval(tc, .negative) // -01:00:00:00
interval.flattened() // 23:00:00:00
```

## Topics

- ``TimecodeInterval``

### CMTime Extensions

- ``CoreMedia/CMTime/timecodeInterval(at:base:limit:)``
- ``CoreMedia/CMTime/timecodeInterval(using:)``
