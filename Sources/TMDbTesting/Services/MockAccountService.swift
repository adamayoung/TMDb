//
//  MockAccountService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

// swiftlint:disable file_length type_body_length
import Foundation
import TMDb

///
/// A mock `AccountService` for use in tests.
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
public final class MockAccountService: AccountService, @unchecked Sendable {

    private let lock = NSLock()
    private var storage = Storage()

    private struct Storage {
        var detailsCalls: [DetailsCall] = []
        var detailsResult: Result<AccountDetails, TMDbError> = .success(.sample)
        var favouriteMoviesCalls: [FavouriteMoviesCall] = []
        var favouriteMoviesResult: Result<MoviePageableList, TMDbError> = .success(.sample)
        var favouriteTVSeriesCalls: [FavouriteTVSeriesCall] = []
        var favouriteTVSeriesResult: Result<TVSeriesPageableList, TMDbError> = .success(.sample)
        var addFavouriteMovieCalls: [AddFavouriteMovieCall] = []
        var addFavouriteMovieResult: Result<Void, TMDbError> = .success(())
        var removeFavouriteMovieCalls: [RemoveFavouriteMovieCall] = []
        var removeFavouriteMovieResult: Result<Void, TMDbError> = .success(())
        var addFavouriteTVSeriesCalls: [AddFavouriteTVSeriesCall] = []
        var addFavouriteTVSeriesResult: Result<Void, TMDbError> = .success(())
        var removeFavouriteTVSeriesCalls: [RemoveFavouriteTVSeriesCall] = []
        var removeFavouriteTVSeriesResult: Result<Void, TMDbError> = .success(())
        var movieWatchlistCalls: [MovieWatchlistCall] = []
        var movieWatchlistResult: Result<MoviePageableList, TMDbError> = .success(.sample)
        var tvSeriesWatchlistCalls: [TVSeriesWatchlistCall] = []
        var tvSeriesWatchlistResult: Result<TVSeriesPageableList, TMDbError> = .success(.sample)
        var addToWatchlistMovieCalls: [AddToWatchlistMovieCall] = []
        var addToWatchlistMovieResult: Result<Void, TMDbError> = .success(())
        var removeFromWatchlistMovieCalls: [RemoveFromWatchlistMovieCall] = []
        var removeFromWatchlistMovieResult: Result<Void, TMDbError> = .success(())
        var addToWatchlistTVSeriesCalls: [AddToWatchlistTVSeriesCall] = []
        var addToWatchlistTVSeriesResult: Result<Void, TMDbError> = .success(())
        var removeFromWatchlistTVSeriesCalls: [RemoveFromWatchlistTVSeriesCall] = []
        var removeFromWatchlistTVSeriesResult: Result<Void, TMDbError> = .success(())
        var ratedMoviesCalls: [RatedMoviesCall] = []
        var ratedMoviesResult: Result<MoviePageableList, TMDbError> = .success(.sample)
        var ratedTVSeriesCalls: [RatedTVSeriesCall] = []
        var ratedTVSeriesResult: Result<TVSeriesPageableList, TMDbError> = .success(.sample)
        var ratedTVEpisodesCalls: [RatedTVEpisodesCall] = []
        var ratedTVEpisodesResult: Result<TVEpisodePageableList, TMDbError> = .success(.sample)
        var listsCalls: [ListsCall] = []
        var listsResult: Result<MediaListSummaryPageableList, TMDbError> = .success(.sample)
    }

    ///
    /// Creates a mock account service.
    ///
    public init() {}

    private func withLock<R>(_ body: () -> R) -> R {
        lock.lock()
        defer { lock.unlock() }
        return body()
    }

    // MARK: - details

    ///
    /// The arguments of a single call to ``details(session:)``.
    ///
    public struct DetailsCall: Sendable {
        ///
        /// The `session` argument the method was called with.
        ///
        public let session: Session
    }

    ///
    /// The recorded calls to ``details(session:)``, in the order they were made.
    ///
    public var detailsCalls: [DetailsCall] {
        withLock { storage.detailsCalls }
    }

    ///
    /// The stubbed result returned by ``details(session:)``.
    ///
    public var detailsResult: Result<AccountDetails, TMDbError> {
        get { withLock { storage.detailsResult } }
        set { withLock { storage.detailsResult = newValue } }
    }

    ///
    /// Records the call and returns ``detailsResult``.
    ///
    /// - Parameter session: The user's authenticated session.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed account details.
    ///
    public func details(session: Session) async throws(TMDbError) -> AccountDetails {
        let result = withLock {
            storage.detailsCalls.append(DetailsCall(session: session))
            return storage.detailsResult
        }

        return try result.get()
    }

    // MARK: - favouriteMovies

    ///
    /// The arguments of a single call to ``favouriteMovies(sortedBy:page:accountID:session:)``.
    ///
    public struct FavouriteMoviesCall: Sendable {
        ///
        /// The `sortedBy` argument the method was called with.
        ///
        public let sortedBy: FavouriteSort?
        ///
        /// The `page` argument the method was called with.
        ///
        public let page: Int?
        ///
        /// The `accountID` argument the method was called with.
        ///
        public let accountID: Int
        ///
        /// The `session` argument the method was called with.
        ///
        public let session: Session
    }

    ///
    /// The recorded calls to ``favouriteMovies(sortedBy:page:accountID:session:)``,
    /// in the order they were made.
    ///
    public var favouriteMoviesCalls: [FavouriteMoviesCall] {
        withLock { storage.favouriteMoviesCalls }
    }

    ///
    /// The stubbed result returned by ``favouriteMovies(sortedBy:page:accountID:session:)``.
    ///
    public var favouriteMoviesResult: Result<MoviePageableList, TMDbError> {
        get { withLock { storage.favouriteMoviesResult } }
        set { withLock { storage.favouriteMoviesResult = newValue } }
    }

    ///
    /// Records the call and returns ``favouriteMoviesResult``.
    ///
    /// - Parameters:
    ///   - sortedBy: How results should be sorted.
    ///   - page: The page of results to return.
    ///   - accountID: The account identifier.
    ///   - session: The user's authenticated session.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed pageable list of movies.
    ///
    public func favouriteMovies(
        sortedBy: FavouriteSort?,
        page: Int?,
        accountID: Int,
        session: Session
    ) async throws(TMDbError) -> MoviePageableList {
        let result = withLock {
            storage.favouriteMoviesCalls.append(
                FavouriteMoviesCall(
                    sortedBy: sortedBy,
                    page: page,
                    accountID: accountID,
                    session: session
                )
            )
            return storage.favouriteMoviesResult
        }

        return try result.get()
    }

    // MARK: - favouriteTVSeries

    ///
    /// The arguments of a single call to ``favouriteTVSeries(sortedBy:page:accountID:session:)``.
    ///
    public struct FavouriteTVSeriesCall: Sendable {
        ///
        /// The `sortedBy` argument the method was called with.
        ///
        public let sortedBy: FavouriteSort?
        ///
        /// The `page` argument the method was called with.
        ///
        public let page: Int?
        ///
        /// The `accountID` argument the method was called with.
        ///
        public let accountID: Int
        ///
        /// The `session` argument the method was called with.
        ///
        public let session: Session
    }

    ///
    /// The recorded calls to ``favouriteTVSeries(sortedBy:page:accountID:session:)``,
    /// in the order they were made.
    ///
    public var favouriteTVSeriesCalls: [FavouriteTVSeriesCall] {
        withLock { storage.favouriteTVSeriesCalls }
    }

    ///
    /// The stubbed result returned by ``favouriteTVSeries(sortedBy:page:accountID:session:)``.
    ///
    public var favouriteTVSeriesResult: Result<TVSeriesPageableList, TMDbError> {
        get { withLock { storage.favouriteTVSeriesResult } }
        set { withLock { storage.favouriteTVSeriesResult = newValue } }
    }

    ///
    /// Records the call and returns ``favouriteTVSeriesResult``.
    ///
    /// - Parameters:
    ///   - sortedBy: How results should be sorted.
    ///   - page: The page of results to return.
    ///   - accountID: The account identifier.
    ///   - session: The user's authenticated session.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed pageable list of TV series.
    ///
    public func favouriteTVSeries(
        sortedBy: FavouriteSort?,
        page: Int?,
        accountID: Int,
        session: Session
    ) async throws(TMDbError) -> TVSeriesPageableList {
        let result = withLock {
            storage.favouriteTVSeriesCalls.append(
                FavouriteTVSeriesCall(
                    sortedBy: sortedBy,
                    page: page,
                    accountID: accountID,
                    session: session
                )
            )
            return storage.favouriteTVSeriesResult
        }

        return try result.get()
    }

    // MARK: - addFavouriteMovie

    ///
    /// The arguments of a single call to ``addFavourite(movie:accountID:session:)-(Movie.ID,_,_)``.
    ///
    public struct AddFavouriteMovieCall: Sendable {
        ///
        /// The `movie` argument the method was called with.
        ///
        public let movieID: Movie.ID
        ///
        /// The `accountID` argument the method was called with.
        ///
        public let accountID: Int
        ///
        /// The `session` argument the method was called with.
        ///
        public let session: Session
    }

    ///
    /// The recorded calls to add a favourite movie, in the order they were made.
    ///
    public var addFavouriteMovieCalls: [AddFavouriteMovieCall] {
        withLock { storage.addFavouriteMovieCalls }
    }

    ///
    /// The stubbed result returned when adding a favourite movie.
    ///
    public var addFavouriteMovieResult: Result<Void, TMDbError> {
        get { withLock { storage.addFavouriteMovieResult } }
        set { withLock { storage.addFavouriteMovieResult = newValue } }
    }

    ///
    /// Records the call and returns ``addFavouriteMovieResult``.
    ///
    /// - Parameters:
    ///   - movieID: The movie identifier.
    ///   - accountID: The account identifier.
    ///   - session: The user's authenticated session.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    public func addFavourite(
        movie movieID: Movie.ID,
        accountID: Int,
        session: Session
    ) async throws(TMDbError) {
        let result = withLock {
            storage.addFavouriteMovieCalls.append(
                AddFavouriteMovieCall(
                    movieID: movieID,
                    accountID: accountID,
                    session: session
                )
            )
            return storage.addFavouriteMovieResult
        }

        return try result.get()
    }

    // MARK: - removeFavouriteMovie

    ///
    /// The arguments of a single call to remove a favourite movie.
    ///
    public struct RemoveFavouriteMovieCall: Sendable {
        ///
        /// The `movie` argument the method was called with.
        ///
        public let movieID: Movie.ID
        ///
        /// The `accountID` argument the method was called with.
        ///
        public let accountID: Int
        ///
        /// The `session` argument the method was called with.
        ///
        public let session: Session
    }

    ///
    /// The recorded calls to remove a favourite movie, in the order they were made.
    ///
    public var removeFavouriteMovieCalls: [RemoveFavouriteMovieCall] {
        withLock { storage.removeFavouriteMovieCalls }
    }

    ///
    /// The stubbed result returned when removing a favourite movie.
    ///
    public var removeFavouriteMovieResult: Result<Void, TMDbError> {
        get { withLock { storage.removeFavouriteMovieResult } }
        set { withLock { storage.removeFavouriteMovieResult = newValue } }
    }

    ///
    /// Records the call and returns ``removeFavouriteMovieResult``.
    ///
    /// - Parameters:
    ///   - movieID: The movie identifier.
    ///   - accountID: The account identifier.
    ///   - session: The user's authenticated session.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    public func removeFavourite(
        movie movieID: Movie.ID,
        accountID: Int,
        session: Session
    ) async throws(TMDbError) {
        let result = withLock {
            storage.removeFavouriteMovieCalls.append(
                RemoveFavouriteMovieCall(
                    movieID: movieID,
                    accountID: accountID,
                    session: session
                )
            )
            return storage.removeFavouriteMovieResult
        }

        return try result.get()
    }

    // MARK: - addFavouriteTVSeries

    ///
    /// The arguments of a single call to add a favourite TV series.
    ///
    public struct AddFavouriteTVSeriesCall: Sendable {
        ///
        /// The `tvSeries` argument the method was called with.
        ///
        public let tvSeriesID: TVSeries.ID
        ///
        /// The `accountID` argument the method was called with.
        ///
        public let accountID: Int
        ///
        /// The `session` argument the method was called with.
        ///
        public let session: Session
    }

    ///
    /// The recorded calls to add a favourite TV series, in the order they were made.
    ///
    public var addFavouriteTVSeriesCalls: [AddFavouriteTVSeriesCall] {
        withLock { storage.addFavouriteTVSeriesCalls }
    }

    ///
    /// The stubbed result returned when adding a favourite TV series.
    ///
    public var addFavouriteTVSeriesResult: Result<Void, TMDbError> {
        get { withLock { storage.addFavouriteTVSeriesResult } }
        set { withLock { storage.addFavouriteTVSeriesResult = newValue } }
    }

    ///
    /// Records the call and returns ``addFavouriteTVSeriesResult``.
    ///
    /// - Parameters:
    ///   - tvSeriesID: The TV series identifier.
    ///   - accountID: The account identifier.
    ///   - session: The user's authenticated session.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    public func addFavourite(
        tvSeries tvSeriesID: TVSeries.ID,
        accountID: Int,
        session: Session
    ) async throws(TMDbError) {
        let result = withLock {
            storage.addFavouriteTVSeriesCalls.append(
                AddFavouriteTVSeriesCall(
                    tvSeriesID: tvSeriesID,
                    accountID: accountID,
                    session: session
                )
            )
            return storage.addFavouriteTVSeriesResult
        }

        return try result.get()
    }

    // MARK: - removeFavouriteTVSeries

    ///
    /// The arguments of a single call to remove a favourite TV series.
    ///
    public struct RemoveFavouriteTVSeriesCall: Sendable {
        ///
        /// The `tvSeries` argument the method was called with.
        ///
        public let tvSeriesID: TVSeries.ID
        ///
        /// The `accountID` argument the method was called with.
        ///
        public let accountID: Int
        ///
        /// The `session` argument the method was called with.
        ///
        public let session: Session
    }

    ///
    /// The recorded calls to remove a favourite TV series, in the order they were made.
    ///
    public var removeFavouriteTVSeriesCalls: [RemoveFavouriteTVSeriesCall] {
        withLock { storage.removeFavouriteTVSeriesCalls }
    }

    ///
    /// The stubbed result returned when removing a favourite TV series.
    ///
    public var removeFavouriteTVSeriesResult: Result<Void, TMDbError> {
        get { withLock { storage.removeFavouriteTVSeriesResult } }
        set { withLock { storage.removeFavouriteTVSeriesResult = newValue } }
    }

    ///
    /// Records the call and returns ``removeFavouriteTVSeriesResult``.
    ///
    /// - Parameters:
    ///   - tvSeriesID: The TV series identifier.
    ///   - accountID: The account identifier.
    ///   - session: The user's authenticated session.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    public func removeFavourite(
        tvSeries tvSeriesID: TVSeries.ID,
        accountID: Int,
        session: Session
    ) async throws(TMDbError) {
        let result = withLock {
            storage.removeFavouriteTVSeriesCalls.append(
                RemoveFavouriteTVSeriesCall(
                    tvSeriesID: tvSeriesID,
                    accountID: accountID,
                    session: session
                )
            )
            return storage.removeFavouriteTVSeriesResult
        }

        return try result.get()
    }

    // MARK: - movieWatchlist

    ///
    /// The arguments of a single call to ``movieWatchlist(sortedBy:page:accountID:session:)``.
    ///
    public struct MovieWatchlistCall: Sendable {
        ///
        /// The `sortedBy` argument the method was called with.
        ///
        public let sortedBy: WatchlistSort?
        ///
        /// The `page` argument the method was called with.
        ///
        public let page: Int?
        ///
        /// The `accountID` argument the method was called with.
        ///
        public let accountID: Int
        ///
        /// The `session` argument the method was called with.
        ///
        public let session: Session
    }

    ///
    /// The recorded calls to ``movieWatchlist(sortedBy:page:accountID:session:)``,
    /// in the order they were made.
    ///
    public var movieWatchlistCalls: [MovieWatchlistCall] {
        withLock { storage.movieWatchlistCalls }
    }

    ///
    /// The stubbed result returned by ``movieWatchlist(sortedBy:page:accountID:session:)``.
    ///
    public var movieWatchlistResult: Result<MoviePageableList, TMDbError> {
        get { withLock { storage.movieWatchlistResult } }
        set { withLock { storage.movieWatchlistResult = newValue } }
    }

    ///
    /// Records the call and returns ``movieWatchlistResult``.
    ///
    /// - Parameters:
    ///   - sortedBy: How results should be sorted.
    ///   - page: The page of results to return.
    ///   - accountID: The account identifier.
    ///   - session: The user's authenticated session.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed pageable list of movies.
    ///
    public func movieWatchlist(
        sortedBy: WatchlistSort?,
        page: Int?,
        accountID: Int,
        session: Session
    ) async throws(TMDbError) -> MoviePageableList {
        let result = withLock {
            storage.movieWatchlistCalls.append(
                MovieWatchlistCall(
                    sortedBy: sortedBy,
                    page: page,
                    accountID: accountID,
                    session: session
                )
            )
            return storage.movieWatchlistResult
        }

        return try result.get()
    }

    // MARK: - tvSeriesWatchlist

    ///
    /// The arguments of a single call to ``tvSeriesWatchlist(sortedBy:page:accountID:session:)``.
    ///
    public struct TVSeriesWatchlistCall: Sendable {
        ///
        /// The `sortedBy` argument the method was called with.
        ///
        public let sortedBy: WatchlistSort?
        ///
        /// The `page` argument the method was called with.
        ///
        public let page: Int?
        ///
        /// The `accountID` argument the method was called with.
        ///
        public let accountID: Int
        ///
        /// The `session` argument the method was called with.
        ///
        public let session: Session
    }

    ///
    /// The recorded calls to ``tvSeriesWatchlist(sortedBy:page:accountID:session:)``,
    /// in the order they were made.
    ///
    public var tvSeriesWatchlistCalls: [TVSeriesWatchlistCall] {
        withLock { storage.tvSeriesWatchlistCalls }
    }

    ///
    /// The stubbed result returned by ``tvSeriesWatchlist(sortedBy:page:accountID:session:)``.
    ///
    public var tvSeriesWatchlistResult: Result<TVSeriesPageableList, TMDbError> {
        get { withLock { storage.tvSeriesWatchlistResult } }
        set { withLock { storage.tvSeriesWatchlistResult = newValue } }
    }

    ///
    /// Records the call and returns ``tvSeriesWatchlistResult``.
    ///
    /// - Parameters:
    ///   - sortedBy: How results should be sorted.
    ///   - page: The page of results to return.
    ///   - accountID: The account identifier.
    ///   - session: The user's authenticated session.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed pageable list of TV series.
    ///
    public func tvSeriesWatchlist(
        sortedBy: WatchlistSort?,
        page: Int?,
        accountID: Int,
        session: Session
    ) async throws(TMDbError) -> TVSeriesPageableList {
        let result = withLock {
            storage.tvSeriesWatchlistCalls.append(
                TVSeriesWatchlistCall(
                    sortedBy: sortedBy,
                    page: page,
                    accountID: accountID,
                    session: session
                )
            )
            return storage.tvSeriesWatchlistResult
        }

        return try result.get()
    }

    // MARK: - addToWatchlistMovie

    ///
    /// The arguments of a single call to add a movie to the watchlist.
    ///
    public struct AddToWatchlistMovieCall: Sendable {
        ///
        /// The `movie` argument the method was called with.
        ///
        public let movieID: Movie.ID
        ///
        /// The `accountID` argument the method was called with.
        ///
        public let accountID: Int
        ///
        /// The `session` argument the method was called with.
        ///
        public let session: Session
    }

    ///
    /// The recorded calls to add a movie to the watchlist, in the order they were made.
    ///
    public var addToWatchlistMovieCalls: [AddToWatchlistMovieCall] {
        withLock { storage.addToWatchlistMovieCalls }
    }

    ///
    /// The stubbed result returned when adding a movie to the watchlist.
    ///
    public var addToWatchlistMovieResult: Result<Void, TMDbError> {
        get { withLock { storage.addToWatchlistMovieResult } }
        set { withLock { storage.addToWatchlistMovieResult = newValue } }
    }

    ///
    /// Records the call and returns ``addToWatchlistMovieResult``.
    ///
    /// - Parameters:
    ///   - movieID: The movie identifier.
    ///   - accountID: The account identifier.
    ///   - session: The user's authenticated session.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    public func addToWatchlist(
        movie movieID: Movie.ID,
        accountID: Int,
        session: Session
    ) async throws(TMDbError) {
        let result = withLock {
            storage.addToWatchlistMovieCalls.append(
                AddToWatchlistMovieCall(
                    movieID: movieID,
                    accountID: accountID,
                    session: session
                )
            )
            return storage.addToWatchlistMovieResult
        }

        return try result.get()
    }

    // MARK: - removeFromWatchlistMovie

    ///
    /// The arguments of a single call to remove a movie from the watchlist.
    ///
    public struct RemoveFromWatchlistMovieCall: Sendable {
        ///
        /// The `movie` argument the method was called with.
        ///
        public let movieID: Movie.ID
        ///
        /// The `accountID` argument the method was called with.
        ///
        public let accountID: Int
        ///
        /// The `session` argument the method was called with.
        ///
        public let session: Session
    }

    ///
    /// The recorded calls to remove a movie from the watchlist, in the order they were made.
    ///
    public var removeFromWatchlistMovieCalls: [RemoveFromWatchlistMovieCall] {
        withLock { storage.removeFromWatchlistMovieCalls }
    }

    ///
    /// The stubbed result returned when removing a movie from the watchlist.
    ///
    public var removeFromWatchlistMovieResult: Result<Void, TMDbError> {
        get { withLock { storage.removeFromWatchlistMovieResult } }
        set { withLock { storage.removeFromWatchlistMovieResult = newValue } }
    }

    ///
    /// Records the call and returns ``removeFromWatchlistMovieResult``.
    ///
    /// - Parameters:
    ///   - movieID: The movie identifier.
    ///   - accountID: The account identifier.
    ///   - session: The user's authenticated session.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    public func removeFromWatchlist(
        movie movieID: Movie.ID,
        accountID: Int,
        session: Session
    ) async throws(TMDbError) {
        let result = withLock {
            storage.removeFromWatchlistMovieCalls.append(
                RemoveFromWatchlistMovieCall(
                    movieID: movieID,
                    accountID: accountID,
                    session: session
                )
            )
            return storage.removeFromWatchlistMovieResult
        }

        return try result.get()
    }

    // MARK: - addToWatchlistTVSeries

    ///
    /// The arguments of a single call to add a TV series to the watchlist.
    ///
    public struct AddToWatchlistTVSeriesCall: Sendable {
        ///
        /// The `tvSeries` argument the method was called with.
        ///
        public let tvSeriesID: TVSeries.ID
        ///
        /// The `accountID` argument the method was called with.
        ///
        public let accountID: Int
        ///
        /// The `session` argument the method was called with.
        ///
        public let session: Session
    }

    ///
    /// The recorded calls to add a TV series to the watchlist, in the order they were made.
    ///
    public var addToWatchlistTVSeriesCalls: [AddToWatchlistTVSeriesCall] {
        withLock { storage.addToWatchlistTVSeriesCalls }
    }

    ///
    /// The stubbed result returned when adding a TV series to the watchlist.
    ///
    public var addToWatchlistTVSeriesResult: Result<Void, TMDbError> {
        get { withLock { storage.addToWatchlistTVSeriesResult } }
        set { withLock { storage.addToWatchlistTVSeriesResult = newValue } }
    }

    ///
    /// Records the call and returns ``addToWatchlistTVSeriesResult``.
    ///
    /// - Parameters:
    ///   - tvSeriesID: The TV series identifier.
    ///   - accountID: The account identifier.
    ///   - session: The user's authenticated session.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    public func addToWatchlist(
        tvSeries tvSeriesID: TVSeries.ID,
        accountID: Int,
        session: Session
    ) async throws(TMDbError) {
        let result = withLock {
            storage.addToWatchlistTVSeriesCalls.append(
                AddToWatchlistTVSeriesCall(
                    tvSeriesID: tvSeriesID,
                    accountID: accountID,
                    session: session
                )
            )
            return storage.addToWatchlistTVSeriesResult
        }

        return try result.get()
    }

    // MARK: - removeFromWatchlistTVSeries

    ///
    /// The arguments of a single call to remove a TV series from the watchlist.
    ///
    public struct RemoveFromWatchlistTVSeriesCall: Sendable {
        ///
        /// The `tvSeries` argument the method was called with.
        ///
        public let tvSeriesID: TVSeries.ID
        ///
        /// The `accountID` argument the method was called with.
        ///
        public let accountID: Int
        ///
        /// The `session` argument the method was called with.
        ///
        public let session: Session
    }

    ///
    /// The recorded calls to remove a TV series from the watchlist, in the order they were made.
    ///
    public var removeFromWatchlistTVSeriesCalls: [RemoveFromWatchlistTVSeriesCall] {
        withLock { storage.removeFromWatchlistTVSeriesCalls }
    }

    ///
    /// The stubbed result returned when removing a TV series from the watchlist.
    ///
    public var removeFromWatchlistTVSeriesResult: Result<Void, TMDbError> {
        get { withLock { storage.removeFromWatchlistTVSeriesResult } }
        set { withLock { storage.removeFromWatchlistTVSeriesResult = newValue } }
    }

    ///
    /// Records the call and returns ``removeFromWatchlistTVSeriesResult``.
    ///
    /// - Parameters:
    ///   - tvSeriesID: The TV series identifier.
    ///   - accountID: The account identifier.
    ///   - session: The user's authenticated session.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    public func removeFromWatchlist(
        tvSeries tvSeriesID: TVSeries.ID,
        accountID: Int,
        session: Session
    ) async throws(TMDbError) {
        let result = withLock {
            storage.removeFromWatchlistTVSeriesCalls.append(
                RemoveFromWatchlistTVSeriesCall(
                    tvSeriesID: tvSeriesID,
                    accountID: accountID,
                    session: session
                )
            )
            return storage.removeFromWatchlistTVSeriesResult
        }

        return try result.get()
    }

    // MARK: - ratedMovies

    ///
    /// The arguments of a single call to ``ratedMovies(sortedBy:page:accountID:session:)``.
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
        /// The `accountID` argument the method was called with.
        ///
        public let accountID: Int
        ///
        /// The `session` argument the method was called with.
        ///
        public let session: Session
    }

    ///
    /// The recorded calls to ``ratedMovies(sortedBy:page:accountID:session:)``,
    /// in the order they were made.
    ///
    public var ratedMoviesCalls: [RatedMoviesCall] {
        withLock { storage.ratedMoviesCalls }
    }

    ///
    /// The stubbed result returned by ``ratedMovies(sortedBy:page:accountID:session:)``.
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
    ///   - accountID: The account identifier.
    ///   - session: The user's authenticated session.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed pageable list of movies.
    ///
    public func ratedMovies(
        sortedBy: RatedSort?,
        page: Int?,
        accountID: Int,
        session: Session
    ) async throws(TMDbError) -> MoviePageableList {
        let result = withLock {
            storage.ratedMoviesCalls.append(
                RatedMoviesCall(
                    sortedBy: sortedBy,
                    page: page,
                    accountID: accountID,
                    session: session
                )
            )
            return storage.ratedMoviesResult
        }

        return try result.get()
    }

    // MARK: - ratedTVSeries

    ///
    /// The arguments of a single call to ``ratedTVSeries(sortedBy:page:accountID:session:)``.
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
        /// The `accountID` argument the method was called with.
        ///
        public let accountID: Int
        ///
        /// The `session` argument the method was called with.
        ///
        public let session: Session
    }

    ///
    /// The recorded calls to ``ratedTVSeries(sortedBy:page:accountID:session:)``,
    /// in the order they were made.
    ///
    public var ratedTVSeriesCalls: [RatedTVSeriesCall] {
        withLock { storage.ratedTVSeriesCalls }
    }

    ///
    /// The stubbed result returned by ``ratedTVSeries(sortedBy:page:accountID:session:)``.
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
    ///   - accountID: The account identifier.
    ///   - session: The user's authenticated session.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed pageable list of TV series.
    ///
    public func ratedTVSeries(
        sortedBy: RatedSort?,
        page: Int?,
        accountID: Int,
        session: Session
    ) async throws(TMDbError) -> TVSeriesPageableList {
        let result = withLock {
            storage.ratedTVSeriesCalls.append(
                RatedTVSeriesCall(
                    sortedBy: sortedBy,
                    page: page,
                    accountID: accountID,
                    session: session
                )
            )
            return storage.ratedTVSeriesResult
        }

        return try result.get()
    }

    // MARK: - ratedTVEpisodes

    ///
    /// The arguments of a single call to ``ratedTVEpisodes(sortedBy:page:accountID:session:)``.
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
        /// The `accountID` argument the method was called with.
        ///
        public let accountID: Int
        ///
        /// The `session` argument the method was called with.
        ///
        public let session: Session
    }

    ///
    /// The recorded calls to ``ratedTVEpisodes(sortedBy:page:accountID:session:)``,
    /// in the order they were made.
    ///
    public var ratedTVEpisodesCalls: [RatedTVEpisodesCall] {
        withLock { storage.ratedTVEpisodesCalls }
    }

    ///
    /// The stubbed result returned by ``ratedTVEpisodes(sortedBy:page:accountID:session:)``.
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
    ///   - accountID: The account identifier.
    ///   - session: The user's authenticated session.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed pageable list of TV episodes.
    ///
    public func ratedTVEpisodes(
        sortedBy: RatedSort?,
        page: Int?,
        accountID: Int,
        session: Session
    ) async throws(TMDbError) -> TVEpisodePageableList {
        let result = withLock {
            storage.ratedTVEpisodesCalls.append(
                RatedTVEpisodesCall(
                    sortedBy: sortedBy,
                    page: page,
                    accountID: accountID,
                    session: session
                )
            )
            return storage.ratedTVEpisodesResult
        }

        return try result.get()
    }

    // MARK: - lists

    ///
    /// The arguments of a single call to ``lists(page:accountID:session:)``.
    ///
    public struct ListsCall: Sendable {
        ///
        /// The `page` argument the method was called with.
        ///
        public let page: Int?
        ///
        /// The `accountID` argument the method was called with.
        ///
        public let accountID: Int
        ///
        /// The `session` argument the method was called with.
        ///
        public let session: Session
    }

    ///
    /// The recorded calls to ``lists(page:accountID:session:)``, in the order they were made.
    ///
    public var listsCalls: [ListsCall] {
        withLock { storage.listsCalls }
    }

    ///
    /// The stubbed result returned by ``lists(page:accountID:session:)``.
    ///
    public var listsResult: Result<MediaListSummaryPageableList, TMDbError> {
        get { withLock { storage.listsResult } }
        set { withLock { storage.listsResult = newValue } }
    }

    ///
    /// Records the call and returns ``listsResult``.
    ///
    /// - Parameters:
    ///   - page: The page of results to return.
    ///   - accountID: The account identifier.
    ///   - session: The user's authenticated session.
    ///
    /// - Throws: TMDb error `TMDbError`.
    ///
    /// - Returns: The stubbed pageable list of media list summaries.
    ///
    public func lists(
        page: Int?,
        accountID: Int,
        session: Session
    ) async throws(TMDbError) -> MediaListSummaryPageableList {
        let result = withLock {
            storage.listsCalls.append(
                ListsCall(
                    page: page,
                    accountID: accountID,
                    session: session
                )
            )
            return storage.listsResult
        }

        return try result.get()
    }

}

// swiftlint:enable type_body_length
