# Display String

Working with timecode strings for GUI display or data output.

To get the timecode string from a ``Timecode`` instance using default formatting options:

```swift
try Timecode(.components(h: 01, m: 00, s: 00, f: 05), at: .fps29_97d)
    .stringValue() // == "01:00:00;00"
```

## Formatting Options

Additionally, formatting options may be provided. These options may by combined.

### Always Show Days

By default, days are not expressed in the string value unless the days value is non-zero. It can be enabled by passing the ``Timecode/StringFormatOption/alwaysShowDays`` option.

```swift
try Timecode(.components(h: 01, m: 00, s: 00, f: 00), at: .fps24)
    .stringValue(format: [.alwaysShowDays]) // == "0 01:00:00:00"
```

### Show Subframes

By default, subframes are not expressed in the string value. It can be enabled by passing the ``Timecode/StringFormatOption/showSubFrames`` option.

```swift
try Timecode(.components(h: 01, m: 00, s: 00, f: 00, sf: 05), at: .fps29_97d)
    .stringValue(format: [.showSubFrames]) // == "01:00:00;00.05"
```

### Filename Compatible

The string value can be formatted to be filename-friendly by passing the ``Timecode/StringFormatOption/filenameCompatible`` option.

```swift
try Timecode(.components(h: 01, m: 05, s: 20, f: 10, sf: 08), at: .fps29_97d)
    .stringValue(format: [.filenameCompatible]) // == "01-05-20-10.08"
```

## Topics

- ``Timecode/stringValue(format:)``
- ``Timecode/stringValueVerbose``

### String Format Options

- ``Timecode/StringFormat``
