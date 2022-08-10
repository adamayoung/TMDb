// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "TMDb",

    platforms: [
        .macOS(.v12), .iOS(.v15), .tvOS(.v15), .watchOS(.v8)
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
            dependencies: ["TMDb"],
            resources: [
                .process("Resources")
            ]
        )
    ]
)
