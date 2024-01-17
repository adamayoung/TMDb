//
//  TrendingIntegrationTests.swift
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

final class TrendingIntegrationTests: XCTestCase {

    var trendingService: TrendingService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        try configureTMDb()
        trendingService = TrendingService()
    }

    override func tearDown() {
        trendingService = nil
        super.tearDown()
    }

    func testMoviesTrendingByDay() async throws {
        let movieList = try await trendingService.movies(inTimeWindow: .day)

        XCTAssertFalse(movieList.results.isEmpty)
    }

    func testMoviesTrendingByWeek() async throws {
        let movieList = try await trendingService.movies(inTimeWindow: .week)

        XCTAssertFalse(movieList.results.isEmpty)
    }

    func testTVSeriesTrendingByDay() async throws {
        let tvSeriesList = try await trendingService.tvSeries(inTimeWindow: .day)

        XCTAssertFalse(tvSeriesList.results.isEmpty)
    }

    func testTVSeriesTrendingByWeek() async throws {
        let tvSeriesList = try await trendingService.tvSeries(inTimeWindow: .week)

        XCTAssertFalse(tvSeriesList.results.isEmpty)
    }

    func testPeopleTrendingByDay() async throws {
        let personList = try await trendingService.people(inTimeWindow: .day)

        XCTAssertFalse(personList.results.isEmpty)
    }

    func testPeopleTrendingByWeek() async throws {
        let personList = try await trendingService.people(inTimeWindow: .week)

        XCTAssertFalse(personList.results.isEmpty)
    }

}
