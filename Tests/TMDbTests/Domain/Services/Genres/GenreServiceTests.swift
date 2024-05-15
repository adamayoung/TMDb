//
//  GenreServiceTests.swift
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

final class GenreServiceTests: XCTestCase {

    var service: GenreService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        service = GenreService(apiClient: apiClient)
    }

    override func tearDown() {
        service = nil
        apiClient = nil
        super.tearDown()
    }

    func testMovieGenresReturnsGenres() async throws {
        let genreList = GenreList.mock()
        let expectedResult = genreList.genres
        apiClient.addResponse(.success(genreList))
        let expectedRequest = MovieGenresRequest(language: nil)

        let result = try await service.movieGenres()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MovieGenresRequest, expectedRequest)
    }

    func testMovieGenresWithLanguageReturnsGenres() async throws {
        let genreList = GenreList.mock()
        let language = "en"
        let expectedResult = genreList.genres
        apiClient.addResponse(.success(genreList))
        let expectedRequest = MovieGenresRequest(language: language)

        let result = try await service.movieGenres(language: language)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MovieGenresRequest, expectedRequest)
    }

    func testMovieGenresWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.movieGenres()
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

    func testTVSeriesGenresReturnsGenres() async throws {
        let genreList = GenreList.mock()
        let expectedResult = genreList.genres
        apiClient.addResponse(.success(genreList))
        let expectedRequest = TVSeriesGenresRequest(language: nil)

        let result = try await service.tvSeriesGenres()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVSeriesGenresRequest, expectedRequest)
    }

    func testTVSeriesGenresWithLanguageReturnsGenres() async throws {
        let genreList = GenreList.mock()
        let language = "en"
        let expectedResult = genreList.genres
        apiClient.addResponse(.success(genreList))
        let expectedRequest = TVSeriesGenresRequest(language: language)

        let result = try await service.tvSeriesGenres(language: language)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVSeriesGenresRequest, expectedRequest)
    }

    func testTVSeriesGenresWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.tvSeriesGenres()
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

}
