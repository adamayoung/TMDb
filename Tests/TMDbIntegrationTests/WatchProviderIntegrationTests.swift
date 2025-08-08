//
//  WatchProviderIntegrationTests.swift
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
    .tags(.tvSeason),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct WatchProviderIntegrationTests {

    var watchProviderService: (any WatchProviderService)!

    init() {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        self.watchProviderService = TMDbClient(apiKey: apiKey).watchProviders
    }

    @Test("countries")
    func countries() async throws {
        let countries = try await watchProviderService.countries()

        #expect(!countries.isEmpty)
    }

    @Test("movieWatchProviders")
    func movieWatchProviders() async throws {
        let watchProviders = try await watchProviderService.movieWatchProviders()

        #expect(!watchProviders.isEmpty)
    }

    @Test("tvSeriesWatchProviders")
    func tvSeriesWatchProviders() async throws {
        let watchProviders = try await watchProviderService.tvSeriesWatchProviders()

        #expect(!watchProviders.isEmpty)
    }

}
