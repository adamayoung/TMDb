//
//  TMDbTrendingService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
final class TMDbTrendingService: TrendingService {

    private let apiClient: any APIClient
    private let configuration: TMDbConfiguration

    init(apiClient: some APIClient, configuration: TMDbConfiguration = .default) {
        self.apiClient = apiClient
        self.configuration = configuration
    }

    func movies(
        inTimeWindow timeWindow: TrendingTimeWindowFilterType = .day,
        page: Int? = nil,
        language: String? = nil
    ) async throws(TMDbError) -> MoviePageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TrendingMoviesRequest(
            timeWindow: timeWindow, page: page, language: languageCode
        )

        return try await apiClient.perform(request)
    }

    func tvSeries(
        inTimeWindow timeWindow: TrendingTimeWindowFilterType = .day,
        page: Int? = nil,
        language: String? = nil
    ) async throws(TMDbError) -> TVSeriesPageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TrendingTVSeriesRequest(
            timeWindow: timeWindow, page: page, language: languageCode
        )

        return try await apiClient.perform(request)
    }

    func people(
        inTimeWindow timeWindow: TrendingTimeWindowFilterType = .day,
        page: Int? = nil,
        language: String? = nil
    ) async throws(TMDbError) -> PersonPageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TrendingPeopleRequest(
            timeWindow: timeWindow, page: page, language: languageCode
        )

        return try await apiClient.perform(request)
    }

    func allTrending(
        inTimeWindow timeWindow: TrendingTimeWindowFilterType = .day,
        page: Int? = nil,
        language: String? = nil
    ) async throws(TMDbError) -> TrendingPageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TrendingAllRequest(
            timeWindow: timeWindow, page: page, language: languageCode
        )

        return try await apiClient.perform(request)
    }

}
