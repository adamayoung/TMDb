//
//  TrendingServiceTests.swift
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

final class TrendingServiceTests: XCTestCase {

    var service: TrendingService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        service = TrendingService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient = nil
        service = nil
        super.tearDown()
    }

    func testMoviesWithDefaultParametersReturnsMovies() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.movies()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, TrendingEndpoint.movies(timeWindow: timeWindow).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testMoviesForDayReturnsMovies() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.movies(inTimeWindow: timeWindow, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, TrendingEndpoint.movies(timeWindow: timeWindow).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testMoviesForDayWithPageReturnsMovies() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = MoviePageableList.mock()
        let page = expectedResult.page
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.movies(inTimeWindow: timeWindow, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, TrendingEndpoint.movies(timeWindow: timeWindow, page: page).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testMoviesForWeekReturnsMovies() async throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.movies(inTimeWindow: timeWindow, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, TrendingEndpoint.movies(timeWindow: timeWindow).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testMoviesForWeekWithPageReturnsMovies() async throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let expectedResult = MoviePageableList.mock()
        let page = expectedResult.page
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.movies(inTimeWindow: timeWindow, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, TrendingEndpoint.movies(timeWindow: timeWindow, page: page).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testTVSeriesWithDefaultReturnsTVSeries() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.tvSeries()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, TrendingEndpoint.tvSeries(timeWindow: timeWindow).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testTVSeriesForDayReturnsTVSeries() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.tvSeries(inTimeWindow: timeWindow, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, TrendingEndpoint.tvSeries(timeWindow: timeWindow).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testTVSeriesForDayWithPageReturnsTVSeries() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = TVSeriesPageableList.mock()
        let page = expectedResult.page
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.tvSeries(inTimeWindow: timeWindow, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, TrendingEndpoint.tvSeries(timeWindow: timeWindow, page: page).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testTVSeriesForWeekReturnsTVSeries() async throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.tvSeries(inTimeWindow: timeWindow, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, TrendingEndpoint.tvSeries(timeWindow: timeWindow).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testTVSeriesForWeekWithPageReturnsTVSeries() async throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let expectedResult = TVSeriesPageableList.mock()
        let page = expectedResult.page
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.tvSeries(inTimeWindow: timeWindow, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, TrendingEndpoint.tvSeries(timeWindow: timeWindow, page: page).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testPeopleWithDefaultParametersReturnsPeople() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = PersonPageableList.mock()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.people()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, TrendingEndpoint.people(timeWindow: timeWindow).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testPeopleForDayReturnsPeople() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = PersonPageableList.mock()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.people(inTimeWindow: timeWindow, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, TrendingEndpoint.people(timeWindow: timeWindow).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testPeopleForDayWithPageReturnsPeople() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = PersonPageableList.mock()
        let page = expectedResult.page
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.people(inTimeWindow: timeWindow, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, TrendingEndpoint.people(timeWindow: timeWindow, page: page).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testPeopleForWeekReturnsPeople() async throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let expectedResult = PersonPageableList.mock()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.people(inTimeWindow: timeWindow, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, TrendingEndpoint.people(timeWindow: timeWindow).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testPeopleForWeekWithPageReturnsPeople() async throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let expectedResult = PersonPageableList.mock()
        let page = expectedResult.page
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.people(inTimeWindow: timeWindow, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, TrendingEndpoint.people(timeWindow: timeWindow, page: page).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

}
