# TimecodeKit

<p>
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/Swift%205.3-compatible-orange.svg?style=flat" alt="Swift 5.3 compatible" /></a>
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/SPM-compatible-orange.svg?style=flat" alt="Swift Package Manager (SPM) compatible" /></a>
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/platform-macOS%20|%20iOS%20|%20tvOS%20|%20watchOS-green.svg?style=flat" alt="Platform - macOS | iOS | tvOS | watchOS" /></a>
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/Linux-not%20tested-black.svg?style=flat" alt="Linux - not tested" /></a>
<a href="https://raw.githubusercontent.com/uraimo/Bitter/master/LICENSE"><img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License: MIT" /></a>
</p>

A robust multiplatform Swift library for working with SMPTE timecode supporting 20 industry frame rates, and including methods to convert to/from timecode strings and perform calculations.

## Supported Frame Rates

| NTSC      | PAL  | HD / Film | Other  |
| --------- | ---- | --------- | ------ |
| 29.97     | 25   | 23.976    | 30     |
| 29.97 DF  | 50   | 24        | 30 DF  |
| 59.94     | 100  | 24.98     | 60     |
| 59.94 DF  |      | 47.952    | 60 DF  |
| 119.88    |      | 48        | 120    |
| 119.88 DF |      |           | 120 DF |

## Core Features

- Convert timecode to string, or a timecode string to values
- Convert timecode to real wall-clock time, and vice-versa
- Convert timecode to # of samples at any audio sample-rate, and vice-versa
- Granular timecode validation
- A Formatter object that can format timecode and also provide an NSAttributedString showing invalid timecode components in an alternate color (such as red)
- Support for Days as a timecode component (which Cubase supports as part of its timecode format)
- Support for sub-frames
- Common math operations between timecodes: add, subtract, multiply, divide
- Exhaustive unit tests ensuring accuracy

## Development Status

### Incomplete Features (Still in Development)

- [ ] Complete sub-frame support

  - [ ] Test subFrameDivisor effect when set to -1, 0, 1, or 1000000
  - [ ] Needs to be added to String getters/setters
    - Add 100-120 fps 3-digit frames display support

- [ ] Add method to convert to another framerate by producing a new `Timecode` object. But make it clear that it's a LOSSY process. Suggested API:

  ```swift
  func convert(to: FrameRate, limit: UpperLimit) -> Timecode
  ```

### Maintenance

- [ ] Add code examples to README.md or wiki.

### Future Features Planned

- None at this time.

## Known Issues

- The Dev Tests are not meant to be run as routine unit tests, but are designed as a test harness to be used only when altering critical parts of the library to ensure stability of internal calculations.
- Unit Tests won't build/run for watchOS Simulator because XCTest does not work on watchOS
  - Workaround: Don't run unit tests for a watchOS target. Using macOS or iOS as a unit test target should be sufficient enough. If anyone runs into issues with the library on watchOS, feel free to contribute a solution or fix anything that requires fixing.
