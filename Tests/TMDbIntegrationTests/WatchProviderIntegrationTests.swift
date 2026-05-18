//
//  WatchProviderIntegrationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(
    .integrationGate,
    .serialized,
    .tags(.tvSeason),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct WatchProviderIntegrationTests {

    var watchProviderService: (any WatchProviderService)!

    init() {
        self.watchProviderService = CredentialHelper.shared.makeClient().watchProviders
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
