//
//  TMDbTVSeriesServiceOthersTests.swift
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

final class TMDbTVSeriesServiceOthersTests: XCTestCase {

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

    func testWatchProvidersReturnsWatchProviders() async throws {
        let expectedResult = ShowWatchProviderResult.mock()
        let tvSeriesID = 1
        let country = "GB"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesWatchProvidersRequest(id: tvSeriesID)

        let result = try await service.watchProviders(forTVSeries: tvSeriesID, country: country)

        XCTAssertEqual(result, expectedResult.results[country])
        XCTAssertEqual(apiClient.lastRequest as? TVSeriesWatchProvidersRequest, expectedRequest)
    }

    func testWatchProvidersWhenErrorsThrowsError() async throws {
        let tvSeriesID = 1
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.watchProviders(forTVSeries: tvSeriesID)
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

    func testExternalLinksReturnsExternalLinks() async throws {
        let expectedResult = TVSeriesExternalLinksCollection.lockeAndKey
        let tvSeriesID = 86423
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesExternalLinksRequest(id: tvSeriesID)

        let result = try await service.externalLinks(forTVSeries: tvSeriesID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TVSeriesExternalLinksRequest, expectedRequest)
    }

    func testExternalLinksWhenErrorsThrowsError() async throws {
        let tvSeriesID = 1
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.externalLinks(forTVSeries: tvSeriesID)
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

}
