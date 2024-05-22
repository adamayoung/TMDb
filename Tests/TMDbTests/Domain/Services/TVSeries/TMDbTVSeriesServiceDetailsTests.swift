//
//  TMDbTVSeriesServiceDetailsTests.swift
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

final class TMDbTVSeriesServiceTests: XCTestCase {

    var service: TMDbTVSeriesService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        service = TMDbTVSeriesService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient = nil
        service = nil
        super.tearDown()
    }

    func testDetailsReturnsTVSeries() async throws {
        let expectedResult = TVSeries.theSandman
        let tvSeriesID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesRequest(id: tvSeriesID, language: nil)

        let result = try await service.details(forTVSeries: tvSeriesID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVSeriesRequest, expectedRequest)
    }

    func testDetailsWithLanguageReturnsTVSeries() async throws {
        let expectedResult = TVSeries.theSandman
        let tvSeriesID = expectedResult.id
        let language = "en"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesRequest(id: tvSeriesID, language: language)

        let result = try await service.details(forTVSeries: tvSeriesID, language: language)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVSeriesRequest, expectedRequest)
    }

    func testDetailsWhenErrorsThrowsError() async throws {
        let tvSeriesID = 1
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.details(forTVSeries: tvSeriesID)
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

}
