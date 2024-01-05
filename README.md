# TMDb - The Movie Database

[![CI](https://github.com/adamayoung/TMDb/actions/workflows/ci.yml/badge.svg)](https://github.com/adamayoung/TMDb/actions/workflows/ci.yml)
[![Integration](https://github.com/adamayoung/TMDb/actions/workflows/integration.yml/badge.svg)](https://github.com/adamayoung/TMDb/actions/workflows/integration.yml)
[![Documentation](https://github.com/adamayoung/TMDb/actions/workflows/documentation.yml/badge.svg)](https://github.com/adamayoung/TMDb/actions/workflows/documentation.yml)

A Swift Package for The Movie Database (TMDb) <https://www.themoviedb.org>

## Requirements

* Swift 5.7+
* OS
  * macOS 11+
  * iOS 14+
  * watchOS 7+
  * tvOS 14+

## Installation

### [Swift Package Manager](https://github.com/apple/swift-package-manager)

Add the TMDb package as a dependency to your `Package.swift` file, and add it
as a dependency to your target.

```swift
// swift-tools-version:5.7

import PackageDescription

let package = Package(
  name: "MyProject",

  dependencies: [
    .package(url: "https://github.com/adamayoung/TMDb.git", from: "10.0.0")
  ],

  targets: [
    .target(name: "MyProject", dependencies: ["TMDb"])
  ]
)
```

### Xcode project

Add the TMDb package to your Project's Package dependencies.

## Setup

### Get an API Key

Create an API key from The Movie Database web site
[https://www.themoviedb.org/documentation/api](https://www.themoviedb.org/documentation/api).

## Documentation

Documentation and examples of usage can be found at
[https://adamayoung.github.io/TMDb/documentation/tmdb/](https://adamayoung.github.io/TMDb/documentation/tmdb/)

## References

* [https://www.themoviedb.org](https://www.themoviedb.org)
* [https://developer.themoviedb.org](https://developer.themoviedb.org)

## License

This library is licensed under the Apache License 2.0. See
[LICENSE](https://github.com/adamayoung/TMDb/blob/main/LICENSE) for details.
