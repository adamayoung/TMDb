//
//  AccountService.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

///
/// Provides an interface for obtaining account data from TMDb.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public protocol AccountService: Sendable {

    ///
    /// Returns the TMDb user's account details.
    ///
    /// - Parameter session: The user's TMDb session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The user's account details.
    ///
    func details(session: Session) async throws -> AccountDetails

    ///
    /// Returns a list of the user's favourited movies.
    ///
    /// - Parameters:
    ///   - sortedBy: How results should be sorted.
    ///   - page: The page of results to return.
    ///   - accountID: The user's account identifier.
    ///   - session: The user's TMDb session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A list of the user's favourited movies.
    ///
    func favouriteMovies(
        sortedBy: FavouriteSort?,
        page: Int?,
        accountID: Int,
        session: Session
    ) async throws -> MoviePageableList

    ///
    /// Returns a list of the user's favourited TV series.
    ///
    /// - Parameters:
    ///   - sortedBy: How results should be sorted.
    ///   - page: The page of results to return.
    ///   - accountID: The user's account identifier.
    ///   - session: The user's TMDb session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A list of the user's favourited TV series.
    ///
    func favouriteTVSeries(
        sortedBy: FavouriteSort?,
        page: Int?,
        accountID: Int,
        session: Session
    ) async throws -> TVSeriesPageableList

    ///
    /// Adds a movie to a user's favourites.
    ///
    /// - Parameters:
    ///   - movieID: The movie identifier.
    ///   - accountID: The user's account identifier.
    ///   - session: The user's session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    func addFavourite(
        movie movieID: Movie.ID,
        accountID: Int,
        session: Session
    ) async throws

    ///
    /// Removes a movie from a user's favourites.
    ///
    /// - Parameters:
    ///   - movieID: The movie identifier.
    ///   - accountID: The user's account identifier.
    ///   - session: The user's session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    func removeFavourite(
        movie movieID: Movie.ID,
        accountID: Int,
        session: Session
    ) async throws

    ///
    /// Adds a TV series to a user's favourites.
    ///
    /// - Parameters:
    ///   - tvSeriesID: The TV series identifier.
    ///   - accountID: The user's account identifier.
    ///   - session: The user's session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    func addFavourite(
        tvSeries tvSeriesID: TVSeries.ID,
        accountID: Int,
        session: Session
    ) async throws

    ///
    /// Removes a TV series from a user's favourites.
    ///
    /// - Parameters:
    ///   - tvSeriesID: The TV series identifier.
    ///   - accountID: The user's account identifier.
    ///   - session: The user's session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    func removeFavourite(
        tvSeries tvSeriesID: TVSeries.ID,
        accountID: Int,
        session: Session
    ) async throws

    ///
    /// Returns a list of movies in the user's watchlist.
    ///
    /// - Parameters:
    ///   - sortedBy: How results should be sorted.
    ///   - page: The page of results to return.
    ///   - accountID: The user's account identifier.
    ///   - session: The user's TMDb session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A list of movies in the user's watchlist.
    ///
    func movieWatchlist(
        sortedBy: WatchlistSort?,
        page: Int?,
        accountID: Int,
        session: Session
    ) async throws -> MoviePageableList

    ///
    /// Returns a list of TV series in the user's watchlist.
    ///
    /// - Parameters:
    ///   - sortedBy: How results should be sorted.
    ///   - page: The page of results to return.
    ///   - accountID: The user's account identifier.
    ///   - session: The user's TMDb session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A list of TV series in the user's watchlist.
    ///
    func tvSeriesWatchlist(
        sortedBy: WatchlistSort?,
        page: Int?,
        accountID: Int,
        session: Session
    ) async throws -> TVSeriesPageableList

    ///
    /// Adds a movie to a user's watchlist.
    ///
    /// - Parameters:
    ///   - movieID: The movie identifier.
    ///   - accountID: The user's account identifier.
    ///   - session: The user's session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    func addToWatchlist(
        movie movieID: Movie.ID,
        accountID: Int,
        session: Session
    ) async throws

    ///
    /// Removes a movie from a user's watchlist.
    ///
    /// - Parameters:
    ///   - movieID: The movie identifier.
    ///   - accountID: The user's account identifier.
    ///   - session: The user's session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    func removeFromWatchlist(
        movie movieID: Movie.ID,
        accountID: Int,
        session: Session
    ) async throws

    ///
    /// Adds a TV series to a user's watchlist.
    ///
    /// - Parameters:
    ///   - tvSeriesID: The TV series identifier.
    ///   - accountID: The user's account identifier.
    ///   - session: The user's session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    func addToWatchlist(
        tvSeries tvSeriesID: TVSeries.ID,
        accountID: Int,
        session: Session
    ) async throws

    ///
    /// Removes a TV series from a user's watchlist.
    ///
    /// - Parameters:
    ///   - tvSeriesID: The TV series identifier.
    ///   - accountID: The user's account identifier.
    ///   - session: The user's session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    func removeFromWatchlist(
        tvSeries tvSeriesID: TVSeries.ID,
        accountID: Int,
        session: Session
    ) async throws

}

extension AccountService {

    ///
    /// Returns a list of the user's favourited movies.
    ///
    /// - Parameters:
    ///   - sortedBy: How results should be sorted.
    ///   - page: The page of results to return.
    ///   - accountID: The user's account identifier.
    ///   - session: The user's TMDb session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A list of the user's favourited movies.
    ///
    public func favouriteMovies(
        sortedBy: FavouriteSort? = nil,
        page: Int? = nil,
        accountID: Int,
        session: Session
    ) async throws -> MoviePageableList {
        try await favouriteMovies(
            sortedBy: sortedBy,
            page: page,
            accountID: accountID,
            session: session
        )
    }

    ///
    /// Returns a list of the user's favourited TV series.
    ///
    /// - Parameters:
    ///   - sortedBy: How results should be sorted.
    ///   - page: The page of results to return.
    ///   - accountID: The user's account identifier.
    ///   - session: The user's TMDb session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A list of the user's favourited TV series.
    ///
    public func favouriteTVSeries(
        sortedBy: FavouriteSort? = nil,
        page: Int? = nil,
        accountID: Int,
        session: Session
    ) async throws -> TVSeriesPageableList {
        try await favouriteTVSeries(
            sortedBy: sortedBy,
            page: page,
            accountID: accountID,
            session: session
        )
    }

    ///
    /// Returns a list of movies in the user's watchlist.
    ///
    /// - Parameters:
    ///   - sortedBy: How results should be sorted.
    ///   - page: The page of results to return.
    ///   - accountID: The user's account identifier.
    ///   - session: The user's TMDb session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A list of movies in the user's watchlist.
    ///
    public func movieWatchlist(
        sortedBy: WatchlistSort? = nil,
        page: Int? = nil,
        accountID: Int,
        session: Session
    ) async throws -> MoviePageableList {
        try await movieWatchlist(
            sortedBy: sortedBy,
            page: page,
            accountID: accountID,
            session: session
        )
    }

    ///
    /// Returns a list of TV series in the user's watchlist.
    ///
    /// - Parameters:
    ///   - sortedBy: How results should be sorted.
    ///   - page: The page of results to return.
    ///   - accountID: The user's account identifier.
    ///   - session: The user's TMDb session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A list of TV series in the user's watchlist.
    ///
    public func tvSeriesWatchlist(
        sortedBy: WatchlistSort? = nil,
        page: Int? = nil,
        accountID: Int,
        session: Session
    ) async throws -> TVSeriesPageableList {
        try await tvSeriesWatchlist(
            sortedBy: sortedBy,
            page: page,
            accountID: accountID,
            session: session
        )
    }

}
