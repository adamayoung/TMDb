//
//  TMDbAccountServiceAuthenticatedSessionTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .account))
struct TMDbAccountServiceAuthenticatedSessionTests {

    var service: TMDbAccountService!
    var apiClient: MockAPIClient!
    var session: Session!
    let accountID = 123

    init() {
        self.session = Session(success: true, sessionID: "abc123")
        self.apiClient = MockAPIClient()
        self.service = TMDbAccountService(apiClient: apiClient)
    }

    private var authenticatedSession: AuthenticatedSession {
        AuthenticatedSession(accountID: accountID, session: session)
    }

    // MARK: - authenticatedSession(for:)

    @Test("authenticatedSession(for:) bundles the account identifier with the session")
    func authenticatedSessionForSessionBundlesAccountIDAndSession() async throws {
        apiClient.addResponse(.success(AccountDetails.mock(id: 999)))

        let result = try await service.authenticatedSession(for: session)

        #expect(result.accountID == 999)
        #expect(result.session == session)
        #expect(apiClient.lastRequest as? AccountRequest == AccountRequest(sessionID: session.sessionID))
    }

    @Test("authenticatedSession(for:) propagates an error from details")
    func authenticatedSessionForSessionPropagatesError() async throws {
        apiClient.addResponse(.failure(.unauthorised()))

        await #expect(throws: TMDbError.unauthorised()) {
            _ = try await service.authenticatedSession(for: session)
        }
    }

    // MARK: - Favourites

    @Test("favouriteMovies forwards the authenticated session")
    func favouriteMoviesForwardsAuthenticatedSession() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = FavouriteMoviesRequest(
            sortedBy: nil,
            page: nil,
            accountID: accountID,
            sessionID: session.sessionID
        )

        let result = try await service.favouriteMovies(authenticatedSession: authenticatedSession)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? FavouriteMoviesRequest == expectedRequest)
    }

    @Test("favouriteTVSeries forwards the authenticated session")
    func favouriteTVSeriesForwardsAuthenticatedSession() async throws {
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.favouriteTVSeries(authenticatedSession: authenticatedSession)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest is FavouriteTVSeriesRequest)
    }

    @Test("addFavourite(movie:) forwards the authenticated session")
    func addFavouriteMovieForwardsAuthenticatedSession() async throws {
        apiClient.addResponse(.success(SuccessResult(success: true)))
        let expectedRequest = AddFavouriteRequest(
            showType: .movie,
            showID: 550,
            isFavourite: true,
            accountID: accountID,
            sessionID: session.sessionID
        )

        try await service.addFavourite(movie: 550, authenticatedSession: authenticatedSession)

        #expect(apiClient.lastRequest as? AddFavouriteRequest == expectedRequest)
    }

    @Test("addFavourite(tvSeries:) forwards the authenticated session")
    func addFavouriteTVSeriesForwardsAuthenticatedSession() async throws {
        apiClient.addResponse(.success(SuccessResult(success: true)))
        let expectedRequest = AddFavouriteRequest(
            showType: .tvSeries,
            showID: 1234,
            isFavourite: true,
            accountID: accountID,
            sessionID: session.sessionID
        )

        try await service.addFavourite(tvSeries: 1234, authenticatedSession: authenticatedSession)

        #expect(apiClient.lastRequest as? AddFavouriteRequest == expectedRequest)
    }

    @Test("removeFavourite(movie:) forwards the authenticated session")
    func removeFavouriteMovieForwardsAuthenticatedSession() async throws {
        apiClient.addResponse(.success(SuccessResult(success: true)))
        let expectedRequest = AddFavouriteRequest(
            showType: .movie,
            showID: 550,
            isFavourite: false,
            accountID: accountID,
            sessionID: session.sessionID
        )

        try await service.removeFavourite(movie: 550, authenticatedSession: authenticatedSession)

        #expect(apiClient.lastRequest as? AddFavouriteRequest == expectedRequest)
    }

    @Test("removeFavourite(tvSeries:) forwards the authenticated session")
    func removeFavouriteTVSeriesForwardsAuthenticatedSession() async throws {
        apiClient.addResponse(.success(SuccessResult(success: true)))
        let expectedRequest = AddFavouriteRequest(
            showType: .tvSeries,
            showID: 1234,
            isFavourite: false,
            accountID: accountID,
            sessionID: session.sessionID
        )

        try await service.removeFavourite(tvSeries: 1234, authenticatedSession: authenticatedSession)

        #expect(apiClient.lastRequest as? AddFavouriteRequest == expectedRequest)
    }

    // MARK: - Watchlist

    @Test("movieWatchlist forwards the authenticated session")
    func movieWatchlistForwardsAuthenticatedSession() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.movieWatchlist(authenticatedSession: authenticatedSession)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest is MovieWatchlistRequest)
    }

    @Test("tvSeriesWatchlist forwards the authenticated session")
    func tvSeriesWatchlistForwardsAuthenticatedSession() async throws {
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.tvSeriesWatchlist(authenticatedSession: authenticatedSession)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest is TVSeriesWatchlistRequest)
    }

    @Test("addToWatchlist(movie:) forwards the authenticated session")
    func addToWatchlistMovieForwardsAuthenticatedSession() async throws {
        apiClient.addResponse(.success(SuccessResult(success: true)))
        let expectedRequest = AddToWatchlistRequest(
            showType: .movie,
            showID: 550,
            isInWatchlist: true,
            accountID: accountID,
            sessionID: session.sessionID
        )

        try await service.addToWatchlist(movie: 550, authenticatedSession: authenticatedSession)

        #expect(apiClient.lastRequest as? AddToWatchlistRequest == expectedRequest)
    }

    @Test("removeFromWatchlist(tvSeries:) forwards the authenticated session")
    func removeFromWatchlistTVSeriesForwardsAuthenticatedSession() async throws {
        apiClient.addResponse(.success(SuccessResult(success: true)))
        let expectedRequest = AddToWatchlistRequest(
            showType: .tvSeries,
            showID: 1234,
            isInWatchlist: false,
            accountID: accountID,
            sessionID: session.sessionID
        )

        try await service.removeFromWatchlist(tvSeries: 1234, authenticatedSession: authenticatedSession)

        #expect(apiClient.lastRequest as? AddToWatchlistRequest == expectedRequest)
    }

    @Test("addToWatchlist(tvSeries:) forwards the authenticated session")
    func addToWatchlistTVSeriesForwardsAuthenticatedSession() async throws {
        apiClient.addResponse(.success(SuccessResult(success: true)))
        let expectedRequest = AddToWatchlistRequest(
            showType: .tvSeries,
            showID: 1234,
            isInWatchlist: true,
            accountID: accountID,
            sessionID: session.sessionID
        )

        try await service.addToWatchlist(tvSeries: 1234, authenticatedSession: authenticatedSession)

        #expect(apiClient.lastRequest as? AddToWatchlistRequest == expectedRequest)
    }

    @Test("removeFromWatchlist(movie:) forwards the authenticated session")
    func removeFromWatchlistMovieForwardsAuthenticatedSession() async throws {
        apiClient.addResponse(.success(SuccessResult(success: true)))
        let expectedRequest = AddToWatchlistRequest(
            showType: .movie,
            showID: 550,
            isInWatchlist: false,
            accountID: accountID,
            sessionID: session.sessionID
        )

        try await service.removeFromWatchlist(movie: 550, authenticatedSession: authenticatedSession)

        #expect(apiClient.lastRequest as? AddToWatchlistRequest == expectedRequest)
    }

    // MARK: - Rated

    @Test("ratedMovies forwards the authenticated session")
    func ratedMoviesForwardsAuthenticatedSession() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = RatedMoviesRequest(
            sortedBy: nil,
            page: nil,
            accountID: accountID,
            sessionID: session.sessionID
        )

        let result = try await service.ratedMovies(authenticatedSession: authenticatedSession)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? RatedMoviesRequest == expectedRequest)
    }

    @Test("ratedTVSeries forwards the authenticated session")
    func ratedTVSeriesForwardsAuthenticatedSession() async throws {
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.ratedTVSeries(authenticatedSession: authenticatedSession)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest is RatedTVSeriesRequest)
    }

    @Test("ratedTVEpisodes forwards the authenticated session")
    func ratedTVEpisodesForwardsAuthenticatedSession() async throws {
        let expectedResult = TVEpisodePageableList.mock()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.ratedTVEpisodes(authenticatedSession: authenticatedSession)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest is RatedTVEpisodesRequest)
    }

    // MARK: - Lists

    @Test("lists forwards the authenticated session")
    func listsForwardsAuthenticatedSession() async throws {
        let expectedResult = MediaListSummaryPageableList.mock()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.lists(authenticatedSession: authenticatedSession)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest is AccountListsRequest)
    }

    // MARK: - Pagination

    @Test("allFavouriteMovies forwards the authenticated session")
    func allFavouriteMoviesForwardsAuthenticatedSession() async throws {
        apiClient.addResponse(.success(MoviePageableList.mock(page: 1, totalPages: 1)))

        var items = [MovieListItem]()
        for try await item in service.allFavouriteMovies(authenticatedSession: authenticatedSession) {
            items.append(item)
        }

        #expect(!items.isEmpty)
        #expect(apiClient.lastRequest is FavouriteMoviesRequest)
    }

    @Test("allWatchlistMovies forwards the authenticated session")
    func allWatchlistMoviesForwardsAuthenticatedSession() async throws {
        apiClient.addResponse(.success(MoviePageableList.mock(page: 1, totalPages: 1)))

        for try await _ in service.allWatchlistMovies(authenticatedSession: authenticatedSession) {}

        #expect(apiClient.lastRequest is MovieWatchlistRequest)
    }

    @Test("allRatedMovies forwards the authenticated session")
    func allRatedMoviesForwardsAuthenticatedSession() async throws {
        apiClient.addResponse(.success(MoviePageableList.mock(page: 1, totalPages: 1)))

        for try await _ in service.allRatedMovies(authenticatedSession: authenticatedSession) {}

        #expect(apiClient.lastRequest is RatedMoviesRequest)
    }

    @Test("allLists forwards the authenticated session")
    func allListsForwardsAuthenticatedSession() async throws {
        apiClient.addResponse(.success(MediaListSummaryPageableList.mock(page: 1, totalPages: 1)))

        for try await _ in service.allLists(authenticatedSession: authenticatedSession) {}

        #expect(apiClient.lastRequest is AccountListsRequest)
    }

    @Test("allFavouriteMoviesPages forwards the authenticated session")
    func allFavouriteMoviesPagesForwardsAuthenticatedSession() async throws {
        apiClient.addResponse(.success(MoviePageableList.mock(page: 1, totalPages: 1)))

        var pages = 0
        for try await _ in service.allFavouriteMoviesPages(authenticatedSession: authenticatedSession) {
            pages += 1
        }

        #expect(pages == 1)
        #expect(apiClient.lastRequest is FavouriteMoviesRequest)
    }

    @Test("allListsPages forwards the authenticated session")
    func allListsPagesForwardsAuthenticatedSession() async throws {
        apiClient.addResponse(.success(MediaListSummaryPageableList.mock(page: 1, totalPages: 1)))

        var pages = 0
        for try await _ in service.allListsPages(authenticatedSession: authenticatedSession) {
            pages += 1
        }

        #expect(pages == 1)
        #expect(apiClient.lastRequest is AccountListsRequest)
    }

}
