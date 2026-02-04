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

    func details(session: Session) async throws -> AccountDetails {
        let request = AccountRequest(sessionID: session.sessionID)

        let accountDetails: AccountDetails
        do {
            accountDetails = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return accountDetails
    }

    func favouriteMovies(
        sortedBy: FavouriteSort? = nil,
        page: Int? = nil,
        accountID: Int,
        session: Session
    ) async throws -> MoviePageableList {
        let request = FavouriteMoviesRequest(
            sortedBy: sortedBy,
            page: page,
            accountID: accountID,
            sessionID: session.sessionID
        )

        let movieList: MoviePageableList
        do {
            movieList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return movieList
    }

    func favouriteTVSeries(
        sortedBy: FavouriteSort? = nil,
        page: Int? = nil,
        accountID: Int,
        session: Session
    ) async throws -> TVSeriesPageableList {
        let request = FavouriteTVSeriesRequest(
            sortedBy: sortedBy,
            page: page,
            accountID: accountID,
            sessionID: session.sessionID
        )

        let tvSeriesList: TVSeriesPageableList
        do {
            tvSeriesList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return tvSeriesList
    }

    func addFavourite(movie movieID: Movie.ID, accountID: Int, session: Session) async throws {
        try await addFavourite(
            showType: .movie,
            showID: movieID,
            isFavourite: true,
            accountID: accountID,
            session: session
        )
    }

    func removeFavourite(movie movieID: Movie.ID, accountID: Int, session: Session) async throws {
        try await addFavourite(
            showType: .movie,
            showID: movieID,
            isFavourite: false,
            accountID: accountID,
            session: session
        )
    }

    func addFavourite(tvSeries tvSeriesID: TVSeries.ID, accountID: Int, session: Session)
    async throws {
        try await addFavourite(
            showType: .tvSeries,
            showID: tvSeriesID,
            isFavourite: true,
            accountID: accountID,
            session: session
        )
    }

    func removeFavourite(tvSeries tvSeriesID: TVSeries.ID, accountID: Int, session: Session)
    async throws {
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
    ) async throws -> MoviePageableList {
        let request = MovieWatchlistRequest(
            sortedBy: sortedBy,
            page: page,
            accountID: accountID,
            sessionID: session.sessionID
        )

        let movieList: MoviePageableList
        do {
            movieList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return movieList
    }

    func tvSeriesWatchlist(
        sortedBy: WatchlistSort? = nil,
        page: Int? = nil,
        accountID: Int,
        session: Session
    ) async throws -> TVSeriesPageableList {
        let request = TVSeriesWatchlistRequest(
            sortedBy: sortedBy,
            page: page,
            accountID: accountID,
            sessionID: session.sessionID
        )

        let tvSeriesList: TVSeriesPageableList
        do {
            tvSeriesList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return tvSeriesList
    }

    func addToWatchlist(movie movieID: Movie.ID, accountID: Int, session: Session) async throws {
        try await addToWatchlist(
            showType: .movie,
            showID: movieID,
            isInWatchlist: true,
            accountID: accountID,
            session: session
        )
    }

    func removeFromWatchlist(movie movieID: Movie.ID, accountID: Int, session: Session) async throws {
        try await addToWatchlist(
            showType: .movie,
            showID: movieID,
            isInWatchlist: false,
            accountID: accountID,
            session: session
        )
    }

    func addToWatchlist(tvSeries tvSeriesID: TVSeries.ID, accountID: Int, session: Session)
    async throws {
        try await addToWatchlist(
            showType: .tvSeries,
            showID: tvSeriesID,
            isInWatchlist: true,
            accountID: accountID,
            session: session
        )
    }

    func removeFromWatchlist(tvSeries tvSeriesID: TVSeries.ID, accountID: Int, session: Session)
    async throws {
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
    ) async throws -> MoviePageableList {
        let request = RatedMoviesRequest(
            sortedBy: sortedBy,
            page: page,
            accountID: accountID,
            sessionID: session.sessionID
        )

        let movieList: MoviePageableList
        do {
            movieList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return movieList
    }

    func ratedTVSeries(
        sortedBy: RatedSort? = nil,
        page: Int? = nil,
        accountID: Int,
        session: Session
    ) async throws -> TVSeriesPageableList {
        let request = RatedTVSeriesRequest(
            sortedBy: sortedBy,
            page: page,
            accountID: accountID,
            sessionID: session.sessionID
        )

        let tvSeriesList: TVSeriesPageableList
        do {
            tvSeriesList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return tvSeriesList
    }

    func ratedTVEpisodes(
        sortedBy: RatedSort? = nil,
        page: Int? = nil,
        accountID: Int,
        session: Session
    ) async throws -> TVEpisodePageableList {
        let request = RatedTVEpisodesRequest(
            sortedBy: sortedBy,
            page: page,
            accountID: accountID,
            sessionID: session.sessionID
        )

        let tvEpisodeList: TVEpisodePageableList
        do {
            tvEpisodeList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return tvEpisodeList
    }

    func lists(
        page: Int? = nil,
        accountID: Int,
        session: Session
    ) async throws -> MediaListPageableList {
        let request = AccountListsRequest(
            page: page,
            accountID: accountID,
            sessionID: session.sessionID
        )

        let listResult: MediaListPageableList
        do {
            listResult = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return listResult
    }

}

extension TMDbAccountService {

    private func addFavourite(
        showType: ShowType,
        showID: Show.ID,
        isFavourite: Bool,
        accountID: Int,
        session: Session
    ) async throws {
        let request = AddFavouriteRequest(
            showType: showType,
            showID: showID,
            isFavourite: isFavourite,
            accountID: accountID,
            sessionID: session.sessionID
        )

        do {
            _ = try await apiClient.perform(request)
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
        let request = AddToWatchlistRequest(
            showType: showType,
            showID: showID,
            isInWatchlist: isInWatchlist,
            accountID: accountID,
            sessionID: session.sessionID
        )

        do {
            _ = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }
    }

}
