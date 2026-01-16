//
//  TMDbTrendingService.swift
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
    ) async throws -> MoviePageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TrendingMoviesRequest(
            timeWindow: timeWindow, page: page, language: languageCode)

        let movieList: MoviePageableList
        do {
            movieList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return movieList
    }

    func tvSeries(
        inTimeWindow timeWindow: TrendingTimeWindowFilterType = .day,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> TVSeriesPageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TrendingTVSeriesRequest(
            timeWindow: timeWindow, page: page, language: languageCode)

        let tvSeriesList: TVSeriesPageableList
        do {
            tvSeriesList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return tvSeriesList
    }

    func people(
        inTimeWindow timeWindow: TrendingTimeWindowFilterType = .day,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> PersonPageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TrendingPeopleRequest(
            timeWindow: timeWindow, page: page, language: languageCode)

        let peopleList: PersonPageableList
        do {
            peopleList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return peopleList
    }

}
