// swift-tools-version:5.5
// (be sure to update the .swift-version file when this Swift version changes)

import PackageDescription

let package = Package(
    name: "TimecodeKit",
    
    defaultLocalization: "en",
    
    // certain features of the library are marked @available only on newer versions of OSes,
    // but a platforms spec here determines what base platforms
    // the library is currently supported on
    platforms: [.macOS(.v10_12), .iOS(.v9), .tvOS(.v9), .watchOS(.v2)],
    
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
        // used only for Dev tests, not part of regular unit test
        // .package(url: "https://github.com/orchetect/SegmentedProgress", from: "1.0.1")
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
                .linkedFramework("SwiftUI", .when(platforms: [.macOS, .iOS, .tvOS, .watchOS]))
            ]
        ),
        
        // unit tests
        .testTarget(
            name: "TimecodeKit-Unit-Tests",
            dependencies: ["TimecodeKit"]
        ),
        
        // dev tests
        // (not meant to be run as unit tests, but only to verify library's computational integrity when making major changes to the library, as these tests require modification to be meaningful)
        .testTarget(
            name: "TimecodeKit-Dev-Tests",
            dependencies: ["TimecodeKit"] // , "SegmentedProgress"
        )
    ]
)

func addShouldTestFlag(toTarget targetName: String) {
    // swiftSettings may be nil so we can't directly append to it
    
    var swiftSettings = package.targets
        .first(where: { $0.name == targetName })?
        .swiftSettings ?? []
    
    swiftSettings.append(.define("shouldTestCurrentPlatform"))
    
    package.targets
        .first(where: { $0.name == targetName })?
        .swiftSettings = swiftSettings
}

func addShouldTestFlags() {
    addShouldTestFlag(toTarget: "TimecodeKit-Unit-Tests")
    addShouldTestFlag(toTarget: "TimecodeKit-Dev-Tests")
}

// Swift version in Xcode 12.5.1 which introduced watchOS testing
#if os(watchOS) && swift(>=5.4.2)
addShouldTestFlags()
#elseif os(watchOS)
// don't add flag
#else
addShouldTestFlags()
#endif
