# Encoding

Encoding and Decoding timecode for the pasteboard and drag events.

TimecodeKit includes support for encoding and decoding ``Timecode`` instances and timecode strings when:

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
    @State var timecodes: [Timecode]
    @State var selection: Timecode
    
    var body: some View {
        List(selection: $selection) {
            ForEach(timecodes) { item in
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
        // originally created using Timecode's itemProviders() method, then
        // these properties will be ignored, as the pasteboard will contain lossless
        // data with which to decode to the new Timecode instance.
        let properties = Timecode.Properties(rate: .fps24)
        let timecode = try await Timecode(
            from: itemProviders,
            propertiesForString: properties
        )
        
        // Timecode's default Identifiable implementation uses self
        // which means we cannot have two identical timecodes in a SwiftUI array
        if !timecodes.contains(timecode) { timecodes.append(timecode) }
    }
}
```

## Transferable

``Timecode`` conforms to the [`Transferable`](https://developer.apple.com/documentation/coretransferable/transferable) protocol which allows instances to be dragged & dropped or copied to/from the clipboard using declarative SwiftUI syntax.

The following example demonstrates a timecode list that supports copy and paste as well as drag and drop in order to copy items to another paste destination (such as a second instance of this view).

```swift
struct TimecodeListView: View {
    @State var timecodes: [Timecode]
    @State var selection: Timecode
    
    var body: some View {
        List(selection: $selection) {
            ForEach(timecodes) { item in
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
        // Timecode's default Identifiable implementation uses self
        // which means we cannot have two identical timecodes in a SwiftUI array
        items.forEach {
            if !timecodes.contains($0) { timecodes.append($0) }
        }
    }
}
```

> Important:
>
> If SwiftUI methods using the [`Transferable`](https://developer.apple.com/documentation/coretransferable/transferable) protocol are invoked without exporting this UT Type, this error will be thrown:
> 
> `Type "com.orchetect.TimecodeKit.timecode" was expected to be declared and exported in the Info.plist of MyApp.app, but it was not found.`
> 
> See UT Types section above for information on how to export this type in your app. 

## Topics

### NSItemProvider

- ``Timecode/init(from:propertiesForString:)-34ph6``
- ``Timecode/init(from:propertiesForString:)-7fhcr``
- ``Timecode/itemProviders(stringFormat:)``

### Transferable

- ``Timecode/transferRepresentation``

### UT Types

- ``UniformTypeIdentifiers/UTType/timecode``
- ``Timecode/textUTType``
- ``Timecode/copyUTTypes``
- ``Timecode/pasteUTTypes``
