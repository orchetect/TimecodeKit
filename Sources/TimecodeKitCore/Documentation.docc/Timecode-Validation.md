# Validation

Timecode validation based on frame rate and upper limit.

## Timecode Component Validation

Timecode validation can be helpful and powerful, for example, when parsing timecode strings read from an external data file or received as user-input in a text field.

Timecode can be tested as:

- valid or invalid as a whole, by catching a throwing error when using the default throwing initializers or `set()` methods, or
- granularly to test validity of individual timecode components

```swift
// example:
// 1 hour and 20 minutes ARE valid at 23.976 fps,
// but 75 seconds and 60 frames are NOT valid

// non-granular validation
try Timecode(.components(h: 1, m: 20, s: 75, f: 60), at: .fps23_976)
    // == throws error; cannot form a valid timecode

// granular validation
// `allowingInvalid` allows invalid values; does not throw errors so 'try' is not needed
let timecode = Timecode(
    .components(h: 1, m: 20, s: 75, f: 60), 
    at: .fps23_976,
    by: .allowingInvalid
)

timecode.isValid // == false
timecode.invalidComponents // == [.seconds, .frames]
```

## Formatted NSAttributedString

When importing `TimecodeKitUI`, this method can produce an `NSAttributedString` highlighting individual invalid timecode components with a specified set of attributes.

```swift
let timecode = Timecode(
    .components(h: 1, m: 20, s: 75, f: 60), 
    at: .fps23_976,
    by: .allowingInvalid
)
let attrString = timecode.nsAttributedString(
    invalidAttributes: [.foregroundColor: NSColor.red]
)
```

You can also supply a set of default attributes to set as the baseline attributes for the entire string.

```swift
// set text's background color to red instead of its foreground color
let invalidAttr: [NSAttributedString.Key: Any] = [
    .backgroundColor: NSColor.red
]

// set custom font and font size for the entire string
let defaultAttr: [NSAttributedString.Key: Any] = [
    .font: NSFont.systemFont(ofSize: 16)
]

let timecode = Timecode(
    .components(h: 1, m: 20, s: 75, f: 60),
    at: .fps23_976,
    by: .allowingInvalid
)
let attrString = timecode.nsAttributedString(
    invalidAttributes: invalidAttr,
    defaultAttributes: defaultAttr
)
```

## NSFormatter

When importing `TimecodeKitUI`, a special string `Formatter` (`NSFormatter`) subclass can format timecode entry and colorize invalid components.

- process user-entered timecode strings and format them in realtime in a TextField
- optionally highlight individual invalid timecode components with a specified set of attributes (defaults to red foreground color)

```swift
// set up formatter
let properties = Timecode.Properties(
    rate: .fps23_976,
    base: .max80SubFrames,
    limit: .max24Hours
)
let formatter = Timecode.TextFormatter(
    using: properties
    stringFormat: [.showSubFrames],
    showsValidation: true, // enable invalid component highlighting
    invalidAttributes: [.backgroundColor: NSColor.red]
)

// assign formatter to a TextField UI object, for example
let textField = NSTextField()
textField.formatter = formatter
```

## Formatted SwiftUI Text

When importing `TimecodeKitUI`, a SwiftUI view is available which highlights individual invalid timecode components with a specified set of modifiers.

Timecode-specific view modifiers can optionally configure colorization of invalid timecode components.

```swift
@TimecodeState var timecode = Timecode(
    .components(h: 1, m: 20, s: 75, f: 60),
    at: .fps23_976,
    by: .allowingInvalid
)

var body: some View {
    TimecodeText(timecode)
        .timecodeValidationStyle(.red)
}
```

## Topics

### Timecode Properties

- ``Timecode/isValid``
- ``Timecode/invalidComponents``

### Timecode.Components Methods

- ``Timecode/Components-swift.struct/invalidComponents(at:base:limit:)``
- ``Timecode/Components-swift.struct/invalidComponents(using:)``
