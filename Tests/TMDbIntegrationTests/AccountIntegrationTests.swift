//
//  AccountIntegrationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(
    .serialized,
    .tags(.account),
    .enabled(if: CredentialHelper.shared.hasAPIKey && CredentialHelper.shared.hasCredential),
    .disabled()
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

        try await accountService.addFavourite(
            movie: movieID, accountID: accountDetails.id, session: session
        )

        let movieListAfterFavorited = try await accountService.favouriteMovies(
            accountID: accountDetails.id,
            session: session
        )
        let isMovieFavourited = movieListAfterFavorited.results.contains { $0.id == movieID }
        #expect(isMovieFavourited)

        try await accountService.removeFavourite(
            movie: movieID, accountID: accountDetails.id, session: session
        )

        let movieListAfterFavoriteRemoved = try await accountService.favouriteMovies(
            accountID: accountDetails.id,
            session: session
        )

        let isMovieFavouritedAfterRemoved = movieListAfterFavoriteRemoved.results.contains {
            $0.id == movieID
        }
        #expect(!isMovieFavouritedAfterRemoved)
    }

    @Test("add and removing favourite TV series")
    func addingAndRemovingFavouriteTVSeries() async throws {
        let accountDetails = try await accountService.details(session: session)
        let tvSeriesID = 2261

        try await accountService.addFavourite(
            tvSeries: tvSeriesID, accountID: accountDetails.id, session: session
        )

        let tvSeriesListAfterFavorited = try await accountService.favouriteTVSeries(
            accountID: accountDetails.id,
            session: session
        )
        let isTVSeriesFavourited = tvSeriesListAfterFavorited.results.contains {
            $0.id == tvSeriesID
        }
        #expect(isTVSeriesFavourited)

        try await accountService.removeFavourite(
            tvSeries: tvSeriesID, accountID: accountDetails.id, session: session
        )

        let tvSeriesListAfterFavoriteRemoved = try await accountService.favouriteTVSeries(
            accountID: accountDetails.id,
            session: session
        )

        let isTVSeriesFavouritedAfterRemoved = tvSeriesListAfterFavoriteRemoved.results.contains {
            $0.id == tvSeriesID
        }
        #expect(!isTVSeriesFavouritedAfterRemoved)
    }

    @Test("add and removing to movies watchlist")
    func addingAndRemovingToMoviesWatchlist() async throws {
        let accountDetails = try await accountService.details(session: session)
        let movieID = 550

        try await accountService.addToWatchlist(
            movie: movieID, accountID: accountDetails.id, session: session
        )

        let movieListAfterAddToWatchlist = try await accountService.movieWatchlist(
            accountID: accountDetails.id,
            session: session
        )
        let isMovieAddedToWatchlist = movieListAfterAddToWatchlist.results.contains {
            $0.id == movieID
        }
        #expect(isMovieAddedToWatchlist)

        try await accountService.removeFromWatchlist(
            movie: movieID, accountID: accountDetails.id, session: session
        )

        let movieListAfterRemovedFromWatchlist = try await accountService.movieWatchlist(
            accountID: accountDetails.id,
            session: session
        )

        let isMovieInWatchlistAfterRemoved = movieListAfterRemovedFromWatchlist.results.contains {
            $0.id == movieID
        }
        #expect(!isMovieInWatchlistAfterRemoved)
    }

    @Test("add and removing to TV series watchlist")
    func addingAndRemovingTVSeriesToWatchlist() async throws {
        let accountDetails = try await accountService.details(session: session)
        let tvSeriesID = 2261

        try await accountService.addToWatchlist(
            tvSeries: tvSeriesID, accountID: accountDetails.id, session: session
        )

        let tvSeriesListAfterAddedToWatchlist = try await accountService.tvSeriesWatchlist(
            accountID: accountDetails.id,
            session: session
        )
        let isTVSeriesAddedToWatchlist = tvSeriesListAfterAddedToWatchlist.results.contains {
            $0.id == tvSeriesID
        }
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

        let isTVSeriesInWatchlistAfterRemoved = tvSeriesListAfterRemovedFromWatchlist.results
            .contains {
                $0.id == tvSeriesID
            }
        #expect(!isTVSeriesInWatchlistAfterRemoved)
    }

    @Test("ratedMovies")
    func ratedMovies() async throws {
        let accountDetails = try await accountService.details(session: session)

        let ratedMoviesList = try await accountService.ratedMovies(
            accountID: accountDetails.id,
            session: session
        )

        #expect(ratedMoviesList.page >= 1)
        #expect(ratedMoviesList.results.count >= 0)
    }

    @Test("ratedTVSeries")
    func ratedTVSeries() async throws {
        let accountDetails = try await accountService.details(session: session)

        let ratedTVSeriesList = try await accountService.ratedTVSeries(
            accountID: accountDetails.id,
            session: session
        )

        #expect(ratedTVSeriesList.page >= 1)
        #expect(ratedTVSeriesList.results.count >= 0)
    }

    @Test("ratedTVEpisodes")
    func ratedTVEpisodes() async throws {
        let accountDetails = try await accountService.details(session: session)

        let ratedTVEpisodesList = try await accountService.ratedTVEpisodes(
            accountID: accountDetails.id,
            session: session
        )

        #expect(ratedTVEpisodesList.page >= 1)
        #expect(ratedTVEpisodesList.results.count >= 0)
    }

    @Test("lists")
    func lists() async throws {
        let accountDetails = try await accountService.details(session: session)

        let listsList = try await accountService.lists(
            accountID: accountDetails.id,
            session: session
        )

        #expect(listsList.page >= 1)
        #expect(listsList.results.count >= 0)
    }

}
