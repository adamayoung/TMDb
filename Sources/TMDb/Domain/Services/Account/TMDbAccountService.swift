//
//  TMDbAccountService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
final class TMDbAccountService: AccountService {

    private let apiClient: any APIClient

    init(apiClient: some APIClient) {
        self.apiClient = apiClient
    }

    func details(session: Session) async throws(TMDbError) -> AccountDetails {
        let request = AccountRequest(sessionID: session.sessionID)

        return try await apiClient.perform(request)
    }

    func favouriteMovies(
        sortedBy: FavouriteSort? = nil,
        page: Int? = nil,
        accountID: Int,
        session: Session
    ) async throws(TMDbError) -> MoviePageableList {
        let request = FavouriteMoviesRequest(
            sortedBy: sortedBy,
            page: page,
            accountID: accountID,
            sessionID: session.sessionID
        )

        return try await apiClient.perform(request)
    }

    func favouriteTVSeries(
        sortedBy: FavouriteSort? = nil,
        page: Int? = nil,
        accountID: Int,
        session: Session
    ) async throws(TMDbError) -> TVSeriesPageableList {
        let request = FavouriteTVSeriesRequest(
            sortedBy: sortedBy,
            page: page,
            accountID: accountID,
            sessionID: session.sessionID
        )

        return try await apiClient.perform(request)
    }

    func addFavourite(movie movieID: Movie.ID, accountID: Int, session: Session)
    async throws(TMDbError) {
        try await addFavourite(
            showType: .movie,
            showID: movieID,
            isFavourite: true,
            accountID: accountID,
            session: session
        )
    }

    func removeFavourite(movie movieID: Movie.ID, accountID: Int, session: Session)
    async throws(TMDbError) {
        try await addFavourite(
            showType: .movie,
            showID: movieID,
            isFavourite: false,
            accountID: accountID,
            session: session
        )
    }

    func addFavourite(tvSeries tvSeriesID: TVSeries.ID, accountID: Int, session: Session)
    async throws(TMDbError) {
        try await addFavourite(
            showType: .tvSeries,
            showID: tvSeriesID,
            isFavourite: true,
            accountID: accountID,
            session: session
        )
    }

    func removeFavourite(tvSeries tvSeriesID: TVSeries.ID, accountID: Int, session: Session)
    async throws(TMDbError) {
        try await addFavourite(
            showType: .tvSeries,
            showID: tvSeriesID,
            isFavourite: false,
            accountID: accountID,
            session: session
        )
    }

    func movieWatchlist(
        sortedBy: WatchlistSort? = nil,
        page: Int? = nil,
        accountID: Int,
        session: Session
    ) async throws(TMDbError) -> MoviePageableList {
        let request = MovieWatchlistRequest(
            sortedBy: sortedBy,
            page: page,
            accountID: accountID,
            sessionID: session.sessionID
        )

        return try await apiClient.perform(request)
    }

    func tvSeriesWatchlist(
        sortedBy: WatchlistSort? = nil,
        page: Int? = nil,
        accountID: Int,
        session: Session
    ) async throws(TMDbError) -> TVSeriesPageableList {
        let request = TVSeriesWatchlistRequest(
            sortedBy: sortedBy,
            page: page,
            accountID: accountID,
            sessionID: session.sessionID
        )

        return try await apiClient.perform(request)
    }

    func addToWatchlist(movie movieID: Movie.ID, accountID: Int, session: Session)
    async throws(TMDbError) {
        try await addToWatchlist(
            showType: .movie,
            showID: movieID,
            isInWatchlist: true,
            accountID: accountID,
            session: session
        )
    }

    func removeFromWatchlist(movie movieID: Movie.ID, accountID: Int, session: Session)
    async throws(TMDbError) {
        try await addToWatchlist(
            showType: .movie,
            showID: movieID,
            isInWatchlist: false,
            accountID: accountID,
            session: session
        )
    }

    func addToWatchlist(tvSeries tvSeriesID: TVSeries.ID, accountID: Int, session: Session)
    async throws(TMDbError) {
        try await addToWatchlist(
            showType: .tvSeries,
            showID: tvSeriesID,
            isInWatchlist: true,
            accountID: accountID,
            session: session
        )
    }

    func removeFromWatchlist(tvSeries tvSeriesID: TVSeries.ID, accountID: Int, session: Session)
    async throws(TMDbError) {
        try await addToWatchlist(
            showType: .tvSeries,
            showID: tvSeriesID,
            isInWatchlist: false,
            accountID: accountID,
            session: session
        )
    }

    func ratedMovies(
        sortedBy: RatedSort? = nil,
        page: Int? = nil,
        accountID: Int,
        session: Session
    ) async throws(TMDbError) -> MoviePageableList {
        let request = RatedMoviesRequest(
            sortedBy: sortedBy,
            page: page,
            accountID: accountID,
            sessionID: session.sessionID
        )

        return try await apiClient.perform(request)
    }

    func ratedTVSeries(
        sortedBy: RatedSort? = nil,
        page: Int? = nil,
        accountID: Int,
        session: Session
    ) async throws(TMDbError) -> TVSeriesPageableList {
        let request = RatedTVSeriesRequest(
            sortedBy: sortedBy,
            page: page,
            accountID: accountID,
            sessionID: session.sessionID
        )

        return try await apiClient.perform(request)
    }

    func ratedTVEpisodes(
        sortedBy: RatedSort? = nil,
        page: Int? = nil,
        accountID: Int,
        session: Session
    ) async throws(TMDbError) -> TVEpisodePageableList {
        let request = RatedTVEpisodesRequest(
            sortedBy: sortedBy,
            page: page,
            accountID: accountID,
            sessionID: session.sessionID
        )

        return try await apiClient.perform(request)
    }

    func lists(
        page: Int? = nil,
        accountID: Int,
        session: Session
    ) async throws(TMDbError) -> MediaListSummaryPageableList {
        let request = AccountListsRequest(
            page: page,
            accountID: accountID,
            sessionID: session.sessionID
        )

        return try await apiClient.perform(request)
    }

}

extension TMDbAccountService {

    private func addFavourite(
        showType: ShowType,
        showID: Show.ID,
        isFavourite: Bool,
        accountID: Int,
        session: Session
    ) async throws(TMDbError) {
        let request = AddFavouriteRequest(
            showType: showType,
            showID: showID,
            isFavourite: isFavourite,
            accountID: accountID,
            sessionID: session.sessionID
        )

        _ = try await apiClient.perform(request)
    }

    private func addToWatchlist(
        showType: ShowType,
        showID: Show.ID,
        isInWatchlist: Bool,
        accountID: Int,
        session: Session
    ) async throws(TMDbError) {
        let request = AddToWatchlistRequest(
            showType: showType,
            showID: showID,
            isInWatchlist: isInWatchlist,
            accountID: accountID,
            sessionID: session.sessionID
        )

        _ = try await apiClient.perform(request)
    }

}
