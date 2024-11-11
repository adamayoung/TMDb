//
//  TMDbSearchServiceTests.swift
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

@Suite(.tags(.requests, .search))
struct TMDbSearchServiceTests {

    var service: TMDbSearchService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbSearchService(apiClient: apiClient)
    }

    @Test("searchAll returns media")
    func searchAllReturnsMedia() async throws {
        let query = String.random
        let expectedResult = MediaPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MultiSearchRequest(
            query: query, includeAdult: nil, page: nil, language: nil)

        let result = try await service.searchAll(query: query)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? MultiSearchRequest == expectedRequest)
    }

    @Test("searchAll with filter, page and language returns media")
    func searchAllWithFilterAndPageAndLanguageReturnsMedia() async throws {
        let query = String.random
        let includeAdult = true
        let page = 2
        let language = "en"
        let expectedResult = MediaPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MultiSearchRequest(
            query: query,
            includeAdult: includeAdult,
            page: page,
            language: language
        )

        let filter = AllMediaSearchFilter(includeAdult: includeAdult)
        let result = try await service.searchAll(
            query: query, filter: filter, page: page, language: language)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? MultiSearchRequest == expectedRequest)
    }

    @Test("searchAll when errors throws error")
    func searchAllWhenErrorsThrowsError() async throws {
        let query = String.random
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.searchAll(query: query)
        }
    }

    @Test("searchMovies returns movies")
    func searchMoviesReturnsMovies() async throws {
        let query = String.random
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieSearchRequest(
            query: query,
            primaryReleaseYear: nil,
            includeAdult: nil,
            page: nil,
            language: nil
        )

        let result = try await service.searchMovies(query: query)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? MovieSearchRequest == expectedRequest)
    }

    @Test("searchMovies with filter, page and language returns movies")
    func searchMoviesWithFilterAndPageAndLanguageReturnsMovies() async throws {
        let query = String.random
        let primaryReleaseYear = 2024
        let country = "GB"
        let includeAdult = true
        let page = 3
        let language = "en"
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieSearchRequest(
            query: query,
            primaryReleaseYear: primaryReleaseYear,
            country: country,
            includeAdult: includeAdult,
            page: page,
            language: language
        )

        let filter = MovieSearchFilter(
            primaryReleaseYear: primaryReleaseYear,
            country: country,
            includeAdult: includeAdult
        )
        let result = try await service.searchMovies(
            query: query, filter: filter, page: page, language: language)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? MovieSearchRequest == expectedRequest)
    }

    @Test("searchMovies when errors throws error")
    func searchMoviesWhenErrorsThrowsError() async throws {
        let query = String.random
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.searchMovies(query: query)
        }
    }

    @Test("searchTVSeries returns TV series")
    func searchTVSeriesReturnsTVSeries() async throws {
        let query = String.random
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesSearchRequest(
            query: query,
            firstAirDateYear: nil,
            year: nil,
            includeAdult: nil,
            page: nil,
            language: nil
        )

        let result = try await service.searchTVSeries(query: query)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesSearchRequest == expectedRequest)
    }

    @Test("searchTVSeries with filter, page and language returns TV series")
    func searchTVSeriesWithFilterAndPageAndLanguageReturnsTVSeries() async throws {
        let query = String.random
        let firstAirDateYear = 2023
        let year = 2024
        let includeAdult = true
        let page = 3
        let language = "en"
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesSearchRequest(
            query: query,
            firstAirDateYear: firstAirDateYear,
            year: year,
            includeAdult: includeAdult,
            page: page,
            language: language
        )

        let filter = TVSeriesSearchFilter(
            firstAirDateYear: firstAirDateYear, year: year, includeAdult: includeAdult)
        let result = try await service.searchTVSeries(
            query: query, filter: filter, page: page, language: language)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesSearchRequest == expectedRequest)
    }

    @Test("searchTVSeries when errors throws error")
    func searchTVSeriesWhenErrorsThrowsError() async throws {
        let query = String.random
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.searchTVSeries(query: query)
        }
    }

    @Test("searchPeople returns people")
    func searchPeopleReturnsPeople() async throws {
        let query = String.random
        let expectedResult = PersonPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PersonSearchRequest(
            query: query, includeAdult: nil, page: nil, language: nil)

        let result = try await service.searchPeople(query: query)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? PersonSearchRequest == expectedRequest)
    }

    @Test("searchPeople with filter, page and language returns people")
    func searchPeopleWithFilterAndPageAndLanguageReturnsPeople() async throws {
        let query = String.random
        let includeAdult = true
        let page = 2
        let language = "en"
        let expectedResult = PersonPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PersonSearchRequest(
            query: query,
            includeAdult: includeAdult,
            page: page,
            language: language
        )

        let filter = PersonSearchFilter(includeAdult: includeAdult)
        let result = try await service.searchPeople(
            query: query, filter: filter, page: page, language: language)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? PersonSearchRequest == expectedRequest)
    }

    @Test("searchPeople when errors throws error")
    func searchPeopleWhenErrorsThrowsError() async throws {
        let query = String.random
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.searchPeople(query: query)
        }
    }

}
