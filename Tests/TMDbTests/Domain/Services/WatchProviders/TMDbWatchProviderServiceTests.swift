//
//  TMDbWatchProviderServiceTests.swift
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

final class TMDbWatchProviderServiceTests: XCTestCase {

    var service: TMDbWatchProviderService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        service = TMDbWatchProviderService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient = nil
        service = nil
        super.tearDown()
    }

    func testCountriesReturnsCountries() async throws {
        let regions = WatchProviderRegions.mock
        let expectedResult = regions.results
        apiClient.addResponse(.success(regions))
        let expectedRequest = WatchProviderRegionsRequest(language: nil)

        let result = try await service.countries()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? WatchProviderRegionsRequest, expectedRequest)
    }

    func testCountriesWithLanguageReturnsCountries() async throws {
        let regions = WatchProviderRegions.mock
        let language = "en"
        let expectedResult = regions.results
        apiClient.addResponse(.success(regions))
        let expectedRequest = WatchProviderRegionsRequest(language: language)

        let result = try await service.countries(language: language)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? WatchProviderRegionsRequest, expectedRequest)
    }

    func testCountriesWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.countries()
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

    func testMovieWatchProvidersReturnsWatchProviders() async throws {
        let watchProviderResult = WatchProviderResult.mock
        let expectedResult = watchProviderResult.results
        apiClient.addResponse(.success(watchProviderResult))
        let expectedRequest = WatchProvidersForMoviesRequest(country: nil, language: nil)

        let result = try await service.movieWatchProviders()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? WatchProvidersForMoviesRequest, expectedRequest)
    }

    func testMovieWatchProvidersWithFilterAndLanguageReturnsWatchProviders() async throws {
        let watchProviderResult = WatchProviderResult.mock
        let country = "GB"
        let language = "en"
        let expectedResult = watchProviderResult.results
        apiClient.addResponse(.success(watchProviderResult))
        let expectedRequest = WatchProvidersForMoviesRequest(country: country, language: language)

        let filter = WatchProviderFilter(country: country)
        let result = try await service.movieWatchProviders(filter: filter, language: language)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? WatchProvidersForMoviesRequest, expectedRequest)
    }

    func testMovieWatchProvidersWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.movieWatchProviders()
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

    func testTVSeriesWatchProvidersReturnsWatchProviders() async throws {
        let watchProviderResult = WatchProviderResult.mock
        let expectedResult = watchProviderResult.results
        apiClient.addResponse(.success(watchProviderResult))
        let expectedRequest = WatchProvidersForTVSeriesRequest(country: nil, language: nil)

        let result = try await service.tvSeriesWatchProviders()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? WatchProvidersForTVSeriesRequest, expectedRequest)
    }

    func testTVSeriesWatchProvidersWithFilterAndLanguageReturnsWatchProviders() async throws {
        let watchProviderResult = WatchProviderResult.mock
        let country = "GB"
        let language = "en"
        let expectedResult = watchProviderResult.results
        apiClient.addResponse(.success(watchProviderResult))
        let expectedRequest = WatchProvidersForTVSeriesRequest(country: country, language: language)

        let filter = WatchProviderFilter(country: country)
        let result = try await service.tvSeriesWatchProviders(filter: filter, language: language)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? WatchProvidersForTVSeriesRequest, expectedRequest)
    }

    func testTVSeriesWatchProvidersWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.tvSeriesWatchProviders()
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

}
