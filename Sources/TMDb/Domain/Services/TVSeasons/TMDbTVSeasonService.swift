//
//  TMDbTVSeasonService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
final class TMDbTVSeasonService: TVSeasonService {

    let apiClient: any APIClient
    let configuration: TMDbConfiguration

    init(apiClient: some APIClient, configuration: TMDbConfiguration = .default) {
        self.apiClient = apiClient
        self.configuration = configuration
    }

    func details(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        language: String? = nil
    ) async throws(TMDbError) -> TVSeason {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TVSeasonRequest(
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            language: languageCode
        )

        return try await apiClient.perform(request)
    }

    func details(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        appending: TVSeasonAppendOption,
        language: String? = nil
    ) async throws(TMDbError) -> TVSeasonDetailsResponse {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TVSeasonDetailsAppendRequest(
            tvSeriesID: tvSeriesID,
            seasonNumber: seasonNumber,
            appendToResponse: appending,
            language: languageCode
        )

        return try await apiClient.perform(request)
    }

    func aggregateCredits(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        language: String? = nil
    ) async throws(TMDbError) -> TVSeasonAggregateCredits {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TVSeasonAggregateCreditsRequest(
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            language: languageCode
        )

        return try await apiClient.perform(request)
    }

    func credits(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        language: String? = nil
    ) async throws(TMDbError) -> ShowCredits {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TVSeasonCreditsRequest(
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            language: languageCode
        )

        return try await apiClient.perform(request)
    }

    func images(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        filter: TVSeasonImageFilter? = nil
    ) async throws(TMDbError) -> TVSeasonImageCollection {
        let request = TVSeasonImagesRequest(
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            languages: filter?.languages
        )

        return try await apiClient.perform(request)
    }

    func videos(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        filter: TVSeasonVideoFilter? = nil
    ) async throws(TMDbError) -> VideoCollection {
        let request = TVSeasonVideosRequest(
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            languages: filter?.languages
        )

        return try await apiClient.perform(request)
    }

}
