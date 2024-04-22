//
//  WatchProviderServiceTests.swift
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

final class WatchProviderServiceTests: XCTestCase {

    var service: WatchProviderService!
    var apiClient: MockAPIClient!
    var localeProvider: LocaleMockProvider!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        localeProvider = LocaleMockProvider(languageCode: "en", regionCode: "GB")
        service = WatchProviderService(apiClient: apiClient, localeProvider: localeProvider)
    }

    override func tearDown() {
        apiClient = nil
        localeProvider = nil
        service = nil
        super.tearDown()
    }

    func testCountriesReturnsCountries() async throws {
        let regions = WatchProviderRegions.mock
        let expectedResult = regions.results
        apiClient.addResponse(.success(regions))
        let expectedRequest = WatchProviderRegionsRequest()

        let result = try await service.countries()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? WatchProviderRegionsRequest, expectedRequest)
    }

    func testMovieWatchProvidersReturnsWatchProviders() async throws {
        let watchProviderResult = WatchProviderResult.mock
        let expectedResult = watchProviderResult.results
        apiClient.addResponse(.success(watchProviderResult))
        let expectedRequest = WatchProvidersForMoviesRequest(regionCode: localeProvider.regionCode)

        let result = try await service.movieWatchProviders()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? WatchProvidersForMoviesRequest, expectedRequest)
    }

    func testTVSeriesWatchProvidersReturnsWatchProviders() async throws {
        let watchProviderResult = WatchProviderResult.mock
        let expectedResult = watchProviderResult.results
        apiClient.addResponse(.success(watchProviderResult))
        let expectedRequest = WatchProvidersForTVSeriesRequest(regionCode: localeProvider.regionCode)

        let result = try await service.tvSeriesWatchProviders()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? WatchProvidersForTVSeriesRequest, expectedRequest)
    }

}
