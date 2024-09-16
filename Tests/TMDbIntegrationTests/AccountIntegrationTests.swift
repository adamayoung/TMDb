//
//  AccountIntegrationTests.swift
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
import Testing
@testable import TMDb

@Suite(
    .serialized,
    .tags(.account),
    .enabled(if: CredentialHelper.shared.hasAPIKey && CredentialHelper.shared.hasCredential)
)
final class AccountIntegrationTests {

    var accountService: (any AccountService)!
    var authenticationService: (any AuthenticationService)!
    var session: Session!

    init() async throws {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        let tmdbClient = TMDbClient(apiKey: apiKey)

        self.authenticationService = tmdbClient.authentication
        self.accountService = tmdbClient.account
        self.session = try await TMDbSessionHelper.shared.createSession()
    }

    deinit {
        if let thisSession = session {
            Task {
                try await TMDbSessionHelper.shared.delete(session: thisSession)
            }
        }
    }

    @Test("details")
    func details() async throws {
        let details = try await accountService.details(session: session)

        #expect(details.id > 0)
    }

    @Test("adding and removing favourite movies")
    func addingAndRemovingFavouriteMovies() async throws {
        let accountDetails = try await accountService.details(session: session)
        let movieID = 550

        try await accountService.addFavourite(movie: movieID, accountID: accountDetails.id, session: session)

        let movieListAfterFavorited = try await accountService.favouriteMovies(
            accountID: accountDetails.id,
            session: session
        )
        let isMovieFavourited = movieListAfterFavorited.results.contains { $0.id == movieID }
        #expect(isMovieFavourited)

        try await accountService.removeFavourite(movie: movieID, accountID: accountDetails.id, session: session)

        let movieListAfterFavoriteRemoved = try await accountService.favouriteMovies(
            accountID: accountDetails.id,
            session: session
        )

        let isMovieFavouritedAfterRemoved = movieListAfterFavoriteRemoved.results.contains { $0.id == movieID }
        #expect(!isMovieFavouritedAfterRemoved)
    }

    @Test("add and removing favourite TV series")
    func addingAndRemovingFavouriteTVSeries() async throws {
        let accountDetails = try await accountService.details(session: session)
        let tvSeriesID = 2261

        try await accountService.addFavourite(tvSeries: tvSeriesID, accountID: accountDetails.id, session: session)

        let tvSeriesListAfterFavorited = try await accountService.favouriteTVSeries(
            accountID: accountDetails.id,
            session: session
        )
        let isTVSeriesFavourited = tvSeriesListAfterFavorited.results.contains { $0.id == tvSeriesID }
        #expect(isTVSeriesFavourited)

        try await accountService.removeFavourite(tvSeries: tvSeriesID, accountID: accountDetails.id, session: session)

        let tvSeriesListAfterFavoriteRemoved = try await accountService.favouriteTVSeries(
            accountID: accountDetails.id,
            session: session
        )

        let isTVSeriesFavouritedAfterRemoved = tvSeriesListAfterFavoriteRemoved.results.contains { $0.id == tvSeriesID }
        #expect(!isTVSeriesFavouritedAfterRemoved)
    }

    @Test("add and removing to movies watchlist")
    func addingAndRemovingToMoviesWatchlist() async throws {
        let accountDetails = try await accountService.details(session: session)
        let movieID = 550

        try await accountService.addToWatchlist(movie: movieID, accountID: accountDetails.id, session: session)

        let movieListAfterAddToWatchlist = try await accountService.movieWatchlist(
            accountID: accountDetails.id,
            session: session
        )
        let isMovieAddedToWatchlist = movieListAfterAddToWatchlist.results.contains { $0.id == movieID }
        #expect(isMovieAddedToWatchlist)

        try await accountService.removeFromWatchlist(movie: movieID, accountID: accountDetails.id, session: session)

        let movieListAfterRemovedFromWatchlist = try await accountService.movieWatchlist(
            accountID: accountDetails.id,
            session: session
        )

        let isMovieInWatchlistAfterRemoved = movieListAfterRemovedFromWatchlist.results.contains { $0.id == movieID }
        #expect(!isMovieInWatchlistAfterRemoved)
    }

    @Test("add and removing to TV series watchlist")
    func addingAndRemovingTVSeriesToWatchlist() async throws {
        let accountDetails = try await accountService.details(session: session)
        let tvSeriesID = 2261

        try await accountService.addToWatchlist(tvSeries: tvSeriesID, accountID: accountDetails.id, session: session)

        let tvSeriesListAfterAddedToWatchlist = try await accountService.tvSeriesWatchlist(
            accountID: accountDetails.id,
            session: session
        )
        let isTVSeriesAddedToWatchlist = tvSeriesListAfterAddedToWatchlist.results.contains { $0.id == tvSeriesID }
        #expect(isTVSeriesAddedToWatchlist)

        try await accountService.removeFromWatchlist(
            tvSeries: tvSeriesID,
            accountID: accountDetails.id,
            session: session
        )

        let tvSeriesListAfterRemovedFromWatchlist = try await accountService.tvSeriesWatchlist(
            accountID: accountDetails.id,
            session: session
        )

        let isTVSeriesInWatchlistAfterRemoved = tvSeriesListAfterRemovedFromWatchlist.results.contains {
            $0.id == tvSeriesID
        }
        #expect(!isTVSeriesInWatchlistAfterRemoved)
    }

}
