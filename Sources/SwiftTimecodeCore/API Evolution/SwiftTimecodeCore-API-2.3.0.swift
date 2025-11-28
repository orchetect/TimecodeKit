//
//  SwiftTimecodeCore-API-2.3.0.swift
//  swift-timecode • https://github.com/orchetect/swift-timecode
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: API Changes in swift-timecode 2.3.0

@_documentation(visibility: internal)
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension Timecode {
    @available(*, deprecated, renamed: "init(from:propertiesForString:)")
    @MainActor
    public init(
        from itemProvider: NSItemProvider,
        propertiesForTimecodeString: Timecode.Properties
    ) async throws {
        try await self.init(from: itemProvider, propertiesForString: propertiesForTimecodeString)
    }
    
    @available(*, deprecated, renamed: "init(from:propertiesForString:)")
    @MainActor
    public init(
        from itemProviders: [NSItemProvider],
        propertiesForTimecodeString: Timecode.Properties
    ) async throws {
        try await self.init(from: itemProviders, propertiesForString: propertiesForTimecodeString)
    }
}

@_documentation(visibility: internal)
extension String {
    @available(*, deprecated, renamed: "TimecodeFrameRate(stringValue:)")
    @_disfavoredOverload
    public var timecodeFrameRate: TimecodeFrameRate? {
        TimecodeFrameRate(stringValue: self)
    }
}
