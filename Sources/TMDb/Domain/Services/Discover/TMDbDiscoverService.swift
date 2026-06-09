//
//  TMDbDiscoverService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
final class TMDbDiscoverService: DiscoverService {

    private let apiClient: any APIClient
    private let configuration: TMDbConfiguration

    init(apiClient: some APIClient, configuration: TMDbConfiguration = .default) {
        self.apiClient = apiClient
        self.configuration = configuration
    }

    func movies(
        filter: DiscoverMovieFilter? = nil,
        sortedBy: MovieSort? = nil,
        page: Int? = nil,
        language: String? = nil
    ) async throws(TMDbError) -> MoviePageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = DiscoverMoviesRequest(
            filter: filter,
            sortedBy: sortedBy,
            page: page,
            language: languageCode
        )

        return try await apiClient.perform(request)
    }

    func tvSeries(
        filter: DiscoverTVSeriesFilter? = nil,
        sortedBy: TVSeriesSort? = nil,
        page: Int? = nil,
        language: String? = nil
    ) async throws(TMDbError) -> TVSeriesPageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = DiscoverTVSeriesRequest(
            filter: filter,
            sortedBy: sortedBy,
            page: page,
            language: languageCode
        )

        return try await apiClient.perform(request)
    }

}
