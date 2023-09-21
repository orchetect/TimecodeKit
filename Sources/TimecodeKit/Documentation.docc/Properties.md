# Properties

Defining and using timecode properties.

## Individual Timecode Components

Timecode components can be get or set directly as instance properties.

```swift
let tc = try "01:12:20:05".timecode(at: ._23_976)

// get
tc.days          // == 0
tc.hours         // == 1
tc.minutes       // == 12
tc.seconds       // == 20
tc.frames        // == 5
tc.subFrames     // == 0

// set
tc.hours = 5
tc.stringValue() // == "05:12:20:05"
```

## Components Struct

A compact components struct can be used to initialize ``Timecode`` and can also be accessed using ``Timecode/components-swift.property``.

See <doc:Components>.
