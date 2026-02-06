# PRD-003: AsyncSequence Auto-Pagination

| Field    | Value                                  |
|----------|----------------------------------------|
| Priority | Medium                                 |
| Effort   | Medium                                 |
| Status   | Complete                               |

## Problem Statement

All list endpoints in the TMDb Swift package return a single
`PageableListResult<T>` page. To fetch all results, consumers must
manually implement pagination:

```swift
var allMovies: [MovieListItem] = []
var page = 1
var totalPages = 1

repeat {
    let result = try await client.movies.popular(page: page)
    allMovies.append(contentsOf: result.results)
    totalPages = result.totalPages ?? 1
    page += 1
} while page <= totalPages
```

This is boilerplate-heavy, error-prone (off-by-one bugs, missing
total-pages handling), and doesn't leverage Swift's structured
concurrency.

## Proposed Solution

Provide an `AsyncSequence`-based API that automatically fetches
subsequent pages, letting consumers iterate through all results with
`for await`:

```swift
// Iterate over all items across all pages (yields MovieListItem)
for try await movie in client.movies.allPopular() {
    print(movie.title)
}

// Or collect all pages (yields PageableListResult<MovieListItem>)
for try await page in client.movies.allPopularPages() {
    print("Page \(page.page ?? 0) of \(page.totalPages ?? 0)")
    process(page.results)
}
```

### Two Levels of Abstraction

1. **Item-level** — yields individual items from all pages
2. **Page-level** — yields entire `PageableListResult<T>` pages

Both are lazy: pages are fetched on demand as the consumer iterates.

## Technical Design

### Core Type: `PagedAsyncSequence`

A generic `AsyncSequence` that wraps any paginated endpoint:

```swift
/// An asynchronous sequence that lazily fetches pages from a
/// paginated TMDb API endpoint.
public struct PagedAsyncSequence<Element: Codable & Identifiable
    & Equatable & Hashable & Sendable>: AsyncSequence, Sendable {

    public typealias PageFetcher = @Sendable (Int) async throws
        -> PageableListResult<Element>

    private let fetchPage: PageFetcher

    init(fetchPage: @escaping PageFetcher) {
        self.fetchPage = fetchPage
    }

    public func makeAsyncIterator() -> AsyncIterator {
        AsyncIterator(fetchPage: fetchPage)
    }

    public struct AsyncIterator: AsyncIteratorProtocol {
        private let fetchPage: PageFetcher
        private var currentPage = 1
        private var totalPages: Int?
        private var buffer: [Element] = []
        private var bufferIndex = 0
        private var finished = false

        init(fetchPage: @escaping PageFetcher) {
            self.fetchPage = fetchPage
        }

        public mutating func next() async throws -> Element? {
            // Return buffered items first
            if bufferIndex < buffer.count {
                let item = buffer[bufferIndex]
                bufferIndex += 1
                return item
            }

            // Check if we've exhausted all pages
            if finished { return nil }
            if let total = totalPages, currentPage > total {
                finished = true
                return nil
            }

            // Respect cooperative cancellation
            try Task.checkCancellation()

            // Fetch next page
            let page = try await fetchPage(currentPage)
            totalPages = page.totalPages
            currentPage += 1
            buffer = page.results
            bufferIndex = 0

            if buffer.isEmpty {
                finished = true
                return nil
            }

            let item = buffer[bufferIndex]
            bufferIndex += 1
            return item
        }
    }
}
```

### Page-Level Sequence

The page-level sequence uses a different generic parameter name to
avoid shadowing the `AsyncSequence.Element` associated type:

```swift
/// An asynchronous sequence that yields entire pages.
public struct PagedPagesAsyncSequence<Result: Codable & Identifiable
    & Equatable & Hashable & Sendable>: AsyncSequence, Sendable {

    public typealias Element = PageableListResult<Result>
    // Similar structure to PagedAsyncSequence, yielding whole
    // PageableListResult<Result> values instead of individual items
}
```

### Integration With Services

Add convenience methods to service protocols. Two approaches:

**Option A (recommended): Named extension methods on service
protocols**

The convenience methods use a distinct name (e.g., `allPopular`) to
avoid ambiguity with existing default-parameter extensions that
already have `page: Int? = nil`. Adding a pageless `popular()`
overload would be ambiguous at call sites.

```swift
extension MovieService {
    /// Returns an async sequence of all popular movies across all
    /// pages.
    func allPopular(
        country: String? = nil,
        language: String? = nil
    ) -> PagedAsyncSequence<MovieListItem> {
        PagedAsyncSequence { page in
            try await self.popular(page: page, country: country,
                                   language: language)
        }
    }
}

// Usage — note: yields MovieListItem (summary), not Movie (full detail)
for try await movie in client.movies.allPopular() {
    print(movie.title)
}
```

**Important:** Paginated endpoints return list item types (e.g.,
`MovieListItem`, `TVSeriesListItem`, `PersonListItem`), not full
detail types (`Movie`, `TVSeries`, `Person`). The `PagedAsyncSequence`
element type must match the `PageableListResult`'s `Result` type.
For example, `MovieService.popular()` returns
`MoviePageableList` (i.e., `PageableListResult<MovieListItem>`), so
the sequence element type is `MovieListItem`.

This avoids modifying service protocols and implementations. The
`all`-prefixed methods return an `AsyncSequence` while the existing
`page:` overloads remain unchanged.

**Option B: Standalone function**

```swift
func allPages<T>(
    fetching: @escaping @Sendable (Int) async throws
        -> PageableListResult<T>
) -> PagedAsyncSequence<T> {
    PagedAsyncSequence(fetchPage: fetching)
}

// Usage
for try await movie in allPages(fetching: { page in
    try await client.movies.popular(page: page)
}) {
    print(movie.title)
}
```

### Applicable Endpoints

Any method returning `PageableListResult<T>`:

| Service | Methods |
|---------|---------|
| `MovieService` | `popular`, `topRated`, `nowPlaying`, `upcoming`, `recommendations`, `similar`, `reviews`, `lists` |
| `TVSeriesService` | `popular`, `topRated`, `airingToday`, `onTheAir`, `recommendations`, `similar`, `reviews`, `lists` |
| `PersonService` | `popular` |
| `TrendingService` | `movies`, `tvSeries`, `people`, `allTrending` (PRD-001) |
| `SearchService` | `movies`, `tvSeries`, `people`, `multi`, `collections`, `companies`, `keywords` |
| `DiscoverService` | `movies`, `tvSeries` |
| `ListService` | `items` (list contents are paginated) |

### Files to Create

| File | Purpose |
|------|---------|
| `Sources/TMDb/Domain/Models/PagedAsyncSequence.swift` | Item-level async sequence |
| `Sources/TMDb/Domain/Models/PagedPagesAsyncSequence.swift` | Page-level async sequence |

### Files to Create (Convenience Extensions)

Each extension file provides `all`-prefixed methods that return
`PagedAsyncSequence` or `PagedPagesAsyncSequence`:

| File | Methods |
|------|---------|
| `Sources/TMDb/Domain/Services/Movies/MovieService+Pagination.swift` | `allPopular`, `allPopularPages`, `allTopRated`, `allTopRatedPages`, `allNowPlaying`, `allUpcoming`, `allRecommendations`, `allSimilar`, `allReviews`, `allLists` |
| `Sources/TMDb/Domain/Services/TVSeries/TVSeriesService+Pagination.swift` | `allPopular`, `allTopRated`, `allAiringToday`, `allOnTheAir`, `allRecommendations`, `allSimilar`, `allReviews`, `allLists` |
| `Sources/TMDb/Domain/Services/People/PersonService+Pagination.swift` | `allPopular` |
| `Sources/TMDb/Domain/Services/Trending/TrendingService+Pagination.swift` | `allMoviesTrending`, `allTVSeriesTrending`, `allPeopleTrending`, `allTrending` (requires PRD-001) |
| `Sources/TMDb/Domain/Services/Search/SearchService+Pagination.swift` | `allMovies`, `allTVSeries`, `allPeople`, `allMulti`, `allCollections`, `allCompanies`, `allKeywords` |
| `Sources/TMDb/Domain/Services/Discover/DiscoverService+Pagination.swift` | `allMovies`, `allTVSeries` |

### Files to Modify

| File | Change |
|------|--------|
| DocC extension files | Document new convenience methods |
| `Sources/TMDb/TMDb.docc/TMDb.md` | Add new types to topic sections |

### Error Handling

If a page fetch throws an error, the error propagates directly to the
consumer through the `for try await` loop. The sequence does not retry
or skip failed pages — that responsibility belongs to the networking
layer (see PRD-004). After an error, the iterator is considered
finished; subsequent calls to `next()` return `nil`.

### Cancellation and Back-Pressure

- Iteration stops when the consumer breaks out of the `for await`
  loop, leveraging structured concurrency's cooperative cancellation
- No prefetching: pages are fetched strictly on demand
- Each `next()` call checks `Task.isCancelled` before making a
  network request

### Rate Limiting Interaction

If the TMDb API returns a 429 during pagination, the error propagates
to the consumer. PRD-004 (automatic retry) would handle this
transparently if implemented.

### Swift 6 Considerations

In Swift 6, `AsyncSequence` and `AsyncIteratorProtocol` have evolved.
The iterator struct pattern with `mutating func next()` is compatible.
Ensure `PagedAsyncSequence` compiles cleanly with strict concurrency
checking enabled (the project already uses Swift 6 strict concurrency).

## Acceptance Criteria

- [ ] `PagedAsyncSequence` conforms to `AsyncSequence` and `Sendable`
- [ ] Iteration lazily fetches pages (no prefetching)
- [ ] Iteration stops after the last page (`totalPages`)
- [ ] Iteration handles empty pages and nil `totalPages` gracefully
- [ ] Cancellation is respected (no network calls after cancellation)
- [ ] Existing paginated methods remain unchanged (no breaking changes)
- [ ] At least `MovieService.allPopular`, `SearchService.allMovies`,
      and `TrendingService.allMovies` have convenience extensions
- [ ] Unit tests verify page iteration, early termination, and error
      propagation
- [ ] Integration tests confirm multi-page iteration with the live API
- [ ] `make ci` passes

## Dependencies

- **PRD-001** — the `allTrending` convenience extension references
  `TrendingService.allTrending(inTimeWindow:page:language:)` added in
  PRD-001. Implement PRD-001 first, or skip the trending convenience
  extension until then.

## Out of Scope

- Concurrent page fetching (prefetching next page while consuming
  current)
- Configurable page size (TMDb API uses a fixed page size of 20)
- Caching of fetched pages (see PRD-005)
- Reverse pagination or random page access
