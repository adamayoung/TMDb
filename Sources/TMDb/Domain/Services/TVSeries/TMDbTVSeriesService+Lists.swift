//
//  TMDbTVSeriesService+Lists.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension TMDbTVSeriesService {

    func recommendations(
        forTVSeries tvSeriesID: TVSeries.ID,
        page: Int? = nil,
        language: String? = nil
    ) async throws(TMDbError) -> TVSeriesPageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TVSeriesRecommendationsRequest(
            id: tvSeriesID, page: page, language: languageCode
        )

        return try await apiClient.perform(request)
    }

    func similar(
        toTVSeries tvSeriesID: TVSeries.ID,
        page: Int? = nil,
        language: String? = nil
    ) async throws(TMDbError) -> TVSeriesPageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = SimilarTVSeriesRequest(id: tvSeriesID, page: page, language: languageCode)

        return try await apiClient.perform(request)
    }

    func popular(page: Int? = nil, language: String? = nil) async throws(TMDbError) -> TVSeriesPageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = PopularTVSeriesRequest(page: page, language: languageCode)

        return try await apiClient.perform(request)
    }

    func airingToday(
        page: Int? = nil,
        timezone: String? = nil,
        language: String? = nil
    ) async throws(TMDbError) -> TVSeriesPageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TVSeriesAiringTodayRequest(
            page: page,
            timezone: timezone,
            language: languageCode
        )

        return try await apiClient.perform(request)
    }

    func onTheAir(
        page: Int? = nil,
        timezone: String? = nil,
        language: String? = nil
    ) async throws(TMDbError) -> TVSeriesPageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TVSeriesOnTheAirRequest(
            page: page,
            timezone: timezone,
            language: languageCode
        )

        return try await apiClient.perform(request)
    }

    func topRated(page: Int? = nil, language: String? = nil) async throws(TMDbError) -> TVSeriesPageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TopRatedTVSeriesRequest(page: page, language: languageCode)

        return try await apiClient.perform(request)
    }

}
