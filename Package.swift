// swift-tools-version:5.3

import PackageDescription

let package = Package(
	
    name: "TimecodeKit",
	
    products: [
		
        // library:
        .library(
            name: "TimecodeKit",
            targets: ["TimecodeKit"])
		
    ],
	
    dependencies: [
		
		// utility/support code:
		.package(url: "https://github.com/orchetect/OTCore", from: "1.1.0"),
		
		// console progress module for dev tests:
		.package(url: "https://github.com/orchetect/SegmentedProgress", from: "1.0.1")
		
    ],
	
    targets: [
		
		// main target:
        .target(
			name: "TimecodeKit",
			dependencies: ["OTCore"]),
		
		// unit tests:
		.testTarget(
			name: "TimecodeKit-Unit-Tests",
			dependencies: ["TimecodeKit"]),
		
		// dev tests:
		// not meant to be run as unit tests, but only to verify library's computational integrity when making major changes to the library, as these tests require modification to be meaningful
		.testTarget(
			name: "TimecodeKit-Dev-Tests",
			dependencies: ["TimecodeKit", "SegmentedProgress"]
		)
		
	]
	
)
