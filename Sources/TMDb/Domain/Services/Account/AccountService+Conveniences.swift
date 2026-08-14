//
//  AccountService+Conveniences.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

// swiftlint:disable file_length

import Foundation

///
/// Shorter forms of the ``AccountService`` requirements.
///
/// Every one of these **drops** parameters rather than defaulting them, and
/// there is one for each combination a caller can leave out. A defaulted
/// overload would share its requirement's signature — default values are not
/// part of a signature for witness matching — and so would silently become that
/// requirement's default implementation, recursing forever for any conformer
/// that omitted it. `Scripts/check-defaulted-witnesses.py` fails the lint if one
/// is ever added here, and equally if one of these overloads is ever removed:
/// dropping a combination is a source break for anyone calling it.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public extension AccountService {

    ///
    /// Returns a list of the user's favourited movies.
    ///
    /// - Parameters:
    ///    - sortedBy: How results should be sorted.
    ///    - accountID: The user's account identifier.
    ///    - session: The user's TMDb session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A list of the user's favourited movies.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func favouriteMovies(
        sortedBy: FavouriteSort?,
        accountID: Int,
        session: Session
    ) async throws(TMDbError) -> MoviePageableList {
        try await favouriteMovies(sortedBy: sortedBy, page: nil, accountID: accountID, session: session)
    }

    ///
    /// Returns a list of the user's favourited movies.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///    - accountID: The user's account identifier.
    ///    - session: The user's TMDb session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A list of the user's favourited movies.
    ///
    /// - Note: This convenience omits `sortedBy` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `sortedBy`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func favouriteMovies(
        page: Int?,
        accountID: Int,
        session: Session
    ) async throws(TMDbError) -> MoviePageableList {
        try await favouriteMovies(sortedBy: nil, page: page, accountID: accountID, session: session)
    }

    ///
    /// Returns a list of the user's favourited movies.
    ///
    /// - Parameters:
    ///    - accountID: The user's account identifier.
    ///    - session: The user's TMDb session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A list of the user's favourited movies.
    ///
    /// - Note: This convenience omits `sortedBy` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `sortedBy` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func favouriteMovies(
        accountID: Int,
        session: Session
    ) async throws(TMDbError) -> MoviePageableList {
        try await favouriteMovies(sortedBy: nil, page: nil, accountID: accountID, session: session)
    }

    ///
    /// Returns a list of the user's favourited TV series.
    ///
    /// - Parameters:
    ///    - sortedBy: How results should be sorted.
    ///    - accountID: The user's account identifier.
    ///    - session: The user's TMDb session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A list of the user's favourited TV series.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func favouriteTVSeries(
        sortedBy: FavouriteSort?,
        accountID: Int,
        session: Session
    ) async throws(TMDbError) -> TVSeriesPageableList {
        try await favouriteTVSeries(sortedBy: sortedBy, page: nil, accountID: accountID, session: session)
    }

    ///
    /// Returns a list of the user's favourited TV series.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///    - accountID: The user's account identifier.
    ///    - session: The user's TMDb session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A list of the user's favourited TV series.
    ///
    /// - Note: This convenience omits `sortedBy` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `sortedBy`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func favouriteTVSeries(
        page: Int?,
        accountID: Int,
        session: Session
    ) async throws(TMDbError) -> TVSeriesPageableList {
        try await favouriteTVSeries(sortedBy: nil, page: page, accountID: accountID, session: session)
    }

    ///
    /// Returns a list of the user's favourited TV series.
    ///
    /// - Parameters:
    ///    - accountID: The user's account identifier.
    ///    - session: The user's TMDb session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A list of the user's favourited TV series.
    ///
    /// - Note: This convenience omits `sortedBy` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `sortedBy` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func favouriteTVSeries(
        accountID: Int,
        session: Session
    ) async throws(TMDbError) -> TVSeriesPageableList {
        try await favouriteTVSeries(sortedBy: nil, page: nil, accountID: accountID, session: session)
    }

    ///
    /// Returns a list of movies in the user's watchlist.
    ///
    /// - Parameters:
    ///    - sortedBy: How results should be sorted.
    ///    - accountID: The user's account identifier.
    ///    - session: The user's TMDb session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A list of movies in the user's watchlist.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func movieWatchlist(
        sortedBy: WatchlistSort?,
        accountID: Int,
        session: Session
    ) async throws(TMDbError) -> MoviePageableList {
        try await movieWatchlist(sortedBy: sortedBy, page: nil, accountID: accountID, session: session)
    }

    ///
    /// Returns a list of movies in the user's watchlist.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///    - accountID: The user's account identifier.
    ///    - session: The user's TMDb session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A list of movies in the user's watchlist.
    ///
    /// - Note: This convenience omits `sortedBy` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `sortedBy`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func movieWatchlist(
        page: Int?,
        accountID: Int,
        session: Session
    ) async throws(TMDbError) -> MoviePageableList {
        try await movieWatchlist(sortedBy: nil, page: page, accountID: accountID, session: session)
    }

    ///
    /// Returns a list of movies in the user's watchlist.
    ///
    /// - Parameters:
    ///    - accountID: The user's account identifier.
    ///    - session: The user's TMDb session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A list of movies in the user's watchlist.
    ///
    /// - Note: This convenience omits `sortedBy` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `sortedBy` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func movieWatchlist(
        accountID: Int,
        session: Session
    ) async throws(TMDbError) -> MoviePageableList {
        try await movieWatchlist(sortedBy: nil, page: nil, accountID: accountID, session: session)
    }

    ///
    /// Returns a list of movies rated by the user.
    ///
    /// - Parameters:
    ///    - sortedBy: How results should be sorted.
    ///    - accountID: The user's account identifier.
    ///    - session: The user's TMDb session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A list of movies rated by the user.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func ratedMovies(
        sortedBy: RatedSort?,
        accountID: Int,
        session: Session
    ) async throws(TMDbError) -> MoviePageableList {
        try await ratedMovies(sortedBy: sortedBy, page: nil, accountID: accountID, session: session)
    }

    ///
    /// Returns a list of movies rated by the user.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///    - accountID: The user's account identifier.
    ///    - session: The user's TMDb session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A list of movies rated by the user.
    ///
    /// - Note: This convenience omits `sortedBy` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `sortedBy`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func ratedMovies(
        page: Int?,
        accountID: Int,
        session: Session
    ) async throws(TMDbError) -> MoviePageableList {
        try await ratedMovies(sortedBy: nil, page: page, accountID: accountID, session: session)
    }

    ///
    /// Returns a list of movies rated by the user.
    ///
    /// - Parameters:
    ///    - accountID: The user's account identifier.
    ///    - session: The user's TMDb session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A list of movies rated by the user.
    ///
    /// - Note: This convenience omits `sortedBy` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `sortedBy` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func ratedMovies(
        accountID: Int,
        session: Session
    ) async throws(TMDbError) -> MoviePageableList {
        try await ratedMovies(sortedBy: nil, page: nil, accountID: accountID, session: session)
    }

    ///
    /// Returns a list of TV episodes rated by the user.
    ///
    /// - Parameters:
    ///    - sortedBy: How results should be sorted.
    ///    - accountID: The user's account identifier.
    ///    - session: The user's TMDb session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A list of TV episodes rated by the user.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func ratedTVEpisodes(
        sortedBy: RatedSort?,
        accountID: Int,
        session: Session
    ) async throws(TMDbError) -> TVEpisodePageableList {
        try await ratedTVEpisodes(sortedBy: sortedBy, page: nil, accountID: accountID, session: session)
    }

    ///
    /// Returns a list of TV episodes rated by the user.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///    - accountID: The user's account identifier.
    ///    - session: The user's TMDb session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A list of TV episodes rated by the user.
    ///
    /// - Note: This convenience omits `sortedBy` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `sortedBy`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func ratedTVEpisodes(
        page: Int?,
        accountID: Int,
        session: Session
    ) async throws(TMDbError) -> TVEpisodePageableList {
        try await ratedTVEpisodes(sortedBy: nil, page: page, accountID: accountID, session: session)
    }

    ///
    /// Returns a list of TV episodes rated by the user.
    ///
    /// - Parameters:
    ///    - accountID: The user's account identifier.
    ///    - session: The user's TMDb session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A list of TV episodes rated by the user.
    ///
    /// - Note: This convenience omits `sortedBy` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `sortedBy` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func ratedTVEpisodes(
        accountID: Int,
        session: Session
    ) async throws(TMDbError) -> TVEpisodePageableList {
        try await ratedTVEpisodes(sortedBy: nil, page: nil, accountID: accountID, session: session)
    }

    ///
    /// Returns a list of TV series rated by the user.
    ///
    /// - Parameters:
    ///    - sortedBy: How results should be sorted.
    ///    - accountID: The user's account identifier.
    ///    - session: The user's TMDb session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A list of TV series rated by the user.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func ratedTVSeries(
        sortedBy: RatedSort?,
        accountID: Int,
        session: Session
    ) async throws(TMDbError) -> TVSeriesPageableList {
        try await ratedTVSeries(sortedBy: sortedBy, page: nil, accountID: accountID, session: session)
    }

    ///
    /// Returns a list of TV series rated by the user.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///    - accountID: The user's account identifier.
    ///    - session: The user's TMDb session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A list of TV series rated by the user.
    ///
    /// - Note: This convenience omits `sortedBy` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `sortedBy`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func ratedTVSeries(
        page: Int?,
        accountID: Int,
        session: Session
    ) async throws(TMDbError) -> TVSeriesPageableList {
        try await ratedTVSeries(sortedBy: nil, page: page, accountID: accountID, session: session)
    }

    ///
    /// Returns a list of TV series rated by the user.
    ///
    /// - Parameters:
    ///    - accountID: The user's account identifier.
    ///    - session: The user's TMDb session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A list of TV series rated by the user.
    ///
    /// - Note: This convenience omits `sortedBy` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `sortedBy` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func ratedTVSeries(
        accountID: Int,
        session: Session
    ) async throws(TMDbError) -> TVSeriesPageableList {
        try await ratedTVSeries(sortedBy: nil, page: nil, accountID: accountID, session: session)
    }

    ///
    /// Returns a list of TV series in the user's watchlist.
    ///
    /// - Parameters:
    ///    - sortedBy: How results should be sorted.
    ///    - accountID: The user's account identifier.
    ///    - session: The user's TMDb session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A list of TV series in the user's watchlist.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func tvSeriesWatchlist(
        sortedBy: WatchlistSort?,
        accountID: Int,
        session: Session
    ) async throws(TMDbError) -> TVSeriesPageableList {
        try await tvSeriesWatchlist(sortedBy: sortedBy, page: nil, accountID: accountID, session: session)
    }

    ///
    /// Returns a list of TV series in the user's watchlist.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///    - accountID: The user's account identifier.
    ///    - session: The user's TMDb session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A list of TV series in the user's watchlist.
    ///
    /// - Note: This convenience omits `sortedBy` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `sortedBy`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func tvSeriesWatchlist(
        page: Int?,
        accountID: Int,
        session: Session
    ) async throws(TMDbError) -> TVSeriesPageableList {
        try await tvSeriesWatchlist(sortedBy: nil, page: page, accountID: accountID, session: session)
    }

    ///
    /// Returns a list of TV series in the user's watchlist.
    ///
    /// - Parameters:
    ///    - accountID: The user's account identifier.
    ///    - session: The user's TMDb session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A list of TV series in the user's watchlist.
    ///
    /// - Note: This convenience omits `sortedBy` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `sortedBy` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func tvSeriesWatchlist(
        accountID: Int,
        session: Session
    ) async throws(TMDbError) -> TVSeriesPageableList {
        try await tvSeriesWatchlist(sortedBy: nil, page: nil, accountID: accountID, session: session)
    }

}
