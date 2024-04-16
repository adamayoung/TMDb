//
//  GenreAPIRepositoryTests.swift
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

final class GenreAPIRepositoryTests: XCTestCase {

    var repository: GenreAPIRepository!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        repository = GenreAPIRepository(apiClient: apiClient)
    }

    override func tearDown() {
        repository = nil
        apiClient = nil
        super.tearDown()
    }

    func testMovieGenresReturnsGenres() async throws {
        let genreList = GenreList.mock()
        let expectedResult = genreList.genres
        apiClient.addResponse(.success(genreList))
        let expectedRequest = MovieGenresRequests()

        let result = try await repository.movieGenres()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MovieGenresRequests, expectedRequest)
    }

    func testTVSeriesGenresReturnsGenres() async throws {
        let genreList = GenreList.mock()
        let expectedResult = genreList.genres
        apiClient.addResponse(.success(genreList))
        let expectedRequest = TVSeriesGenresRequests()

        let result = try await repository.tvSeriesGenres()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVSeriesGenresRequests, expectedRequest)
    }

}
