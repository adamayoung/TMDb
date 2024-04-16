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
    var repository: GenreStubRepository!

    override func setUp() {
        super.setUp()
        repository = GenreStubRepository()
        service = GenreService(repository: repository)
    }

    override func tearDown() {
        service = nil
        repository = nil
        super.tearDown()
    }

    func testMovieGenresWhenSuccessfulReturnsGenres() async throws {
        let expectedResult = GenreList.mock().genres
        repository.movieGenresResult = .success(expectedResult)

        let result = try await service.movieGenres()

        XCTAssertEqual(result, expectedResult)
    }

    func testMovieGenresWhenFailureThrowsError() async throws {
        let expectedError = TMDbError.unknown
        repository.movieGenresResult = .failure(expectedError)

        var error: TMDbError?
        do {
            _ = try await service.movieGenres()
        } catch let err {
            error = err as? TMDbError
        }

        XCTAssertEqual(error, expectedError)
    }

    func testTVSeriesGenresWhenSuccessfulReturnsGenres() async throws {
        let expectedResult = GenreList.mock().genres
        repository.tvSeriesGenresResult = .success(expectedResult)

        let result = try await service.tvSeriesGenres()

        XCTAssertEqual(result, expectedResult)
    }

    func testTVSeriesGenresWhenFailureThrowsError() async throws {
        let expectedError = TMDbError.unknown
        repository.tvSeriesGenresResult = .failure(expectedError)

        var error: TMDbError?
        do {
            _ = try await service.tvSeriesGenres()
        } catch let err {
            error = err as? TMDbError
        }

        XCTAssertEqual(error, expectedError)
    }

}
