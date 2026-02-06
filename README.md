# TMDb - The Movie Database

[![CI](https://github.com/adamayoung/TMDb/actions/workflows/ci.yml/badge.svg)](https://github.com/adamayoung/TMDb/actions/workflows/ci.yml)
[![Integration](https://github.com/adamayoung/TMDb/actions/workflows/integration.yml/badge.svg)](https://github.com/adamayoung/TMDb/actions/workflows/integration.yml)
[![CodeQL](https://github.com/adamayoung/TMDb/actions/workflows/codeql.yml/badge.svg)](https://github.com/adamayoung/TMDb/actions/workflows/codeql.yml)
[![Documentation](https://github.com/adamayoung/TMDb/actions/workflows/documentation.yml/badge.svg)](https://github.com/adamayoung/TMDb/actions/workflows/documentation.yml)
[![codecov](https://codecov.io/gh/adamayoung/TMDb/graph/badge.svg?token=TICHRASF6F)](https://codecov.io/gh/adamayoung/TMDb)
[![Swift 6.0+](https://img.shields.io/badge/Swift-6.0+-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%20|%20macOS%20|%20watchOS%20|%20tvOS%20|%20visionOS%20|%20Linux%20|%20Windows-blue.svg)](https://github.com/adamayoung/TMDb)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](LICENSE)

A Swift Package for The Movie Database (TMDb) <https://www.themoviedb.org>

## Features

* **Comprehensive API Coverage**: Full support for TMDb API v3 with 25
  specialized services
* **Append to Response**: Fetch details with credits, images, videos,
  and more in a single request using `append_to_response`
* **Movie & TV Data**: Details, credits, images, videos, reviews,
  recommendations, similar content
* **Discovery & Search**: Advanced filtering, multi-type search,
  trending content
* **User Features**: Account management, favorites, watchlists, ratings
  (requires authentication)
* **Metadata**: Genres, certifications, companies, collections, watch
  providers
* **Image Generation**: Built-in URL generation for all image types with
  size optimization
* **Swift 6 Ready**: Full strict concurrency support with Sendable types
* **Cross-Platform**: iOS 16+, macOS 13+, watchOS 9+, tvOS 16+,
  visionOS 1+, Linux, Windows
* **Modern Swift**: Async/await throughout, strongly-typed models,
  protocol-based architecture

## Available Services

| Service | Description |
| ------- | ----------- |
| **movies** | Movie details, credits, keywords, images, videos, reviews, recommendations, similar, releases, watch providers, append-to-response |
| **tvSeries** | TV show details, credits, images, videos, reviews, recommendations, similar, watch providers, screened theatrically, episode groups, append-to-response |
| **tvSeasons** | Season-specific details, aggregate credits, credits, images, videos, translations, watch providers, append-to-response |
| **tvEpisodes** | Episode-specific details, credits, images, videos, translations, append-to-response |
| **people** | Person details, combined/movie/TV credits, images, external links, translations, append-to-response |
| **search** | Multi-search across movies, TV shows, people, collections, companies, keywords |
| **discover** | Advanced filtering for movies and TV shows with 30+ filter options |
| **trending** | Trending movies, TV shows, people, and all media (daily/weekly) |
| **find** | Find movies, TV shows, and people by external IDs (IMDb, TVDB, etc.) |
| **account** | User favorites, watchlist, rated items (requires authentication) |
| **authentication** | Session management, guest sessions, request tokens |
| **genres** | Genre lists for movies and TV shows |
| **keywords** | Keyword details and movies by keyword |
| **networks** | TV network details, alternative names, logos |
| **watchProviders** | Streaming availability by region |
| **certifications** | Content ratings (G, PG, R, etc.) |
| **collections** | Movie collection details, images, translations |
| **companies** | Production company details, alternative names, logos |
| **lists** | Custom list management (requires authentication) |
| **configurations** | API configuration, countries, jobs, languages, primary translations, timezones |
| **changes** | Track changes to movies, TV series, people, seasons, and episodes |
| **credits** | Credit details including person and media information |
| **reviews** | Review details with author and media information |
| **tvEpisodeGroups** | TV episode group details and episode organization |
| **guestSessions** | Guest session rated movies, TV series, and episodes |

See the [full API documentation](https://adamayoung.github.io/TMDb/documentation/tmdb/)
for detailed usage.

## Requirements

* Swift 6.0+
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
// swift-tools-version:6.0

import PackageDescription

let package = Package(
  name: "MyProject",

  dependencies: [
    .package(url: "https://github.com/adamayoung/TMDb.git", from: "14.0.0")
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

### Quick Start

```swift
import TMDb

// Initialize client
let tmdbClient = TMDbClient(apiKey: "<your-tmdb-api-key>")

// Discover movies with filters
let popularMovies = try await tmdbClient.discover.movies(
    sortedBy: .popularity(descending: true)
).results

// Get movie details
let fightClub = try await tmdbClient.movies.details(forMovie: 550)
print("Title: \(fightClub.title)")
print("Release Date: \(fightClub.releaseDate)")
print("Rating: \(fightClub.voteAverage)/10")

// Search across movies, TV shows, and people
let searchResults = try await tmdbClient.search.multi(query: "Breaking Bad")

// Get trending movies today
let trendingMovies = try await tmdbClient.trending.movies(inTimeWindow: .day)

// Get streaming providers for a movie
let watchProviders = try await tmdbClient.movies.watchProviders(forMovie: 550)
if let usProvider = watchProviders.first(where: { $0.countryCode == "US" }) {
    print("Available on: \(usProvider.watchProviders.flatRate?.map(\.providerName) ?? [])")
}

// Generate poster image URL
let config = try await tmdbClient.configurations.apiConfiguration()
if let posterPath = fightClub.posterPath {
    let posterURL = config.images.posterURL(for: posterPath, idealWidth: 500)
}
```

### Configuration

By default, the TMDb client automatically uses your system's language and
country settings from `Locale.current`:

```swift
import TMDb

// Uses system locale automatically (recommended)
let tmdbClient = TMDbClient(apiKey: "<your-api-key>")
```

You can also configure the client with custom language and country settings:

```swift
// Custom configuration
let configuration = TMDbConfiguration(
    defaultLanguage: "es-ES",  // ISO 639-1 language code
    defaultCountry: "ES"       // ISO 3166-1 country code
)
let tmdbClient = TMDbClient(apiKey: "<your-api-key>", configuration: configuration)

// Disable locale defaults (API determines language)
let tmdbClient = TMDbClient(apiKey: "<your-api-key>", configuration: .default)
```

Per-request overrides are always available:

```swift
// Override language for a specific request
let movieInFrench = try await tmdbClient.movies.details(forMovie: 550, language: "fr")
```

## Common Use Cases

### Displaying Movie Details

```swift
let movie = try await tmdbClient.movies.details(forMovie: movieId)
let credits = try await tmdbClient.movies.credits(forMovie: movieId)
let images = try await tmdbClient.movies.images(forMovie: movieId)
```

### Building a Discover/Browse Interface

```swift
let movies = try await tmdbClient.discover.movies(
    sortedBy: .popularity(descending: true),
    withGenres: [28, 12], // Action & Adventure
    releaseDateGTE: Date().addingTimeInterval(-365*24*60*60) // Last year
)
```

### Getting Watch Providers (Streaming Availability)

```swift
let providers = try await tmdbClient.movies.watchProviders(forMovie: movieId)
if let usProvider = providers.first(where: { $0.countryCode == "US" }) {
    print("Available on: \(usProvider.watchProviders.flatRate?.map(\.providerName) ?? [])")
}
```

### User Account Features (Authentication Required)

```swift
// Add to favorites
try await tmdbClient.account.addToFavourites(movie: movieId, accountId: accountId)

// Rate a movie
try await tmdbClient.movies.addRating(8.5, toMovie: movieId)

// Get watchlist
let watchlist = try await tmdbClient.account.movieWatchlist(accountId: accountId)
```

## Documentation

Documentation and examples of usage can be found at
[https://adamayoung.github.io/TMDb/documentation/tmdb/](https://adamayoung.github.io/TMDb/documentation/tmdb/)

## Related Resources

* [TMDb API Documentation](https://developer.themoviedb.org/docs)
* [Swift Package Index](https://swiftpackageindex.com/adamayoung/TMDb)
* [Full API Reference](https://adamayoung.github.io/TMDb/documentation/tmdb/)
* [Getting Started Guide](https://adamayoung.github.io/TMDb/documentation/tmdb/creatingtmdbclient)
* [Image URL Generation Guide](https://adamayoung.github.io/TMDb/documentation/tmdb/generatingimageurls)

## Development

### Prerequisites

Xcode 16.0+
Swift 6.0+
Homebrew

#### Homebrew

Install [homebrew](https://brew.sh) and the following formulae

* [swiftlint](https://github.com/realm/SwiftLint)
* [swiftformat](https://github.com/nicklockwood/SwiftFormat)
* [markdownlint](https://github.com/igorshubovych/markdownlint-cli)
* [xcsift](https://github.com/ldomaradzki/xcsift)

```bash
brew install swiftlint swiftformat markdownlint xcsift
```

### Before Submitting a PR

See [CLAUDE.md](CLAUDE.md) for comprehensive development guidelines including:

* Testing requirements (unit and integration tests)
* Code style enforcement with swift-format
* DocC documentation requirements
* Complete CI check commands

Quick reference:

```bash
make format        # Auto-format code
make lint          # Check code style
make test          # Run unit tests
make ci            # Full CI validation
```

**Important**: Both unit tests AND integration tests must pass.
Integration tests require these environment variables:

* `TMDB_API_KEY` - Your TMDb API key
* `TMDB_USERNAME` - Your TMDb username
* `TMDB_PASSWORD` - Your TMDB password

Running unit tests on Linux requires [Docker](https://www.docker.com) to be running.

## Acknowledgments

* [The Movie Database (TMDb)](https://www.themoviedb.org) for providing
  the comprehensive movie and TV data API
* [JustWatch](https://www.justwatch.com) for watch provider data
* All contributors who have helped improve this library

**Disclaimer**: This product uses the TMDb API but is not endorsed or
certified by TMDb.

## License

This library is licensed under the Apache License 2.0. See
[LICENSE](https://github.com/adamayoung/TMDb/blob/main/LICENSE) for details.
