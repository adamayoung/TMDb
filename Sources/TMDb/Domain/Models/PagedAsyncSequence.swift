//
//  PagedAsyncSequence.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// An async sequence that yields individual items from paginated API endpoints.
///
/// `PagedAsyncSequence` wraps any paginated endpoint and yields individual items across all pages,
/// fetching pages lazily on demand. This eliminates manual pagination boilerplate and provides a
/// clean, Swift-native iteration pattern.
///
/// ## Example
///
/// ```swift
/// let client = TMDbClient(apiKey: "your-api-key")
///
/// // Iterate through all popular movies across all pages
/// for try await movie in client.movies.allPopular() {
///     print(movie.title)
///     if someCondition {
///         break // Stops fetching additional pages
///     }
/// }
/// ```
///
/// ## Behavior
///
/// - **Lazy fetching**: Pages are fetched only when needed, one at a time
/// - **Automatic termination**: Stops when reaching the last page (based on `totalPages`) or an empty page
/// - **Cancellation support**: Respects `Task` cancellation via `Task.checkCancellation()`
/// - **Error propagation**: Errors from the page fetcher propagate immediately and stop iteration
/// - **Early break**: Breaking from the loop stops fetching additional pages
///
/// ## Edge Cases
///
/// - **Empty first page**: Returns immediately with zero items
/// - **Unknown `totalPages` (`0`)**: Continues fetching until receiving an empty `results` array
/// - **Task cancellation**: Throws cancellation error and stops iteration
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public struct PagedAsyncSequence<Element: Codable & Identifiable & Equatable & Hashable & Sendable>:
AsyncSequence, Sendable {

    ///
    /// The type of element produced by this async sequence.
    ///
    public typealias Element = Element

    ///
    /// The type of async iterator used to iterate through elements.
    ///
    public typealias AsyncIterator = Iterator

    ///
    /// A closure that fetches a single page of results.
    ///
    /// - Parameter page: The page number to fetch (1-based).
    /// - Returns: A `PageableListResult` containing the requested page.
    /// - Throws: Any error encountered during the fetch operation.
    ///
    public typealias PageFetcher = @Sendable (Int) async throws -> PageableListResult<Element>

    private let pageFetcher: PageFetcher
    private let prefetchEnabled: Bool

    ///
    /// Creates a new paged async sequence.
    ///
    /// - Parameter pageFetcher: A closure that fetches a single page of results.
    ///
    public init(pageFetcher: @escaping PageFetcher) {
        self.init(pageFetcher: pageFetcher, prefetchEnabled: false)
    }

    private init(pageFetcher: @escaping PageFetcher, prefetchEnabled: Bool) {
        self.pageFetcher = pageFetcher
        self.prefetchEnabled = prefetchEnabled
    }

    ///
    /// Returns a copy of this sequence that prefetches the next page.
    ///
    /// With prefetch enabled, the next page begins fetching concurrently as the current page's last
    /// item is consumed, hiding inter-page network latency on long scans. The emitted items are
    /// identical to the default lazy sequence.
    ///
    /// - Important: Prefetch is opt-in because it trades up to **one** speculative request for lower
    /// latency. On an early `break` at most one in-flight prefetch may run to completion (the
    /// value-type iterator has no `deinit` to cancel it on drop). The sequence must be iterated by a
    /// **single consumer** — the standard `AsyncIteratorProtocol` contract; sharing one iterator
    /// across tasks is not supported.
    ///
    /// - Returns: A sequence that prefetches one page ahead while iterating.
    ///
    public func prefetchingNextPage() -> Self {
        Self(pageFetcher: pageFetcher, prefetchEnabled: true)
    }

    ///
    /// Creates an async iterator to iterate through elements.
    ///
    /// - Returns: An iterator for this sequence.
    ///
    public func makeAsyncIterator() -> Iterator {
        Iterator(pageFetcher: pageFetcher, prefetchEnabled: prefetchEnabled)
    }

}

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public extension PagedAsyncSequence {

    ///
    /// An iterator that yields individual items from paginated results.
    ///
    struct Iterator: AsyncIteratorProtocol {

        private let pageFetcher: PageFetcher
        private let prefetchEnabled: Bool
        private var currentPage = 0
        private var totalPages: Int?
        private var buffer: [Element] = []
        private var bufferIndex = 0
        private var finished = false
        private var prefetchTask: Task<PageableListResult<Element>, Error>?
        private var prefetchedPage: Int?

        init(pageFetcher: @escaping PageFetcher, prefetchEnabled: Bool) {
            self.pageFetcher = pageFetcher
            self.prefetchEnabled = prefetchEnabled
        }

        ///
        /// Produces the next element in the sequence.
        ///
        /// - Returns: The next element, or `nil` if the sequence is exhausted.
        /// - Throws: Any error encountered during page fetching or if the task is cancelled.
        ///
        public mutating func next() async throws -> Element? {
            // If we're finished, return nil
            if finished {
                return nil
            }

            // If buffer has remaining items, return the next one
            if bufferIndex < buffer.count {
                defer {
                    bufferIndex += 1
                    startPrefetchIfNeeded()
                }
                return buffer[bufferIndex]
            }

            // Check for cancellation before fetching the next page
            try Task.checkCancellation()

            // Check if we've reached the last page
            if let totalPages, currentPage >= totalPages {
                finished = true
                return nil
            }

            // Fetch the next page (awaiting an in-flight prefetch when present)
            let page = try await fetchNextPage()

            // Update total pages if not yet set. A non-positive `totalPages`
            // means the endpoint did not report a total, so leave the cap unset
            // and continue fetching until an empty page.
            if totalPages == nil, page.totalPages > 0 {
                totalPages = page.totalPages
            }

            // Check if the page is empty
            if page.results.isEmpty {
                finished = true
                return nil
            }

            // Load the buffer with new items
            buffer = page.results
            bufferIndex = 0

            // Return the first item from the buffer
            defer {
                bufferIndex += 1
                startPrefetchIfNeeded()
            }
            return buffer[bufferIndex]
        }

        /// Fetches the next page, consuming an in-flight prefetch if one exists.
        private mutating func fetchNextPage() async throws -> PageableListResult<Element> {
            if let task = prefetchTask, let prefetchedPage {
                prefetchTask = nil
                self.prefetchedPage = nil
                currentPage = prefetchedPage
                // Forward consumer cancellation into the in-flight prefetch.
                return try await withTaskCancellationHandler {
                    try await task.value
                } onCancel: {
                    task.cancel()
                }
            }

            currentPage += 1
            return try await pageFetcher(currentPage)
        }

        /// Starts a one-page lookahead once the current buffer's last item is served.
        private mutating func startPrefetchIfNeeded() {
            guard prefetchEnabled,
                  prefetchTask == nil,
                  !finished,
                  !buffer.isEmpty,
                  bufferIndex == buffer.count,
                  PrefetchPolicy.shouldPrefetchNext(currentPage: currentPage, totalPages: totalPages)
            else {
                return
            }

            let nextPage = currentPage + 1
            let fetcher = pageFetcher
            prefetchedPage = nextPage
            prefetchTask = Task { try await fetcher(nextPage) }
        }

    }

}
