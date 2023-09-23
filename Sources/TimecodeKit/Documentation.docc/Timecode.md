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
- ``frameRate``
- ``subFramesBase-swift.property``
- ``upperLimit-swift.property``

### Frame Count

- ``FrameCount-swift.struct``
- ``frameCount-swift.property``
- ``maxFrameCountExpressible``
- ``maxSubFramesExpressible``
- ``maxSubFrameCountExpressible``

### Timecode String

- ``stringValue(format:)``
- ``stringValueValidated(format:invalidAttributes:defaultAttributes:)``
- ``StringFormat``

### Conversion

- ``converted(to:preservingValues:)``
- ``cmTime``
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
- ``validRange(of:)``

### Transformer

- ``transform(using:)``
- ``transformed(using:)``

### Formatter

- ``TextFormatter``

### Internals

- <doc:Timecode-Internals>
