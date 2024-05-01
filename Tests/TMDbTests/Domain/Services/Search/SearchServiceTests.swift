//
//  SearchServiceTests.swift
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

final class SearchServiceTests: XCTestCase {

    var service: SearchService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        service = SearchService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient = nil
        service = nil
        super.tearDown()
    }

    func testSearchAllWithDefaultParametersReturnsMedia() async throws {
        let query = String.randomString
        let expectedResult = MediaPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MultiSearchRequest(query: query)

        let result = try await service.searchAll(query: query)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MultiSearchRequest, expectedRequest)
    }

    func testSearchAllReturnsMedia() async throws {
        let query = String.randomString
        let expectedResult = MediaPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MultiSearchRequest(query: query)

        let result = try await service.searchAll(query: query, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MultiSearchRequest, expectedRequest)
    }

    func testSearchAllWithPageReturnsMedia() async throws {
        let query = String.randomString
        let expectedResult = MediaPageableList.mock()
        let page = expectedResult.page
        let expectedRequest = MultiSearchRequest(query: query, page: page)

        apiClient.addResponse(.success(expectedResult))

        let result = try await service.searchAll(query: query, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MultiSearchRequest, expectedRequest)
    }

    func testSearchMoviesWithDefaultParametersReturnsMovies() async throws {
        let query = String.randomString
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieSearchRequest(query: query, year: nil, page: nil)

        let result = try await service.searchMovies(query: query)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MovieSearchRequest, expectedRequest)
    }

    func testSearchMoviesReturnsMovies() async throws {
        let query = String.randomString
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieSearchRequest(query: query, year: nil, page: nil)

        let result = try await service.searchMovies(query: query, year: nil, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MovieSearchRequest, expectedRequest)
    }

    func testSearchMoviesWithYearReturnsMovies() async throws {
        let query = String.randomString
        let year = 2020
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieSearchRequest(query: query, year: year, page: nil)

        let result = try await service.searchMovies(query: query, year: year, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MovieSearchRequest, expectedRequest)
    }

    func testSearchMoviesWithPageReturnsMovies() async throws {
        let query = String.randomString
        let expectedResult = MoviePageableList.mock()
        let page = expectedResult.page
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieSearchRequest(query: query, year: nil, page: page)

        let result = try await service.searchMovies(query: query, year: nil, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MovieSearchRequest, expectedRequest)
    }

    func testSearchMoviesWithYearAndPageReturnsMovies() async throws {
        let query = String.randomString
        let year = 2020
        let expectedResult = MoviePageableList.mock()
        let page = expectedResult.page
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieSearchRequest(query: query, year: year, page: page)

        let result = try await service.searchMovies(query: query, year: year, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MovieSearchRequest, expectedRequest)
    }

    func testSearchTVSeriesWithDefaultParametersReturnsTVSeries() async throws {
        let query = String.randomString
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesSearchRequest(query: query, firstAirDateYear: nil, page: nil)

        let result = try await service.searchTVSeries(query: query)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVSeriesSearchRequest, expectedRequest)
    }

    func testSearchTVSeriesReturnsTVSeries() async throws {
        let query = String.randomString
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesSearchRequest(query: query, firstAirDateYear: nil, page: nil)

        let result = try await service.searchTVSeries(query: query, firstAirDateYear: nil, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVSeriesSearchRequest, expectedRequest)
    }

    func testSearchTVSeriesWithFirstAirDateYearReturnsTVSeries() async throws {
        let query = String.randomString
        let year = 2020
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesSearchRequest(query: query, firstAirDateYear: year, page: nil)

        let result = try await service.searchTVSeries(query: query, firstAirDateYear: year, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVSeriesSearchRequest, expectedRequest)
    }

    func testSearchTVSeriesWithPageReturnsTVSeries() async throws {
        let query = String.randomString
        let expectedResult = TVSeriesPageableList.mock()
        let page = expectedResult.page
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesSearchRequest(query: query, firstAirDateYear: nil, page: page)

        let result = try await service.searchTVSeries(query: query, firstAirDateYear: nil, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVSeriesSearchRequest, expectedRequest)
    }

    func testSearchTVSeriesWithFirstAirDateYearANdPageReturnsTVSeries() async throws {
        let query = String.randomString
        let year = 2020
        let expectedResult = TVSeriesPageableList.mock()
        let page = expectedResult.page
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesSearchRequest(query: query, firstAirDateYear: year, page: page)

        let result = try await service.searchTVSeries(query: query, firstAirDateYear: year, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVSeriesSearchRequest, expectedRequest)
    }

    func testSearchPeopleWithDefaultParametersReturnsPeople() async throws {
        let query = String.randomString
        let expectedResult = PersonPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PersonSearchRequest(query: query, page: nil)

        let result = try await service.searchPeople(query: query)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? PersonSearchRequest, expectedRequest)
    }

    func testSearchPeopleReturnsPeople() async throws {
        let query = String.randomString
        let expectedResult = PersonPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PersonSearchRequest(query: query, page: nil)

        let result = try await service.searchPeople(query: query, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? PersonSearchRequest, expectedRequest)
    }

    func testSearchPeopleWithPageReturnsPeople() async throws {
        let query = String.randomString
        let expectedResult = PersonPageableList.mock()
        let page = expectedResult.page
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PersonSearchRequest(query: query, page: page)

        let result = try await service.searchPeople(query: query, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? PersonSearchRequest, expectedRequest)
    }

}
