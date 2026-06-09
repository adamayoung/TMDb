//
//  TMDbSearchService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
final class TMDbSearchService: SearchService {

    private let apiClient: any APIClient
    private let configuration: TMDbConfiguration

    init(apiClient: some APIClient, configuration: TMDbConfiguration = .default) {
        self.apiClient = apiClient
        self.configuration = configuration
    }

    func searchAll(
        query: String,
        filter: AllMediaSearchFilter? = nil,
        page: Int? = nil,
        language: String? = nil
    ) async throws(TMDbError) -> MediaPageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = MultiSearchRequest(
            query: query,
            includeAdult: filter?.includeAdult,
            page: page,
            language: languageCode
        )

        return try await apiClient.perform(request)
    }

    func searchMovies(
        query: String,
        filter: MovieSearchFilter? = nil,
        page: Int? = nil,
        language: String? = nil
    ) async throws(TMDbError) -> MoviePageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = MovieSearchRequest(
            query: query,
            primaryReleaseYear: filter?.primaryReleaseYear,
            year: filter?.year,
            country: filter?.country,
            includeAdult: filter?.includeAdult,
            page: page,
            language: languageCode
        )

        return try await apiClient.perform(request)
    }

    func searchTVSeries(
        query: String,
        filter: TVSeriesSearchFilter? = nil,
        page: Int? = nil,
        language: String? = nil
    ) async throws(TMDbError) -> TVSeriesPageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TVSeriesSearchRequest(
            query: query,
            firstAirDateYear: filter?.firstAirDateYear,
            year: filter?.year,
            includeAdult: filter?.includeAdult,
            page: page,
            language: languageCode
        )

        return try await apiClient.perform(request)
    }

    func searchPeople(
        query: String,
        filter: PersonSearchFilter? = nil,
        page: Int? = nil,
        language: String? = nil
    ) async throws(TMDbError) -> PersonPageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = PersonSearchRequest(
            query: query,
            includeAdult: filter?.includeAdult,
            page: page,
            language: languageCode
        )

        return try await apiClient.perform(request)
    }

    func searchCollections(
        query: String,
        page: Int? = nil,
        language: String? = nil
    ) async throws(TMDbError) -> CollectionPageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = CollectionSearchRequest(
            query: query,
            page: page,
            language: languageCode
        )

        return try await apiClient.perform(request)
    }

    func searchCompanies(
        query: String,
        page: Int? = nil
    ) async throws(TMDbError) -> CompanyPageableList {
        let request = CompanySearchRequest(
            query: query,
            page: page
        )

        return try await apiClient.perform(request)
    }

    func searchKeywords(
        query: String,
        page: Int? = nil
    ) async throws(TMDbError) -> KeywordPageableList {
        let request = KeywordSearchRequest(
            query: query,
            page: page
        )

        return try await apiClient.perform(request)
    }

}
