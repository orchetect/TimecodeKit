# Display String

Working with timecode strings for GUI display or data output.

To get the timecode string from a ``Timecode`` instance using default formatting options:

```swift
try Timecode(.components(h: 01, m: 00, s: 00, f: 05), at: ._29_97_drop)
    .stringValue() // == "01:00:00;00"
```

## Formatting Options

Additionally, formatting options may be provided. These options may by combined.

### Show Subframes

By default, subframes are not expressed in the string value. They can be enabled by passing the ``Timecode/StringFormatParameter/showSubFrames`` option.

```swift
try Timecode(.components(h: 01, m: 00, s: 00, f: 05), at: ._29_97_drop)
    .stringValue(format: [.showSubFrames]) // == "01:00:00;00.05"
```

### Filename Compatible

The string value can be formatted to be filename-friendly by passing the ``Timecode/StringFormatParameter/filenameCompatible`` option.

```swift
try Timecode(.components(h: 01, m: 05, s: 20, f: 10), at: ._29_97_drop)
    .stringValue(format: [.filenameCompatible]) // == "01-05-20-10"
```

## Topics

- ``Timecode/stringValue(format:)``
- ``Timecode/stringValueValidated(format:invalidAttributes:defaultAttributes:)``
