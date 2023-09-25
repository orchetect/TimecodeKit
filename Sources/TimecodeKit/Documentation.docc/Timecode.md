# ``TimecodeKit/Timecode``

## Topics

### Constructors

- <doc:Timecode-Constructors>

### Components

- ``Components-swift.struct``
- ``components-swift.property``
- ``days``
- ``hours``
- ``minutes``
- ``seconds``
- ``frames``
- ``subFrames``

### Properties

- ``Properties-swift.struct``
- ``properties-swift.property``

### Frame Rate

- ``frameRate``

### Subframes Base

- ``SubFramesBase-swift.enum``
- ``subFramesBase-swift.property``

### Upper Limit

- ``UpperLimit-swift.enum``
- ``upperLimit-swift.property``

### Frame Count

- ``FrameCount-swift.struct``
- ``frameCount-swift.property``
- ``maxFrameCountExpressible``
- ``maxSubFramesExpressible``
- ``maxSubFrameCountExpressible``

### Timecode String

- ``StringFormat``
- ``StringFormatParameter``
- ``stringValue(format:)``
- ``stringValueValidated(format:invalidAttributes:defaultAttributes:)``

### Conversion

- ``converted(to:preservingValues:)``
- ``cmTimeValue``
- ``feetAndFramesValue``
- ``rationalValue``
- ``realTimeValue``
- ``samplesValue(sampleRate:)``
- ``samplesDoubleValue(sampleRate:)``

### Setting Timecode

- <doc:Timecode-Set>

### Math

- <doc:Timecode-Math>
- ``isZero``

### Rounding

- ``clampComponents()``
- ``roundUp(toNearest:)``
- ``roundedUp(toNearest:)``
- ``roundDown(toNearest:)``
- ``roundedDown(toNearest:)``

### Comparison

- ``compare(to:timelineStart:)``

### Intervals

- ``asInterval(_:)``
- ``interval(to:)``
- ``offset(by:)``
- ``offsetting(by:)``

### Validation

- ``ValidationRule``
- ``ValidationError``
- ``invalidComponents``
- ``stringValueValidated(format:invalidAttributes:defaultAttributes:)``
- ``Component``
- ``validRange(of:)``

### Transformer

- ``transform(using:)``
- ``transformed(using:)``

### Formatter

- ``TextFormatter``

### Errors

- ``StringParseError``
- ``MediaParseError``
- ``MediaWriteError``

### Internals

- <doc:Timecode-Internals>
