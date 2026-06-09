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
    ) async throws(TMDbError) -> TVSeasonExternalLinksCollection {
        let request = TVSeasonExternalLinksRequest(
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID
        )

        return try await apiClient.perform(request)
    }

    func translations(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID
    ) async throws(TMDbError)
    -> TranslationCollection<TVSeasonTranslationData> {
        let request = TVSeasonTranslationsRequest(
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID
        )

        return try await apiClient.perform(request)
    }

    func watchProviders(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID
    ) async throws(TMDbError) -> [ShowWatchProvidersByCountry] {
        let request = TVSeasonWatchProvidersRequest(
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID
        )

        let result: ShowWatchProviderResult = try await apiClient.perform(request)

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
