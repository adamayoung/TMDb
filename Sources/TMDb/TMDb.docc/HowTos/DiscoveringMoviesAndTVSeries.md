# Discovering Movies and TV Series

Browse and filter movies and TV series with advanced options.

## Overview

The ``DiscoverService`` lets you find movies and TV series using a wide
range of filters and sorting options. Access it through the
``TMDbClient/discover`` property.

## Discovering Movies

Use ``DiscoverService/movies(filter:sortedBy:page:language:)`` to browse
movies with optional filtering and sorting.

```swift
let tmdbClient = TMDbClient(apiKey: "<your-tmdb-api-key>")

// Discover popular movies (no filters)
let popularMovies = try await tmdbClient.discover.movies()

// Sort by popularity
let sorted = try await tmdbClient.discover.movies(
    sortedBy: .popularity(descending: true)
)

for movie in sorted.results {
    print(movie.title)
}
```

## Filtering Movies

Use ``DiscoverMovieFilter`` to narrow results by genre, release date,
vote average, and more.

```swift
// Action & Adventure movies from the last year
let currentYear = Calendar.current.component(.year, from: Date())
let filter = DiscoverMovieFilter(
    genres: [28, 12],
    primaryReleaseYear: .between(
        start: currentYear - 1,
        end: currentYear
    )
)

let actionMovies = try await tmdbClient.discover.movies(
    filter: filter,
    sortedBy: .popularity(descending: true)
)
```

## Discovering TV Series

Use ``DiscoverService/tvSeries(filter:sortedBy:page:language:)`` to
browse TV series with similar filtering options.

```swift
let tvSeries = try await tmdbClient.discover.tvSeries(
    sortedBy: .popularity(descending: true)
)

for series in tvSeries.results {
    print(series.name)
}
```

## Auto-Pagination

Iterate through all pages of results automatically using
``DiscoverService/allMovies(filter:sortedBy:language:)`` or
``DiscoverService/allTVSeries(filter:sortedBy:language:)``.

```swift
// Iterate through ALL popular movies across all pages
for try await movie in tmdbClient.discover.allMovies(
    sortedBy: .popularity(descending: true)
) {
    print(movie.title)
}

// Early break stops fetching additional pages
var count = 0
for try await movie in tmdbClient.discover.allMovies() {
    count += 1
    if count >= 50 { break }
}
```
