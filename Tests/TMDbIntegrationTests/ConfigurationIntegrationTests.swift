//
//  ConfigurationIntegrationTests.swift
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

import Foundation
import Testing
@testable import TMDb

@Suite(
    .tags(.configuration),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct ConfigurationIntegrationTests {

    var configurationService: (any ConfigurationService)!

    init() throws {
        let apiKey = CredentialHelper.shared.tmdbAPIKey()
        self.configurationService = TMDbClient(apiKey: apiKey).configurations
    }

    @Test("apiConfiguration")
    func apiConfiguration() async throws {
        let configuration = try await configurationService.apiConfiguration()

        #expect(!configuration.images.backdropSizes.isEmpty)
        #expect(!configuration.images.logoSizes.isEmpty)
        #expect(!configuration.images.posterSizes.isEmpty)
        #expect(!configuration.images.profileSizes.isEmpty)
        #expect(!configuration.images.stillSizes.isEmpty)
        #expect(!configuration.changeKeys.isEmpty)
    }

    @Test("countries")
    func countries() async throws {
        let countries = try await configurationService.countries()

        #expect(!countries.isEmpty)
    }

    @Test("jobsByDepartments")
    func jobsByDepartment() async throws {
        let departments = try await configurationService.jobsByDepartment()

        #expect(!departments.isEmpty)
    }

    @Test("languages")
    func languages() async throws {
        let languages = try await configurationService.languages()

        #expect(!languages.isEmpty)
    }

}
