# TMDb - The Movie Database

![CI](https://github.com/adamayoung/TMDb/workflows/CI/badge.svg) [![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager) ![platforms](https://img.shields.io/badge/platforms-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS-333333.svg)

A Swift Package for The Movie Database (TMDb) <https://www.themoviedb.org>

## Requirements

* Xcode 11.4+
* Swift 5.2+

## Installation

### [Swift Package Manager](https://github.com/apple/swift-package-manager)

Add the TMDb package as a dependency to your `Package.swift` file, and add it as a dependency on your target.

```swift
// swift-tools-version:5.2

import PackageDescription

let package = Package(
  name: "MyProject",
  dependencies: [
    .package(url: "https://github.com/adamayoung/TMDb.git", from: "1.0.0")
  ],
  targets: [
    .target(name: "MyProject", dependencies: ["TMDb"])
  ]
)
```

## Usage

### Get an API Key

Create an API Key from The Movie Database web site [https://www.themoviedb.org/documentation/api](https://www.themoviedb.org/documentation/api).

### Setup

Set your API key

```swift
TMDbAPIClient.setAPIKey("ahb4334n43nj34jk43nklkg4")
```


## References

* [https://www.themoviedb.org](https://www.themoviedb.org)
* [https://developers.themoviedb.org](https://developers.themoviedb.org)