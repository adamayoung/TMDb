//
//  TMDbGuestSessionService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
final class TMDbGuestSessionService: GuestSessionService {

    private let apiClient: any APIClient

    init(apiClient: some APIClient) {
        self.apiClient = apiClient
    }

    func ratedMovies(
        sortedBy: RatedSort?,
        page: Int?,
        guestSessionID: String
    ) async throws -> MoviePageableList {
        let request = GuestSessionRatedMoviesRequest(
            sortedBy: sortedBy,
            page: page,
            guestSessionID: guestSessionID
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
        sortedBy: RatedSort?,
        page: Int?,
        guestSessionID: String
    ) async throws -> TVSeriesPageableList {
        let request = GuestSessionRatedTVSeriesRequest(
            sortedBy: sortedBy,
            page: page,
            guestSessionID: guestSessionID
        )

        let tvSeriesList: TVSeriesPageableList
        do {
            tvSeriesList = try await apiClient.perform(
                request
            )
        } catch let error {
            throw TMDbError(error: error)
        }

        return tvSeriesList
    }

    func ratedTVEpisodes(
        sortedBy: RatedSort?,
        page: Int?,
        guestSessionID: String
    ) async throws -> TVEpisodePageableList {
        let request = GuestSessionRatedTVEpisodesRequest(
            sortedBy: sortedBy,
            page: page,
            guestSessionID: guestSessionID
        )

        let tvEpisodeList: TVEpisodePageableList
        do {
            tvEpisodeList = try await apiClient.perform(
                request
            )
        } catch let error {
            throw TMDbError(error: error)
        }

        return tvEpisodeList
    }

}
