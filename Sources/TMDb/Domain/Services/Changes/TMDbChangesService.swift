//
//  TMDbChangesService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
final class TMDbChangesService: ChangesService {

    private let apiClient: any APIClient

    init(apiClient: some APIClient) {
        self.apiClient = apiClient
    }

    func movieChanges(
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangedIDCollection {
        let request = MovieChangesListRequest(
            startDate: startDate,
            endDate: endDate,
            page: page
        )

        return try await apiClient.perform(request)
    }

    func tvSeriesChanges(
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangedIDCollection {
        let request = TVSeriesChangesListRequest(
            startDate: startDate,
            endDate: endDate,
            page: page
        )

        return try await apiClient.perform(request)
    }

    func personChanges(
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangedIDCollection {
        let request = PersonChangesListRequest(
            startDate: startDate,
            endDate: endDate,
            page: page
        )

        return try await apiClient.perform(request)
    }

    func movieDetails(
        forMovie id: Movie.ID,
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        let request = MovieChangesRequest(
            id: id,
            startDate: startDate,
            endDate: endDate,
            page: page
        )

        return try await apiClient.perform(request)
    }

    func tvSeriesDetails(
        forTVSeries id: TVSeries.ID,
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        let request = TVSeriesChangesRequest(
            id: id,
            startDate: startDate,
            endDate: endDate,
            page: page
        )

        return try await apiClient.perform(request)
    }

    func personDetails(
        forPerson id: Person.ID,
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        let request = PersonChangesRequest(
            id: id,
            startDate: startDate,
            endDate: endDate,
            page: page
        )

        return try await apiClient.perform(request)
    }

    func tvSeasonDetails(
        forSeason seasonID: Int,
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        let request = TVSeasonChangesRequest(
            seasonID: seasonID,
            startDate: startDate,
            endDate: endDate,
            page: page
        )

        return try await apiClient.perform(request)
    }

    func tvEpisodeDetails(
        forEpisode episodeID: Int,
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        let request = TVEpisodeChangesRequest(
            episodeID: episodeID,
            startDate: startDate,
            endDate: endDate,
            page: page
        )

        return try await apiClient.perform(request)
    }

}
