//
//  MockDiscoverService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

///
/// A mock `DiscoverService` for use in tests.
///
/// Each method records the calls it receives and returns an injectable stubbed
/// result. By default a freshly-constructed mock returns sample data, so it can
/// be used with zero setup; inject a `Result` into the matching `*Result`
/// property to control the outcome of a method — assert on the value you
/// injected, not on the believable defaults.
///
/// The mock is safe to share across concurrent calls: its recorded state is
/// guarded by a lock.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public final class MockDiscoverService: DiscoverService, @unchecked Sendable {

    private let lock = NSLock()
    private var storage = Storage()

    private struct Storage {
        var moviesCalls: [MoviesCall] = []
        var moviesResult: Result<MoviePageableList, TMDbError> = .success(.sample)
        var tvSeriesCalls: [TVSeriesCall] = []
        var tvSeriesResult: Result<TVSeriesPageableList, TMDbError> = .success(.sample)
    }

    ///
    /// Creates a mock discover service.
    ///
    public init() {}

    private func withLock<R>(_ body: () -> R) -> R {
        lock.lock()
        defer { lock.unlock() }
        return body()
    }

    // MARK: - movies

    ///
    /// The arguments of a single call to ``movies(filter:sortedBy:page:language:)``.
    ///
    public struct MoviesCall: Sendable {
        ///
        /// The `filter` argument the method was called with.
        ///
        public let filter: DiscoverMovieFilter?
        ///
        /// The `sortedBy` argument the method was called with.
        ///
        public let sortedBy: MovieSort?
        ///
        /// The `page` argument the method was called with.
        ///
        public let page: Int?
        ///
        /// The `language` argument the method was called with.
        ///
        public let language: String?
    }

    ///
    /// The recorded calls to ``movies(filter:sortedBy:page:language:)``, in the order they
    /// were made.
    ///
    public var moviesCalls: [MoviesCall] {
        withLock { storage.moviesCalls }
    }

    ///
    /// The stubbed result returned by ``movies(filter:sortedBy:page:language:)``.
    ///
    public var moviesResult: Result<MoviePageableList, TMDbError> {
        get { withLock { storage.moviesResult } }
        set { withLock { storage.moviesResult = newValue } }
    }

    ///
    /// Records the call and returns ``moviesResult``.
    ///
    /// - Parameters:
    ///   - filter: Movie filter to apply to the discovery.
    ///   - sortedBy: How results should be sorted.
    ///   - page: The page of results to return.
    ///   - language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed pageable list of movies.
    ///
    public func movies(
        filter: DiscoverMovieFilter?,
        sortedBy: MovieSort?,
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> MoviePageableList {
        let result = withLock {
            storage.moviesCalls.append(
                MoviesCall(filter: filter, sortedBy: sortedBy, page: page, language: language)
            )
            return storage.moviesResult
        }

        return try result.get()
    }

    // MARK: - tvSeries

    ///
    /// The arguments of a single call to ``tvSeries(filter:sortedBy:page:language:)``.
    ///
    public struct TVSeriesCall: Sendable {
        ///
        /// The `filter` argument the method was called with.
        ///
        public let filter: DiscoverTVSeriesFilter?
        ///
        /// The `sortedBy` argument the method was called with.
        ///
        public let sortedBy: TVSeriesSort?
        ///
        /// The `page` argument the method was called with.
        ///
        public let page: Int?
        ///
        /// The `language` argument the method was called with.
        ///
        public let language: String?
    }

    ///
    /// The recorded calls to ``tvSeries(filter:sortedBy:page:language:)``, in the order they
    /// were made.
    ///
    public var tvSeriesCalls: [TVSeriesCall] {
        withLock { storage.tvSeriesCalls }
    }

    ///
    /// The stubbed result returned by ``tvSeries(filter:sortedBy:page:language:)``.
    ///
    public var tvSeriesResult: Result<TVSeriesPageableList, TMDbError> {
        get { withLock { storage.tvSeriesResult } }
        set { withLock { storage.tvSeriesResult = newValue } }
    }

    ///
    /// Records the call and returns ``tvSeriesResult``.
    ///
    /// - Parameters:
    ///   - filter: TV series filter to apply to the discovery.
    ///   - sortedBy: How results should be sorted.
    ///   - page: The page of results to return.
    ///   - language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed pageable list of TV series.
    ///
    public func tvSeries(
        filter: DiscoverTVSeriesFilter?,
        sortedBy: TVSeriesSort?,
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> TVSeriesPageableList {
        let result = withLock {
            storage.tvSeriesCalls.append(
                TVSeriesCall(filter: filter, sortedBy: sortedBy, page: page, language: language)
            )
            return storage.tvSeriesResult
        }

        return try result.get()
    }

}
