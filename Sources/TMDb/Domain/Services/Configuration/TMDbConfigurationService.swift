//
//  TMDbConfigurationService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
final class TMDbConfigurationService: ConfigurationService {

    private let apiClient: any APIClient

    init(apiClient: some APIClient) {
        self.apiClient = apiClient
    }

    func apiConfiguration() async throws(TMDbError) -> APIConfiguration {
        let request = APIConfigurationRequest()

        return try await apiClient.perform(request)
    }

    func countries(language: String? = nil) async throws(TMDbError) -> [Country] {
        let request = CountriesConfigurationRequest(language: language)

        return try await apiClient.perform(request)
    }

    func jobsByDepartment() async throws(TMDbError) -> [Department] {
        let request = JobsConfigurationRequest()

        return try await apiClient.perform(request)
    }

    func languages() async throws(TMDbError) -> [Language] {
        let request = LanguaguesConfigurationRequest()

        return try await apiClient.perform(request)
    }

    func primaryTranslations() async throws(TMDbError) -> [String] {
        let request = ConfigurationPrimaryTranslationsRequest()

        return try await apiClient.perform(request)
    }

    func timezones() async throws(TMDbError) -> [Timezone] {
        let request = ConfigurationTimezonesRequest()

        return try await apiClient.perform(request)
    }

}
