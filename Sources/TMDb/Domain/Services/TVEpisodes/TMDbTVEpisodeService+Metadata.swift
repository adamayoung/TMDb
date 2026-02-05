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
    ) async throws -> TVEpisodeExternalLinksCollection {
        let request = TVEpisodeExternalLinksRequest(
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID
        )

        let linksCollection: TVEpisodeExternalLinksCollection
        do {
            linksCollection = try await apiClient.perform(
                request
            )
        } catch let error {
            throw TMDbError(error: error)
        }

        return linksCollection
    }

    func translations(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID
    ) async throws
    -> TranslationCollection<TVEpisodeTranslationData> {
        let request = TVEpisodeTranslationsRequest(
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID
        )

        let translationCollection:
            TranslationCollection<TVEpisodeTranslationData>
        do {
            translationCollection = try await apiClient.perform(
                request
            )
        } catch let error {
            throw TMDbError(error: error)
        }

        return translationCollection
    }

}
