# ``SwiftTimecodeUI``

UI controls and tools for formatting and displaying timecode, including user-editable timecode fields.

![swift-timecode](swifttimecode-banner.png)

## Topics

### AppKit

- ``SwiftTimecodeCore/Timecode/TextField``
- ``SwiftTimecodeCore/Timecode/TextFieldCell``

### SwiftUI

- ``TimecodeField``
- ``TimecodeText``

### SwiftUI View Modifiers

- ``SwiftUICore/View/timecodeFormat(_:)``
- ``SwiftUICore/View/timecodeFieldHighlightStyle(_:)-(S)``
- ``SwiftUICore/View/timecodeFieldHighlightStyle(_:)-(S?)``
- ``SwiftUICore/View/timecodeFieldInputStyle(_:)``
- ``SwiftUICore/View/timecodeFieldInputWrapping(_:)``
- ``SwiftUICore/View/timecodeFieldEscapeAction(_:)``
- ``SwiftUICore/View/timecodeFieldReturnAction(_:)``
- ``SwiftUICore/View/timecodeFieldValidationPolicy(_:)``
- ``SwiftUICore/View/timecodeFieldInputRejectionFeedback(_:)``
- ``SwiftUICore/View/timecodeSeparatorStyle(_:)-(S)``
- ``SwiftUICore/View/timecodeSeparatorStyle(_:)-(S?)``
- ``SwiftUICore/View/timecodeSubFramesStyle(_:)-(S)``
- ``SwiftUICore/View/timecodeSubFramesStyle(_:)-(S?)``
- ``SwiftUICore/View/timecodeSubFramesStyle(scale:)``
- ``SwiftUICore/View/timecodeSubFramesStyle(_:scale:)-(S,_)``
- ``SwiftUICore/View/timecodeSubFramesStyle(_:scale:)-(S?,_)``
- ``SwiftUICore/View/timecodeValidationStyle(_:)-(S)``
- ``SwiftUICore/View/timecodeValidationStyle(_:)-(S?)``

### SwiftUI State

- ``TimecodeState``
- ``SwiftUICore/Binding/option(_:)``

### AttributedString

- ``Foundation/AttributedString/init(_:format:separatorStyle:subFramesStyle:validationStyle:)``

### NSAttributedString

- ``Foundation/NSAttributedString/init(_:format:defaultAttributes:separatorAttributes:subFramesAttributes:invalidAttributes:)``
- ``SwiftTimecodeCore/Timecode/nsAttributedString(format:defaultAttributes:separatorAttributes:subFramesAttributes:invalidAttributes:)``

### Formatter

- ``SwiftTimecodeCore/Timecode/TextFormatter``
