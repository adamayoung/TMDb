# Searching for Content

Search across movies, TV series, people, and more.

## Overview

The ``SearchService`` provides methods to search for movies, TV series,
people, collections, companies, and keywords. Access it through the
``TMDbClient/search`` property.

## Multi-Search

Use ``SearchService/searchAll(query:filter:page:language:)`` to search
across movies, TV series, and people in a single request.

```swift
let tmdbClient = TMDbClient(apiKey: "<your-tmdb-api-key>")

let results = try await tmdbClient.search.searchAll(
    query: "Breaking Bad"
)

for item in results.results {
    switch item {
    case let .movie(movie):
        print("Movie: \(movie.title)")
    case let .tvSeries(tvSeries):
        print("TV: \(tvSeries.name)")
    case let .person(person):
        print("Person: \(person.name)")
    }
}
```

## Searching for Movies

Use ``SearchService/searchMovies(query:filter:page:language:)`` to
search specifically for movies.

```swift
let movies = try await tmdbClient.search.searchMovies(
    query: "Inception"
)

for movie in movies.results {
    print("\(movie.title) (\(movie.releaseDate?.formatted(.dateTime.year()) ?? "Unknown"))")
}
```

## Searching for TV Series

```swift
let tvSeries = try await tmdbClient.search.searchTVSeries(
    query: "The Office"
)

for series in tvSeries.results {
    print(series.name)
}
```

## Searching for People

```swift
let people = try await tmdbClient.search.searchPeople(
    query: "Tom Hanks"
)

for person in people.results {
    print("\(person.name) — \(person.knownForDepartment ?? "")")
}
```

## Auto-Pagination

Iterate through all search results across pages using the `all*` methods.

```swift
// Iterate through all movie results
for try await movie in tmdbClient.search.allMovies(
    query: "Star Wars"
) {
    print(movie.title)
}

// Iterate through result pages with metadata
for try await page in tmdbClient.search.allMoviesPages(
    query: "Star Wars"
) {
    print("Page \(page.page ?? 0) of \(page.totalPages ?? 0)")
    for movie in page.results {
        print("  - \(movie.title)")
    }
}
```
