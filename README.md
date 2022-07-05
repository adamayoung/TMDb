# TMDb - The Movie Database

![CI](https://github.com/adamayoung/TMDb/workflows/CI/badge.svg) [![codecov](https://codecov.io/gh/adamayoung/TMDb/branch/main/graph/badge.svg?token=TICHRASF6F)](https://codecov.io/gh/adamayoung/TMDb)

A Swift Package for The Movie Database (TMDb) <https://www.themoviedb.org>

## Requirements

* Swift 5.6

## Installation

### [Swift Package Manager](https://github.com/apple/swift-package-manager)

Add the TMDb package as a dependency to your `Package.swift` file, and add it as a dependency to your target.

```swift
// swift-tools-version:5.6

import PackageDescription

let package = Package(
  name: "MyPackage",
  dependencies: [
    .package(url: "https://github.com/adamayoung/TMDb.git", upToNextMajor: "9.0.0")
  ],
  targets: [
    .target(name: "MyPackage", dependencies: ["TMDb"])
  ]
)
```

## Setup

### Get an API Key

Create an API key from The Movie Database web site [https://www.themoviedb.org/documentation/api](https://www.themoviedb.org/documentation/api).

## API Areas

### Certifications

Get an up to date list of the officially supported movie certifications on TMDb.

### Configuration

System wide configuration information.

### Discover

Discover movies by different types of data like average rating, number of votes, genres and certifications.

Discover TV shows by different types of data like average rating, number of votes, genres, the network they aired on and air dates.

### Movies

Get information about movies.

### People

Get information about people.

### Search

Search for movies, TV shows and people.

### Trending

Get the daily or weekly trending items. The daily trending list tracks items over the period of a day while items have a 24 hour half life. The weekly list tracks items over a 7 day period, with a 7 day half life.

### TV Shows

Get information about TV shows.

### TV Show Seasons

Get information about TV show seasons.

## Examples

First, create an instance of TMDb with your [API key](#get-an-api-key).

```swift
let tmdb = TMDbAPI(apiKey: "<tmdb-api-key>")
```

### Discover Movies

```swift
let movieList = try await tmdb.discover.movies()
let movies = movieList.results
```

### Trending TV Shows this week, 2nd page

```swift
let tvShowList = try await tmdb.trending.tvShows(inTimeWindow: .week, page: 2)
let tvShows = list.results
```

### Popular People

```swift
let personList = try await tmdb.people.popular()
let people = personList.results
```

## Support for Combine

Combine support is available in version [6.0.0](https://github.com/adamayoung/TMDb/tree/6.0.0).

## Documentation

The latest documentation for the TMDb APIs is available at [https://adamayoung.github.io/TMDb](https://adamayoung.github.io/TMDb/).

## References

* [https://www.themoviedb.org](https://www.themoviedb.org)
* [https://developers.themoviedb.org](https://developers.themoviedb.org)

## License

This library is licensed under the Apache License 2.0. See [LICENSE](https://github.com/adamayoung/TMDb/blob/main/LICENSE) for details.
