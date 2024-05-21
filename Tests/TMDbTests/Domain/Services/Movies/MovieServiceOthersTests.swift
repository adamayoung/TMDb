//
//  MovieServiceOthersTests.swift
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

final class MovieServiceOthersTests: XCTestCase {

    var service: TMDbMovieService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        service = TMDbMovieService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient = nil
        service = nil
        super.tearDown()
    }

    func testWatchProvidersReturnsWatchProviders() async throws {
        let expectedResult = ShowWatchProviderResult.mock()
        let movieID = 1
        let country = "GB"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieWatchProvidersRequest(id: movieID)

        let result = try await service.watchProviders(forMovie: movieID, country: country)

        XCTAssertEqual(result, expectedResult.results[country])
        XCTAssertEqual(apiClient.lastRequest as? MovieWatchProvidersRequest, expectedRequest)
    }

    func testWatchProvidersWhenErrorsThrowsError() async throws {
        let movieID = 1
        let country = "GB"
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.watchProviders(forMovie: movieID, country: country)
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

    func testExternalLinksReturnsExternalLinks() async throws {
        let expectedResult = MovieExternalLinksCollection.barbie
        let movieID = 346_698
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieExternalLinksRequest(id: movieID)

        let result = try await service.externalLinks(forMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MovieExternalLinksRequest, expectedRequest)
    }

    func testExternalLinksWhenErrorsThrowsError() async throws {
        let movieID = 346_698
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.externalLinks(forMovie: movieID)
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

}
