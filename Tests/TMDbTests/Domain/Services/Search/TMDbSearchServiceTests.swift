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

@testable import TMDb
import XCTest

final class TMDbSearchServiceTests: XCTestCase {

    var service: TMDbSearchService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        service = TMDbSearchService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient = nil
        service = nil
        super.tearDown()
    }

    func testSearchAllReturnsMedia() async throws {
        let query = String.randomString
        let expectedResult = MediaPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MultiSearchRequest(query: query, includeAdult: nil, page: nil, language: nil)

        let result = try await service.searchAll(query: query)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MultiSearchRequest, expectedRequest)
    }

    func testSearchAllWithFilterAndPageAndLanguageReturnsMedia() async throws {
        let query = String.randomString
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
        let result = try await service.searchAll(query: query, filter: filter, page: page, language: language)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MultiSearchRequest, expectedRequest)
    }

    func testSearchAllWhenErrorsThrowsError() async throws {
        let query = String.randomString
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.searchAll(query: query)
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

    func testSearchMoviesReturnsMovies() async throws {
        let query = String.randomString
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

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MovieSearchRequest, expectedRequest)
    }

    func testSearchMoviesWithFilterAndPageAndLanguageReturnsMovies() async throws {
        let query = String.randomString
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
        let result = try await service.searchMovies(query: query, filter: filter, page: page, language: language)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MovieSearchRequest, expectedRequest)
    }

    func testSearchMoviesWhenErrorsThrowsError() async throws {
        let query = String.randomString
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.searchMovies(query: query)
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

    func testSearchTVSeriesReturnsTVSeries() async throws {
        let query = String.randomString
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

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVSeriesSearchRequest, expectedRequest)
    }

    func testSearchTVSeriesWithFilterAndPageAndLanguageReturnsTVSeries() async throws {
        let query = String.randomString
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

        let filter = TVSeriesSearchFilter(firstAirDateYear: firstAirDateYear, year: year, includeAdult: includeAdult)
        let result = try await service.searchTVSeries(query: query, filter: filter, page: page, language: language)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVSeriesSearchRequest, expectedRequest)
    }

    func testSearchTVSeriesWhenErrorsThrowsError() async throws {
        let query = String.randomString
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.searchTVSeries(query: query)
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

    func testSearchPeopleReturnsPeople() async throws {
        let query = String.randomString
        let expectedResult = PersonPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PersonSearchRequest(query: query, includeAdult: nil, page: nil, language: nil)

        let result = try await service.searchPeople(query: query)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? PersonSearchRequest, expectedRequest)
    }

    func testSearchPeopleWithFilterAndPageAndLanguageReturnsPeople() async throws {
        let query = String.randomString
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
        let result = try await service.searchPeople(query: query, filter: filter, page: page, language: language)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? PersonSearchRequest, expectedRequest)
    }

    func testSearchPeopleWhenErrorsThrowsError() async throws {
        let query = String.randomString
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.searchPeople(query: query)
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

}
