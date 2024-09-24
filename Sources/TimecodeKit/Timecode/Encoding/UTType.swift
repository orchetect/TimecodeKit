//
//  UTType.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

#if canImport(UniformTypeIdentifiers)

import UniformTypeIdentifiers

@available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
extension UTType {
    /// UT Type defined in TimecodeKit to globally identify ``Timecode`` instances.
    public static let timecode = UTType(exportedAs: "com.orchetect.TimecodeKit.timecode")
}

@available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
extension Timecode {
    /// The UT Type used to encode ``Timecode`` as plain text.
    public static let textUTType: UTType = .utf8PlainText
    
    /// All supported UT Types for copying to the pasteboard or dragging an item.
    public static let copyUTTypes: [UTType] = [textUTType, .timecode]
    
    /// All supported UT Types for pasting from the pasteboard or dropping a dragged item.
    public static let pasteUTTypes: [UTType] = [textUTType, .timecode]
}

#endif
