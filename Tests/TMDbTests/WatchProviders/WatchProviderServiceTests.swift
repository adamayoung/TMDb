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
        apiClient.result = .success(regions)

        let result = try await service.countries()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, WatchProviderEndpoint.regions.path)
    }

    func testMovieWatchProvidersReturnsWatchProviders() async throws {
        let watchProviderResult = WatchProviderResult.mock
        let expectedResult = watchProviderResult.results
        apiClient.result = .success(watchProviderResult)

        let result = try await service.movieWatchProviders()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, WatchProviderEndpoint.movie(regionCode: localeProvider.regionCode).path)
    }

    func testTVSeriesWatchProvidersReturnsWatchProviders() async throws {
        let watchProviderResult = WatchProviderResult.mock
        let expectedResult = watchProviderResult.results
        apiClient.result = .success(watchProviderResult)

        let result = try await service.tvSeriesWatchProviders()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, WatchProviderEndpoint.tvSeries(regionCode: localeProvider.regionCode).path)
    }

}
