# ``TimecodeKitCore``

Value types and related logic for representing and working with SMPTE/EBU timecode.

![TimecodeKit](timecodekit-banner.png)

- A variety of initializers and methods are available for string and numeric representation, validation, and conversion
- Mathematical operators are available between two instances: `+`, `-`, `*`, `\`
- Comparison operators are available between two instances: `==`, `!=`, `<`, `>`
- `Range` and `Stride` can be formed between two instances
- Many more features are detailed in the documentation

## Topics

### Timecode

- ``Timecode``
- ``Timecode/Properties-swift.struct``
- ``Timecode/Components-swift.struct``
- <doc:Timecode-String>
- <doc:Timecode-Comparison-and-Sort>
- <doc:Timecode-Range-and-Strideable>
- <doc:Timecode-Validation>

### Frame Rate

- ``TimecodeFrameRate``
- ``VideoFrameRate``

### Math & Conversions

- <doc:Math>
- <doc:Timecode-Conversions>
- <doc:Rational-Numbers-and-CMTime>
- <doc:Timecode-Interval>
- <doc:Timecode-Transformer>

### Encoding

- <doc:Timecode-Encoding>

### Additional Value Types

- ``FeetAndFrames``
