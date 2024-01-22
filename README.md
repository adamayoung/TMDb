# TMDb - The Movie Database

[![CI](https://github.com/adamayoung/TMDb/actions/workflows/ci.yml/badge.svg)](https://github.com/adamayoung/TMDb/actions/workflows/ci.yml)
[![Integration](https://github.com/adamayoung/TMDb/actions/workflows/integration.yml/badge.svg)](https://github.com/adamayoung/TMDb/actions/workflows/integration.yml)
[![CodeQL](https://github.com/adamayoung/TMDb/actions/workflows/codeql.yml/badge.svg)](https://github.com/adamayoung/TMDb/actions/workflows/codeql.yml)
[![Documentation](https://github.com/adamayoung/TMDb/actions/workflows/documentation.yml/badge.svg)](https://github.com/adamayoung/TMDb/actions/workflows/documentation.yml)

A Swift Package for The Movie Database (TMDb) <https://www.themoviedb.org>

## Requirements

* Swift 5.9+
* OS
  * macOS 13+
  * iOS 16+
  * watchOS 9+
  * tvOS 16+
  * visionOS 1+

## Installation

### [Swift Package Manager](https://github.com/apple/swift-package-manager)

Add the TMDb package as a dependency to your `Package.swift` file, and add it
as a dependency to your target.

```swift
// swift-tools-version:5.9

import PackageDescription

let package = Package(
  name: "MyProject",

  dependencies: [
    .package(url: "https://github.com/adamayoung/TMDb.git", from: "11.0.0")
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

## Development

### Prerequisites

Install [homebrew](https://brew.sh) and the follow formulae

* swiftlint
* swiftformat
* markdownlint

```bash
brew install swiftlint swiftformat markdownlint
```

### Before submitting a PR

#### Unit and Integration Tests

Ensure all new code is covered by unit tests. If any new methods are added to
services that make calls to TMDb API endpoints, ensure there are integration tests
covering these.

#### Coding Style

Coding style is enforced by `swiftlint` and `swiftformat`.

Use the following command to lint the codebase:

```bash
make lint
```

To format the codebase use:

```bash
make format
```

#### DocC Documentation

Ensure all `public` classes, structs, properties and methods are commented

The DocC documentation can be built and hosted locally by

```bash
make preview-docs
```

See [DocC | Apple Developer Documentation](https://developer.apple.com/documentation/docc)
for more details.

#### CI Checks

Before submitting a PR, ensure all CI checks will pass:

```bash
make ci
```

CI checks are made up of the follow tasks:

```bash
make lint
make lint-markddown
make test
make test-ios
make test-watchos
make test-tvos
make test-linux
make integration-test
make build-release
make build-docs
```

In order to run integration tests the `TMDB_API_KEY` environment variable needs
to be set.

Running unit tests on Linux requires [Docker](https://www.docker.com) to be
running.

## References

* [https://www.themoviedb.org](https://www.themoviedb.org)
* [https://developer.themoviedb.org](https://developer.themoviedb.org)

## License

This library is licensed under the Apache License 2.0. See
[LICENSE](https://github.com/adamayoung/TMDb/blob/main/LICENSE) for details.
