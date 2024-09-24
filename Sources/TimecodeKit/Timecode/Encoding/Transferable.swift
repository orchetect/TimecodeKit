//
//  Transferable.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

#if canImport(UniformTypeIdentifiers) && canImport(CoreTransferable)

import Foundation
import CoreTransferable

@available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
extension Timecode: Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        // Encodes Timecode instance losslessly.
        DataRepresentation(contentType: .timecode) { instance in
            // convert Timecode to json then to Data
            let encoder = JSONEncoder()
            let data = try encoder.encode(instance)
            return data
        } importing: { data in
            // convert from Data to String, then deserialize using Timecode json decoder
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(Timecode.self, from: data)
            return decoded
        }
        
        // This works but we have to hard-code properties (frame rate, subframes base, upperlimit).
        // so the alternative solution is to manually use two NSItemProvider (Timecode and String)
        // when using .onCopyCommand {} and .onPasteCommand {}
        //
        // DataRepresentation(contentType: textUTType) { instance in
        //     guard let data = instance.stringValue(format: [.showSubFrames]).data(using: .utf8)
        //     else { throw CocoaError(.coderInvalidValue) }
        //     return data
        // } importing: { data in
        //     guard let string = String(data: data, encoding: .utf8) else {
        //         throw CocoaError(.serviceInvalidPasteboardData)
        //     }
        //     // Note: 30 fps is hard-coded here. not sure if there's another way to do this.
        //     let timecode = try Timecode(.string(string), at: .fps30, by: .allowingInvalid)
        //     return timecode
        // }
        
        // Can allow .draggable() SwiftUI modifier to drag as plain text.
        // This is lossy, of course, as some properties cannot be inferred from a timecode string
        // such frame rate, subframes base, or upperlimit.
        DataRepresentation(exportedContentType: textUTType) { instance in
            instance.stringValue(format: [.showSubFrames]).data(using: .utf8) ?? Data()
        }
    }
}

#endif
