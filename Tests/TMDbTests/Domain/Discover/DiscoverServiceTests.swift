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
    var repository: DiscoverStubRepository!

    override func setUp() {
        super.setUp()
        repository = DiscoverStubRepository()
        service = DiscoverService(repository: repository)
    }

    override func tearDown() {
        service = nil
        repository = nil
        super.tearDown()
    }

    func testMoviesWithNoParametersWhenSuccessfulReturnsMovieList() async throws {
        let expectedResult = MoviePageableList.mock()
        repository.moviesResult = .success(expectedResult)

        let result = try await service.movies()

        XCTAssertEqual(result, expectedResult)
        let parameters = try XCTUnwrap(repository.lastMoviesParameters)
        XCTAssertNil(parameters.0)
        XCTAssertNil(parameters.1)
        XCTAssertNil(parameters.2)
    }

    func testMoviesWithParametersWhenSuccessfulReturnsMovieList() async throws {
        let expectedResult = MoviePageableList.mock()
        repository.moviesResult = .success(expectedResult)
        let sortedBy = MovieSort.originalTitle(descending: true)
        let people = [1, 2, 3, 4]
        let page = 4

        let result = try await service.movies(sortedBy: sortedBy, withPeople: people, page: page)

        XCTAssertEqual(result, expectedResult)
        let parameters = try XCTUnwrap(repository.lastMoviesParameters)
        XCTAssertEqual(parameters.0, sortedBy)
        XCTAssertEqual(parameters.1, people)
        XCTAssertEqual(parameters.2, page)
    }

    func testMoviesWhenFailureThrowsError() async throws {
        let expectedError = TMDbError.unknown
        repository.moviesResult = .failure(expectedError)

        var error: TMDbError?
        do {
            _ = try await service.movies()
        } catch let err {
            error = err as? TMDbError
        }

        XCTAssertEqual(error, expectedError)
    }

    func testTVSeriesWithNoParametersWhenSuccessfulReturnsTVSeriesList() async throws {
        let expectedResult = TVSeriesPageableList.mock()
        repository.tvSeriesResult = .success(expectedResult)

        let result = try await service.tvSeries()

        XCTAssertEqual(result, expectedResult)
        let parameters = try XCTUnwrap(repository.lastTVSeriesParameters)
        XCTAssertNil(parameters.0)
        XCTAssertNil(parameters.1)
    }

    func testTVSeriesWithParametersWhenSuccessfulReturnsTVSeriesList() async throws {
        let expectedResult = TVSeriesPageableList.mock()
        repository.tvSeriesResult = .success(expectedResult)
        let sortedBy = TVSeriesSort.popularity(descending: false)
        let page = 4

        let result = try await service.tvSeries(sortedBy: sortedBy, page: page)

        XCTAssertEqual(result, expectedResult)
        let parameters = try XCTUnwrap(repository.lastTVSeriesParameters)
        XCTAssertEqual(parameters.0, sortedBy)
        XCTAssertEqual(parameters.1, page)
    }

    func testTVSeriesWhenFailureThrowsError() async throws {
        let expectedError = TMDbError.unknown
        repository.tvSeriesResult = .failure(expectedError)

        var error: TMDbError?
        do {
            _ = try await service.tvSeries()
        } catch let err {
            error = err as? TMDbError
        }

        XCTAssertEqual(error, expectedError)
    }

}
