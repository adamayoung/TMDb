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

@testable import TMDb
import XCTest

final class TMDbDiscoverServiceTests: XCTestCase {

    var service: TMDbDiscoverService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        service = TMDbDiscoverService(apiClient: apiClient)
    }

    override func tearDown() {
        service = nil
        apiClient = nil
        super.tearDown()
    }

    func testMoviesReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = DiscoverMoviesRequest(people: nil, sortedBy: nil, page: nil, language: nil)

        let result = try await service.movies()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? DiscoverMoviesRequest, expectedRequest)
    }

    func testMoviesWithFilterAndSortByAndPageAndLanguageReturnsMovies() async throws {
        let people = [4, 5, 6, 7, 8]
        let sortBy = MovieSort.originalTitle(descending: false)
        let expectedResult = MoviePageableList.mock()
        let page = expectedResult.page
        let language = "en"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = DiscoverMoviesRequest(people: people, sortedBy: sortBy, page: page, language: language)

        let filter = DiscoverMovieFilter(people: people)
        let result = try await service.movies(filter: filter, sortedBy: sortBy, page: page, language: language)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? DiscoverMoviesRequest, expectedRequest)
    }

    func testMoviesWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.movies()
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
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

    func testTVSeriesWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.tvSeries()
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

}
