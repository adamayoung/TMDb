//
//  MockTrendingService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

///
/// A mock `TrendingService` for use in tests.
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
public final class MockTrendingService: TrendingService, @unchecked Sendable {

    private let lock = NSLock()
    private var storage = Storage()

    private struct Storage {
        var moviesCalls: [MoviesCall] = []
        var moviesResult: Result<MoviePageableList, TMDbError> = .success(.sample)
        var tvSeriesCalls: [TVSeriesCall] = []
        var tvSeriesResult: Result<TVSeriesPageableList, TMDbError> = .success(.sample)
        var peopleCalls: [PeopleCall] = []
        var peopleResult: Result<PersonPageableList, TMDbError> = .success(.sample)
        var allTrendingCalls: [AllTrendingCall] = []
        var allTrendingResult: Result<TrendingPageableList, TMDbError> = .success(.sample)
    }

    ///
    /// Creates a mock trending service.
    ///
    public init() {}

    private func withLock<R>(_ body: () -> R) -> R {
        lock.lock()
        defer { lock.unlock() }
        return body()
    }

    // MARK: - movies

    ///
    /// The arguments of a single call to ``movies(inTimeWindow:page:language:)``.
    ///
    public struct MoviesCall: Sendable {
        ///
        /// The `timeWindow` argument the method was called with.
        ///
        public let timeWindow: TrendingTimeWindowFilterType
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
    /// The recorded calls to ``movies(inTimeWindow:page:language:)``, in the order they
    /// were made.
    ///
    public var moviesCalls: [MoviesCall] {
        withLock { storage.moviesCalls }
    }

    ///
    /// The stubbed result returned by ``movies(inTimeWindow:page:language:)``.
    ///
    public var moviesResult: Result<MoviePageableList, TMDbError> {
        get { withLock { storage.moviesResult } }
        set { withLock { storage.moviesResult = newValue } }
    }

    ///
    /// Records the call and returns ``moviesResult``.
    ///
    /// - Parameters:
    ///   - timeWindow: The trending time window to retrieve results for.
    ///   - page: The page of results to return.
    ///   - language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed pageable list of trending movies.
    ///
    public func movies(
        inTimeWindow timeWindow: TrendingTimeWindowFilterType,
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> MoviePageableList {
        let result = withLock {
            storage.moviesCalls.append(
                MoviesCall(timeWindow: timeWindow, page: page, language: language)
            )
            return storage.moviesResult
        }

        return try result.get()
    }

    // MARK: - tvSeries

    ///
    /// The arguments of a single call to ``tvSeries(inTimeWindow:page:language:)``.
    ///
    public struct TVSeriesCall: Sendable {
        ///
        /// The `timeWindow` argument the method was called with.
        ///
        public let timeWindow: TrendingTimeWindowFilterType
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
    /// The recorded calls to ``tvSeries(inTimeWindow:page:language:)``, in the order they
    /// were made.
    ///
    public var tvSeriesCalls: [TVSeriesCall] {
        withLock { storage.tvSeriesCalls }
    }

    ///
    /// The stubbed result returned by ``tvSeries(inTimeWindow:page:language:)``.
    ///
    public var tvSeriesResult: Result<TVSeriesPageableList, TMDbError> {
        get { withLock { storage.tvSeriesResult } }
        set { withLock { storage.tvSeriesResult = newValue } }
    }

    ///
    /// Records the call and returns ``tvSeriesResult``.
    ///
    /// - Parameters:
    ///   - timeWindow: The trending time window to retrieve results for.
    ///   - page: The page of results to return.
    ///   - language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed pageable list of trending TV series.
    ///
    public func tvSeries(
        inTimeWindow timeWindow: TrendingTimeWindowFilterType,
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> TVSeriesPageableList {
        let result = withLock {
            storage.tvSeriesCalls.append(
                TVSeriesCall(timeWindow: timeWindow, page: page, language: language)
            )
            return storage.tvSeriesResult
        }

        return try result.get()
    }

    // MARK: - people

    ///
    /// The arguments of a single call to ``people(inTimeWindow:page:language:)``.
    ///
    public struct PeopleCall: Sendable {
        ///
        /// The `timeWindow` argument the method was called with.
        ///
        public let timeWindow: TrendingTimeWindowFilterType
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
    /// The recorded calls to ``people(inTimeWindow:page:language:)``, in the order they
    /// were made.
    ///
    public var peopleCalls: [PeopleCall] {
        withLock { storage.peopleCalls }
    }

    ///
    /// The stubbed result returned by ``people(inTimeWindow:page:language:)``.
    ///
    public var peopleResult: Result<PersonPageableList, TMDbError> {
        get { withLock { storage.peopleResult } }
        set { withLock { storage.peopleResult = newValue } }
    }

    ///
    /// Records the call and returns ``peopleResult``.
    ///
    /// - Parameters:
    ///   - timeWindow: The trending time window to retrieve results for.
    ///   - page: The page of results to return.
    ///   - language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed pageable list of trending people.
    ///
    public func people(
        inTimeWindow timeWindow: TrendingTimeWindowFilterType,
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> PersonPageableList {
        let result = withLock {
            storage.peopleCalls.append(
                PeopleCall(timeWindow: timeWindow, page: page, language: language)
            )
            return storage.peopleResult
        }

        return try result.get()
    }

    // MARK: - allTrending

    ///
    /// The arguments of a single call to ``allTrending(inTimeWindow:page:language:)``.
    ///
    public struct AllTrendingCall: Sendable {
        ///
        /// The `timeWindow` argument the method was called with.
        ///
        public let timeWindow: TrendingTimeWindowFilterType
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
    /// The recorded calls to ``allTrending(inTimeWindow:page:language:)``, in the order
    /// they were made.
    ///
    public var allTrendingCalls: [AllTrendingCall] {
        withLock { storage.allTrendingCalls }
    }

    ///
    /// The stubbed result returned by ``allTrending(inTimeWindow:page:language:)``.
    ///
    public var allTrendingResult: Result<TrendingPageableList, TMDbError> {
        get { withLock { storage.allTrendingResult } }
        set { withLock { storage.allTrendingResult = newValue } }
    }

    ///
    /// Records the call and returns ``allTrendingResult``.
    ///
    /// - Parameters:
    ///   - timeWindow: The trending time window to retrieve results for.
    ///   - page: The page of results to return.
    ///   - language: ISO 639-1 language code to display results in.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed pageable list of all trending items.
    ///
    public func allTrending(
        inTimeWindow timeWindow: TrendingTimeWindowFilterType,
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> TrendingPageableList {
        let result = withLock {
            storage.allTrendingCalls.append(
                AllTrendingCall(timeWindow: timeWindow, page: page, language: language)
            )
            return storage.allTrendingResult
        }

        return try result.get()
    }

}
