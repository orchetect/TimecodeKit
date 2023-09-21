# Components

Defining and using timecode components.

In order to help facilitate defining a set of timecode component values, a simple ``Timecode/Components`` struct is implemented. This struct can be passed into many methods and initializers.

```swift
let tcc = Timecode.Components(h: 1)
Timecode(.components(tcc), at: ._23_976)

// is the same as using the shorthand:
Timecode(.components(h: 1), at: ._23_976)
```

```swift
let cmp = try "01:12:20:05"
    .timecode(at: ._23_976)
    .components // Timecode.Components

cmp.days      // == 0
cmp.hours     // == 1
cmp.minutes   // == 12
cmp.seconds   // == 20
cmp.frames    // == 5
cmp.subFrames // == 0
```
