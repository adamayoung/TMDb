//
//  TMDbTVSeriesService+Metadata.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension TMDbTVSeriesService {

    func watchProviders(
        forTVSeries tvSeriesID: TVSeries.ID
    ) async throws(TMDbError) -> [ShowWatchProvidersByCountry] {
        let request = TVSeriesWatchProvidersRequest(id: tvSeriesID)

        let result: ShowWatchProviderResult = try await apiClient.perform(request)

        return result.results
            .map { ShowWatchProvidersByCountry(countryCode: $0.key, watchProviders: $0.value) }
            .sorted { $0.countryCode < $1.countryCode }
    }

    func contentRatings(forTVSeries tvSeriesID: TVSeries.ID) async throws(TMDbError) -> [ContentRating] {
        let request = ContentRatingRequest(id: tvSeriesID)

        let result: ContentRatingResult = try await apiClient.perform(request)

        return result.results
    }

    func externalLinks(forTVSeries tvSeriesID: TVSeries.ID) async throws(TMDbError)
    -> TVSeriesExternalLinksCollection {
        let request = TVSeriesExternalLinksRequest(id: tvSeriesID)

        return try await apiClient.perform(request)
    }

    func keywords(forTVSeries tvSeriesID: TVSeries.ID) async throws(TMDbError) -> KeywordCollection {
        let request = TVSeriesKeywordsRequest(id: tvSeriesID)

        return try await apiClient.perform(request)
    }

    func alternativeTitles(forTVSeries tvSeriesID: TVSeries.ID) async throws(TMDbError)
    -> AlternativeTitleCollection {
        let request = TVSeriesAlternativeTitlesRequest(id: tvSeriesID)

        return try await apiClient.perform(request)
    }

    func translations(forTVSeries tvSeriesID: TVSeries.ID) async throws(TMDbError)
    -> TranslationCollection<TVSeriesTranslationData> {
        let request = TVSeriesTranslationsRequest(id: tvSeriesID)

        return try await apiClient.perform(request)
    }

    func lists(
        forTVSeries tvSeriesID: TVSeries.ID,
        page: Int? = nil,
        language: String? = nil
    ) async throws(TMDbError) -> MediaListSummaryPageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TVSeriesListsRequest(id: tvSeriesID, page: page, language: languageCode)

        return try await apiClient.perform(request)
    }

    func screenedTheatrically(
        forTVSeries tvSeriesID: TVSeries.ID
    ) async throws(TMDbError) -> ScreenedTheatricallyCollection {
        let request = TVSeriesScreenedTheatricallyRequest(id: tvSeriesID)

        return try await apiClient.perform(request)
    }

    func episodeGroups(
        forTVSeries tvSeriesID: TVSeries.ID
    ) async throws(TMDbError) -> TVEpisodeGroupCollection {
        let request = TVSeriesEpisodeGroupsRequest(id: tvSeriesID)

        return try await apiClient.perform(request)
    }

}
