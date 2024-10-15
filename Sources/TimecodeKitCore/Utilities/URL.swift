//
//  URL.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension URL {
    package init(temporaryFileWithData data: Data) throws {
        let url = FileManager.default.temporaryDirectoryCompat
            .appendingPathComponent(UUID().uuidString)
        try data.write(to: url)
        self = url
    }
}

extension FileManager {
    /// Backwards compatible method for retrieving a temporary folder from the system.
    @_disfavoredOverload
    package var temporaryDirectoryCompat: URL {
        if #available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
            return temporaryDirectory
        } else {
            return URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        }
    }
}
