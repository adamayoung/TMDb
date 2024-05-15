//
//  DiscoverServiceTests.swift
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

final class DiscoverServiceTests: XCTestCase {

    var service: DiscoverService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        service = DiscoverService(apiClient: apiClient)
    }

    override func tearDown() {
        service = nil
        apiClient = nil
        super.tearDown()
    }

    func testMoviesReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = DiscoverMoviesRequest(sortedBy: nil, people: nil, page: nil, language: nil)

        let result = try await service.movies()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? DiscoverMoviesRequest, expectedRequest)
    }

    func testMoviesWithSortByAndWithPeopleAndPageAndLanguageReturnsMovies() async throws {
        let sortBy = MovieSort.originalTitle(descending: false)
        let people = [4, 5, 6, 7, 8]
        let expectedResult = MoviePageableList.mock()
        let page = expectedResult.page
        let language = "en"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = DiscoverMoviesRequest(sortedBy: sortBy, people: people, page: page, language: language)

        let result = try await service.movies(sortedBy: sortBy, withPeople: people, page: page, language: language)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? DiscoverMoviesRequest, expectedRequest)
    }

    func testTVSeriesReturnsTVSeries() async throws {
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = DiscoverTVSeriesRequest(sortedBy: nil, page: nil, language: nil)

        let result = try await service.tvSeries()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? DiscoverTVSeriesRequest, expectedRequest)
    }

    func testTVSeriesWithSortByAndPageAndLanguageReturnsTVSeries() async throws {
        let sortBy = TVSeriesSort.firstAirDate(descending: false)
        let expectedResult = TVSeriesPageableList.mock()
        let page = expectedResult.page
        let language = "en"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = DiscoverTVSeriesRequest(sortedBy: sortBy, page: page, language: language)

        let result = try await service.tvSeries(sortedBy: sortBy, page: page, language: language)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? DiscoverTVSeriesRequest, expectedRequest)
    }

}
