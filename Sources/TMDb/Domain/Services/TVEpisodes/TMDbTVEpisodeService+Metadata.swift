//
//  TMDbTVEpisodeService+Metadata.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension TMDbTVEpisodeService {

    func externalLinks(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID
    ) async throws(TMDbError) -> TVEpisodeExternalLinksCollection {
        let request = TVEpisodeExternalLinksRequest(
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID
        )

        return try await apiClient.perform(request)
    }

    func translations(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID
    ) async throws(TMDbError)
    -> TranslationCollection<TVEpisodeTranslationData> {
        let request = TVEpisodeTranslationsRequest(
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID
        )

        return try await apiClient.perform(request)
    }

}
