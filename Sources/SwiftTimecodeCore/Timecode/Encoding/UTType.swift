//
//  UTType.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(UniformTypeIdentifiers)

import UniformTypeIdentifiers

@available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
extension UTType {
    /// UT Type defined in TimecodeKit to globally identify ``Timecode`` instances.
    public static let timecode = UTType(exportedAs: "com.orchetect.TimecodeKit.timecode", conformingTo: .data)
}

@available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
extension Timecode {
    /// The UT Type used to encode ``Timecode`` as plain text.
    public static let textUTType: UTType = .utf8PlainText
    
    /// All supported UT Types for copying to the pasteboard or dragging an item.
    public static let copyUTTypes: [UTType] = [.timecode, textUTType]
    
    // NOTE - Apple Docs says for `onPasteCommand()` view modifier:
    // Pass an array of uniform type identifiers to the supportedContentTypes parameter. Place the higher priority
    // types closer to the beginning of the array. The Clipboard items that the action closure receives have the
    // most preferred type out of all the types the source supports.
    
    /// All supported UT Types for pasting from the pasteboard or dropping a dragged item.
    public static let pasteUTTypes: [UTType] = [.timecode, textUTType] // array order matters!!!
}

#endif
