//
//  AccountService.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
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

// swiftlint:disable file_length

///
/// Provides an interface for obtaining account data from TMDb.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public final class AccountService {

    private let apiClient: any APIClient

    ///
    /// Creates an account service object.
    ///
    public convenience init() {
        self.init(
            apiClient: TMDbFactory.apiClient
        )
    }

    init(apiClient: some APIClient) {
        self.apiClient = apiClient
    }

    ///
    /// Returns the TMDb user's account details..
    ///
    /// - Parameter session: The user's TMDb session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The user's account details.
    ///
    public func details(session: Session) async throws -> AccountDetails {
        let accountDetails: AccountDetails
        do {
            accountDetails = try await apiClient.get(endpoint: AccountEndpoint.details(sessionID: session.sessionID))
        } catch let error {
            throw TMDbError(error: error)
        }

        return accountDetails
    }

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
        let movieList: MoviePageableList
        do {
            movieList = try await apiClient.get(
                endpoint: AccountEndpoint.favouriteMovies(
                    sortedBy: sortedBy,
                    page: page,
                    accountID: accountID,
                    sessionID: session.sessionID
                )
            )
        } catch let error {
            throw TMDbError(error: error)
        }

        return movieList
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
        let tvSeriesList: TVSeriesPageableList
        do {
            tvSeriesList = try await apiClient.get(
                endpoint: AccountEndpoint.favouriteTVSeries(
                    sortedBy: sortedBy,
                    page: page,
                    accountID: accountID,
                    sessionID: session.sessionID
                )
            )
        } catch let error {
            throw TMDbError(error: error)
        }

        return tvSeriesList
    }

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
    public func addFavourite(movie movieID: Movie.ID, accountID: Int, session: Session) async throws {
        try await addFavourite(
            showType: .movie,
            showID: movieID,
            isFavourite: true,
            accountID: accountID,
            session: session
        )
    }

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
    public func removeFavourite(movie movieID: Movie.ID, accountID: Int, session: Session) async throws {
        try await addFavourite(
            showType: .movie,
            showID: movieID,
            isFavourite: false,
            accountID: accountID,
            session: session
        )
    }

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
    public func addFavourite(tvSeries tvSeriesID: TVSeries.ID, accountID: Int, session: Session) async throws {
        try await addFavourite(
            showType: .tvSeries,
            showID: tvSeriesID,
            isFavourite: true,
            accountID: accountID,
            session: session
        )
    }

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
    public func removeFavourite(tvSeries tvSeriesID: TVSeries.ID, accountID: Int, session: Session) async throws {
        try await addFavourite(
            showType: .tvSeries,
            showID: tvSeriesID,
            isFavourite: false,
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
        let movieList: MoviePageableList
        do {
            movieList = try await apiClient.get(
                endpoint: AccountEndpoint.movieWatchlist(
                    sortedBy: sortedBy,
                    page: page,
                    accountID: accountID,
                    sessionID: session.sessionID
                )
            )
        } catch let error {
            throw TMDbError(error: error)
        }

        return movieList
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
        let tvSeriesList: TVSeriesPageableList
        do {
            tvSeriesList = try await apiClient.get(
                endpoint: AccountEndpoint.tvSeriesWatchlist(
                    sortedBy: sortedBy,
                    page: page,
                    accountID: accountID,
                    sessionID: session.sessionID
                )
            )
        } catch let error {
            throw TMDbError(error: error)
        }

        return tvSeriesList
    }

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
    public func addToWatchlist(movie movieID: Movie.ID, accountID: Int, session: Session) async throws {
        try await addToWatchlist(
            showType: .movie,
            showID: movieID,
            isInWatchlist: true,
            accountID: accountID,
            session: session
        )
    }

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
    public func removeFromWatchlist(movie movieID: Movie.ID, accountID: Int, session: Session) async throws {
        try await addToWatchlist(
            showType: .movie,
            showID: movieID,
            isInWatchlist: false,
            accountID: accountID,
            session: session
        )
    }

    ///
    /// Adds a TV series to a user's watchlist.
    ///
    /// - Parameters:
    ///   - movieID: The TV series identifier.
    ///   - accountID: The user's account identifier.
    ///   - session: The user's session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    public func addToWatchlist(tvSeries tvSeriesID: TVSeries.ID, accountID: Int, session: Session) async throws {
        try await addToWatchlist(
            showType: .tvSeries,
            showID: tvSeriesID,
            isInWatchlist: true,
            accountID: accountID,
            session: session
        )
    }

    ///
    /// Removes a TV series from a user's watchlist.
    ///
    /// - Parameters:
    ///   - movieID: The TV series identifier.
    ///   - accountID: The user's account identifier.
    ///   - session: The user's session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    public func removeFromWatchlist(tvSeries tvSeriesID: TVSeries.ID, accountID: Int, session: Session) async throws {
        try await addToWatchlist(
            showType: .tvSeries,
            showID: tvSeriesID,
            isInWatchlist: false,
            accountID: accountID,
            session: session
        )
    }

}

extension AccountService {

    private func addFavourite(
        showType: ShowType,
        showID: Show.ID,
        isFavourite: Bool,
        accountID: Int,
        session: Session
    ) async throws {
        let body = AddFavouriteRequestBody(showType: showType, showID: showID, isFavourite: isFavourite)
        do {
            _ = try await apiClient.post(
                endpoint: AccountEndpoint.addFavourite(accountID: accountID, sessionID: session.sessionID),
                body: body
            ) as SuccessResult
        } catch let error {
            throw TMDbError(error: error)
        }
    }

    private func addToWatchlist(
        showType: ShowType,
        showID: Show.ID,
        isInWatchlist: Bool,
        accountID: Int,
        session: Session
    ) async throws {
        let body = AddToWatchlistRequestBody(showType: showType, showID: showID, isInWatchlist: isInWatchlist)
        do {
            _ = try await apiClient.post(
                endpoint: AccountEndpoint.addToWatchlist(accountID: accountID, sessionID: session.sessionID),
                body: body
            ) as SuccessResult
        } catch let error {
            throw TMDbError(error: error)
        }
    }

}
