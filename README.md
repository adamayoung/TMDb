# TMDb - The Movie Database

![CI](https://github.com/adamayoung/TMDb/workflows/CI/badge.svg) [![Coverage](https://sonarcloud.io/api/project_badges/measure?project=adamayoung_TMDb&metric=coverage)](https://sonarcloud.io/dashboard?id=adamayoung_TMDb) [![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=adamayoung_TMDb&metric=alert_status)](https://sonarcloud.io/dashboard?id=adamayoung_TMDb) [![Security Rating](https://sonarcloud.io/api/project_badges/measure?project=adamayoung_TMDb&metric=security_rating)](https://sonarcloud.io/dashboard?id=adamayoung_TMDb)

[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager) ![platforms](https://img.shields.io/badge/platforms-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS%20%7C%20Linux-333333.svg)

A Swift Package for The Movie Database (TMDb) <https://www.themoviedb.org>

## Requirements

* Swift 5.2+

## Installation

### [Swift Package Manager](https://github.com/apple/swift-package-manager)

Add the TMDb package as a dependency to your `Package.swift` file, and add it as a dependency to your target.

```swift
// swift-tools-version:5.2

import PackageDescription

let package = Package(
  name: "MyProject",
  dependencies: [
    .package(url: "https://github.com/adamayoung/TMDb.git", from: "4.1.0")
  ],
  targets: [
    .target(name: "MyProject", dependencies: ["TMDb"])
  ]
)
```

## Setup

### Get an API Key

Create an API Key from The Movie Database web site [https://www.themoviedb.org/documentation/api](https://www.themoviedb.org/documentation/api).

### Set you API Key

Set your API key before making any calls

```swift
TMDbAPI.setAPIKey("ahb4334n43nj34jk43nklkg4")
```

## API Areas

### Certifications

Get an up to date list of the officially supported movie certifications on TMDB.

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

### TV Shows and Seasons

Get information about TV shows.

### TV Show Seasons

Get information about TV show seasons.

## Examples

```swift
TMDbAPI.setAPIKey("ahb4334n43nj34jk43nklkg4")
let tmdb = TMDbAPI.shared
```

### Discover Movies

```swift
// With Combine
tmdb.discover.moviesPublisher()
    .map(\.results)
    .replaceError(with: [])
    .assign(to: \.movies, on: self)
    .store(in: &cancellables)

// With a completion handler
tmdb.discover.fetchMovies { result in
    let movies = (try? result.get())?.results
    ...
}
```

### Trending TV Shows this week, 2nd page

```swift
// With Combine
tmdb.trending.tvShowsPublisher(inTimeWindow: .week, page: 2)
    .map(\.results)
    .replaceError(with: [])
    .assign(to: \.tvShows, on: self)
    .store(in: &cancellables)

// With a completion handler
tmdb.trending.fetchTVShows(inTimeWindow: .week, page: 2) { result in
    let tvShows = (try? result.get())?.results
    ...
}
```

### Popular People

```swift
// With Combine
tmdb.person.popularPublisher()
    .map(\.results)
    .replaceError(with: [])
    .assign(to: \.people, on: self)
    .store(in: &cancellables)

// With a completion handler
tmdb.person.fetchPopular { result in
    let people = (try? result.get())?.results
}
```

## References

* [https://www.themoviedb.org](https://www.themoviedb.org)
* [https://developers.themoviedb.org](https://developers.themoviedb.org)
