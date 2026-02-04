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
    ) async throws -> [ShowWatchProvidersByCountry] {
        let request = TVSeriesWatchProvidersRequest(id: tvSeriesID)

        let result: ShowWatchProviderResult
        do {
            result = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return result.results
            .map { ShowWatchProvidersByCountry(countryCode: $0.key, watchProviders: $0.value) }
            .sorted { $0.countryCode < $1.countryCode }
    }

    func contentRatings(forTVSeries tvSeriesID: TVSeries.ID) async throws -> [ContentRating] {
        let request = ContentRatingRequest(id: tvSeriesID)

        let result: ContentRatingResult
        do {
            result = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return result.results
    }

    func externalLinks(forTVSeries tvSeriesID: TVSeries.ID) async throws
    -> TVSeriesExternalLinksCollection {
        let request = TVSeriesExternalLinksRequest(id: tvSeriesID)

        let linksCollection: TVSeriesExternalLinksCollection
        do {
            linksCollection = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return linksCollection
    }

    func keywords(forTVSeries tvSeriesID: TVSeries.ID) async throws -> KeywordCollection {
        let request = TVSeriesKeywordsRequest(id: tvSeriesID)

        let keywordCollection: KeywordCollection
        do {
            keywordCollection = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return keywordCollection
    }

    func alternativeTitles(forTVSeries tvSeriesID: TVSeries.ID) async throws
    -> AlternativeTitleCollection {
        let request = TVSeriesAlternativeTitlesRequest(id: tvSeriesID)

        let alternativeTitleCollection: AlternativeTitleCollection
        do {
            alternativeTitleCollection = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return alternativeTitleCollection
    }

    func translations(forTVSeries tvSeriesID: TVSeries.ID) async throws
    -> TranslationCollection<TVSeriesTranslationData> {
        let request = TVSeriesTranslationsRequest(id: tvSeriesID)

        let translationCollection: TranslationCollection<TVSeriesTranslationData>
        do {
            translationCollection = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return translationCollection
    }

    func lists(
        forTVSeries tvSeriesID: TVSeries.ID,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> MediaPageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TVSeriesListsRequest(id: tvSeriesID, page: page, language: languageCode)

        let mediaList: MediaPageableList
        do {
            mediaList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return mediaList
    }

}
