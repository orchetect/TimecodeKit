# ``TimecodeKitUI``

UI controls and tools for formatting and displaying timecode, including user-editable timecode fields.

![TimecodeKit](timecodekit-banner.png)

## Topics

### AppKit

- ``TimecodeKitCore/Timecode/TextField``
- ``TimecodeKitCore/Timecode/TextFieldCell``

### SwiftUI

- ``TimecodeField``
- ``TimecodeText``

### SwiftUI View Modifiers

- ``SwiftUICore/View/timecodeFormat(_:)``
- ``SwiftUICore/View/timecodeFieldHighlightStyle(_:)``
- ``SwiftUICore/View/timecodeFieldInputStyle(_:)``
- ``SwiftUICore/View/timecodeFieldInputWrapping(_:)``
- ``SwiftUICore/View/timecodeFieldReturnAction(_:)``
- ``SwiftUICore/View/timecodeFieldEscapeAction(_:)``
- ``SwiftUICore/View/timecodeFieldValidationPolicy(_:animation:)``
- ``SwiftUICore/View/timecodeSeparatorStyle(_:)``
- ``SwiftUICore/View/timecodeSubFramesStyle(_:scale:)``
- ``SwiftUICore/View/timecodeValidationStyle(_:)``

### SwiftUI State

- ``TimecodeState``
- ``SwiftUICore/Binding/option(_:)``

### AttributedString

- ``Foundation/AttributedString/init(_:format:separatorStyle:validationStyle:)``
- ``TimecodeKitCore/Timecode/stringValueValidatedText(format:invalidModifiers:defaultModifiers:)``

### Formatter

- ``TimecodeKitCore/Timecode/TextFormatter``
