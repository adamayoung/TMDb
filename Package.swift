// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "TMDb",
  platforms: [
    .macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)
  ],
  products: [
    .library(name: "TMDbClient", targets: ["TMDbClient"]),
    .library(name: "TMDbConfiguration", targets: ["TMDbConfiguration"]),
    .library(name: "TMDbCredits", targets: ["TMDbCredits"]),
    .library(name: "TMDbImages", targets: ["TMDbImages"]),
    .library(name: "TMDbMovies", targets: ["TMDbMovies"]),
    .library(name: "TMDbPeople", targets: ["TMDbPeople"]),
    .library(name: "TMDbReviews", targets: ["TMDbReviews"]),
    .library(name: "TMDbTVShows", targets: ["TMDbTVShows"]),
    .library(name: "TMDbVideos", targets: ["TMDbVideos"])
  ],
  dependencies: [],
  targets: [
    .target(name: "TMDbClient"),
    .testTarget(name: "TMDbClientTests", dependencies: ["TMDbClient"]),

    .target(name: "TMDbConfiguration"),
    .testTarget(name: "TMDbConfigurationTests", dependencies: ["TMDbConfiguration"]),

    .target(name: "TMDbCredits"),
    .testTarget(name: "TMDbCreditsTests", dependencies: ["TMDbCredits"]),

    .target(name: "TMDbImages"),
    .testTarget(name: "TMDbImagesTests", dependencies: ["TMDbImages"]),

    .target(name: "TMDbMovies"),
    .testTarget(name: "TMDbMoviesTests", dependencies: ["TMDbMovies"]),

    .target(name: "TMDbPeople"),
    .testTarget(name: "TMDbPeopleTests", dependencies: ["TMDbPeople"]),

    .target(name: "TMDbReviews"),
    .testTarget(name: "TMDbReviewsTests", dependencies: ["TMDbReviews"]),

    .target(name: "TMDbTVShows"),
    .testTarget(name: "TMDbTVShowsTests", dependencies: ["TMDbTVShows"]),

    .target(name: "TMDbVideos"),
    .testTarget(name: "TMDbVideosTests", dependencies: ["TMDbVideos"])
  ]
)
