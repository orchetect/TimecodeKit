![swift-timecode](Images/swifttimecode-banner.png)

# swift-timecode

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Forchetect%2Fswift-timecode%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/orchetect/swift-timecode) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Forchetect%2Fswift-timecode%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/orchetect/swift-timecode) [![Xcode 16](https://img.shields.io/badge/Xcode-16-blue.svg?style=flat)](https://developer.apple.com/swift) [![License: MIT](http://img.shields.io/badge/License-MIT-lightgrey.svg?style=flat)](https://github.com/orchetect/swift-timecode/blob/main/LICENSE)

The most robust, precise and complete Swift library for working with SMPTE/EBU timecode. Supports 23 industry-standard timecode frame rates with a suite of conversions, calculations and integrations with Apple AV frameworks.

Timecode is a broadcast and post-production standard for addressing video frames. It is often used for video burn-in timecode (BITC), and display in a DAW (Digital Audio Workstation) or video playback/editing applications.

## Supported Timecode Frame Rates

The following timecode rates and formats are supported.

| Film / ATSC / HD | PAL / SECAM / DVB / ATSC | NTSC / ATSC / PAL-M | NTSC Non-Standard | ATSC / HD |
| ---------------- | ------------------------ | ------------------- | ----------------- | --------- |
| 23.976           | 25                       | 29.97               | 30 DF             | 30        |
| 24               | 50                       | 29.97 DF            | 60 DF             | 60        |
| 24.98            | 100                      | 59.94               | 120 DF            | 90        |
| 47.952           |                          | 59.94 DF            |                   | 120       |
| 48               |                          | 119.88              |                   |           |
| 95.904           |                          | 119.88 DF           |                   |           |
| 96               |                          |                     |                   |           |

## Supported Video Frame Rates

The following video frame rates are supported. (Video rates)

| Film / HD | PAL       | NTSC            |
| --------- | --------- | --------------- |
| 23.98p    | 25p / 25i | 29.97p / 29.97i |
| 24p       | 50p / 50i | 30p             |
| 47.95p    | 100p      | 59.94p / 59.94i |
| 48p       |           | 60p / 60i       |
| 95.9p     |           | 90p             |
| 96p       |           | 119.88p         |
|           |           | 120p            |

## Core Features

- Convert timecode between:
  - timecode display string
  - total elapsed frame count
  - real wall-clock time
  - elapsed audio samples at any audio sample rate
  - rational time notation (such as `CMTime` or Final Cut Pro XML and AAF encoding)
  - feet + frames
- Convert timecode and/or frame rate to a rational fraction, and vice-versa (including `CMTime`)
- Support for Days as a timecode component (some DAWs including Cubase support > 24 hour timecode)
- Support for Subframes
- Math operations: add, subtract, multiply, divide
- Granular timecode validation
- Form a `Range` or `Stride` between two timecode instances
- Conforms to `Codable`
- Formatters
  - A `Formatter` object that can format timecode
  - An `AttributedString` showing invalid timecode components using alternate attributes (such as red text color)
- SwiftUI Views
  - A timecode entry text field
  - A timecode string `Text` view emphasizing invalid timecode components using alternate attributes (such as red text color)
- `AVAsset` video file utilities to easily read/write timecode tracks and locate `AVPlayer` to timecode locations
- Exhaustive unit tests ensuring accuracy

## Installation

### Swift Package Manager (SPM)

To add this package to an Xcode app project, use:

 `https://github.com/orchetect/swift-timecode` as the URL.

To add this package to a Swift package, add the dependency to your package and target in Package.swift:

```swift
let package = Package(
    dependencies: [
        .package(url: "https://github.com/orchetect/swift-timecode", from: "3.0.0")
    ],
    targets: [
        .target(
            dependencies: [
                .product(name: "SwiftTimecode", package: "swift-timecode")
            ]
        )
    ]
)
```

Import the entire library to use all features (core, AV, UI):
```swift
import SwiftTimecode
```

Or import individual targets as-needed:

```swift
import SwiftTimecodeCore // core value types
import SwiftTimecodeAV // AVFoundation extensions
import SwiftTimecodeUI // UI components
```

## Documentation

See the [online documentation](https://orchetect.github.io/swift-timecode) for library usage and getting started info.

Also check out the [Examples](Examples) folder for sample code to see swift-timecode in action.

## References

- Wikipedia: [SMPTE Timecode](https://en.wikipedia.org/wiki/SMPTE_timecode)

## Author

Coded by a bunch of 🐹 hamsters in a trenchcoat that calls itself [@orchetect](https://github.com/orchetect).

## License

Licensed under the MIT license. See [LICENSE](https://github.com/orchetect/swift-timecode/blob/master/LICENSE) for details.

## Sponsoring

If you enjoy using swift-timecode and want to contribute to open-source financially, GitHub sponsorship is much appreciated. Feedback and code contributions are also welcome.

## Community & Support

Please do not email maintainers for technical support. Several options are available for issues and questions:

- Questions and feature ideas can be posted to [Discussions](https://github.com/orchetect/swift-timecode/discussions).
- If an issue is a verifiable bug with reproducible steps it may be posted in [Issues](https://github.com/orchetect/swift-timecode/issues).

## Contributions

Contributions are welcome. Posting in [Discussions](https://github.com/orchetect/swift-timecode/discussions) first prior to new submitting PRs for features or modifications is encouraged.

## Legacy

This repository was formerly known as TimecodeKit.
