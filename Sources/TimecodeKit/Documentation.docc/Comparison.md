# Comparison

Comparing the ordering of two timecodes.

## Comparable Conformance

Comparable protocol conformance.

Two ``Timecode`` instances can be compared linearly using common comparison operators.

```swift
try "01:00:00:00".timecode(at: ._24) 
    == try "01:00:00:00".timecode(at: ._24) // == true

try "00:59:50:00".timecode(at: ._24) 
    < "01:00:00:00".timecode(at: ._24) // == true

try "00:59:50:00".timecode(at: ._24) 
    > "01:00:00:00".timecode(at: ._24) // == false
```

## Comparing using Timeline Context

Special comparison methods based on non-zero timeline origin timecode.

Sometimes a timeline does not have a zero start time (00:00:00:00). For example, many DAW applications such as Pro Tools allow a project start time to be set to any timecode. Its timeline then extends for 24 hours from that timecode, wrapping over 00:00:00:00 at some point along the timeline.

For example, given a 24 hour limit:

- A timeline start of 00:00:00:00 @ 24fps:

  24 hours elapses from 00:00:00:00 → 23:59:59:23

- A timeline start of 20:00:00:00 @ 24fps:

  24 hours elapses from 20:00:00:00 → 00:00:00:00 → 19:59:59:23

  This would mean for example, that 21:00:00:00 is < 00:00:00:00 since it is earlier in the wrapping timeline, and 18:00:00:00 is > 21:00:00:00 since it is later in the wrapping timeline.

Methods to sort and test sort order of ``Timecode`` collections are provided.

Note that passing `timelineStart` of `nil` or zero (00:00:00:00) is the same as using the standard  `<`, `==`, or  `>` operators as a sort comparator.

```swift
let timecode1: Timecode
let timecode2: Timecode
let start: Timecode
let result = timecode1.compare(to: timecode2, timelineStart: start)
// result is a ComparisonResult of orderedAscending, orderedSame, or orderedDescending
```
