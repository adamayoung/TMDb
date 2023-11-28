// swift-tools-version:5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import class Foundation.ProcessInfo
import PackageDescription

let package = Package(
    name: "TMDb",

    defaultLocalization: "en",

    platforms: [
        .macOS(.v11),
        .iOS(.v14),
        .tvOS(.v14),
        .watchOS(.v7)
    ],

    products: [
        .library(name: "TMDb", targets: ["TMDb"])
    ],

    targets: [
        .target(
            name: "TMDb"
        ),
        .testTarget(
            name: "TMDbTests",
            dependencies: ["TMDb"],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "TMDbIntegrationTests",
            dependencies: ["TMDb"]
        )
    ]
)

if ProcessInfo.processInfo.environment["SWIFTCI_DOCC"] == "1" {
    package.dependencies += [
        .package(url: "https://github.com/apple/swift-docc-plugin.git", from: "1.3.0")
    ]
}
