// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

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

    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin.git", from: "1.3.0")
    ],

    targets: [
        .target(
            name: "TMDb",
            resources: [
                .process("Resources")
            ]
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
