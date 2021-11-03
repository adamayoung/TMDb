// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "TMDb",

    platforms: [
        .macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)
    ],

    products: [
        .library(name: "TMDb", targets: ["TMDb"])
    ],

    targets: [
        .target(name: "TMDb"),
        .testTarget(name: "TMDbTests", dependencies: ["TMDb"])
    ]
)
