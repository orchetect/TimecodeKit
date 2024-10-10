//
//  NSItemProvider Tests.swift
//  TimecodeKit • https://github.com/orchetect/TimecodeKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(UniformTypeIdentifiers) && canImport(CoreTransferable)

@testable import TimecodeKit
import XCTest

final class NSItemProviderTests: XCTestCase {
    @MainActor
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    func testEncodeDecode() async throws {
        let properties = Timecode.Properties(
            rate: .fps120,
            base: .max100SubFrames,
            limit: .max100Days
        )
        let timecode = try Timecode(.components(d: 2, h: 1, m: 02, s: 03, f: 04, sf: 05), using: properties)
        
        let itemProviders = timecode.itemProviders(stringFormat: [.showSubFrames])
        
        let wrongProperties = Timecode.Properties(
            rate: .fps60,
            base: .max80SubFrames,
            limit: .max24Hours
        )
        
        let decoded = try await Timecode(
            from: itemProviders,
            propertiesForTimecodeString: wrongProperties
        )
        
        XCTAssertEqual(decoded.components, timecode.components)
        XCTAssertEqual(decoded.properties, timecode.properties)
    }
    
    @MainActor
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    func testDecodeString() async throws {
        let properties = Timecode.Properties(
            rate: .fps120,
            base: .max100SubFrames,
            limit: .max100Days
        )
        let timecode = try Timecode(.components(d: 2, h: 1, m: 02, s: 03, f: 04, sf: 05), using: properties)
        
        let itemProvider = timecode.stringItemProvider(stringFormat: [.showSubFrames])
        
        let newProperties = Timecode.Properties(
            rate: .fps60,
            base: .max80SubFrames,
            limit: .max24Hours
        )
        
        // even though new properties have a 24-hour upper limit, days value is still preserved
        // since the init uses `allowingInvalid` validation rule
        let decoded = try await Timecode(
            from: itemProvider,
            propertiesForTimecodeString: newProperties
        )
        
        XCTAssertEqual(decoded.components, timecode.components)
        XCTAssertEqual(decoded.properties, newProperties)
    }
    
    @MainActor
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    func testDecodeJSON() async throws {
        let properties = Timecode.Properties(
            rate: .fps120,
            base: .max100SubFrames,
            limit: .max100Days
        )
        let timecode = try Timecode(.components(d: 2, h: 1, m: 02, s: 03, f: 04, sf: 05), using: properties)
        
        let itemProvider = try timecode.jsonItemProvider()
        
        let wrongProperties = Timecode.Properties(
            rate: .fps60,
            base: .max80SubFrames,
            limit: .max24Hours
        )
        
        let decoded = try await Timecode(
            from: itemProvider,
            propertiesForTimecodeString: wrongProperties
        )
        
        XCTAssertEqual(decoded.components, timecode.components)
        XCTAssertEqual(decoded.properties, timecode.properties)
    }
}

#endif
