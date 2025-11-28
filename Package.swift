// swift-tools-version: 5.9
// (be sure to update the .swift-version file when this Swift version changes)

import Foundation
import PackageDescription

let package = Package(
    name: "swift-timecode",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v10_13), .iOS(.v12), .tvOS(.v12), .watchOS(.v4), .visionOS(.v1)
    ],
    products: [
        .library(name: "SwiftTimecode", targets: ["SwiftTimecode"]),
        .library(name: "SwiftTimecodeCore", type: .static, targets: ["SwiftTimecodeCore"]),
        .library(name: "SwiftTimecodeAV", targets: ["SwiftTimecodeAV"]),
        .library(name: "SwiftTimecodeUI", targets: ["SwiftTimecodeUI"])
    ],
    dependencies: [
        // used only for Dev tests, not part of regular unit tests
        // .package(url: "https://github.com/orchetect/xctest-extensions", from: "2.0.0")
    ] + doccPluginDependency(),
    targets: [
        .target(
            name: "SwiftTimecode",
            dependencies: ["SwiftTimecodeCore", "SwiftTimecodeAV", "SwiftTimecodeUI"]
        ),
        .target(
            name: "SwiftTimecodeCore",
            dependencies: []
        ),
        .target(
            name: "SwiftTimecodeAV",
            dependencies: ["SwiftTimecodeCore"]
        ),
        .target(
            name: "SwiftTimecodeUI",
            dependencies: ["SwiftTimecodeCore"],
            linkerSettings: [
                .linkedFramework("SwiftUI", .when(platforms: [.macOS, .macCatalyst, .iOS, .tvOS, .watchOS, .visionOS]))
            ]
        ),
        .testTarget(
            name: "SwiftTimecodeCoreTests",
            dependencies: ["SwiftTimecodeCore"]
        ),
        .testTarget(
            name: "SwiftTimecodeAVTests",
            dependencies: ["SwiftTimecodeAV"],
            resources: [.copy("TestResource/Media Files")]
        ),
        .testTarget(
            name: "SwiftTimecodeUITests",
            dependencies: ["SwiftTimecodeUI"],
            linkerSettings: [
                .linkedFramework("SwiftUI", .when(platforms: [.macOS, .macCatalyst, .iOS, .tvOS, .watchOS, .visionOS]))
            ]
        ),
        // dev tests
        // (not meant to be run as unit tests, but only to verify library's computational integrity
        // when making major changes to the library, as these tests require modification to be meaningful)
        .testTarget(
            name: "SwiftTimecodeDevTests",
            dependencies: [
                "SwiftTimecodeCore"
                // .product(name: "XCTestExtensions", package: "xctest-extensions")
            ]
        )
    ]
)

/// Conditionally opt-in to Swift DocC Plugin when an environment flag is present.
func doccPluginDependency() -> [Package.Dependency] {
    ProcessInfo.processInfo.environment["ENABLE_DOCC_PLUGIN"] != nil
        ? [.package(url: "https://github.com/apple/swift-docc-plugin.git", from: "1.4.5")]
        : []
}
