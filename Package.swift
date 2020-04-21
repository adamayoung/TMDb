// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "TMDb",

  platforms: [
    .macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)
  ],

  products: [
    .library(name: "TMDb", targets: ["TMDb"]),
    .library(name: "TMDbSwiftUI", targets: ["TMDbSwiftUI"])
  ],

  dependencies: [
    .package(url: "https://github.com/SDWebImage/SDWebImageSwiftUI.git", from: "1.0.0")
  ],

  targets: [
    .target(name: "TMDb"),
    .testTarget(name: "TMDbTests", dependencies: ["TMDb"]),

    .target(name: "TMDbSwiftUI", dependencies: ["TMDb", "SDWebImageSwiftUI"]),
    .testTarget(name: "TMDbSwiftUITests", dependencies: ["TMDbSwiftUI", "SDWebImageSwiftUI"])
  ]
)
