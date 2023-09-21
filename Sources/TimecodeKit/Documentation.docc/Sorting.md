# Sorting

Sorting collections of ``Timecode``.

## Standard Sorting

Collections of `Timecode` can be sorted ascending or descending.

```swift
let timeline: [Timecode] = [ ... ]
let sorted = timeline.sorted() // ascending
let sorted = timeline.sorted(ascending: false) // descending
```

These collections can also be tested for sort order:

```swift
let timeline: [Timecode] = [ ... ]
let isSorted: Bool = timeline.isSorted() // ascending
let isSorted: Bool = timeline.isSorted(ascending: false) // descending
```

On newer systems, a `SortComparator` called ``TimecodeSortComparator`` is available as well.

```swift
let comparator = TimecodeSortComparator() // ascending
let comparator = TimecodeSortComparator(order: .reverse) // descending

let timeline: [Timecode] = [ ... ]
let sorted = timeline.sorted(using: comparator)
```

## Sorting using Timeline Context

For an explanation of timeline context, see <doc:Comparison#Comparing-using-Timeline-Context>.

Collections of ``Timecode`` can be sorted ascending or descending.

```swift
let timeline: [Timecode] = [ ... ]
let start = try "01:00:00:00".timecode(at: ._24)
let sorted = timeline.sorted(timelineStart: start) // ascending
let sorted = timeline.sorted(order: .reverse, timelineStart: start) // descending
```

These collections can also be tested for sort order:

```swift
let timeline: [Timecode] = [ ... ]
let start = try "01:00:00:00".timecode(at: ._24)
let isSorted: Bool = timeline.isSorted(timelineStart: start) // ascending
let isSorted: Bool = timeline.isSorted(order: .reverse, timelineStart: start) // descending
```

On newer systems, a `SortComparator` called ``TimecodeSortComparator`` is available as well.

```swift
let start = try "01:00:00:00".timecode(at: ._24)
let comparator = TimecodeSortComparator(timelineStart: start) // ascending
let comparator = TimecodeSortComparator(order: .reverse, timelineStart: start) // descending

let timeline: [Timecode] = [ ... ]
let sorted = timeline.sorted(using: comparator)
```
