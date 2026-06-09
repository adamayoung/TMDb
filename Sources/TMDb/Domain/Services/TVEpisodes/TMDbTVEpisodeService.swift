//
//  TMDbTVEpisodeService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
final class TMDbTVEpisodeService: TVEpisodeService {

    let apiClient: any APIClient
    let configuration: TMDbConfiguration

    init(apiClient: some APIClient, configuration: TMDbConfiguration = .default) {
        self.apiClient = apiClient
        self.configuration = configuration
    }

    func details(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        language: String? = nil
    ) async throws(TMDbError) -> TVEpisode {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TVEpisodeRequest(
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            language: languageCode
        )

        return try await apiClient.perform(request)
    }

    func details(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        appending: TVEpisodeAppendOption,
        language: String? = nil
    ) async throws(TMDbError) -> TVEpisodeDetailsResponse {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TVEpisodeDetailsAppendRequest(
            tvSeriesID: tvSeriesID,
            seasonNumber: seasonNumber,
            episodeNumber: episodeNumber,
            appendToResponse: appending,
            language: languageCode
        )

        return try await apiClient.perform(request)
    }

    func credits(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        language: String? = nil
    ) async throws(TMDbError) -> ShowCredits {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TVEpisodeCreditsRequest(
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            language: languageCode
        )

        return try await apiClient.perform(request)
    }

    func images(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        filter: TVEpisodeImageFilter? = nil
    ) async throws(TMDbError) -> TVEpisodeImageCollection {
        let request = TVEpisodeImagesRequest(
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            languages: filter?.languages
        )

        return try await apiClient.perform(request)
    }

    func videos(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        filter: TVEpisodeVideoFilter? = nil
    ) async throws(TMDbError) -> VideoCollection {
        let request = TVEpisodeVideosRequest(
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            languages: filter?.languages
        )

        return try await apiClient.perform(request)
    }

}
