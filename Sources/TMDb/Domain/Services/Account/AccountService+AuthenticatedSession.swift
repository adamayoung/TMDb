//
//  AccountService+AuthenticatedSession.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public extension AccountService {

    ///
    /// Bundles a session together with its account identifier into an
    /// ``AuthenticatedSession``.
    ///
    /// This is a convenience over fetching ``details(session:)`` and reading
    /// its identifier manually. The returned value can then be passed to the
    /// `authenticatedSession:` variants of the account methods.
    ///
    /// - Important: This performs a network request (it calls
    ///   ``details(session:)``) and can therefore throw ``TMDbError``.
    ///
    /// - Parameter session: The user's TMDb session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: An ``AuthenticatedSession`` pairing the account identifier
    ///   with the session.
    ///
    func authenticatedSession(
        for session: Session
    ) async throws(TMDbError) -> AuthenticatedSession {
        let details = try await details(session: session)
        return AuthenticatedSession(accountID: details.id, session: session)
    }

    ///
    /// Returns a list of the user's favourited movies.
    ///
    /// - Parameters:
    ///   - sortedBy: How results should be sorted.
    ///   - page: The page of results to return.
    ///   - authenticatedSession: The user's authenticated session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching movies as a pageable list.
    ///
    func favouriteMovies(
        sortedBy: FavouriteSort? = nil,
        page: Int? = nil,
        authenticatedSession: AuthenticatedSession
    ) async throws(TMDbError) -> MoviePageableList {
        try await favouriteMovies(
            sortedBy: sortedBy,
            page: page,
            accountID: authenticatedSession.accountID,
            session: authenticatedSession.session
        )
    }

    ///
    /// Returns a list of the user's favourited TV series.
    ///
    /// - Parameters:
    ///   - sortedBy: How results should be sorted.
    ///   - page: The page of results to return.
    ///   - authenticatedSession: The user's authenticated session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching TV series as a pageable list.
    ///
    func favouriteTVSeries(
        sortedBy: FavouriteSort? = nil,
        page: Int? = nil,
        authenticatedSession: AuthenticatedSession
    ) async throws(TMDbError) -> TVSeriesPageableList {
        try await favouriteTVSeries(
            sortedBy: sortedBy,
            page: page,
            accountID: authenticatedSession.accountID,
            session: authenticatedSession.session
        )
    }

    ///
    /// Adds a movie to the user's favourites.
    ///
    /// - Parameters:
    ///   - movieID: The identifier of the movie.
    ///   - authenticatedSession: The user's authenticated session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    func addFavourite(
        movie movieID: Movie.ID,
        authenticatedSession: AuthenticatedSession
    ) async throws(TMDbError) {
        try await addFavourite(
            movie: movieID,
            accountID: authenticatedSession.accountID,
            session: authenticatedSession.session
        )
    }

    ///
    /// Removes a movie from the user's favourites.
    ///
    /// - Parameters:
    ///   - movieID: The identifier of the movie.
    ///   - authenticatedSession: The user's authenticated session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    func removeFavourite(
        movie movieID: Movie.ID,
        authenticatedSession: AuthenticatedSession
    ) async throws(TMDbError) {
        try await removeFavourite(
            movie: movieID,
            accountID: authenticatedSession.accountID,
            session: authenticatedSession.session
        )
    }

    ///
    /// Adds a TV series to the user's favourites.
    ///
    /// - Parameters:
    ///   - tvSeriesID: The identifier of the TV series.
    ///   - authenticatedSession: The user's authenticated session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    func addFavourite(
        tvSeries tvSeriesID: TVSeries.ID,
        authenticatedSession: AuthenticatedSession
    ) async throws(TMDbError) {
        try await addFavourite(
            tvSeries: tvSeriesID,
            accountID: authenticatedSession.accountID,
            session: authenticatedSession.session
        )
    }

    ///
    /// Removes a TV series from the user's favourites.
    ///
    /// - Parameters:
    ///   - tvSeriesID: The identifier of the TV series.
    ///   - authenticatedSession: The user's authenticated session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    func removeFavourite(
        tvSeries tvSeriesID: TVSeries.ID,
        authenticatedSession: AuthenticatedSession
    ) async throws(TMDbError) {
        try await removeFavourite(
            tvSeries: tvSeriesID,
            accountID: authenticatedSession.accountID,
            session: authenticatedSession.session
        )
    }

    ///
    /// Returns a list of movies on the user's watchlist.
    ///
    /// - Parameters:
    ///   - sortedBy: How results should be sorted.
    ///   - page: The page of results to return.
    ///   - authenticatedSession: The user's authenticated session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching movies as a pageable list.
    ///
    func movieWatchlist(
        sortedBy: WatchlistSort? = nil,
        page: Int? = nil,
        authenticatedSession: AuthenticatedSession
    ) async throws(TMDbError) -> MoviePageableList {
        try await movieWatchlist(
            sortedBy: sortedBy,
            page: page,
            accountID: authenticatedSession.accountID,
            session: authenticatedSession.session
        )
    }

    ///
    /// Returns a list of TV series on the user's watchlist.
    ///
    /// - Parameters:
    ///   - sortedBy: How results should be sorted.
    ///   - page: The page of results to return.
    ///   - authenticatedSession: The user's authenticated session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching TV series as a pageable list.
    ///
    func tvSeriesWatchlist(
        sortedBy: WatchlistSort? = nil,
        page: Int? = nil,
        authenticatedSession: AuthenticatedSession
    ) async throws(TMDbError) -> TVSeriesPageableList {
        try await tvSeriesWatchlist(
            sortedBy: sortedBy,
            page: page,
            accountID: authenticatedSession.accountID,
            session: authenticatedSession.session
        )
    }

    ///
    /// Adds a movie to the user's watchlist.
    ///
    /// - Parameters:
    ///   - movieID: The identifier of the movie.
    ///   - authenticatedSession: The user's authenticated session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    func addToWatchlist(
        movie movieID: Movie.ID,
        authenticatedSession: AuthenticatedSession
    ) async throws(TMDbError) {
        try await addToWatchlist(
            movie: movieID,
            accountID: authenticatedSession.accountID,
            session: authenticatedSession.session
        )
    }

    ///
    /// Removes a movie from the user's watchlist.
    ///
    /// - Parameters:
    ///   - movieID: The identifier of the movie.
    ///   - authenticatedSession: The user's authenticated session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    func removeFromWatchlist(
        movie movieID: Movie.ID,
        authenticatedSession: AuthenticatedSession
    ) async throws(TMDbError) {
        try await removeFromWatchlist(
            movie: movieID,
            accountID: authenticatedSession.accountID,
            session: authenticatedSession.session
        )
    }

    ///
    /// Adds a TV series to the user's watchlist.
    ///
    /// - Parameters:
    ///   - tvSeriesID: The identifier of the TV series.
    ///   - authenticatedSession: The user's authenticated session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    func addToWatchlist(
        tvSeries tvSeriesID: TVSeries.ID,
        authenticatedSession: AuthenticatedSession
    ) async throws(TMDbError) {
        try await addToWatchlist(
            tvSeries: tvSeriesID,
            accountID: authenticatedSession.accountID,
            session: authenticatedSession.session
        )
    }

    ///
    /// Removes a TV series from the user's watchlist.
    ///
    /// - Parameters:
    ///   - tvSeriesID: The identifier of the TV series.
    ///   - authenticatedSession: The user's authenticated session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    func removeFromWatchlist(
        tvSeries tvSeriesID: TVSeries.ID,
        authenticatedSession: AuthenticatedSession
    ) async throws(TMDbError) {
        try await removeFromWatchlist(
            tvSeries: tvSeriesID,
            accountID: authenticatedSession.accountID,
            session: authenticatedSession.session
        )
    }

    ///
    /// Returns a list of movies the user has rated.
    ///
    /// - Parameters:
    ///   - sortedBy: How results should be sorted.
    ///   - page: The page of results to return.
    ///   - authenticatedSession: The user's authenticated session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching movies as a pageable list.
    ///
    func ratedMovies(
        sortedBy: RatedSort? = nil,
        page: Int? = nil,
        authenticatedSession: AuthenticatedSession
    ) async throws(TMDbError) -> MoviePageableList {
        try await ratedMovies(
            sortedBy: sortedBy,
            page: page,
            accountID: authenticatedSession.accountID,
            session: authenticatedSession.session
        )
    }

    ///
    /// Returns a list of TV series the user has rated.
    ///
    /// - Parameters:
    ///   - sortedBy: How results should be sorted.
    ///   - page: The page of results to return.
    ///   - authenticatedSession: The user's authenticated session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching TV series as a pageable list.
    ///
    func ratedTVSeries(
        sortedBy: RatedSort? = nil,
        page: Int? = nil,
        authenticatedSession: AuthenticatedSession
    ) async throws(TMDbError) -> TVSeriesPageableList {
        try await ratedTVSeries(
            sortedBy: sortedBy,
            page: page,
            accountID: authenticatedSession.accountID,
            session: authenticatedSession.session
        )
    }

    ///
    /// Returns a list of TV episodes the user has rated.
    ///
    /// - Parameters:
    ///   - sortedBy: How results should be sorted.
    ///   - page: The page of results to return.
    ///   - authenticatedSession: The user's authenticated session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching TV episodes as a pageable list.
    ///
    func ratedTVEpisodes(
        sortedBy: RatedSort? = nil,
        page: Int? = nil,
        authenticatedSession: AuthenticatedSession
    ) async throws(TMDbError) -> TVEpisodePageableList {
        try await ratedTVEpisodes(
            sortedBy: sortedBy,
            page: page,
            accountID: authenticatedSession.accountID,
            session: authenticatedSession.session
        )
    }

    ///
    /// Returns a list of the user's custom lists.
    ///
    /// - Parameters:
    ///   - page: The page of results to return.
    ///   - authenticatedSession: The user's authenticated session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The user's lists as a pageable list.
    ///
    func lists(
        page: Int? = nil,
        authenticatedSession: AuthenticatedSession
    ) async throws(TMDbError) -> MediaListSummaryPageableList {
        try await lists(
            page: page,
            accountID: authenticatedSession.accountID,
            session: authenticatedSession.session
        )
    }

    ///
    /// Returns an async sequence of all the user's favourited movies across all
    /// pages.
    ///
    /// - Parameters:
    ///   - sortedBy: How results should be sorted.
    ///   - authenticatedSession: The user's authenticated session.
    ///
    /// - Returns: An async sequence that yields individual ``MovieListItem`` objects.
    ///
    func allFavouriteMovies(
        sortedBy: FavouriteSort? = nil,
        authenticatedSession: AuthenticatedSession
    ) -> PagedAsyncSequence<MovieListItem> {
        allFavouriteMovies(
            sortedBy: sortedBy,
            accountID: authenticatedSession.accountID,
            session: authenticatedSession.session
        )
    }

    ///
    /// Returns an async sequence of all the user's favourited TV series across
    /// all pages.
    ///
    /// - Parameters:
    ///   - sortedBy: How results should be sorted.
    ///   - authenticatedSession: The user's authenticated session.
    ///
    /// - Returns: An async sequence that yields individual ``TVSeriesListItem`` objects.
    ///
    func allFavouriteTVSeries(
        sortedBy: FavouriteSort? = nil,
        authenticatedSession: AuthenticatedSession
    ) -> PagedAsyncSequence<TVSeriesListItem> {
        allFavouriteTVSeries(
            sortedBy: sortedBy,
            accountID: authenticatedSession.accountID,
            session: authenticatedSession.session
        )
    }

    ///
    /// Returns an async sequence of all movies on the user's watchlist across
    /// all pages.
    ///
    /// - Parameters:
    ///   - sortedBy: How results should be sorted.
    ///   - authenticatedSession: The user's authenticated session.
    ///
    /// - Returns: An async sequence that yields individual ``MovieListItem`` objects.
    ///
    func allWatchlistMovies(
        sortedBy: WatchlistSort? = nil,
        authenticatedSession: AuthenticatedSession
    ) -> PagedAsyncSequence<MovieListItem> {
        allWatchlistMovies(
            sortedBy: sortedBy,
            accountID: authenticatedSession.accountID,
            session: authenticatedSession.session
        )
    }

    ///
    /// Returns an async sequence of all TV series on the user's watchlist across
    /// all pages.
    ///
    /// - Parameters:
    ///   - sortedBy: How results should be sorted.
    ///   - authenticatedSession: The user's authenticated session.
    ///
    /// - Returns: An async sequence that yields individual ``TVSeriesListItem`` objects.
    ///
    func allWatchlistTVSeries(
        sortedBy: WatchlistSort? = nil,
        authenticatedSession: AuthenticatedSession
    ) -> PagedAsyncSequence<TVSeriesListItem> {
        allWatchlistTVSeries(
            sortedBy: sortedBy,
            accountID: authenticatedSession.accountID,
            session: authenticatedSession.session
        )
    }

    ///
    /// Returns an async sequence of all movies the user has rated across all
    /// pages.
    ///
    /// - Parameters:
    ///   - sortedBy: How results should be sorted.
    ///   - authenticatedSession: The user's authenticated session.
    ///
    /// - Returns: An async sequence that yields individual ``MovieListItem`` objects.
    ///
    func allRatedMovies(
        sortedBy: RatedSort? = nil,
        authenticatedSession: AuthenticatedSession
    ) -> PagedAsyncSequence<MovieListItem> {
        allRatedMovies(
            sortedBy: sortedBy,
            accountID: authenticatedSession.accountID,
            session: authenticatedSession.session
        )
    }

    ///
    /// Returns an async sequence of all TV series the user has rated across all
    /// pages.
    ///
    /// - Parameters:
    ///   - sortedBy: How results should be sorted.
    ///   - authenticatedSession: The user's authenticated session.
    ///
    /// - Returns: An async sequence that yields individual ``TVSeriesListItem`` objects.
    ///
    func allRatedTVSeries(
        sortedBy: RatedSort? = nil,
        authenticatedSession: AuthenticatedSession
    ) -> PagedAsyncSequence<TVSeriesListItem> {
        allRatedTVSeries(
            sortedBy: sortedBy,
            accountID: authenticatedSession.accountID,
            session: authenticatedSession.session
        )
    }

    ///
    /// Returns an async sequence of all TV episodes the user has rated across
    /// all pages.
    ///
    /// - Parameters:
    ///   - sortedBy: How results should be sorted.
    ///   - authenticatedSession: The user's authenticated session.
    ///
    /// - Returns: An async sequence that yields individual ``TVEpisode`` objects.
    ///
    func allRatedTVEpisodes(
        sortedBy: RatedSort? = nil,
        authenticatedSession: AuthenticatedSession
    ) -> PagedAsyncSequence<TVEpisode> {
        allRatedTVEpisodes(
            sortedBy: sortedBy,
            accountID: authenticatedSession.accountID,
            session: authenticatedSession.session
        )
    }

    ///
    /// Returns an async sequence of all the user's custom lists across all pages.
    ///
    /// - Parameter authenticatedSession: The user's authenticated session.
    ///
    /// - Returns: An async sequence that yields individual ``MediaListSummary`` objects.
    ///
    func allLists(
        authenticatedSession: AuthenticatedSession
    ) -> PagedAsyncSequence<MediaListSummary> {
        allLists(
            accountID: authenticatedSession.accountID,
            session: authenticatedSession.session
        )
    }

    ///
    /// Returns an async sequence of all the user's favourited movie pages.
    ///
    /// - Parameters:
    ///   - sortedBy: How results should be sorted.
    ///   - authenticatedSession: The user's authenticated session.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages of ``MovieListItem`` objects.
    ///
    func allFavouriteMoviesPages(
        sortedBy: FavouriteSort? = nil,
        authenticatedSession: AuthenticatedSession
    ) -> PagedPagesAsyncSequence<MovieListItem> {
        allFavouriteMoviesPages(
            sortedBy: sortedBy,
            accountID: authenticatedSession.accountID,
            session: authenticatedSession.session
        )
    }

    ///
    /// Returns an async sequence of all the user's favourited TV series pages.
    ///
    /// - Parameters:
    ///   - sortedBy: How results should be sorted.
    ///   - authenticatedSession: The user's authenticated session.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages of ``TVSeriesListItem`` objects.
    ///
    func allFavouriteTVSeriesPages(
        sortedBy: FavouriteSort? = nil,
        authenticatedSession: AuthenticatedSession
    ) -> PagedPagesAsyncSequence<TVSeriesListItem> {
        allFavouriteTVSeriesPages(
            sortedBy: sortedBy,
            accountID: authenticatedSession.accountID,
            session: authenticatedSession.session
        )
    }

    ///
    /// Returns an async sequence of all the user's movie watchlist pages.
    ///
    /// - Parameters:
    ///   - sortedBy: How results should be sorted.
    ///   - authenticatedSession: The user's authenticated session.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages of ``MovieListItem`` objects.
    ///
    func allWatchlistMoviesPages(
        sortedBy: WatchlistSort? = nil,
        authenticatedSession: AuthenticatedSession
    ) -> PagedPagesAsyncSequence<MovieListItem> {
        allWatchlistMoviesPages(
            sortedBy: sortedBy,
            accountID: authenticatedSession.accountID,
            session: authenticatedSession.session
        )
    }

    ///
    /// Returns an async sequence of all the user's TV series watchlist pages.
    ///
    /// - Parameters:
    ///   - sortedBy: How results should be sorted.
    ///   - authenticatedSession: The user's authenticated session.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages of ``TVSeriesListItem`` objects.
    ///
    func allWatchlistTVSeriesPages(
        sortedBy: WatchlistSort? = nil,
        authenticatedSession: AuthenticatedSession
    ) -> PagedPagesAsyncSequence<TVSeriesListItem> {
        allWatchlistTVSeriesPages(
            sortedBy: sortedBy,
            accountID: authenticatedSession.accountID,
            session: authenticatedSession.session
        )
    }

    ///
    /// Returns an async sequence of all the user's rated movie pages.
    ///
    /// - Parameters:
    ///   - sortedBy: How results should be sorted.
    ///   - authenticatedSession: The user's authenticated session.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages of ``MovieListItem`` objects.
    ///
    func allRatedMoviesPages(
        sortedBy: RatedSort? = nil,
        authenticatedSession: AuthenticatedSession
    ) -> PagedPagesAsyncSequence<MovieListItem> {
        allRatedMoviesPages(
            sortedBy: sortedBy,
            accountID: authenticatedSession.accountID,
            session: authenticatedSession.session
        )
    }

    ///
    /// Returns an async sequence of all the user's rated TV series pages.
    ///
    /// - Parameters:
    ///   - sortedBy: How results should be sorted.
    ///   - authenticatedSession: The user's authenticated session.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages of ``TVSeriesListItem`` objects.
    ///
    func allRatedTVSeriesPages(
        sortedBy: RatedSort? = nil,
        authenticatedSession: AuthenticatedSession
    ) -> PagedPagesAsyncSequence<TVSeriesListItem> {
        allRatedTVSeriesPages(
            sortedBy: sortedBy,
            accountID: authenticatedSession.accountID,
            session: authenticatedSession.session
        )
    }

    ///
    /// Returns an async sequence of all the user's rated TV episode pages.
    ///
    /// - Parameters:
    ///   - sortedBy: How results should be sorted.
    ///   - authenticatedSession: The user's authenticated session.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages of ``TVEpisode`` objects.
    ///
    func allRatedTVEpisodesPages(
        sortedBy: RatedSort? = nil,
        authenticatedSession: AuthenticatedSession
    ) -> PagedPagesAsyncSequence<TVEpisode> {
        allRatedTVEpisodesPages(
            sortedBy: sortedBy,
            accountID: authenticatedSession.accountID,
            session: authenticatedSession.session
        )
    }

    ///
    /// Returns an async sequence of all the user's custom list pages.
    ///
    /// - Parameter authenticatedSession: The user's authenticated session.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages of ``MediaListSummary`` objects.
    ///
    func allListsPages(
        authenticatedSession: AuthenticatedSession
    ) -> PagedPagesAsyncSequence<MediaListSummary> {
        allListsPages(
            accountID: authenticatedSession.accountID,
            session: authenticatedSession.session
        )
    }

}
