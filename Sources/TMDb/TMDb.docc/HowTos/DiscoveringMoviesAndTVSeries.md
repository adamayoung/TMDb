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

### Composing Filters Fluently

Filters also expose copy-returning builder methods so they can be composed
incrementally. Each method returns a new filter, leaving the original
unchanged.

```swift
let filter = DiscoverMovieFilter()
    .withGenres([28, 12])
    .voteAverage(in: 7...10)
    .primaryReleaseYear(.on(2024))
```

Range-typed conveniences map a `ClosedRange` onto the underlying minimum and
maximum fields for ``DiscoverMovieFilter/voteAverage(in:)``,
``DiscoverMovieFilter/voteCount(in:)`` and
``DiscoverMovieFilter/runtime(in:)``.

### Combining Values with AND or OR

Multi-valued parameters such as genres and keywords are joined with a
logical `AND` by default, meaning a result must match **every** value. Use
``DiscoverFilterJoin/or`` to match **any** value instead.

```swift
// Movies tagged with genre 28 OR genre 12
let filter = DiscoverMovieFilter().withGenres([28, 12], joinedBy: .or)
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
