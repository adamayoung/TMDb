# Using Auto-Pagination

Iterate through all pages of results without manual pagination.

## Overview

Many TMDb API endpoints return paginated results. The library provides
auto-pagination methods that return `AsyncSequence` types, allowing you
to iterate through all results across all pages without managing
pagination manually. Pages are fetched lazily as items are consumed.

## Item-Level Iteration

Methods prefixed with `all` (e.g., ``MovieService/allPopular(country:language:)``)
return a ``PagedAsyncSequence`` that yields individual items.

```swift
let tmdbClient = TMDbClient(apiKey: "<your-tmdb-api-key>")

// Iterate through all popular movies across all pages
for try await movie in tmdbClient.movies.allPopular() {
    print(movie.title)
    // Automatically fetches the next page when needed
}
```

## Page-Level Iteration

Methods suffixed with `Pages` (e.g., ``MovieService/allPopularPages(country:language:)``)
return a ``PagedPagesAsyncSequence`` that yields entire pages with
metadata.

```swift
// Iterate through pages with metadata
for try await page in tmdbClient.movies.allPopularPages() {
    print("Page \(page.page ?? 0) of \(page.totalPages ?? 0)")
    for movie in page.results {
        print("  - \(movie.title)")
    }
}
```

## Early Termination

Breaking out of the loop stops fetching additional pages, saving
unnecessary network requests.

```swift
// Get only the first 50 top-rated movies
var count = 0
for try await movie in tmdbClient.movies.allTopRated() {
    count += 1
    if count >= 50 { break }
}
```

## Available Services

Auto-pagination is available across 7 services with 32 paginated
endpoints and 64 auto-pagination methods:

- **Movies** — popular, top rated, now playing, upcoming,
  recommendations, similar, reviews, lists
- **TV Series** — popular, top rated, airing today, on the air,
  recommendations, similar, reviews, lists
- **Search** — multi, movies, TV series, people, collections, companies,
  keywords
- **Trending** — movies, TV series, people, all
- **People** — popular, tagged images
- **Discover** — movies, TV series
- **Lists** — list items
