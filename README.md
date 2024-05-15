# TMDb - The Movie Database

[![CI](https://github.com/adamayoung/TMDb/actions/workflows/ci.yml/badge.svg)](https://github.com/adamayoung/TMDb/actions/workflows/ci.yml)
[![Integration](https://github.com/adamayoung/TMDb/actions/workflows/integration.yml/badge.svg)](https://github.com/adamayoung/TMDb/actions/workflows/integration.yml)
[![CodeQL](https://github.com/adamayoung/TMDb/actions/workflows/codeql.yml/badge.svg)](https://github.com/adamayoung/TMDb/actions/workflows/codeql.yml)
[![Documentation](https://github.com/adamayoung/TMDb/actions/workflows/documentation.yml/badge.svg)](https://github.com/adamayoung/TMDb/actions/workflows/documentation.yml)
[![codecov](https://codecov.io/gh/adamayoung/TMDb/graph/badge.svg?token=TICHRASF6F)](https://codecov.io/gh/adamayoung/TMDb)

A Swift Package for The Movie Database (TMDb) <https://www.themoviedb.org>

## Requirements

* Swift 5.9+
* OS
  * macOS 13+
  * iOS 16+
  * watchOS 9+
  * tvOS 16+
  * visionOS 1+
  * Windows
  * Linux

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
    .package(url: "https://github.com/adamayoung/TMDb.git", from: "12.0.0")
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

* [swiftlint](https://github.com/realm/SwiftLint)
* [swiftformat](https://github.com/nicklockwood/SwiftFormat)
* [markdownlint](https://github.com/igorshubovych/markdownlint-cli)
* [xcbeautify](https://github.com/cpisciotta/xcbeautify)

```bash
brew install swiftlint swiftformat markdownlint xcbeautify
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
make test-visionos
make test-linux
make integration-test
make build-release
make build-docs
```

In order to run integration tests the following environment variables need to
be set.

* `TMDB_API_KEY` - Your TMDb API key
* `TMDB_USERNAME` - Your TMDb username
* `TMDB_PASSWORD` - Your TMDB password

If these environment variables aren't set then integration tests are skipped
when not using `make`.

Running unit tests on Linux requires [Docker](https://www.docker.com) to be
running.

## References

* [https://www.themoviedb.org](https://www.themoviedb.org)
* [https://developer.themoviedb.org](https://developer.themoviedb.org)

## License

This library is licensed under the Apache License 2.0. See
[LICENSE](https://github.com/adamayoung/TMDb/blob/main/LICENSE) for details.
