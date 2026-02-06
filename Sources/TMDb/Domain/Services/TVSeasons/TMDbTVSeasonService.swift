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
    ) async throws -> TVSeason {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TVSeasonRequest(
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            language: languageCode
        )

        let season: TVSeason
        do {
            season = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return season
    }

    func details(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        appending: TVSeasonAppendOption,
        language: String? = nil
    ) async throws -> TVSeasonDetailsResponse {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TVSeasonDetailsAppendRequest(
            tvSeriesID: tvSeriesID,
            seasonNumber: seasonNumber,
            appendToResponse: appending,
            language: languageCode
        )

        let response: TVSeasonDetailsResponse
        do {
            response = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return response
    }

    func aggregateCredits(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        language: String? = nil
    ) async throws -> TVSeasonAggregateCredits {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TVSeasonAggregateCreditsRequest(
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            language: languageCode
        )

        let credits: TVSeasonAggregateCredits
        do {
            credits = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return credits
    }

    func credits(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        language: String? = nil
    ) async throws -> ShowCredits {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TVSeasonCreditsRequest(
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            language: languageCode
        )

        let credits: ShowCredits
        do {
            credits = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return credits
    }

    func images(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        filter: TVSeasonImageFilter? = nil
    ) async throws -> TVSeasonImageCollection {
        let request = TVSeasonImagesRequest(
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            languages: filter?.languages
        )

        let imageCollection: TVSeasonImageCollection
        do {
            imageCollection = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return imageCollection
    }

    func videos(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        filter: TVSeasonVideoFilter? = nil
    ) async throws -> VideoCollection {
        let request = TVSeasonVideosRequest(
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            languages: filter?.languages
        )

        let videoCollection: VideoCollection
        do {
            videoCollection = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return videoCollection
    }

}
