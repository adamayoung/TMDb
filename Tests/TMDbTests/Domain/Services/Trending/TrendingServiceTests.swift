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

    func testMoviesReturnsMovies() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TrendingMoviesRequest(timeWindow: timeWindow, page: nil, language: nil)

        let result = try await service.movies(inTimeWindow: timeWindow)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TrendingMoviesRequest, expectedRequest)
    }

    func testMoviesWithPageAndLanguageReturnsMovies() async throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let page = 2
        let language = "en"
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TrendingMoviesRequest(timeWindow: timeWindow, page: page, language: language)

        let result = try await service.movies(inTimeWindow: timeWindow, page: page, language: language)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TrendingMoviesRequest, expectedRequest)
    }

    func testMoviesWhenErrorsThrowsError() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.movies(inTimeWindow: timeWindow)
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

    func testTVSeriesReturnsTVSeries() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TrendingTVSeriesRequest(timeWindow: timeWindow, page: nil, language: nil)

        let result = try await service.tvSeries(inTimeWindow: timeWindow)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TrendingTVSeriesRequest, expectedRequest)
    }

    func testTVSeriesWithPageAndLanguageReturnsTVSeries() async throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let page = 2
        let language = "en"
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TrendingTVSeriesRequest(timeWindow: timeWindow, page: page, language: language)

        let result = try await service.tvSeries(inTimeWindow: timeWindow, page: page, language: language)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TrendingTVSeriesRequest, expectedRequest)
    }

    func testTVSeriesWhenErrorsThrowsError() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.tvSeries(inTimeWindow: timeWindow)
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

    func testPeopleReturnsPeople() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = PersonPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TrendingPeopleRequest(timeWindow: timeWindow, page: nil, language: nil)

        let result = try await service.people(inTimeWindow: timeWindow)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TrendingPeopleRequest, expectedRequest)
    }

    func testPeopleWithPageAndLanguageReturnsPeople() async throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let page = 2
        let language = "en"
        let expectedResult = PersonPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TrendingPeopleRequest(timeWindow: timeWindow, page: page, language: language)

        let result = try await service.people(inTimeWindow: timeWindow, page: page, language: language)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TrendingPeopleRequest, expectedRequest)
    }

    func testPeopleWhenErrorsThrowsError() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.people(inTimeWindow: timeWindow)
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

}
