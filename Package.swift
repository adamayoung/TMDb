// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "TMDb",

    platforms: [
        .macOS(.v12), .iOS(.v15), .tvOS(.v15), .watchOS(.v8)
    ],

    products: [
        .library(name: "TMDb", targets: ["TMDb"])
    ],

    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin.git", from: "1.0.0")
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
            dependencies: ["TMDb"],
            resources: [
                .process("Resources")
            ]
        )
    ]
)
