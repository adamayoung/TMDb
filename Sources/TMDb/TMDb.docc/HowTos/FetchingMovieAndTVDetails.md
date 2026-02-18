# Fetching Movie and TV Series Details

Get detailed information about movies and TV series.

## Overview

The ``MovieService`` and ``TVSeriesService`` provide methods to fetch
details, credits, images, videos, and more for individual titles. Access
them through the ``TMDbClient/movies`` and ``TMDbClient/tvSeries``
properties.

## Movie Details

Use ``MovieService/details(forMovie:language:)`` to get details for a
movie.

```swift
let tmdbClient = TMDbClient(apiKey: "<your-tmdb-api-key>")

let movie = try await tmdbClient.movies.details(forMovie: 550)
print("Title: \(movie.title)")
print("Release Date: \(movie.releaseDate?.formatted() ?? "Unknown")")
print("Rating: \(movie.voteAverage)/10")
print("Overview: \(movie.overview)")
```

## Movie Credits

Use ``MovieService/credits(forMovie:language:)`` to get cast and crew.

```swift
let credits = try await tmdbClient.movies.credits(forMovie: 550)

print("Cast:")
for member in credits.cast.prefix(5) {
    print("  \(member.name) as \(member.character)")
}

print("Director:")
if let director = credits.crew.first(where: {
    $0.job == "Director"
}) {
    print("  \(director.name)")
}
```

## Movie Images and Videos

```swift
let images = try await tmdbClient.movies.images(forMovie: 550)
print("Posters: \(images.posters.count)")
print("Backdrops: \(images.backdrops.count)")

let videos = try await tmdbClient.movies.videos(forMovie: 550)
for video in videos.results {
    print("\(video.name) (\(video.type))")
}
```

## Append to Response

Fetch multiple types of data in a single request using
``MovieService/details(forMovie:appending:language:)``.

```swift
let response = try await tmdbClient.movies.details(
    forMovie: 550,
    appending: [.credits, .images, .videos, .reviews]
)

print("Title: \(response.movie.title)")

if let credits = response.credits {
    print("Cast count: \(credits.cast.count)")
}

if let images = response.images {
    print("Image count: \(images.posters.count)")
}
```

## TV Series Details

Use ``TVSeriesService/details(forTVSeries:language:)`` to get TV series
details.

```swift
let tvSeries = try await tmdbClient.tvSeries.details(forTVSeries: 1396)
print("Name: \(tvSeries.name)")
print("Seasons: \(tvSeries.numberOfSeasons ?? 0)")
print("Episodes: \(tvSeries.numberOfEpisodes ?? 0)")
```

## Watch Providers

Find where a movie or TV series is available for streaming.

```swift
let providers = try await tmdbClient.movies.watchProviders(
    forMovie: 550
)

if let usProvider = providers.first(where: {
    $0.countryCode == "US"
}) {
    let streaming = usProvider.watchProviders.flatRate?.map(
        \.name
    ) ?? []
    print("Streaming on: \(streaming.joined(separator: ", "))")
}
```
