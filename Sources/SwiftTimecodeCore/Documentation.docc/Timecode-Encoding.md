# Encoding

Encoding and Decoding timecode for the pasteboard and drag events.

This library includes support for encoding and decoding ``Timecode`` instances and timecode strings when:

- copying to the pasteboard / pasting from the pasteboard
- drag & drop operations

## UT Types

To support exchange of ``Timecode`` instances, your app needs to export its UT Type.

1. In the app project, select your app's target and switch to the Info tab
2. Open the **Exported Type Identifiers** section
3. Add a new entry by clicking the `+` button
4. Enter the following data in the corresponding fields:
   | Field | Content |
   | --- | --- |
   | Description | `Timecode` |
   | Identifier | `com.orchetect.TimecodeKit.timecode` |

![Exported Types](app-target-exported-types.png)

## NSItemProvider

``Timecode`` supports encoding and decoding timecode using one or more [`NSItemProvider`](https://developer.apple.com/documentation/foundation/nsitemprovider) instances.

In AppKit, UIKit and SwiftUI, [`NSItemProvider`](https://developer.apple.com/documentation/foundation/nsitemprovider) is used commonly to exchange content with the pasteboard.

When using the associated methods, timecode will generate two item providers:
- A plain-text timecode string
- A lossless JSON-encoded representation

This means that the end-user is able to:
- paste or drag as a timecode string to any 3rd-party application that can receive plain-text
- paste or drag to paste destinations within your app that accept the ``UniformTypeIdentifiers/UTType/timecode`` UT Type

```swift
struct TimecodeListView: View {
    @State var model: [Timecode]
    @State var selection: Timecode
    
    var body: some View {
        List(selection: $selection) {
            ForEach(model) { item in
                Text(item.stringValue()).tag(item)
            }
        }
        .onCopyCommand {
            selection.itemProviders()
        }
        .onPasteCommand(of: [.timecode]) { itemProviders in
            Task {
                try await add(itemFrom: itemProviders)
            }
        }
    }
    
    func add(itemFrom itemProviders: [NSItemProvider]) async throws {
        // Provide default properties in case only a timecode string is present,
        // which could be the case if the user copies a plain-text timecode string
        // from another application. If the timecode data on the pasteboard was
        // originally created using Timecode's `itemProviders()` method or its
        // `Transferable` representation, then these properties will be ignored,
        // as the pasteboard will contain lossless data with which to decode to
        // the new Timecode instance.
        let properties = model.last?.properties
            ?? Timecode.Properties(rate: .fps24)
        let timecode = try await Timecode(
            from: itemProviders,
            propertiesForString: properties
        )

        // Here is where you can validate pasted timecode before accepting it.
        // See the `validate()` method inline help or Encoding section in the
        // documentation for details. 
        let validatedTimecode = TimecodeField.validate(pastedTimecode: timecode, ... )

        // Finally, accept the pasted timecode
        // Timecode's default `Identifiable` implementation uses self
        // which means we cannot have two identical timecodes in a SwiftUI array
        if !model.contains(validatedTimecode) {
            model.append(validatedTimecode) 
        }
    }
}
```

See the <doc:#Pasted-Timecode-Validation-Against-Local-Context> section on how to validate pasted timecode.

> Important:
>
> If SwiftUI view modifiers using `NSItemProviders` are invoked without exporting `Timecode`'s UT Type, this error will be thrown:
> 
> `Type "com.orchetect.TimecodeKit.timecode" was expected to be declared and exported in the Info.plist of MyApp.app, but it was not found.`
> 
> See the <doc:#UT-Types> section for information on how to export this type in your app.

## Transferable

``Timecode`` conforms to the [`Transferable`](https://developer.apple.com/documentation/coretransferable/transferable) protocol which allows instances to be dragged & dropped or copied to/from the clipboard using declarative SwiftUI syntax.

The following example demonstrates a timecode list that supports copy and paste as well as drag and drop in order to copy items to another paste destination (such as a second instance of this view).

```swift
struct TimecodeListView: View {
    @State var model: [Timecode]
    @State var selection: Timecode
    
    var body: some View {
        List(selection: $selection) {
            ForEach(model) { item in
                Text(item.stringValue()).tag(item)
            }
            .dropDestination(for: Timecode.self) { items, location in
                add(items: items)
                return true
            }
        }
        .copyable([selection])
        .pasteDestination(for: Timecode.self) { items in
            add(items: items)
        }
    }
    
    func add(items: [Timecode]) {
        for item in items {
            // Here is where you can validate pasted timecode before accepting it.
            // See the `validate()` method inline help or Encoding section in the 
            // documentation for details. 
            let validatedTimecode = TimecodeField.validate(pastedTimecode: item, ... )

            // Timecode's default `Identifiable` implementation uses self
            // which means we cannot have two identical timecodes in a SwiftUI array
            if !model.contains(validatedTimecode) { model.append(validatedTimecode) }
        }
    }
}
```

See the <doc:#Pasted-Timecode-Validation-Against-Local-Context> section on how to validate pasted timecode.

> Important:
>
> If SwiftUI view modifiers using the [`Transferable`](https://developer.apple.com/documentation/coretransferable/transferable) protocol are invoked without exporting `Timecode`'s UT Type, this error will be thrown:
> 
> `Type "com.orchetect.TimecodeKit.timecode" was expected to be declared and exported in the Info.plist of MyApp.app, but it was not found.`
> 
> See the <doc:#UT-Types> section for information on how to export this type in your app. 

## Pasted Timecode Validation Against Local Context

When accepting timecode pasted from the clipboard, it is common to validate it against a local context.

For example, you may want to constrain pasted timecode to a certain frame rate, subframes base and upper limit.

The `SwiftTimecodeUI` target offers static API to perform this validation by supplying policies to validate against.

```swift
@TimecodeState private var timecode: Timecode

// pass in the `Timecode` instance received from the pasteboard
// from the `pasteDestination()` or `onPasteCommand()` view modifiers:
func validate(pastedTimecode: Timecode) {
    guard let newTimecode = TimecodeField.validate(
        pastedTimecode: pastedTimecode,
        localTimecodeProperties: timecode.properties,
        pastePolicy: .preserveLocalProperties,
        validationPolicy: .enforceValid
    ) else { return }

    timecode = newTimecode
}
```

> Note:
>
> This method is offered on `TimecodeField` since it is the same API the field uses internally when handling its own paste events.
> 
> Because `TimecodeField` implements copy and paste functionality under the hood, calling the `validate` method is unnecessary as it is already being called internally on user paste events.
>
> Instead, use the corresponding view modifiers to specify the policies on your `TimecodeField` instance:
>
> - `timecodeFieldPastePolicy(_:)`
> - `timecodeFieldValidationPolicy(_:)`
> - `timecodeFieldInputStyle(_:)`
> 
> See `TimecodeField` documentation in the `SwiftTimecodeUI` module for more information, or try out the **Timecode UI** example project located in the **Examples** folder within this repo.

## Topics

### NSItemProvider

- ``Timecode/init(from:propertiesForString:)-7hl9l``
- ``Timecode/init(from:propertiesForString:)-1cqhu``
- ``Timecode/itemProviders(stringFormat:)``

### Transferable

- ``Timecode/transferRepresentation``

### UT Types

- ``UniformTypeIdentifiers/UTType/timecode``
- ``Timecode/textUTType``
- ``Timecode/copyUTTypes``
- ``Timecode/pasteUTTypes``
