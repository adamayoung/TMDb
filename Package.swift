// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TMDb",

    defaultLocalization: "en",

    platforms: [
        .macOS(.v12), .iOS(.v15), .tvOS(.v15), .watchOS(.v8)
    ],

    products: [
        .library(name: "TMDb", targets: ["TMDb"])
    ],

    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin.git", from: "1.2.0")
    ],

    targets: [
        .target(
            name: "TMDb",
            plugins: [
                .plugin(name: "SwiftLintPlugin")
            ]
        ),
        .testTarget(
            name: "TMDbTests",
            dependencies: ["TMDb"],
            resources: [
                .process("Resources")
            ],
            plugins: [
                .plugin(name: "SwiftLintPlugin")
            ]
        ),
        .testTarget(
            name: "TMDbIntegrationTests",
            dependencies: ["TMDb"],
            resources: [
                .process("Resources")
            ],
            plugins: [
                .plugin(name: "SwiftLintPlugin")
            ]
        ),

        .plugin(
            name: "SwiftLintPlugin",
            capability: .buildTool(),
            dependencies: ["SwiftLintBinary"]
        ),
        .plugin(
            name: "SwiftLint",
            capability: .command(
                intent: .custom(
                    verb: "swiftlint",
                    description: "SwiftLint."
                )
            ),
            dependencies: ["SwiftLintBinary"]
        ),

        .binaryTarget(
            name: "SwiftLintBinary",
            url: "https://github.com/realm/SwiftLint/releases/download/0.51.0/SwiftLintBinary-macos.artifactbundle.zip",
            checksum: "9fbfdf1c2a248469cfbe17a158c5fbf96ac1b606fbcfef4b800993e7accf43ae"
        )
    ]
)
