// swift-tools-version:5.3

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
            targets: ["TimecodeKit"]),
        
        .library(
            name: "TimecodeKitUI",
            type: .static,
            targets: ["TimecodeKitUI"])
    ],
    
    dependencies: [
        // boilerplate:
        .package(url: "https://github.com/orchetect/OTCore", from: "1.1.26")
        
        // used only for Dev tests, not part of regular unit test
        //.package(url: "https://github.com/orchetect/SegmentedProgress", from: "1.0.1")
    ],
    
    targets: [
        // main target
        .target(
            name: "TimecodeKit",
            dependencies: ["OTCore"]
        ),
        
        // UI components
        .target(
            name: "TimecodeKitUI",
            dependencies: ["TimecodeKit", "OTCore"],
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
