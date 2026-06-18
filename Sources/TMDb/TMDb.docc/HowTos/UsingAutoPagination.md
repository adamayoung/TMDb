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
    print("Page \(page.page) of \(page.totalPages)")
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

## Prefetching the Next Page

By default pages are fetched lazily — the next page is requested only once the
current page is exhausted. Call ``PagedAsyncSequence/prefetchingNextPage()`` (or
``PagedPagesAsyncSequence/prefetchingNextPage()``) to fetch the next page
concurrently as the current page is consumed, hiding inter-page latency on long
scans.

```swift
for try await movie in tmdbClient.movies.allPopular().prefetchingNextPage() {
    print(movie.title)
}
```

Prefetch is opt-in: it trades at most one extra (possibly wasted) request on an
early `break` for lower latency, and the emitted items are identical to the
default lazy sequence. Iterate a prefetching sequence from a single consumer.

## Available Services

Auto-pagination is available across 11 services with 47 paginated
endpoints and 94 auto-pagination methods:

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
- **Account** — favourite movies, favourite TV series, movie watchlist,
  TV series watchlist, rated movies, rated TV series, rated TV episodes,
  lists
- **Guest Sessions** — rated movies, rated TV series, rated TV episodes
- **Keywords** — movies
- **Changes** — movie, TV series, person
