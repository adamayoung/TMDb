# Working with Trending Content

Get trending movies, TV series, and people.

## Overview

The ``TrendingService`` provides access to daily and weekly trending
content. Access it through the ``TMDbClient/trending`` property.

## Trending Movies

Use ``TrendingService/movies(inTimeWindow:page:language:)`` to get
trending movies for a daily or weekly time window.

```swift
let tmdbClient = TMDbClient(apiKey: "<your-tmdb-api-key>")

// Get today's trending movies
let dailyTrending = try await tmdbClient.trending.movies(
    inTimeWindow: .day
)

for movie in dailyTrending.results {
    print(movie.title)
}

// Get this week's trending movies
let weeklyTrending = try await tmdbClient.trending.movies(
    inTimeWindow: .week
)
```

## Trending TV Series

```swift
let trendingTV = try await tmdbClient.trending.tvSeries(
    inTimeWindow: .day
)

for series in trendingTV.results {
    print(series.name)
}
```

## Trending People

```swift
let trendingPeople = try await tmdbClient.trending.people(
    inTimeWindow: .week
)

for person in trendingPeople.results {
    print(person.name)
}
```

## Auto-Pagination

Iterate through all trending content across pages.

```swift
for try await movie in tmdbClient.trending.allMovies(
    inTimeWindow: .day
) {
    print(movie.title)
}
```
