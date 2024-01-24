//
//  TrendingService.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
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

///
/// Provides an interface for finding trending movies, TV series and people from TMDb.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public final class TrendingService {

    private let apiClient: any APIClient

    ///
    /// Creates a trending service object.
    ///
    public convenience init() {
        self.init(
            apiClient: TMDbFactory.apiClient
        )
    }

    init(apiClient: some APIClient) {
        self.apiClient = apiClient
    }

    ///
    /// Returns a list of the daily or weekly trending movies.
    ///
    /// The daily trending list tracks movies over the period of a day while movies have a 24 hour half life. The
    /// weekly list tracks movies over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending: Movies](https://developer.themoviedb.org/reference/trending-all)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - timeWindow: Daily or weekly time window. Defaults to daily.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Trending movies in a time window as a pageable list.
    ///
    public func movies(
        inTimeWindow timeWindow: TrendingTimeWindowFilterType = .day,
        page: Int? = nil
    ) async throws -> MoviePageableList {
        let movieList: MoviePageableList
        do {
            movieList = try await apiClient.get(endpoint: TrendingEndpoint.movies(timeWindow: timeWindow, page: page))
        } catch let error {
            throw TMDbError(error: error)
        }

        return movieList
    }

    ///
    /// Returns a list of the daily or weekly trending TV series.
    ///
    /// The daily trending list tracks TV series over the period of a day while TV series have a 24 hour half life. The
    /// weekly list tracks TV series over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending: TV](https://developer.themoviedb.org/reference/trending-tv)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - timeWindow: Daily or weekly time window. Defaults to daily.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Trending TV series in a time window as a pageable list.
    ///
    public func tvSeries(
        inTimeWindow timeWindow: TrendingTimeWindowFilterType = .day,
        page: Int? = nil
    ) async throws -> TVSeriesPageableList {
        let tvSeriesList: TVSeriesPageableList
        do {
            tvSeriesList = try await apiClient.get(
                endpoint: TrendingEndpoint.tvSeries(timeWindow: timeWindow, page: page)
            )
        } catch let error {
            throw TMDbError(error: error)
        }

        return tvSeriesList
    }

    ///
    /// Returns a list of the daily or weekly trending people.
    ///
    /// The daily trending list tracks people over the period of a day while people shows have a 24 hour half life. The
    /// weekly list tracks people over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending: People](https://developer.themoviedb.org/reference/trending-people)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - timeWindow: Daily or weekly time window. Defaults to daily.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Trending people in a time window as a pageable list.
    ///
    public func people(
        inTimeWindow timeWindow: TrendingTimeWindowFilterType = .day,
        page: Int? = nil
    ) async throws -> PersonPageableList {
        let peopleList: PersonPageableList
        do {
            peopleList = try await apiClient.get(endpoint: TrendingEndpoint.people(timeWindow: timeWindow, page: page))
        } catch let error {
            throw TMDbError(error: error)
        }

        return peopleList
    }

}
