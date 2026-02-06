//
//  ConfigurationIntegrationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.serialized, 
    .tags(.configuration),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct ConfigurationIntegrationTests {

    var configurationService: (any ConfigurationService)!

    init() throws {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
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

    @Test("primaryTranslations")
    func primaryTranslations() async throws {
        let translations = try await configurationService
            .primaryTranslations()

        #expect(!translations.isEmpty)
    }

    @Test("timezones")
    func timezones() async throws {
        let timezones = try await configurationService.timezones()

        #expect(!timezones.isEmpty)
    }

}
