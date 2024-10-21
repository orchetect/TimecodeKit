![TimecodeKit](Images/timecodekit-banner.png)

# TimecodeKit

[![CI Build Status](https://github.com/orchetect/TimecodeKit/actions/workflows/build.yml/badge.svg)](https://github.com/orchetect/TimecodeKit/actions/workflows/build.yml) [![Platforms - macOS 10.13 | iOS 12 | tvOS 12 | watchOS 4 | visionOS 1](https://img.shields.io/badge/Platforms-macOS%2010.13%20|%20iOS%2012%20|%20tvOS%2012%20|%20watchOS%204%20|%20visionOS%201-lightgrey.svg?style=flat)](https://developer.apple.com/swift) ![Swift 5.9-6](https://img.shields.io/badge/Swift-5.9–6-orange.svg?style=flat) [![Xcode 16](https://img.shields.io/badge/Xcode-16-blue.svg?style=flat)](https://developer.apple.com/swift) [![License: MIT](http://img.shields.io/badge/License-MIT-lightgrey.svg?style=flat)](https://github.com/orchetect/TimecodeKit/blob/main/LICENSE)

The most robust, precise and complete Swift library for working with SMPTE/EBU timecode. Supports 22 industry timecode frame rates, with a suite of conversions, calculations and integrations with Apple AV frameworks.

Timecode is a broadcast and post-production standard for addressing video frames. It is used for video burn-in timecode (BITC), and display in a DAW (Digital Audio Workstation) or video playback/editing applications.

## Supported Timecode Frame Rates

The following timecode rates and formats are supported.

| Film / ATSC / HD | PAL / SECAM / DVB / ATSC | NTSC / ATSC / PAL-M | NTSC Non-Standard | ATSC |
| ---------------- | ------------------------ | ------------------- | ----------------- | ---- |
| 23.976           | 25                       | 29.97               | 30 DF             | 30   |
| 24               | 50                       | 29.97 DF            | 60 DF             | 60   |
| 24.98            | 100                      | 59.94               | 120 DF            | 120  |
| 47.952           |                          | 59.94 DF            |                   |      |
| 48               |                          | 119.88              |                   |      |
| 95.904           |                          | 119.88 DF           |                   |      |
| 96               |                          |                     |                   |      |

## Supported Video Frame Rates

The following video frame rates are supported. (Video rates)

| Film / HD | PAL       | NTSC            |
| --------- | --------- | --------------- |
| 23.98p    | 25p / 25i | 29.97p / 29.97i |
| 24p       | 50p / 50i | 30p             |
| 47.95p    | 100p      | 59.94p / 59.94i |
| 48p       |           | 60p / 60i       |
| 95.9p     |           | 119.88p         |
| 96p       |           | 120p            |

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

1. Add TimecodeKit as a dependency using Swift Package Manager.
   - In an app project or framework, in Xcode:
     Add the package to your target using this URL: `https://github.com/orchetect/TimecodeKit`
   - In a Swift Package, add it to the Package.swift dependencies:
     ```swift
     .package(url: "https://github.com/orchetect/TimecodeKit", from: "2.3.1")
     ```
2. Import the library:
   ```swift
   import TimecodeKit
   ```

## Documentation

See the [online documentation](https://orchetect.github.io/TimecodeKit) for library usage, getting started info, and 1.x → 2.x migration guide.

Also check out the [Examples](Examples) folder for sample code to see TimecodeKit in action.

## References

- Wikipedia: [SMPTE Timecode](https://en.wikipedia.org/wiki/SMPTE_timecode)

## Author

Coded by a bunch of 🐹 hamsters in a trenchcoat that calls itself [@orchetect](https://github.com/orchetect).

## License

Licensed under the MIT license. See [LICENSE](https://github.com/orchetect/TimecodeKit/blob/master/LICENSE) for details.

## Sponsoring

If you enjoy using TimecodeKit and want to contribute to open-source financially, GitHub sponsorship is much appreciated. Feedback and code contributions are also welcome.

## Community & Support

Please do not email maintainers for technical support. Several options are available for questions and feature ideas:

- Questions and feature ideas can be posted to [Discussions](https://github.com/orchetect/TimecodeKit/discussions).
- If an issue is a verifiable bug with reproducible steps it may be posted in [Issues](https://github.com/orchetect/TimecodeKit/issues).

## Contributions

Contributions are welcome. Feel free to post in Discussions first before submitting a PR.
