# Range & Strideable

Forming a `Range` or `Stride` between two ``Timecode`` instances.

For simplicity, we will define the start and end timecodes beforehand.

```swift
let startTC = try "01:00:00:00".timecode(at: ._24)
let endTC   = try "01:00:00:10".timecode(at: ._24)
```

## Range

Check if a timecode is contained within the range:

```swift
(startTC...endTC).contains(try "01:00:00:05".timecode(at: ._24)) // == true
(startTC...endTC).contains(try "01:05:00:00".timecode(at: ._24)) // == false
```

Iterate on each frame of the range:

```swift
for tc in startTC...endTC {
    print(tc)
}
```

Prints:

```
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

## Stride

Iterate on every `n` frames of the range by using a stride:

```swift
for tc in stride(from: startTC, to: endTC, by: 5) {
    print(tc)
}
```

Prints:

```
01:00:00:00
01:00:00:05
01:00:00:10
```

## Topics

### CMTimeRange Extensions

- ``CoreMedia/CMTimeRange/timecodeRange(at:base:limit:)``
- ``CoreMedia/CMTimeRange/timecodeRange(using:)``
