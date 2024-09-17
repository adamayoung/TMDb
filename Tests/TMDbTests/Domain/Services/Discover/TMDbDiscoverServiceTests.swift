//
//  TMDbDiscoverServiceTests.swift
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

@Suite(.tags(.services, .configuration))
struct TMDbDiscoverServiceTests {

    var service: TMDbDiscoverService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbDiscoverService(apiClient: apiClient)
    }

    @Test("movies returns movies")
    func moviesReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = DiscoverMoviesRequest(people: nil, sortedBy: nil, page: nil, language: nil)

        let result = try await service.movies()

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? DiscoverMoviesRequest == expectedRequest)
    }

    @Test("movies with filter, sort by, page and language returns movies")
    func moviesWithFilterAndSortByAndPageAndLanguageReturnsMovies() async throws {
        let people = [4, 5, 6, 7, 8]
        let sortBy = MovieSort.originalTitle(descending: false)
        let expectedResult = MoviePageableList.mock()
        let page = expectedResult.page
        let language = "en"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = DiscoverMoviesRequest(people: people, sortedBy: sortBy, page: page, language: language)

        let filter = DiscoverMovieFilter(people: people)
        let result = try await service.movies(filter: filter, sortedBy: sortBy, page: page, language: language)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? DiscoverMoviesRequest == expectedRequest)
    }

    @Test("movies when errors throws error")
    func moviesWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.movies()
        }
    }

    @Test("tvSeries returns TV series")
    func tvSeriesReturnsTVSeries() async throws {
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = DiscoverTVSeriesRequest(sortedBy: nil, page: nil, language: nil)

        let result = try await service.tvSeries()

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? DiscoverTVSeriesRequest == expectedRequest)
    }

    @Test("tvSeries with sort by, page and language returns TV series")
    func tvSeriesWithSortByAndPageAndLanguageReturnsTVSeries() async throws {
        let sortBy = TVSeriesSort.firstAirDate(descending: false)
        let expectedResult = TVSeriesPageableList.mock()
        let page = expectedResult.page
        let language = "en"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = DiscoverTVSeriesRequest(sortedBy: sortBy, page: page, language: language)

        let result = try await service.tvSeries(sortedBy: sortBy, page: page, language: language)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? DiscoverTVSeriesRequest == expectedRequest)
    }

    @Test("tvSeries when errors throws error")
    func tvSeriesWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.tvSeries()
        }
    }

}
