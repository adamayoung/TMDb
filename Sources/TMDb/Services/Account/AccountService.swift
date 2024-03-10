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

    public func addFavourite(movie movieID: Movie.ID, accountID: Int, session: Session) async throws {
        try await addFavourite(
            showID: movieID,
            showType: .movie,
            isFavourite: true,
            accountID: accountID,
            session: session
        )
    }

    public func removeFavourite(movie movieID: Movie.ID, accountID: Int, session: Session) async throws {
        try await addFavourite(
            showID: movieID,
            showType: .movie,
            isFavourite: false,
            accountID: accountID,
            session: session
        )
    }

    public func addFavourite(tvSeries tvSeriesID: TVSeries.ID, accountID: Int, session: Session) async throws {
        try await addFavourite(
            showID: tvSeriesID,
            showType: .tvSeries,
            isFavourite: true,
            accountID: accountID,
            session: session
        )
    }

    public func removeFavourite(tvSeries tvSeriesID: TVSeries.ID, accountID: Int, session: Session) async throws {
        try await addFavourite(
            showID: tvSeriesID,
            showType: .tvSeries,
            isFavourite: false,
            accountID: accountID,
            session: session
        )
    }

}

extension AccountService {

    private func addFavourite(
        showID: Show.ID,
        showType: ShowType,
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

}
