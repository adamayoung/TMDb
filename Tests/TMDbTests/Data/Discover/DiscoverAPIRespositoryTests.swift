//
//  DiscoverAPIRespositoryTests.swift
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

final class DiscoverAPIRespositoryTests: XCTestCase {

    var repository: DiscoverAPIRepository!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        repository = DiscoverAPIRepository(apiClient: apiClient)
    }

    override func tearDown() {
        repository = nil
        apiClient = nil
        super.tearDown()
    }

    func testMoviesReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = DiscoverMoviesRequest(sortedBy: nil, people: nil, page: nil)

        let result = try await repository.movies(sortedBy: nil, withPeople: nil, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? DiscoverMoviesRequest, expectedRequest)
    }

    func testMoviesWithSortByReturnsMovies() async throws {
        let sortBy = MovieSort.originalTitle(descending: false)
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = DiscoverMoviesRequest(sortedBy: sortBy, people: nil, page: nil)

        let result = try await repository.movies(sortedBy: sortBy, withPeople: nil, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? DiscoverMoviesRequest, expectedRequest)
    }

    func testMoviesWithWithPeopleReturnsMovies() async throws {
        let people: [Int] = [1, 2, 3, 4]
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = DiscoverMoviesRequest(sortedBy: nil, people: people, page: nil)

        let result = try await repository.movies(sortedBy: nil, withPeople: people, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? DiscoverMoviesRequest, expectedRequest)
    }

    func testMoviesWithWithPageReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        let page = expectedResult.page
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = DiscoverMoviesRequest(sortedBy: nil, people: nil, page: page)

        let result = try await repository.movies(sortedBy: nil, withPeople: nil, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? DiscoverMoviesRequest, expectedRequest)
    }

    func testMoviesWithSortByAndWithPeopleAndPageReturnsMovies() async throws {
        let sortBy = MovieSort.originalTitle(descending: false)
        let people: [Int] = [4, 5, 6, 7, 8]
        let expectedResult = MoviePageableList.mock()
        let page = expectedResult.page
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = DiscoverMoviesRequest(sortedBy: sortBy, people: people, page: page)

        let result = try await repository.movies(sortedBy: sortBy, withPeople: people, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? DiscoverMoviesRequest, expectedRequest)
    }

    func testTVSeriesReturnsTVSeries() async throws {
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = DiscoverTVSeriesRequest(sortedBy: nil, page: nil)

        let result = try await repository.tvSeries(sortedBy: nil, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? DiscoverTVSeriesRequest, expectedRequest)
    }

    func testTVSeriesWithSortByReturnsTVSeries() async throws {
        let sortBy = TVSeriesSort.firstAirDate(descending: false)
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = DiscoverTVSeriesRequest(sortedBy: sortBy, page: nil)

        let result = try await repository.tvSeries(sortedBy: sortBy, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? DiscoverTVSeriesRequest, expectedRequest)
    }

    func testTVSeriesWithPageReturnsTVSeries() async throws {
        let expectedResult = TVSeriesPageableList.mock()
        let page = expectedResult.page
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = DiscoverTVSeriesRequest(sortedBy: nil, page: page)

        let result = try await repository.tvSeries(sortedBy: nil, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? DiscoverTVSeriesRequest, expectedRequest)
    }

    func testTVSeriesWithSortByAndPageReturnsTVSeries() async throws {
        let sortBy = TVSeriesSort.firstAirDate(descending: false)
        let expectedResult = TVSeriesPageableList.mock()
        let page = expectedResult.page
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = DiscoverTVSeriesRequest(sortedBy: sortBy, page: page)

        let result = try await repository.tvSeries(sortedBy: sortBy, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? DiscoverTVSeriesRequest, expectedRequest)
    }

}
