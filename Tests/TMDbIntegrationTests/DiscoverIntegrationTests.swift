//
//  DiscoverIntegrationTests.swift
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
    .tags(.discover),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct DiscoverIntegrationTests {

    var discoverService: (any DiscoverService)!

    init() {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        self.discoverService = TMDbClient(apiKey: apiKey).discover
    }

    @Test("movies")
    func movies() async throws {
        let movieList = try await discoverService.movies()

        #expect(!movieList.results.isEmpty)
    }

    @Test("TV series")
    func tvSeries() async throws {
        let tvSeriesList = try await discoverService.tvSeries()

        #expect(!tvSeriesList.results.isEmpty)
    }

}
