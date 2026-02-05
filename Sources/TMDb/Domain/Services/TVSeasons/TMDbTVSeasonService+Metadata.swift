//
//  TMDbTVSeasonService+Metadata.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension TMDbTVSeasonService {

    func externalLinks(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID
    ) async throws -> TVSeasonExternalLinksCollection {
        let request = TVSeasonExternalLinksRequest(
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID
        )

        let linksCollection: TVSeasonExternalLinksCollection
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
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID
    ) async throws
    -> TranslationCollection<TVSeasonTranslationData> {
        let request = TVSeasonTranslationsRequest(
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID
        )

        let translationCollection:
            TranslationCollection<TVSeasonTranslationData>
        do {
            translationCollection = try await apiClient.perform(
                request
            )
        } catch let error {
            throw TMDbError(error: error)
        }

        return translationCollection
    }

    func watchProviders(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID
    ) async throws -> [ShowWatchProvidersByCountry] {
        let request = TVSeasonWatchProvidersRequest(
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID
        )

        let result: ShowWatchProviderResult
        do {
            result = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return result.results
            .map {
                ShowWatchProvidersByCountry(
                    countryCode: $0.key,
                    watchProviders: $0.value
                )
            }
            .sorted { $0.countryCode < $1.countryCode }
    }

}
