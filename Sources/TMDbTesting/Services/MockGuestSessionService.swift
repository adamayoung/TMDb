//
//  MockGuestSessionService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

///
/// A mock `GuestSessionService` for use in tests.
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
public final class MockGuestSessionService: GuestSessionService, @unchecked Sendable {

    private let lock = NSLock()
    private var storage = Storage()

    private struct Storage {
        var ratedMoviesCalls: [RatedMoviesCall] = []
        var ratedMoviesResult: Result<MoviePageableList, TMDbError> = .success(.sample)
        var ratedTVSeriesCalls: [RatedTVSeriesCall] = []
        var ratedTVSeriesResult: Result<TVSeriesPageableList, TMDbError> = .success(.sample)
        var ratedTVEpisodesCalls: [RatedTVEpisodesCall] = []
        var ratedTVEpisodesResult: Result<TVEpisodePageableList, TMDbError> = .success(.sample)
    }

    ///
    /// Creates a mock guest session service.
    ///
    public init() {}

    private func withLock<R>(_ body: () -> R) -> R {
        lock.lock()
        defer { lock.unlock() }
        return body()
    }

    // MARK: - ratedMovies

    ///
    /// The arguments of a single call to ``ratedMovies(sortedBy:page:guestSessionID:)``.
    ///
    public struct RatedMoviesCall: Sendable {
        ///
        /// The `sortedBy` argument the method was called with.
        ///
        public let sortedBy: RatedSort?
        ///
        /// The `page` argument the method was called with.
        ///
        public let page: Int?
        ///
        /// The `guestSessionID` argument the method was called with.
        ///
        public let guestSessionID: String
    }

    ///
    /// The recorded calls to ``ratedMovies(sortedBy:page:guestSessionID:)``, in the order they
    /// were made.
    ///
    public var ratedMoviesCalls: [RatedMoviesCall] {
        withLock { storage.ratedMoviesCalls }
    }

    ///
    /// The stubbed result returned by ``ratedMovies(sortedBy:page:guestSessionID:)``.
    ///
    public var ratedMoviesResult: Result<MoviePageableList, TMDbError> {
        get { withLock { storage.ratedMoviesResult } }
        set { withLock { storage.ratedMoviesResult = newValue } }
    }

    ///
    /// Records the call and returns ``ratedMoviesResult``.
    ///
    /// - Parameters:
    ///   - sortedBy: How results should be sorted.
    ///   - page: The page of results to return.
    ///   - guestSessionID: The guest session identifier.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed pageable list of rated movies.
    ///
    public func ratedMovies(
        sortedBy: RatedSort?,
        page: Int?,
        guestSessionID: String
    ) async throws(TMDbError) -> MoviePageableList {
        let result = withLock {
            storage.ratedMoviesCalls.append(
                RatedMoviesCall(sortedBy: sortedBy, page: page, guestSessionID: guestSessionID)
            )
            return storage.ratedMoviesResult
        }

        return try result.get()
    }

    // MARK: - ratedTVSeries

    ///
    /// The arguments of a single call to ``ratedTVSeries(sortedBy:page:guestSessionID:)``.
    ///
    public struct RatedTVSeriesCall: Sendable {
        ///
        /// The `sortedBy` argument the method was called with.
        ///
        public let sortedBy: RatedSort?
        ///
        /// The `page` argument the method was called with.
        ///
        public let page: Int?
        ///
        /// The `guestSessionID` argument the method was called with.
        ///
        public let guestSessionID: String
    }

    ///
    /// The recorded calls to ``ratedTVSeries(sortedBy:page:guestSessionID:)``, in the order
    /// they were made.
    ///
    public var ratedTVSeriesCalls: [RatedTVSeriesCall] {
        withLock { storage.ratedTVSeriesCalls }
    }

    ///
    /// The stubbed result returned by ``ratedTVSeries(sortedBy:page:guestSessionID:)``.
    ///
    public var ratedTVSeriesResult: Result<TVSeriesPageableList, TMDbError> {
        get { withLock { storage.ratedTVSeriesResult } }
        set { withLock { storage.ratedTVSeriesResult = newValue } }
    }

    ///
    /// Records the call and returns ``ratedTVSeriesResult``.
    ///
    /// - Parameters:
    ///   - sortedBy: How results should be sorted.
    ///   - page: The page of results to return.
    ///   - guestSessionID: The guest session identifier.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed pageable list of rated TV series.
    ///
    public func ratedTVSeries(
        sortedBy: RatedSort?,
        page: Int?,
        guestSessionID: String
    ) async throws(TMDbError) -> TVSeriesPageableList {
        let result = withLock {
            storage.ratedTVSeriesCalls.append(
                RatedTVSeriesCall(sortedBy: sortedBy, page: page, guestSessionID: guestSessionID)
            )
            return storage.ratedTVSeriesResult
        }

        return try result.get()
    }

    // MARK: - ratedTVEpisodes

    ///
    /// The arguments of a single call to ``ratedTVEpisodes(sortedBy:page:guestSessionID:)``.
    ///
    public struct RatedTVEpisodesCall: Sendable {
        ///
        /// The `sortedBy` argument the method was called with.
        ///
        public let sortedBy: RatedSort?
        ///
        /// The `page` argument the method was called with.
        ///
        public let page: Int?
        ///
        /// The `guestSessionID` argument the method was called with.
        ///
        public let guestSessionID: String
    }

    ///
    /// The recorded calls to ``ratedTVEpisodes(sortedBy:page:guestSessionID:)``, in the order
    /// they were made.
    ///
    public var ratedTVEpisodesCalls: [RatedTVEpisodesCall] {
        withLock { storage.ratedTVEpisodesCalls }
    }

    ///
    /// The stubbed result returned by ``ratedTVEpisodes(sortedBy:page:guestSessionID:)``.
    ///
    public var ratedTVEpisodesResult: Result<TVEpisodePageableList, TMDbError> {
        get { withLock { storage.ratedTVEpisodesResult } }
        set { withLock { storage.ratedTVEpisodesResult = newValue } }
    }

    ///
    /// Records the call and returns ``ratedTVEpisodesResult``.
    ///
    /// - Parameters:
    ///   - sortedBy: How results should be sorted.
    ///   - page: The page of results to return.
    ///   - guestSessionID: The guest session identifier.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed pageable list of rated TV episodes.
    ///
    public func ratedTVEpisodes(
        sortedBy: RatedSort?,
        page: Int?,
        guestSessionID: String
    ) async throws(TMDbError) -> TVEpisodePageableList {
        let result = withLock {
            storage.ratedTVEpisodesCalls.append(
                RatedTVEpisodesCall(sortedBy: sortedBy, page: page, guestSessionID: guestSessionID)
            )
            return storage.ratedTVEpisodesResult
        }

        return try result.get()
    }

}
