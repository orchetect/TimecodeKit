# Display String

Working with timecode strings for GUI display or data output.

To get the timecode string from a ``Timecode`` instance using default formatting options:

```swift
try Timecode(.components(h: 01, m: 00, s: 00, f: 05), at: ._29_97_drop)
    .stringValue() // == "01:00:00;00"
```

Additionally, formatting options may be provided.

```swift
try Timecode(.components(h: 01, m: 00, s: 00, f: 05), at: ._29_97_drop)
    .stringValue(format: [.showSubFrames]) // == "01:00:00;00.05"
```
