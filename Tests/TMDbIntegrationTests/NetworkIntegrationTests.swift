//
//  NetworkIntegrationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(
    .tags(.network),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct NetworkIntegrationTests {

    var networkService: (any NetworkService)!

    init() {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        self.networkService = TMDbClient(apiKey: apiKey).networks
    }

    @Test("details")
    func details() async throws {
        let networkID = 49

        let network = try await networkService.details(forNetwork: networkID)

        #expect(network.id == networkID)
        #expect(network.name == "HBO")
    }

    @Test("alternativeNames")
    func alternativeNames() async throws {
        let networkID = 49

        let alternativeNames = try await networkService.alternativeNames(forNetwork: networkID)

        #expect(!alternativeNames.isEmpty)
    }

    @Test("images")
    func images() async throws {
        let networkID = 49

        let logos = try await networkService.images(forNetwork: networkID)

        #expect(!logos.isEmpty)
    }

}
