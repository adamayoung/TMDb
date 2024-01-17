//
//  WatchProviderIntegrationTests.swift
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

import TMDb
import XCTest

final class WatchProviderIntegrationTests: XCTestCase {

    var watchProviderService: WatchProviderService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        try configureTMDb()
        watchProviderService = WatchProviderService()
    }

    override func tearDown() {
        watchProviderService = nil
        super.tearDown()
    }

    func testCountries() async throws {
        let countries = try await watchProviderService.countries()

        XCTAssertFalse(countries.isEmpty)
    }

    func testMovieWatchProviders() async throws {
        let watchProviders = try await watchProviderService.movieWatchProviders()

        XCTAssertFalse(watchProviders.isEmpty)
    }

    func testTVSeriesWatchProviders() async throws {
        let watchProviders = try await watchProviderService.tvSeriesWatchProviders()

        XCTAssertFalse(watchProviders.isEmpty)
    }

}
