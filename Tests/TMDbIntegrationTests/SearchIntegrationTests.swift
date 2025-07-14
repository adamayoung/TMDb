//
//  SearchIntegrationTests.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
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

import Foundation
import Testing

@testable import TMDb

@Suite(
    .tags(.search),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct SearchIntegrationTests {

    var searchService: (any SearchService)!

    init() {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        self.searchService = TMDbClient(apiKey: apiKey).search
    }

    @Test("searchAll")
    func searchAll() async throws {
        let query = "barbie"

        let mediaList = try await searchService.searchAll(query: query)

        #expect(!mediaList.results.isEmpty)
    }

    @Test(
        "searchAll with 'Velvet Underground'",
        .bug(
            "https://github.com/adamayoung/TMDb/issues/227",
            "Searching for 'Velvet Underground' throws an unknown error"
        )
    )
    func searchAllWithVelvetUnderground() async throws {
        let query = "Velvet Underground"

        let mediaList = try await searchService.searchAll(query: query)

        #expect(!mediaList.results.isEmpty)
    }

    @Test("searchMovies")
    func searchMovies() async throws {
        let query = "avengers"

        let movieList = try await searchService.searchMovies(query: query)

        #expect(!movieList.results.isEmpty)
    }

    @Test("searchTVSeries")
    func searchTVSeries() async throws {
        let query = "game of thrones"

        let tvSeriesList = try await searchService.searchTVSeries(query: query)

        #expect(!tvSeriesList.results.isEmpty)
    }

    @Test("searchPeople")
    func searchPeople() async throws {
        let query = "tom hardy"

        let personList = try await searchService.searchPeople(query: query)

        #expect(!personList.results.isEmpty)
    }

}
