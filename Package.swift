// swift-tools-version: 5.5
// (be sure to update the .swift-version file when this Swift version changes)

import PackageDescription

let package = Package(
    name: "TimecodeKit",
    
    defaultLocalization: "en",
    
    // certain features of the library are marked @available only on newer versions of OSes,
    // but a platforms spec here determines what base platforms
    // the library is currently supported on
    
    // Add visionOS platform in supported Swift toolchain / Xcode versions
    // TODO: Not yet implemented in Xcode 15.0 but can be added later
    platforms: {
        // #if swift(>=5.9.1)
        // [.macOS(.v10_12), .iOS(.v9), .tvOS(.v9), .watchOS(.v2), .visionOS(.v1)]
        // #else
        [.macOS(.v10_12), .iOS(.v9), .tvOS(.v9), .watchOS(.v2)]
        // #endif
    }(),
    
    products: [
        .library(
            name: "TimecodeKit",
            type: .static,
            targets: ["TimecodeKit"]
        ),
        
        .library(
            name: "TimecodeKitUI",
            type: .static,
            targets: ["TimecodeKitUI"]
        )
    ],
    
    dependencies: [
        // used only for Dev tests, not part of regular unit tests
        // .package(url: "https://github.com/orchetect/XCTestUtils", from: "1.0.3")
    ],
    
    targets: [
        // main target
        .target(
            name: "TimecodeKit",
            dependencies: []
        ),
        
        // UI components
        .target(
            name: "TimecodeKitUI",
            dependencies: ["TimecodeKit"],
            linkerSettings: [
                .linkedFramework(
                    "SwiftUI",
                    .when(platforms: {
                        // Xcode 15 beta 8 (Swift 5.9) introduced visionOS
                        #if swift(>=5.9)
                        [.macOS, .iOS, .tvOS, .watchOS, .visionOS]
                        #else
                        [.macOS, .iOS, .tvOS, .watchOS]
                        #endif
                    }())
                )
            ]
        ),
            
        // unit tests
        .testTarget(
            name: "TimecodeKit-Unit-Tests",
            dependencies: ["TimecodeKit"],
            resources: [.copy("TestResource/Media Files")]
        ),
        
        // dev tests
        // (not meant to be run as unit tests, but only to verify library's computational integrity when making major changes to the
        // library, as these tests require modification to be meaningful)
        .testTarget(
            name: "TimecodeKit-Dev-Tests",
            dependencies: ["TimecodeKit"] // , "XCTestUtils"
        )
    ]
)

// MARK: - Conditional Unit Testing

func addShouldTestFlag() {
    package.targets.filter { $0.isTest }.forEach { target in
        if target.swiftSettings == nil { target.swiftSettings = [] }
        target.swiftSettings?.append(.define("shouldTestCurrentPlatform"))
    }
}

// Xcode 12.5.1 (Swift 5.4.2) introduced watchOS testing
#if swift(>=5.4.2)
addShouldTestFlag()
#elseif !os(watchOS)
addShouldTestFlag()
#endif
