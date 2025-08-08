//
//  TMDbSearchService.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
final class TMDbSearchService: SearchService {

    private let apiClient: any APIClient

    init(apiClient: some APIClient) {
        self.apiClient = apiClient
    }

    func searchAll(
        query: String,
        filter: AllMediaSearchFilter? = nil,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> MediaPageableList {
        let request = MultiSearchRequest(
            query: query,
            includeAdult: filter?.includeAdult,
            page: page,
            language: language
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
        let request = MovieSearchRequest(
            query: query,
            primaryReleaseYear: filter?.primaryReleaseYear,
            country: filter?.country,
            includeAdult: filter?.includeAdult,
            page: page,
            language: language
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
        let request = TVSeriesSearchRequest(
            query: query,
            firstAirDateYear: filter?.firstAirDateYear,
            year: filter?.year,
            includeAdult: filter?.includeAdult,
            page: page,
            language: language
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
        let request = PersonSearchRequest(
            query: query,
            includeAdult: filter?.includeAdult,
            page: page,
            language: language
        )

        let peopleList: PersonPageableList
        do {
            peopleList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return peopleList
    }

}
