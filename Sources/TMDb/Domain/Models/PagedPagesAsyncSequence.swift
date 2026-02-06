//
//  PagedPagesAsyncSequence.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// An async sequence that yields entire pages from paginated API endpoints.
///
/// `PagedPagesAsyncSequence` wraps any paginated endpoint and yields entire `PageableListResult<Result>`
/// pages, fetching pages lazily on demand. This is useful when you need access to page metadata
/// (page number, total results, etc.) in addition to the items.
///
/// ## Example
///
/// ```swift
/// let client = TMDbClient(apiKey: "your-api-key")
///
/// // Iterate through pages of popular movies
/// for try await page in client.movies.allPopularPages() {
///     print("Page \(page.page ?? 0) of \(page.totalPages ?? 0)")
///     print("Total results: \(page.totalResults ?? 0)")
///     for movie in page.results {
///         print("  - \(movie.title)")
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
/// - **Empty first page**: Returns immediately with zero pages
/// - **Nil totalPages**: Continues fetching until receiving an empty `results` array
/// - **Task cancellation**: Throws cancellation error and stops iteration
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public struct PagedPagesAsyncSequence<
    Result: Codable & Identifiable & Equatable & Hashable & Sendable
>: AsyncSequence, Sendable {

    ///
    /// The type of element produced by this async sequence.
    ///
    public typealias Element = PageableListResult<Result>

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
    public typealias PageFetcher = @Sendable (Int) async throws -> PageableListResult<Result>

    private let pageFetcher: PageFetcher

    ///
    /// Creates a new paged pages async sequence.
    ///
    /// - Parameter pageFetcher: A closure that fetches a single page of results.
    ///
    public init(pageFetcher: @escaping PageFetcher) {
        self.pageFetcher = pageFetcher
    }

    ///
    /// Creates an async iterator to iterate through pages.
    ///
    /// - Returns: An iterator for this sequence.
    ///
    public func makeAsyncIterator() -> Iterator {
        Iterator(pageFetcher: pageFetcher)
    }

}

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public extension PagedPagesAsyncSequence {

    ///
    /// An iterator that yields entire pages from paginated results.
    ///
    struct Iterator: AsyncIteratorProtocol {

        private let pageFetcher: PageFetcher
        private var currentPage = 0
        private var totalPages: Int?
        private var finished = false

        init(pageFetcher: @escaping PageFetcher) {
            self.pageFetcher = pageFetcher
        }

        ///
        /// Produces the next page in the sequence.
        ///
        /// - Returns: The next page, or `nil` if the sequence is exhausted.
        /// - Throws: Any error encountered during page fetching or if the task is cancelled.
        ///
        public mutating func next() async throws -> PageableListResult<Result>? {
            // If we're finished, return nil
            if finished {
                return nil
            }

            // Check for cancellation before fetching the next page
            try Task.checkCancellation()

            // Check if we've reached the last page
            if let totalPages, currentPage >= totalPages {
                finished = true
                return nil
            }

            // Fetch the next page
            currentPage += 1
            let page = try await pageFetcher(currentPage)

            // Update total pages if not yet set
            if totalPages == nil {
                totalPages = page.totalPages
            }

            // Check if the page is empty
            if page.results.isEmpty {
                finished = true
                return nil
            }

            return page
        }

    }

}
