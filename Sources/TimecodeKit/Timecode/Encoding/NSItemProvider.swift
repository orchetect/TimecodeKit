//
//  NSItemProvider.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

#if canImport(UniformTypeIdentifiers) && canImport(CoreTransferable)
import UniformTypeIdentifiers
import CoreTransferable

#if os(macOS)
import AppKit
#else
import UIKit
#endif

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension Timecode {
    /// Decode the content of an `NSItemProvider` as a new ``Timecode`` instance.
    /// 
    /// If the item provider does not contain data that can be decoded, an error will be thrown.
    ///
    /// > Note:
    /// >
    /// > An item provider is used when conveying data or a file between processes during drag-and-drop
    /// > or copy-and-paste activities, or from a host app to an app extension.
    /// >
    /// > See [NSItemProvider](https://developer.apple.com/documentation/foundation/nsitemprovider)
    /// > for more details.
    ///
    /// - Parameters:
    ///   - itemProvider: The item provider to decode.
    ///   - propertiesForTimecodeString: Properties to apply to the newly formed ``Timecode`` instance
    ///     in the event the item provider contains a plain-text timecode string.
    public init(
        from itemProvider: NSItemProvider,
        propertiesForTimecodeString: Timecode.Properties
    ) async throws {
        try await self.init(
            from: [itemProvider],
            propertiesForTimecodeString: propertiesForTimecodeString
        )
    }
    
    /// Decode the content of a `NSItemProvider` collection as a new ``Timecode`` instance.
    /// 
    /// Attempts to decode the item provider that contains the richest data.
    /// For instance, if a timecode String item provider and a JSON-encoded item provider are both present,
    /// the JSON-encoded item provider will be favored.
    /// 
    /// If none of the item providers contain data that can be decoded, an error will be thrown.
    ///
    /// > Note:
    /// >
    /// > An item provider is used when conveying data or a file between processes during drag-and-drop
    /// > or copy-and-paste activities, or from a host app to an app extension.
    /// >
    /// > See [NSItemProvider](https://developer.apple.com/documentation/foundation/nsitemprovider)
    /// > for more details.
    ///
    /// - Parameters:
    ///   - itemProviders: The item provider(s) to decode.
    ///   - propertiesForTimecodeString: Properties to apply to the newly formed ``Timecode`` instance
    ///     in the event the item provider(s) contain a plain-text timecode string and no richer encoding
    ///     is present.
    public init(
        from itemProviders: [NSItemProvider],
        propertiesForTimecodeString: Timecode.Properties
    ) async throws {
        // 1. first try Codable decode from data
        
        if let provider = itemProviders.first(where: {
            $0.hasItemConformingToTypeIdentifier(UTType.timecode.identifier)
        }),
            let timecode = try? await provider._loadTransferable(type: Timecode.self)
        {
            self = timecode
            return
        }
        
        // 2. then try plain-text string
        if let provider = itemProviders.first(where: {
            $0.hasItemConformingToTypeIdentifier(Self.textUTType.identifier)
        }),
           let string = try? await provider._loadTransferable(type: String.self),
           let timecode = try? Timecode(.string(string), using: propertiesForTimecodeString, by: .allowingInvalid)
        {
            self = timecode
            return
        }
        
        // 3. otherwise call completion with nothing
        throw CocoaError(.coderValueNotFound)
    }
    
    /// Generates item providers for copying the ``Timecode`` instance to the pasteboard.
    /// 
    /// > Note:
    /// >
    /// > An item provider is used when conveying data or a file between processes during drag-and-drop
    /// > or copy-and-paste activities, or from a host app to an app extension.
    /// >
    /// > See [NSItemProvider](https://developer.apple.com/documentation/foundation/nsitemprovider)
    /// > for more details.
    ///
    /// - Parameter stringFormat: String format used when generating the timecode string item provider.
    /// - Returns: Collection of item providers. Both a plain-text timecode string (lossy) item provider
    ///   and a JSON-encoded (lossless) item provider.
    public func itemProviders(stringFormat: StringFormat = .default()) -> [NSItemProvider] {
        var providers: [NSItemProvider] = []
        
        let text = stringValue(format: stringFormat)
        
        // Codable data (lossless)
        let encoder = JSONEncoder()
        if let tcData = try? encoder.encode(self) as NSData {
            let dataProvider = NSItemProvider(item: tcData, typeIdentifier: UTType.timecode.identifier)
            providers.append(dataProvider)
        }
        
        // String (lossy)
        let strProvider = NSItemProvider(object: text as NSString)
        providers.append(strProvider)
        
        return providers
    }
}

#if canImport(CoreTransferable)
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension NSItemProvider {
    /// Swift Concurrency wrapper for `loadTransferable`.
    ///
    /// - Note: This discards the `Progress` instance that the internal method normally returns.
    ///         If access to this is required, use the original `loadTransferable` method directly instead.
    fileprivate func _loadTransferable<T>(
        type transferableType: T.Type
    ) async throws -> T where T: Transferable {
        let result = await withCheckedContinuation { continuation in
            // discard the returned Progress instance
            _ = loadTransferable(type: transferableType) { result in
                continuation.resume(returning: result)
            }
        }
        return try result.get()
    }
}
#endif

#endif
