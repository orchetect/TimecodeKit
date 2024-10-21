// swift-tools-version: 5.9
// (be sure to update the .swift-version file when this Swift version changes)

import Foundation
import PackageDescription

let package = Package(
    name: "TimecodeKit",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v10_13), .iOS(.v12), .tvOS(.v12), .watchOS(.v4), .visionOS(.v1)
    ],
    products: [
        .library(name: "TimecodeKit", targets: ["TimecodeKit"]),
        .library(name: "TimecodeKitCore", type: .static, targets: ["TimecodeKitCore"]),
        .library(name: "TimecodeKitAV", targets: ["TimecodeKitAV"]),
        .library(name: "TimecodeKitUI", targets: ["TimecodeKitUI"])
    ],
    dependencies: [
        // used only for Dev tests, not part of regular unit tests
        // .package(url: "https://github.com/orchetect/XCTestUtils", from: "1.0.3")
    ] + doccPluginDependency(),
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

        // core unit tests
        .testTarget(
            name: "TimecodeKitCoreTests",
            dependencies: ["TimecodeKitCore"]
        ),
        
        // AV tests
        .testTarget(
            name: "TimecodeKitAVTests",
            dependencies: ["TimecodeKitAV"],
            resources: [.copy("TestResource/Media Files")]
        ),
        
        // dev tests
        // (not meant to be run as unit tests, but only to verify library's computational integrity
        // when making major changes to the library, as these tests require modification to be meaningful)
        .testTarget(
            name: "TimecodeKitDevTests",
            dependencies: ["TimecodeKitCore"] // , "XCTestUtils"
        )
    ]
)

func doccPluginDependency() -> [Package.Dependency] {
    ProcessInfo.processInfo.environment["ENABLE_DOCC_PLUGIN"] != nil
        ? [.package(url: "https://github.com/apple/swift-docc-plugin.git", from: "1.4.3")]
        : []
}
