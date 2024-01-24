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
        apiClient = nil
        service = nil
        super.tearDown()
    }

    func testMoviesWithDefaultParametersReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.movies()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies().path)
    }

    func testMoviesReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.movies(sortedBy: nil, withPeople: nil, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies().path)
    }

    func testMoviesWithSortByReturnsMovies() async throws {
        let sortBy = MovieSort.originalTitle(descending: false)
        let expectedResult = MoviePageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.movies(sortedBy: sortBy, withPeople: nil, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies(sortedBy: sortBy).path)
    }

    func testMoviesWithWithPeopleReturnsMovies() async throws {
        let people: [Int] = [.randomID, .randomID, .randomID, .randomID, .randomID]
        let expectedResult = MoviePageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.movies(sortedBy: nil, withPeople: people, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies(people: people).path)
    }

    func testMoviesWithWithPageReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.movies(sortedBy: nil, withPeople: nil, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies(page: page).path)
    }

    func testMoviesWithSortByAndWithPeopleAndPageReturnsMovies() async throws {
        let sortBy = MovieSort.originalTitle(descending: false)
        let people: [Int] = [.randomID, .randomID, .randomID, .randomID, .randomID]
        let expectedResult = MoviePageableList.mock()
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.movies(sortedBy: sortBy, withPeople: people, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies(sortedBy: sortBy, people: people, page: page).path)
    }

    func testTVSeriesWithDefaultParametersReturnsTVSeries() async throws {
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.tvSeries()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.tvSeries().path)
    }

    func testTVSeriesReturnsTVSeries() async throws {
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.tvSeries(sortedBy: nil, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.tvSeries().path)
    }

    func testTVSeriesWithSortByReturnsTVSeries() async throws {
        let sortBy = TVSeriesSort.firstAirDate(descending: false)
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.result = .success(expectedResult)

        let result = try await service.tvSeries(sortedBy: sortBy, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.tvSeries(sortedBy: sortBy).path)
    }

    func testTVSeriesWithPageReturnsTVSeries() async throws {
        let expectedResult = TVSeriesPageableList.mock()
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.tvSeries(sortedBy: nil, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.tvSeries(page: page).path)
    }

    func testTVSeriesWithSortByAndPageReturnsTVSeries() async throws {
        let sortBy = TVSeriesSort.firstAirDate(descending: false)
        let expectedResult = TVSeriesPageableList.mock()
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try await service.tvSeries(sortedBy: sortBy, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.tvSeries(sortedBy: sortBy, page: page).path)
    }

}
