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
// allowingInvalid allows invalid values; does not throw errors so 'try' is not needed
Timecode(.components(h: 1, m: 20, s: 75, f: 60), at: .fps23_976, by: .allowingInvalid)
    .invalidComponents // == [.seconds, .frames]
```

## Formatted NSAttributedString

This method can produce an `NSAttributedString` highlighting individual invalid timecode components with a specified set of attributes.

```swift
Timecode(.components(h: 1, m: 20, s: 75, f: 60), at: .fps23_976, by: .allowingInvalid)
    .stringValueValidated()
```

The invalid formatting attributes defaults to applying `[.foregroundColor: NSColor.red]` to invalid components. You can alternatively supply your own invalid attributes by setting the `invalidAttributes` argument.

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

Timecode(.components(h: 1, m: 20, s: 75, f: 60), at: .fps23_976, by: .allowingInvalid)
    .stringValueValidated(invalidAttributes: invalidAttr,
                          defaultAttributes: defaultAttr)
```

## NSFormatter

A special string `Formatter` (`NSFormatter`) subclass can

- process user-entered timecode strings and format them in realtime in a TextField
- optionally highlight individual invalid timecode components with a specified set of attributes (defaults to red foreground color)

The invalid formatting attributes defaults to applying `[.foregroundColor: NSColor.red]` to invalid components. You can alternatively supply your own invalid attributes by setting the `validationAttributes` property on the formatter.

```swift
// set up formatter
let formatter = Timecode.TextFormatter(
    using: .init(
        rate: .fps23_976,
        base: .max80SubFrames,
        limit: .max24Hours
    )
    stringFormat: [.showSubFrames],
    showsValidation: true,    // enable invalid component highlighting
    validationAttributes: nil // if nil, defaults to red foreground color
)

// assign formatter to a TextField UI object, for example
let textField = NSTextField()
textField.formatter = formatter
```

## Formatted SwiftUI Text

When importing `TimecodeKitUI`, a SwiftUI `Text` view is available which highlights individual invalid timecode components with a specified set of modifiers.

The invalid formatting attributes defaults to applying `.foregroundColor(Color.red)` to invalid components.

```swift
Timecode(.components(h: 1, m: 20, s: 75, f: 60), at: .fps23_976, by: .allowingInvalid)
    .stringValueValidatedText()
```

You can alternatively supply your own invalid modifiers by setting the `invalidModifiers` argument.

```swift
import TimecodeKitUI

Timecode(.components(h: 1, m: 20, s: 75, f: 60), at: .fps23_976, by: .allowingInvalid)
    .stringValueValidatedText(
        invalidModifiers: {
            $0.foregroundColor(.blue)
        }, defaultModifiers: {
            $0.foregroundColor(.black)
        }
    )
```

## Topics

### Invalid Components

- ``Timecode/invalidComponents``
- ``Timecode/invalidComponents(in:at:base:limit:)``
- ``Timecode/invalidComponents(in:using:)``

### Formatted Attributed String

- ``Timecode/stringValueValidated(format:invalidAttributes:defaultAttributes:)``

### Formatter

- ``Timecode/TextFormatter``
