//
//  SearchIntegrationTests.swift
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

final class SearchIntegrationTests: XCTestCase {

    var searchService: SearchService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        try configureTMDb()
        searchService = SearchService()
    }

    override func tearDown() {
        searchService = nil
        super.tearDown()
    }

    func testSearchAll() async throws {
        let query = "barbie"

        let mediaList = try await searchService.searchAll(query: query)

        XCTAssertFalse(mediaList.results.isEmpty)
    }

    func testSearchMovies() async throws {
        let query = "avengers"

        let movieList = try await searchService.searchMovies(query: query)

        XCTAssertFalse(movieList.results.isEmpty)
    }

    func testSearchTVSeries() async throws {
        let query = "game of thrones"

        let tvSeriesList = try await searchService.searchTVSeries(query: query)

        XCTAssertFalse(tvSeriesList.results.isEmpty)
    }

    func testSearchPeople() async throws {
        let query = "tom hardy"

        let personList = try await searchService.searchPeople(query: query)

        XCTAssertFalse(personList.results.isEmpty)
    }

}
