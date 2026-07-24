// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import class Foundation.ProcessInfo
import PackageDescription

let package = Package(
    name: "TMDb",

    defaultLocalization: "en",

    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .watchOS(.v9),
        .tvOS(.v16),
        .visionOS(.v1)
    ],

    products: [
        .library(name: "TMDb", targets: ["TMDb"]),
        .library(name: "TMDbTesting", targets: ["TMDbTesting"])
    ],

    targets: [
        .target(
            name: "TMDb"
        ),
        .target(
            name: "TMDbTesting",
            dependencies: ["TMDb"]
        ),
        .testTarget(
            name: "TMDbTests",
            dependencies: ["TMDb"],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "TMDbTestingTests",
            dependencies: ["TMDb", "TMDbTesting"]
        ),
        .testTarget(
            name: "TMDbIntegrationTests",
            dependencies: ["TMDb"]
        )
    ]
)

if ProcessInfo.processInfo.environment["SWIFTCI_DOCC"] == "1" {
    package.dependencies += [
        .package(url: "https://github.com/apple/swift-docc-plugin.git", from: "1.4.6")
    ]
} else {
    // Outside a documentation build the DocC plugin is not loaded, so no build
    // rule claims the `.docc` catalogs and SwiftPM reports them as unhandled
    // files. From Swift 6.4 (Xcode 27) `-Xswiftc -warnings-as-errors` promotes
    // that package-load warning to an error, which fails every `make` build,
    // test and release target. Excluding the catalogs when they are not being
    // built keeps those targets clean; the documentation build still sees them.
    package.targets.first { $0.name == "TMDb" }?.exclude = ["TMDb.docc"]
    package.targets.first { $0.name == "TMDbTesting" }?.exclude = ["TMDbTesting.docc"]
}
