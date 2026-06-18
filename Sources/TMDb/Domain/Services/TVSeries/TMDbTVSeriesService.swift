//
//  TMDbTVSeriesService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
final class TMDbTVSeriesService: TVSeriesService {

    let apiClient: any APIClient
    let configuration: TMDbConfiguration

    init(apiClient: some APIClient, configuration: TMDbConfiguration = .default) {
        self.apiClient = apiClient
        self.configuration = configuration
    }

    func details(forTVSeries tvSeriesID: TVSeries.ID, language: String? = nil) async throws(TMDbError) -> TVSeries {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TVSeriesRequest(id: tvSeriesID, language: languageCode)

        return try await apiClient.perform(request)
    }

    func details(
        forTVSeries tvSeriesID: TVSeries.ID,
        appending: TVSeriesAppendOption,
        language: String? = nil
    ) async throws(TMDbError) -> TVSeriesDetailsResponse {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TVSeriesDetailsAppendRequest(
            id: tvSeriesID,
            appendToResponse: appending,
            language: languageCode
        )

        return try await apiClient.perform(request)
    }

    func credits(forTVSeries tvSeriesID: TVSeries.ID, language: String? = nil) async throws(TMDbError)
    -> ShowCredits {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TVSeriesCreditsRequest(id: tvSeriesID, language: languageCode)

        return try await apiClient.perform(request)
    }

    func aggregateCredits(
        forTVSeries tvSeriesID: TVSeries.ID,
        language: String? = nil
    ) async throws(TMDbError) -> TVSeriesAggregateCredits {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TVSeriesAggregateCreditsRequest(id: tvSeriesID, language: languageCode)

        return try await apiClient.perform(request)
    }

    func reviews(
        forTVSeries tvSeriesID: TVSeries.ID,
        page: Int? = nil,
        language: String? = nil
    ) async throws(TMDbError) -> ReviewPageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TVSeriesReviewsRequest(id: tvSeriesID, page: page, language: languageCode)

        return try await apiClient.perform(request)
    }

}
