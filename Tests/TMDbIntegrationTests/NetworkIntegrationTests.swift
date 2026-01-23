//
//  NetworkIntegrationTests.swift
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
