//
//  TMDbTrendingServiceTests.swift
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
import Testing

@testable import TMDb

@Suite(.tags(.services, .trending))
struct TMDbTrendingServiceTests {

    var service: TMDbTrendingService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbTrendingService(apiClient: apiClient)
    }

    @Test("movies returns movies")
    func moviesReturnsMovies() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TrendingMoviesRequest(
            timeWindow: timeWindow, page: nil, language: nil)

        let result = try await service.movies(inTimeWindow: timeWindow)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TrendingMoviesRequest == expectedRequest)
    }

    @Test("movies with page and language returns movies")
    func moviesWithPageAndLanguageReturnsMovies() async throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let page = 2
        let language = "en"
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TrendingMoviesRequest(
            timeWindow: timeWindow, page: page, language: language)

        let result = try await service.movies(
            inTimeWindow: timeWindow, page: page, language: language)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TrendingMoviesRequest == expectedRequest)
    }

    @Test("movies when errors throws error")
    func moviesWhenErrorsThrowsError() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.movies(inTimeWindow: timeWindow)
        }
    }

    @Test("tvSeries returns tv series")
    func tvSeriesReturnsTVSeries() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TrendingTVSeriesRequest(
            timeWindow: timeWindow, page: nil, language: nil)

        let result = try await service.tvSeries(inTimeWindow: timeWindow)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TrendingTVSeriesRequest == expectedRequest)
    }

    @Test("tvSeries with page and language returns TV series")
    func tvSeriesWithPageAndLanguageReturnsTVSeries() async throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let page = 2
        let language = "en"
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TrendingTVSeriesRequest(
            timeWindow: timeWindow, page: page, language: language)

        let result = try await service.tvSeries(
            inTimeWindow: timeWindow, page: page, language: language)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TrendingTVSeriesRequest == expectedRequest)
    }

    @Test("tvSeries when errors throws error")
    func tvSeriesWhenErrorsThrowsError() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.tvSeries(inTimeWindow: timeWindow)
        }
    }

    @Test("people returns people")
    func peopleReturnsPeople() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = PersonPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TrendingPeopleRequest(
            timeWindow: timeWindow, page: nil, language: nil)

        let result = try await service.people(inTimeWindow: timeWindow)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TrendingPeopleRequest == expectedRequest)
    }

    @Test("people with page and language returns people")
    func peopleWithPageAndLanguageReturnsPeople() async throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let page = 2
        let language = "en"
        let expectedResult = PersonPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TrendingPeopleRequest(
            timeWindow: timeWindow, page: page, language: language)

        let result = try await service.people(
            inTimeWindow: timeWindow, page: page, language: language)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TrendingPeopleRequest == expectedRequest)
    }

    @Test("people when errors throws error")
    func peopleWhenErrorsThrowsError() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.people(inTimeWindow: timeWindow)
        }
    }

}
