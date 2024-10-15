// swift-tools-version: 5.9
// (be sure to update the .swift-version file when this Swift version changes)

import PackageDescription

let package = Package(
    name: "TimecodeKit",
    defaultLocalization: "en",
    platforms: {
        #if swift(>=5.9)
        [.macOS(.v10_13), .iOS(.v12), .tvOS(.v12), .watchOS(.v4), .visionOS(.v1)]
        #else
        [.macOS(.v10_12), .iOS(.v9), .tvOS(.v9), .watchOS(.v2)]
        #endif
    }(),
    products: [
        .library(
            name: "TimecodeKit",
            targets: ["TimecodeKit"]
        ),
        .library(
            name: "TimecodeKitCore",
            type: .static,
            targets: ["TimecodeKitCore"]
        ),
        .library(
            name: "TimecodeKitAV",
            targets: ["TimecodeKitAV"]
        ),
        .library(
            name: "TimecodeKitUI",
            targets: ["TimecodeKitUI"]
        )
    ],
    dependencies: [
        // used only for Dev tests, not part of regular unit tests
        // .package(url: "https://github.com/orchetect/XCTestUtils", from: "1.0.3")
    ],
    targets: [
        // umbrella target
        .target(
            name: "TimecodeKit",
            dependencies: ["TimecodeKitCore", "TimecodeKitAV", "TimecodeKitUI"]
        ),
        
        // core target
        .target(
            name: "TimecodeKitCore",
            dependencies: []
        ),
        
        // AVFoundation target
        .target(
            name: "TimecodeKitAV",
            dependencies: ["TimecodeKitCore"]
        ),
        
        // UI components
        .target(
            name: "TimecodeKitUI",
            dependencies: ["TimecodeKitCore"],
            linkerSettings: [
                .linkedFramework(
                    "SwiftUI",
                    .when(platforms: {
                        #if swift(>=5.9)
                        [.macOS, .macCatalyst, .iOS, .tvOS, .watchOS, .visionOS]
                        #else
                        [.macOS, .macCatalyst, .iOS, .tvOS, .watchOS]
                        #endif
                    }())
                )
            ]
        ),
            
        // unit tests
        .testTarget(
            name: "TimecodeKit-Unit-Tests",
            dependencies: ["TimecodeKitCore"],
            resources: [.copy("TestResource/Media Files")]
        ),
        
        // dev tests
        // (not meant to be run as unit tests, but only to verify library's computational integrity
        // when making major changes to the library, as these tests require modification to be meaningful)
        .testTarget(
            name: "TimecodeKit-Dev-Tests",
            dependencies: ["TimecodeKitCore"] // , "XCTestUtils"
        )
    ]
)
