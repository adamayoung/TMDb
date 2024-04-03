//
//  DiscoverIntegrationTests.swift
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

final class DiscoverIntegrationTests: XCTestCase {

    var discoverService: DiscoverService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        let configuration = try tmdbConfiguration()
        discoverService = DiscoverService(configuration: configuration)
    }

    override func tearDown() {
        discoverService = nil
        super.tearDown()
    }

    func testMovies() async throws {
        let movieList = try await discoverService.movies()

        XCTAssertFalse(movieList.results.isEmpty)
    }

    func testTVSeries() async throws {
        let tvSeriesList = try await discoverService.tvSeries()

        XCTAssertFalse(tvSeriesList.results.isEmpty)
    }

}
