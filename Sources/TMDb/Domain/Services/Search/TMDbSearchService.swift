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
    ) async throws -> MediaPageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = MultiSearchRequest(
            query: query,
            includeAdult: filter?.includeAdult,
            page: page,
            language: languageCode
        )

        let mediaList: MediaPageableList
        do {
            mediaList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return mediaList
    }

    func searchMovies(
        query: String,
        filter: MovieSearchFilter? = nil,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> MoviePageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = MovieSearchRequest(
            query: query,
            primaryReleaseYear: filter?.primaryReleaseYear,
            country: filter?.country,
            includeAdult: filter?.includeAdult,
            page: page,
            language: languageCode
        )

        let movieList: MoviePageableList
        do {
            movieList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return movieList
    }

    func searchTVSeries(
        query: String,
        filter: TVSeriesSearchFilter? = nil,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> TVSeriesPageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TVSeriesSearchRequest(
            query: query,
            firstAirDateYear: filter?.firstAirDateYear,
            year: filter?.year,
            includeAdult: filter?.includeAdult,
            page: page,
            language: languageCode
        )

        let tvSeriesList: TVSeriesPageableList
        do {
            tvSeriesList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return tvSeriesList
    }

    func searchPeople(
        query: String,
        filter: PersonSearchFilter? = nil,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> PersonPageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = PersonSearchRequest(
            query: query,
            includeAdult: filter?.includeAdult,
            page: page,
            language: languageCode
        )

        let peopleList: PersonPageableList
        do {
            peopleList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return peopleList
    }

    func searchCollections(
        query: String,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> CollectionPageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = CollectionSearchRequest(
            query: query,
            page: page,
            language: languageCode
        )

        let collectionList: CollectionPageableList
        do {
            collectionList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return collectionList
    }

    func searchCompanies(
        query: String,
        page: Int? = nil
    ) async throws -> CompanyPageableList {
        let request = CompanySearchRequest(
            query: query,
            page: page
        )

        let companyList: CompanyPageableList
        do {
            companyList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return companyList
    }

    func searchKeywords(
        query: String,
        page: Int? = nil
    ) async throws -> KeywordPageableList {
        let request = KeywordSearchRequest(
            query: query,
            page: page
        )

        let keywordList: KeywordPageableList
        do {
            keywordList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return keywordList
    }

}
